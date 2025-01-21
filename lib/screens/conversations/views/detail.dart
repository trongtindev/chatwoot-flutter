import '/screens/conversations/controllers/detail.dart';
import '/imports.dart';

class ConversationDetailView extends StatelessWidget {
  final ConversationDetailController c;
  final int id;

  ConversationDetailView({super.key, required this.id})
      : c = Get.put(
          ConversationDetailController(id),
          tag: '$id',
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('detai'),
    );
  }
}
