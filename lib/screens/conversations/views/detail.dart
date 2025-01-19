import '/screens/conversations/controllers/detail.dart';
import '/imports.dart';

class ConversationDetailView extends StatelessWidget {
  final ConversationDetailController controller;
  final int conversation_id;

  ConversationDetailView({super.key, required this.conversation_id})
      : controller = Get.isRegistered<ConversationDetailController>(
                tag: conversation_id.toString())
            ? Get.find<ConversationDetailController>(
                tag: conversation_id.toString())
            : Get.put(
                ConversationDetailController(conversation_id: conversation_id),
                tag: conversation_id.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('detai'),
    );
  }
}
