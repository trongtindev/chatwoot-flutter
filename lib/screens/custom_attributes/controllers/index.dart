import '/imports.dart';

class CustomAttributesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  late TabController tabController;
  CustomAttributesController() {
    tabController = TabController(length: 2, vsync: this);
  }

  final items = RxList<CustomAttribute>();

  @override
  void onReady() {
    super.onReady();

    _auth.profile.listen((next) {
      if (next == null) return;
      getAttributes();
    });

    if (_auth.isSignedIn.value) getAttributes();
  }

  Future<CustomAttributesController> init() async {
    return this;
  }

  Future<void> getAttributes() async {
    try {
      final result = await _api.listCustomAttributes();
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }
}
