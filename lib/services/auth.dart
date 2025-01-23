import '/imports.dart';

class AuthService extends GetxService {
  final _logger = Logger();

  final profile = PersistentRxCustom<ProfileInfo?>(
    null,
    key: 'auth:profile',
    encode: (profile) {
      if (profile == null) return null;
      return jsonEncode(profile.toJson());
    },
    decode: (json) {
      return ProfileInfo.fromJson(jsonDecode(json));
    },
  );
  Rx<bool> isSignedIn = false.obs;
  Rx<bool> isAuthorized = false.obs;

  ApiService? _api;
  ApiService get _getApi {
    _api ??= Get.find<ApiService>();
    if (_api == null) throw Exception('ApiService not found!');
    return _api!;
  }

  NotificationService? _notification;
  NotificationService get _getNotification {
    _notification ??= Get.find<NotificationService>();
    if (_notification == null) {
      throw Exception('NotificationService not found!');
    }
    return _notification!;
  }

  Future<AuthService> init() async {
    profile.listen((data) {
      if (kDebugMode) print(profile);
      isAuthorized.value = data != null;
      isSignedIn.value = profile.value != null;
    });
    isSignedIn.value = profile.value != null;

    return this;
  }

  Future<void> logout() async {
    _logger.i('logout');

    if (!isNullOrEmpty(_getNotification.token.value)) {
      _logger.d('deleteNotificationSubscription');
      _getApi.deleteNotificationSubscription(
        push_token: _getNotification.token.value!,
      );
    }

    Future.delayed(Duration(milliseconds: 250), () {
      _logger.d('reset profile');
      profile.value = null;
    });
  }
}
