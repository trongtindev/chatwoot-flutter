import '/screens/conversations/controllers/chat.dart';
import '/imports.dart';

class ConversationDetailController extends GetxController {
  final _logger = Logger();
  final _labels = Get.find<LabelsController>();
  final _api = Get.find<ApiService>();
  final _macros = Get.find<MacrosController>();
  final _agents = Get.find<AgentsController>();

  final assignable_agents = RxList<UserInfo>();
  final participants = RxList<UserInfo>();
  final List<CancelToken> _cancelTokens = [];
  final executingMacroId = Rxn<int>();

  final int conversation_id;
  final ConversationChatController c;
  ConversationDetailController({required this.conversation_id})
      : c = Get.find<ConversationChatController>(tag: '$conversation_id');

  @override
  void onReady() {
    super.onReady();

    getParticipants();
    _macros.getMacros();
  }

  @override
  void onClose() {
    super.onClose();

    for (final cancelToken in _cancelTokens) {
      cancelToken.cancel();
    }
  }

  Future<void> getParticipants() async {
    final token = CancelToken();
    _cancelTokens.add(token);

    final result = await _api.getConversationParticipants(
      id: conversation_id,
      cancelToken: token,
    );
    _cancelTokens.remove(token);

    participants.value = result.getOrThrow();
  }

  // TODO: make this
  Future<void> removeLabel(LabelInfo info) async {}

  Future<void> showLabelPicker() async {
    final items = await _labels.showPicker(selected: c.info.value!.labels);
    if (items.isEmpty) return;
    _api.updateConversationLabels(
      conversation_id: c.conversation_id,
      labels: items.map((e) => e.title).toList(),
    );
  }

  Future<void> showAgentAssign() async {
    final item = await _agents.showPicker(
      initial: c.info.value!.meta.assignee?.id,
      conversation_id: conversation_id,
      inbox_ids: [c.info.value!.inbox_id],
    );
    if (kDebugMode) print(item);
    if (item == null) return;
    _api.updateConversationAssignments(
      conversation_id: c.conversation_id,
      assignee_id: item.id,
    );
  }

  Future<void> showTeamAssign() async {}

  Future<void> changeStatus(ConversationStatus status) async {
    _logger.d('status: ${status.name}');
    c.changeStatus(status, skipConfirm: true);
  }

  Future<void> executeMacro(MacroInfo info) async {
    if (!await confirm(t.macro_execute_confirm_message(info.name))) {
      return;
    }

    final token = CancelToken();
    _cancelTokens.add(token);
    executingMacroId.value = info.id;

    final result = await _api.executeMacro(
      conversation_ids: [conversation_id],
      macro_id: info.id,
      cancelToken: token,
    );

    _cancelTokens.remove(token);
    executingMacroId.value = null;

    if (result.isError()) {
      showSnackBar(result.exceptionOrNull()!.toString());
      return;
    }
    showSnackBar(t.successful);
  }
}
