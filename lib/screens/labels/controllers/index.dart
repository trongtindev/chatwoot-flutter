import '/imports.dart';

class LabelsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final items = RxList<LabelInfo>();

  @override
  void onReady() {
    super.onReady();

    _auth.profile.listen((next) {
      if (next == null) {
        items.value = [];
        return;
      }
      getLabels();
    });
    if (_auth.isSignedIn.value) getLabels();
  }

  Future<LabelsController> init() async {
    return this;
  }

  Future<void> getLabels() async {
    try {
      final result = await _api.listLabels(
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

  Future<void> addLabel() async {}
}
