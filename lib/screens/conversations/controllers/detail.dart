import '/screens/conversations/controllers/chat.dart';
import '/imports.dart';

class ConversationDetailController extends GetxController {
  final _logger = Logger();
  final _labels = Get.find<LabelsController>();
  final _api = Get.find<ApiService>();

  final ConversationChatController c;
  ConversationDetailController({required int id})
      : c = Get.find<ConversationChatController>(tag: '$id');

  Future<void> removeLabel(LabelInfo info) async {}

  Future<void> showLabelPicker() async {
    final items = await _labels.showPicker(selected: c.info.value!.labels);
    if (items.isEmpty) return;
    _api.updateConversationLabels(
        conversation_id: c.id, labels: items.map((e) => e.title).toList());
  }

  Future<void> showAgentAssign() async {}

  Future<void> showTeamAssign() async {}

  Future<void> changeStatus(ConversationStatus status) async {
    _logger.d('status: ${status.name}');
    c.changeStatus(status, skipConfirm: true);
  }
}
