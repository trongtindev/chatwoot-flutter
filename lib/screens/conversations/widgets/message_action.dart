import '/screens/conversations/controllers/chat.dart';
import '/imports.dart';

class MessageActions extends StatelessWidget {
  final ConversationChatController controller;
  final MessageInfo info;

  const MessageActions({
    super.key,
    required this.controller,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // CustomListTile(
        //   leading: Icon(Icons.copy_outlined),
        //   title: Text(t.copy),
        //   onTap: () {
        //     Get.close();
        //   },
        // ),
        // CustomListTile(
        //   leading: Icon(Icons.delete_outline),
        //   title: Text(t.delete),
        //   onTap: () {
        //     Get.close();
        //   },
        // ),
        Obx(() {
          final translated = controller.translated.value;
          final isTranslating = translated.containsKey(info.id);
          final isTranslated =
              isTranslating && isNotNullOrEmpty(translated[info.id]);

          return CustomListTile(
            enabled: !translated.containsKey(info.id),
            leading: Icon(Icons.translate),
            title: Text(t.translate),
            onTap: () async {
              await controller.translate(info);
              Get.close();
            },
            trailing: SizedBox(
              width: 24,
              height: 24,
              child: isTranslating && !isTranslated
                  ? CircularProgressIndicator()
                  : null,
            ),
          );
        }),
      ],
    );
  }
}
