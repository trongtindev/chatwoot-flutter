import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/screens/conversations/controllers/chat.dart';
import '/screens/conversations/views/chat.dart';
import '/imports.dart';

enum NotificationEventId { onMessage, onMessageOpenedApp }

class NotificationService extends GetxService {
  final _logger = Logger();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  final events = EventEmitter();
  final enabled = PersistentRxBool(false, key: 'notification:enabled');
  final token = PersistentRx<String?>(null, key: 'notification:token');
  final authorizationStatus = AuthorizationStatus.notDetermined.obs;

  RemoteMessage? _initialMessage;
  StreamSubscription<bool>? _enabledChangeSubscription;
  StreamSubscription<String?>? _tokenChangeSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  EventListener<ConversationInfo>? _conversationReadListener;
  EventListener<NotificationInfo>? _notificationCreatedListener;
  EventListener<int>? _notificationDeletedListener;

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

  RealtimeService? _realtime;
  RealtimeService get _getRealtime {
    _realtime ??= Get.find<RealtimeService>();
    if (_realtime == null) throw Exception('RealtimeService not found!');
    return _realtime!;
  }

  RemoteMessage? get getRemoteMessage => _initialMessage;

  @override
  void onReady() {
    super.onReady();

    _getAuth.isSignedIn.listen((next) {
      if (!next) {
        token.value = null;
        return;
      }
      _ensurePermission();
    });

    _conversationReadListener = _getRealtime.events.on(
      RealtimeEventId.conversationRead.name,
      _onConversationRead,
    );

    _notificationCreatedListener = _getRealtime.events.on(
      RealtimeEventId.notificationCreated.name,
      _onNotificationCreated,
    );

    _notificationDeletedListener = _getRealtime.events.on(
      RealtimeEventId.notificationDeleted.name,
      _onNotificationDeleted,
    );

    _enabledChangeSubscription = enabled.listen((next) {
      _logger.i('enabled changed => $next');
      if (next) _ensurePermission();
    });

    _tokenChangeSubscription = token.listen((next) {
      if (isNullOrEmpty(next)) return;
      saveDeviceDetails();
    });

    if (!GetPlatform.isDesktop) {
      _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
        (next) => token.value = next,
        onError: (error, stackTrace) {
          _logger.e(error, stackTrace: stackTrace);
        },
      );
    }

    _onMessageSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(_onMessage);
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessage.listen(_onMessageOpenedApp);
  }

  @override
  void onClose() {
    _enabledChangeSubscription?.cancel();
    _tokenChangeSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _conversationReadListener?.cancel();
    _notificationCreatedListener?.cancel();
    _notificationDeletedListener?.cancel();

    super.onClose();
  }

  Future<NotificationService> init() async {
    await _ensurePermission();

    await _notificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    if (!GetPlatform.isDesktop) {
      _initialMessage = await _firebaseMessaging.getInitialMessage();
      if (_initialMessage != null) {
        _logger.i('getInitialMessage: ${jsonEncode(_initialMessage!.toMap())}');
      }
    }

    return this;
  }

  Future<void> handleNavigation(NotificationInfo info) async {
    switch (info.primary_actor_type) {
      case NotificationActorType.conversation:
        Get.to(
          () => ConversationChatView(conversation_id: info.primary_actor_id),
        );
        break;

      default:
        _logger.w('unhandled primary_actor_type ${info.primary_actor_id}');
        return;
    }
  }

  Future<void> showPushNotification(NotificationInfo info) async {
    await _notificationsPlugin.show(
      info.id,
      info.push_message_title,
      info.notification_type.name,
      NotificationDetails(),
      payload: jsonEncode(info.toJson()),
    );
  }

  Future<void> _onMessage(RemoteMessage message) async {
    _logger.i(jsonEncode(message.toMap()));
    events.emit(NotificationEventId.onMessage.name, message);

    // TODO: message.data not tested
    try {
      final info = NotificationInfo.fromJson(message.data);

      // if conversation opened
      if (isConversationChatOpened(info.id)) return;

      // show push notifications
      await showPushNotification(info);
    } on Error catch (error) {
      _logger.e(error, stackTrace: error.stackTrace);
      _logger.e('failed to parse message.data');
      _logger.e(message.data);
    }
  }

  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    _logger.i(jsonEncode(message.toMap()));
    events.emit(NotificationEventId.onMessageOpenedApp.name, message);

    // TODO: message.data not tested
    try {
      final info = NotificationInfo.fromJson(message.data);
      await handleNavigation(info);
    } on Error catch (error) {
      _logger.e(error, stackTrace: error.stackTrace);
      _logger.e('failed to parse message.data');
      _logger.e(message.data);
    }
  }

  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    try {
      final data = jsonDecode(response.payload!);
      final info = NotificationInfo.fromJson(data);
      await handleNavigation(info);
    } on Error catch (error) {
      _logger.e(error, stackTrace: error.stackTrace);
      _logger.e('failed to parse response.payload');
      _logger.e(response.payload);
    }
  }

  bool isConversationChatOpened(int conversation_id) {
    return Get.isRegistered<ConversationChatController>(
      tag: '$conversation_id',
    );
  }

  Future<void> _onConversationRead(ConversationInfo info) async {
    await _notificationsPlugin.cancel(info.id);
  }

  Future<void> _onNotificationCreated(NotificationInfo info) async {
    await showPushNotification(info);
  }

  Future<void> _onNotificationDeleted(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> _ensurePermission() async {
    if (GetPlatform.isDesktop) {
      _logger.d('requestPermission ignored when isDesktop');
      return;
    }
    _logger.d('requestPermission');

    final notificationSettings =
        await _firebaseMessaging.requestPermission(provisional: true);
    authorizationStatus.value = notificationSettings.authorizationStatus;
    if (authorizationStatus.value == AuthorizationStatus.denied) {
      _logger.w('permission:denied');
      return;
    }
    _logger.d('permission:${authorizationStatus.value}');

    final getToken = await _firebaseMessaging.getToken();
    if (isNullOrEmpty(token.value) || getToken != token.value) {
      token.value = getToken;
    }
    _logger.d('token:${token.value}');
  }

  Future<void> saveDeviceDetails() async {
    if (isNullOrEmpty(token.value)) {
      _logger.w('saveDeviceDetails() => token is empty');
      return;
    }
    _logger.d('saveDeviceDetails()');
    await _getApi.notifications.saveDeviceDetails(push_token: token.value!);
    _logger.d('saveDeviceDetails() => successful');
  }
}
