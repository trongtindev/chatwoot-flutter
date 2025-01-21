import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  RemoteMessage? get getRemoteMessage => _initialMessage;

  @override
  void onReady() {
    super.onReady();
    _logger.d('onReady()');

    _getAuth.profile.listen((next) {
      if (next == null) {
        token.value = null;
        return;
      }
      requestPermission();
    });

    _enabledChangeSubscription = enabled.listen((next) {
      _logger.i('enabled changed => $next');
      if (next) requestPermission();
    });

    _tokenChangeSubscription = token.listen((next) => saveDeviceDetails());

    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
      (next) => token.value = next,
      onError: (error, stackTrace) {
        _logger.e(error, stackTrace: stackTrace);
      },
    );

    _onMessageSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(_onMessage);
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessage.listen(_onMessageOpenedApp);
  }

  @override
  void onClose() {
    _logger.d('onClose()');

    _enabledChangeSubscription?.cancel();
    _tokenChangeSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();

    super.onClose();
  }

  Future<NotificationService> init() async {
    await requestPermission();
    _logger.i('getInitialMessage()');
    _initialMessage = await _firebaseMessaging.getInitialMessage();
    return this;
  }

  void _onMessage(RemoteMessage message) {
    _logger.i(jsonEncode(message.toMap()));
    events.emit(NotificationEventId.onMessage.name, message);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _logger.i(jsonEncode(message.toMap()));
    events.emit(NotificationEventId.onMessageOpenedApp.name, message);
  }

  Future<void> requestPermission() async {
    _logger.d('requestPermission');

    var notificationSettings =
        await _firebaseMessaging.requestPermission(provisional: true);
    authorizationStatus.value = notificationSettings.authorizationStatus;
    if (authorizationStatus.value == AuthorizationStatus.denied) {
      _logger.w('permission:denied');
      return;
    }
    _logger.d('permission:${authorizationStatus.value}');

    var getToken = await _firebaseMessaging.getToken();
    if (getToken != token.value) token.value = getToken;
    _logger.d('token:${token.value}');
  }

  Future<void> saveDeviceDetails() async {
    if (token.value == null || token.value!.isEmpty) {
      _logger.w('saveDeviceDetails() => token is empty');
      return;
    }
    _logger.i('saveDeviceDetails()');
    await _getApi.saveDeviceDetails(push_token: token.value!);
    _logger.i('saveDeviceDetails() => successful');
  }
}
