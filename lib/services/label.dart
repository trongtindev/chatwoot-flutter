import '/imports.dart';

class LabelService extends GetxService {
  final _logger = Logger();

  final items = RxList<LabelInfo>();

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
      if (next == null) {
        items.value = [];
        return;
      }
      getItems();
    });
    if (_getAuth.isSignedIn.value) getItems();
  }

  Future<void> getItems() async {
    try {
      final result = await _getApi.listLabels(
        onCacheHit: (data) {
          items.value = data;
        },
      );
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }
}
