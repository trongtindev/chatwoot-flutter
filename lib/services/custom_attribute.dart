import '/imports.dart';

class CustomAttributeService extends GetxService {
  final _logger = Logger();

  final items = RxList<CustomAttribute>();

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
      getAttributes();
    });

    if (_getAuth.isSignedIn.value) getAttributes();
  }

  Future<void> getAttributes() async {
    try {
      final result = await _getApi.listCustomAttributes();
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }
}
