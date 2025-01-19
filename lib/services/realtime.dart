import 'package:action_cable/action_cable.dart';
import '/imports.dart';

const CHANNEL_NAME = 'RoomChannel';
const PRESENCE_INTERVAL = 20000;

enum RealtimeEventId { messageCreated }

class RealtimeService extends GetxService {
  final _logger = Logger();

  final events = EventEmitter();
  final online = RxList<int>();
  final typingUsers = RxMap<int, List<int>>();
  final connected = false.obs;

  Timer? _updatePresenceTimer;
  ActionCable? _actionCable;
  StreamSubscription? _subscription;

  @override
  void onReady() {
    super.onReady();
    _logger.i('onReady()');
    if (_getAuth.isSignedIn.value) connect();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _actionCable?.disconnect();
    super.onClose();
  }

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

  Future<RealtimeService> init() async {
    _logger.i('init()');

    _logger.i('init() => successful');
    return this;
  }

  Future<void> connect({int? retries}) async {
    try {
      retries ??= 0;
      _logger.i('connect()');

      var host = Uri.parse(_getApi.baseUrl.value).host;

      if (_actionCable != null && connected.value) {
        _logger.w('connect() => already connected!');
        return;
      }

      _actionCable?.disconnect();
      _actionCable = ActionCable.connect(
        'wss://$host/cable',
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
          Future.delayed(Duration(seconds: retries! * 1), () => connect());
        },
        onCannotConnect: () {
          _logger.w('onCannotConnect');
          connected.value = false;
          _updatePresenceTimer?.cancel();
          Future.delayed(Duration(seconds: retries! * 1), () => connect());
        },
      );

      _logger.i('connect() => successful');
    } catch (error) {
      _logger.i('connect() => $error');
      _logger.i(error);

      Timer.periodic(Duration(seconds: 1), (_) => connect());
    }
  }

  void _perform() {
    _logger.t('_perform()');
    _actionCable!.performAction(CHANNEL_NAME, action: 'update_presence');
  }

  void _onMessage(Map<dynamic, dynamic> payload) async {
    switch (payload['event']) {
      case 'presence.update':
        _onPresenceUpdate(payload['data']);
        break;

      case 'message.created':
        _onMessageCreated(payload['data']);
        break;

      case 'conversation.typing_on':
        var parse = TypingData.fromJson(payload['data']);
        _onTypingOn(parse);
        break;

      case 'conversation.typing_off':
        var parse = TypingData.fromJson(payload['data']);
        _onTypingOff(parse);
        break;

      // TODO: Handle all these events later
      // case 'contact.updated':
      //   break;

      default:
        _logger.w('_onMessage() => unkown event ${payload['event']}');
        _logger.w(payload);
        break;
    }
  }

  Future<void> _onPresenceUpdate(Map<dynamic, dynamic> data) async {
    _logger.d('_onPresenceUpdate()');

    Map<String, dynamic> users = data['users'];
    Map<String, dynamic> contacts = data['contacts'];
    online.value = [
      ...users.keys.map((e) => int.parse(e)),
      ...contacts.keys.map((e) => int.parse(e)),
    ];

    _logger.d('_onPresenceUpdate() => length:${online.length}');
  }

  Future<void> _onMessageCreated(Map<dynamic, dynamic> data) async {
    _logger.d('_onMessageCreated()');
    var message = MessageInfo.fromJson(data);
    events.emit(RealtimeEventId.messageCreated.name, message);
  }

  Future<void> _onTypingOn(TypingData data) async {
    _logger.d('_onTypingOn(${data.conversation.id})#${data.user.id}');

    typingUsers[data.conversation.id] ??= [];
    if (typingUsers[data.conversation.id]!.contains(data.user.id)) {
      return;
    }
    typingUsers[data.conversation.id]!.add(data.user.id);
  }

  Future<void> _onTypingOff(TypingData data) async {
    _logger.d('_onTypingOff(${data.conversation.id})#${data.user.id}');

    typingUsers[data.conversation.id] ??= [];
    if (!typingUsers[data.conversation.id]!.contains(data.user.id)) {
      return;
    }
    typingUsers[data.conversation.id]!.remove(data.user.id);
  }

  Future<void> onError(Object data, StackTrace stackTrace) async {
    _logger.e('onError()');
    _logger.e(data);
    _logger.e(stackTrace);

    Timer.periodic(Duration(seconds: 1), (_) => connect());
  }
}
