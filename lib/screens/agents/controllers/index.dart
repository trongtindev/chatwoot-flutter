import '../widgets/picker.dart';
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
      final result = await _api.agents.list();
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }

  Future<UserInfo?> showPicker({
    int? initial,
    required List<int> inbox_ids,
    required int conversation_id,
  }) async {
    final result = await Get.bottomSheet<UserInfo?>(
      AgentsPicker(
        initial: initial,
        inbox_ids: inbox_ids,
        conversation_id: conversation_id,
      ),
    );
    return result;
  }

  Future<void> add() async {}

  Future<void> delete(UserInfo info) async {}
}
