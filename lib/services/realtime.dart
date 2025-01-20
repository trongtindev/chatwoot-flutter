import 'package:action_cable/action_cable.dart';
import '/imports.dart';

const CHANNEL_NAME = 'RoomChannel';
const PRESENCE_INTERVAL = 20000;

enum RealtimeEventId {
  contactCreated,
  messageCreated,
  messageUpdated,
  conversationUpdated,
  conversationStatusChanged
}

class RealtimeService extends GetxService {
  final _logger = Logger();

  final events = EventEmitter();
  final online = RxList<int>();
  final typingUsers = RxMap<int, List<int>>();
  final connected = false.obs;

  Timer? _updatePresenceTimer;
  ActionCable? _actionCable;
  StreamSubscription? _subscription;

  ApiService? _api;
  ApiService get _getApi {
    _api ??= Get.find<ApiService>();
    if (_api == null) throw Exception('ApiService not found!');
    return _api!;
  }

  AuthService? _auth;
  AuthService get _getAuth {
    _auth ??= Get.find<AuthService>();
    if (_auth == null) throw Exception('AuthService not found!');
    return _auth!;
  }

  @override
  void onReady() {
    super.onReady();
    _logger.i('onReady()');
    if (_getAuth.isSignedIn.value) connect();
  }

  @override
  void onClose() {
    _logger.d('onClose()');
    _subscription?.cancel();
    _actionCable?.disconnect();
    super.onClose();
  }

  Future<RealtimeService> init() async {
    _logger.i('init()');

    _logger.i('init() => successful');
    return this;
  }

  Future<void> connect() async {
    try {
      var host = Uri.parse(_getApi.baseUrl.value).host;
      var url = 'wss://$host/cable';
      _logger.i(url);

      if (_actionCable != null && connected.value) {
        _logger.w('already connected!');
        return;
      }

      _actionCable?.disconnect();
      _actionCable = ActionCable.connect(
        url,
        onConnected: () {
          _logger.i('onConnected');
          connected.value = true;

          _actionCable!.subscribe(
            CHANNEL_NAME,
            channelParams: {
              'channel': CHANNEL_NAME,
              'pubsub_token': _getAuth.profile.value!.pubsub_token,
              'account_id': _getAuth.profile.value!.account_id,
              'user_id': _getAuth.profile.value!.id,
            },
            onMessage: _onMessage,
            onSubscribed: () => _perform(),
          );

          _updatePresenceTimer?.cancel();
          _updatePresenceTimer = Timer.periodic(
              Duration(milliseconds: PRESENCE_INTERVAL), (_) => _perform());
        },
        onConnectionLost: () {
          _logger.w('onConnectionLost');
          connected.value = false;
          _updatePresenceTimer?.cancel();
          Future.delayed(Duration(seconds: 5), () => connect());
        },
        onCannotConnect: () {
          _logger.w('onCannotConnect');
          connected.value = false;
          _updatePresenceTimer?.cancel();
          Future.delayed(Duration(seconds: 5), () => connect());
        },
      );

      _logger.i('successful');
    } catch (error) {
      _logger.i(error);

      Timer.periodic(Duration(seconds: 1), (_) => connect());
    }
  }

  void _perform() {
    _logger.d('update_presence()');
    _actionCable!.performAction(CHANNEL_NAME, action: 'update_presence');
  }

  void _onMessage(Map<dynamic, dynamic> payload) async {
    try {
      switch (payload['event']) {
        case 'presence.update':
          _onPresenceUpdate(payload['data']);
          break;

        case 'contact.created':
          var parse = ContactInfo.fromJson(payload['data']);
          _onContactCreated(parse);
          break;

        case 'message.created':
          var parse = MessageInfo.fromJson(payload['data']);
          _onMessageCreated(parse);
          break;

        case 'message.updated':
          var parse = MessageInfo.fromJson(payload['data']);
          _onMessageUpdated(parse);
          break;

        case 'conversation.typing_on':
          var parse = TypingData.fromJson(payload['data']);
          _onTypingOn(parse);
          break;

        case 'conversation.typing_off':
          var parse = TypingData.fromJson(payload['data']);
          _onTypingOff(parse);
          break;

        case 'conversation.updated':
          var parse = ConversationInfo.fromJson(payload['data']);
          _onConversationUpdated(parse);
          break;

        case 'conversation.status_changed':
          var parse = ConversationInfo.fromJson(payload['data']);
          _onConversationStatusChanged(parse);
          break;

        // TODO: Handle all these events later
        // case 'contact.updated':
        //   break;

        default:
          _logger.w('failed to parse event ${payload['event']}');
          _logger.w(payload);
          break;
      }
    } on Error catch (error) {
      _logger.w(error, stackTrace: error.stackTrace);
      _logger.d(payload);
    }
  }

  Future<void> _onPresenceUpdate(Map<dynamic, dynamic> data) async {
    _logger.d(data);

    Map<String, dynamic> users = data['users'];
    Map<String, dynamic> contacts = data['contacts'];
    online.value = [
      ...users.keys.map((e) => int.parse(e)),
      ...contacts.keys.map((e) => int.parse(e)),
    ];
  }

  Future<void> _onContactCreated(ContactInfo info) async {
    _logger.d('${info.name}#${info.id}');
    events.emit(RealtimeEventId.contactCreated.name, info);
  }

  Future<void> _onMessageCreated(MessageInfo info) async {
    _logger.d('${info.id}#${info.conversation_id}');
    events.emit(RealtimeEventId.messageCreated.name, info);
  }

  Future<void> _onMessageUpdated(MessageInfo info) async {
    _logger.d('${info.id}#${info.conversation_id}');
    events.emit(RealtimeEventId.messageUpdated.name, info);
  }

  Future<void> _onTypingOn(TypingData data) async {
    _logger.d('${data.conversation.id})#${data.user.id}');

    typingUsers[data.conversation.id] ??= [];
    if (typingUsers[data.conversation.id]!.contains(data.user.id)) {
      return;
    }
    typingUsers[data.conversation.id]!.add(data.user.id);
  }

  Future<void> _onTypingOff(TypingData data) async {
    _logger.d('${data.conversation.id})#${data.user.id}');

    typingUsers[data.conversation.id] ??= [];
    if (!typingUsers[data.conversation.id]!.contains(data.user.id)) {
      return;
    }
    typingUsers[data.conversation.id]!.remove(data.user.id);
  }

  Future<void> _onConversationUpdated(ConversationInfo info) async {
    _logger.d('${info.id}${info.status.name}');
    events.emit(RealtimeEventId.conversationUpdated.name, info);
  }

  Future<void> _onConversationStatusChanged(ConversationInfo info) async {
    _logger.d('${info.id}${info.status.name}');
    events.emit(RealtimeEventId.conversationStatusChanged.name, info);
  }
}
