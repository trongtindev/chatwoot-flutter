import '/imports.dart';

class InboxService extends GetxService {
  final _logger = Logger();

  final inboxes = RxList<InboxInfo>();

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
      getInboxes();
    });

    if (_getAuth.isSignedIn.value) getInboxes();
  }

  Future<void> getInboxes() async {
    try {
      final result = await _getApi.listInboxes();
      inboxes.value = result.getOrThrow();
      _logger.d('found ${inboxes.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }
}
