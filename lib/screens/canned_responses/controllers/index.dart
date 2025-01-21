import '/imports.dart';

class CannedResponsesController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final items = RxList<CannedResponseInfo>();

  @override
  void onReady() {
    super.onReady();

    _auth.profile.listen((next) {
      if (next == null) return;
      getCannedResponses();
    });

    if (_auth.isSignedIn.value) getCannedResponses();
  }

  Future<CannedResponsesController> init() async {
    return this;
  }

  Future<void> getCannedResponses() async {
    try {
      final result = await _api.listCannedResponses();
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }
}
