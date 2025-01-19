import '/screens/conversations/widgets/message.dart';
import '/screens/conversations/controllers/chat.dart';
import '/screens/conversations/widgets/input.dart';
import '/imports.dart';

class ConversationChatView extends StatelessWidget {
  final ConversationChatController controller;
  final int conversation_id;

  ConversationChatView({
    super.key,
    required this.conversation_id,
    MessageInfo? initial_message,
  }) : controller = Get.isRegistered<ConversationChatController>(
                tag: conversation_id.toString())
            ? Get.find<ConversationChatController>(
                tag: conversation_id.toString())
            : Get.put(
                ConversationChatController(
                  conversation_id: conversation_id,
                  initial_message: initial_message,
                ),
                tag: conversation_id.toString());

  @override
  Widget build(BuildContext context) {
    final realtime = Get.find<RealtimeService>();

    return Obx(() {
      var info = controller.info.value;
      var resolved = controller.resolved.value;
      var error = controller.error.value;
      var message_count = controller.message_count.value;

      return Scaffold(
        appBar: AppBar(
          title: info != null
              ? ListTile(
                  contentPadding: EdgeInsets.only(),
                  leading: avatar(
                    url: info.meta.sender.thumbnail,
                    fallback: info.meta.sender.name.substring(0, 1),
                    isOnline: realtime.online.contains(info.meta.sender.id),
                    width: 28,
                    height: 28,
                  ),
                  title: Text(
                    info.meta.sender.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('contact.view_details'.tr),
                  onTap: controller.showContactDetail,
                )
              : null,
          actions: [
            if (resolved)
              IconButton(
                icon: Icon(Icons.refresh_outlined),
                onPressed: () {},
              )
            else
              IconButton(
                icon: Icon(Icons.task_alt_outlined),
                onPressed: () {},
              ),
            IconButton(
              icon: Icon(Icons.menu_outlined),
              onPressed: () {},
            ),
            Padding(padding: EdgeInsets.only(right: 8)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (_) {
                  if (error.isNotEmpty) {
                    return buildError();
                  } else if (message_count == 0) {
                    return buildPlaceholder();
                  }
                  return buildMessages();
                },
              ),
            ),
            ConversationInput(),
          ],
        ),
      );
    });
  }

  Widget buildPlaceholder() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildError() {
    return error(
      message: controller.error.value,
      onRetry: () {
        controller.getConversation();
        controller.getMessages();
      },
    );
  }

  Widget buildMessages() {
    var count = controller.messages.length;

    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.only(left: 8, right: 8),
      itemCount: count,
      itemBuilder: (_, i) {
        var item = controller.messages[i];

        // TODO: make radius
        var topLeft = 8.0;
        var topRight = 8.0;
        var bottomLeft = 8.0;
        var bottomRight = 8.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Message(
            info: item,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeft),
              topRight: Radius.circular(topRight),
              bottomLeft: Radius.circular(bottomLeft),
              bottomRight: Radius.circular(bottomRight),
            ),
          ),
        );
      },
    );
  }
}
