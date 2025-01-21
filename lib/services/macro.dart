import '/imports.dart';

class MacroService extends GetxService {
  final _logger = Logger();

  final items = RxList<MacroInfo>();

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
      getMacros();
    });

    if (_getAuth.isSignedIn.value) getMacros();
  }

  Future<void> getMacros() async {
    try {
      final result = await _getApi.listMacros();
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }
}
