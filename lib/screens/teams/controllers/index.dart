import '/imports.dart';

class TeamsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final items = RxList<TeamInfo>();

  @override
  void onReady() {
    super.onReady();

    _auth.profile.listen((next) {
      if (next == null) return;
      getTeams();
    });

    if (_auth.isSignedIn.value) getTeams();
  }

  Future<TeamsController> init() async {
    return this;
  }

  Future<void> getTeams() async {
    try {
      final result = await _api.listTeams();
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }

  Future<void> delete(TeamInfo info) async {}
}
