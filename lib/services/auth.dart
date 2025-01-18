import '/imports.dart';

class AuthService extends GetxService {
  final _logger = Logger();
  final events = EventEmitter();

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

  Future<AuthService> init() async {
    _logger.i('init()');

    profile.listen((data) {
      if (kDebugMode) print(profile);
      isAuthorized.value = data != null;
      isSignedIn.value = profile.value != null;
    });
    isSignedIn.value = profile.value != null;

    return this;
  }

  Future<void> signOut() async {
    _logger.i('signOut()');
    profile.value = null;
  }
}
