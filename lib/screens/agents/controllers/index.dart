import '/imports.dart';

class AgentsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final items = RxList<UserInfo>();

  @override
  void onReady() {
    super.onReady();

    _auth.profile.listen((next) {
      if (next == null) return;
      getAgents();
    });

    if (_auth.isSignedIn.value) getAgents();
  }

  Future<AgentsController> init() async {
    return this;
  }

  Future<void> getAgents() async {
    try {
      final result = await _api.listAgents();
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }
}
