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

  @override
  void onReady() {
    super.onReady();

    _enabledChangeSubscription = enabled.listen((next) {
      _logger.i('enabled changed => $next');
      if (next) requestPermission();
    });

    _tokenChangeSubscription = token.listen((next) => saveDeviceDetails());

    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
      (next) => token.value = next,
      onError: (error, StackTrace stackTrace) {
        _logger.e('onTokenRefresh() => $error');
        _logger.e(stackTrace);
      },
    );

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

    super.onClose();
  }

  ApiService? _api;
  ApiService get _getApi {
    _api ??= Get.find<ApiService>();
    if (_api == null) throw Exception('ApiService not found!');
    return _api!;
  }

  RemoteMessage? get getRemoteMessage => _initialMessage;

  Future<NotificationService> init() async {
    _logger.i('init()');

    await requestPermission();

    _initialMessage = await _firebaseMessaging.getInitialMessage();

    _logger.i('init() => successful');
    return this;
  }

  void _onMessage(RemoteMessage message) {
    _logger.i('_onMessageOpenedApp()');
    _logger.i(jsonEncode(message.toMap()));
    events.emit(NotificationEventId.onMessage.name, message);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _logger.i('_onMessageOpenedApp()');
    _logger.i(jsonEncode(message.toMap()));
    events.emit(NotificationEventId.onMessageOpenedApp.name, message);
  }

  Future<void> requestPermission() async {
    _logger.i('requestPermission()');

    var notificationSettings =
        await _firebaseMessaging.requestPermission(provisional: true);
    authorizationStatus.value = notificationSettings.authorizationStatus;
    if (authorizationStatus.value == AuthorizationStatus.denied) {
      _logger.w('requestPermission() => denied');
      return;
    }
    _logger.w('requestPermission() => permission:${authorizationStatus.value}');

    var getToken = await _firebaseMessaging.getToken();
    if (getToken != token.value) token.value = getToken;
    _logger.d('requestPermission() => token:${token.value}');

    _logger.i('requestPermission() => successful');
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
