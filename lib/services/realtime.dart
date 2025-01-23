import 'package:action_cable/action_cable.dart';
import '/imports.dart';

const CHANNEL_NAME = 'RoomChannel';
const PRESENCE_INTERVAL = 20000;

enum RealtimeEventId {
  contactCreated,
  contactUpdated,
  messageCreated,
  messageUpdated,
  conversationCreated,
  conversationUpdated,
  conversationRead,
  conversationStatusChanged,
  notificationCreated,
  notificationDeleted
}

class RealtimeService extends GetxService {
  final _logger = Logger();

  final events = EventEmitter();
  final online = RxList<int>();
  final typingUsers = RxList<int>();
  final connected = false.obs;

  // Timer? _updatePresenceTimer;
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

    _getAuth.profile.listen((next) {
      if (next == null) return;
      connect();
    });

    _getAuth.isSignedIn.listen((next) {
      if (next) {
        connect();
        return;
      }
      disconnect();
    });

    if (_getAuth.isSignedIn.value) connect();
  }

  @override
  void onClose() {
    disconnect();

    super.onClose();
  }

  Future<RealtimeService> init() async {
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
            // onSubscribed: () => _perform(),
          );

          // _updatePresenceTimer?.cancel();
          // _updatePresenceTimer = Timer.periodic(
          //   Duration(milliseconds: PRESENCE_INTERVAL),
          //   (_) => _perform(),
          // );
        },
        onConnectionLost: () {
          _logger.w('onConnectionLost');
          connected.value = false;
          // _updatePresenceTimer?.cancel();
          Future.delayed(Duration(seconds: 5), () => connect());
        },
        onCannotConnect: () {
          _logger.w('onCannotConnect');
          connected.value = false;
          // _updatePresenceTimer?.cancel();
          Future.delayed(Duration(seconds: 5), () => connect());
        },
      );

      _logger.i('successful');
    } catch (error) {
      _logger.i(error);

      Timer.periodic(Duration(seconds: 1), (_) => connect());
    }
  }

  Future<void> disconnect() async {
    _subscription?.cancel();
    _actionCable?.disconnect();
  }

  // void _perform() {
  //   _logger.d('update_presence()');
  //   _actionCable!.performAction(CHANNEL_NAME, action: 'update_presence');
  // }

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

        case 'contact.updated':
          var parse = ContactInfo.fromJson(payload['data']);
          _onContactUpdated(parse);
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

        case 'conversation.created':
          var parse = ConversationInfo.fromJson(payload['data']);
          _onConversationCreated(parse);
          break;

        case 'conversation.read':
          var parse = ConversationInfo.fromJson(payload['data']);
          _onConversationRead(parse);
          break;

        case 'conversation.updated':
          var parse = ConversationInfo.fromJson(payload['data']);
          _onConversationUpdated(parse);
          break;

        case 'conversation.status_changed':
          var parse = ConversationInfo.fromJson(payload['data']);
          _onConversationStatusChanged(parse);
          break;

        case 'notification.created':
          var parse =
              NotificationInfo.fromJson(payload['data']['notification']);
          _onnotificationCreated(parse);
          break;

        case 'notification.deleted':
          _onnotificationDeleted(payload['data']['notification']['id']);
          break;

        // TODO: Handle all these events later
        // case 'assignee.changed':
        //   break;
        // case 'conversation.contact_changed':
        //   break;
        // case 'conversation.mentioned':
        //   break;
        // case 'contact.deleted':
        //   break;
        // case 'first.reply.created':
        //   break;
        // case 'team.changed':
        //   break;
        // case 'account.cache_invalidated':
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

  Future<void> _onContactUpdated(ContactInfo info) async {
    _logger.d('${info.name}#${info.id}');
    events.emit(RealtimeEventId.contactUpdated.name, info);
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
    _logger.d('${data.user.name}#${data.conversation.id}');
    if (typingUsers.contains(data.user.id)) return;
    typingUsers.add(data.user.id);
  }

  Future<void> _onTypingOff(TypingData data) async {
    _logger.d('${data.user.name}#${data.conversation.id}');
    if (!typingUsers.contains(data.user.id)) return;
    typingUsers.remove(data.user.id);
  }

  Future<void> _onConversationCreated(ConversationInfo info) async {
    _logger.d('${info.meta.sender.name}#${info.id}');
    events.emit(RealtimeEventId.conversationCreated.name, info);
  }

  Future<void> _onConversationRead(ConversationInfo info) async {
    _logger.d('${info.meta.sender.name}#${info.id}');
    events.emit(RealtimeEventId.conversationRead.name, info);
  }

  Future<void> _onConversationUpdated(ConversationInfo info) async {
    _logger.d('${info.meta.sender.name}#${info.id} status:${info.status.name}');
    events.emit(RealtimeEventId.conversationUpdated.name, info);
  }

  Future<void> _onConversationStatusChanged(ConversationInfo info) async {
    _logger.d('${info.meta.sender.name}#${info.id} status:${info.status.name}');
    events.emit(RealtimeEventId.conversationStatusChanged.name, info);
  }

  void _onnotificationCreated(NotificationInfo info) {
    _logger.d('#${info.id}');
    events.emit(RealtimeEventId.notificationCreated.name, info);
  }

  void _onnotificationDeleted(int id) {
    _logger.d('#$id');
    events.emit(RealtimeEventId.notificationDeleted.name, id);
  }
}
