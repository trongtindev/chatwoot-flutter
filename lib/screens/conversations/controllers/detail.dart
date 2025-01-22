import '/screens/conversations/controllers/chat.dart';
import '/imports.dart';

class ConversationDetailController extends GetxController {
  final _logger = Logger();

  final ConversationChatController c;
  ConversationDetailController({required int id})
      : c = Get.find<ConversationChatController>(tag: '$id');

  Future<void> showAgentAssign() async {}

  Future<void> showTeamAssign() async {}

  Future<void> changeStatus(ConversationStatus status) async {
    _logger.d('status: ${status.name}');
    c.changeStatus(status, skipConfirm: true);
  }
}
