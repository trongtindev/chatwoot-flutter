import '/screens/conversations/widgets/message.dart';
import '/screens/conversations/controllers/chat.dart';
import '/screens/conversations/widgets/input.dart';
import '/imports.dart';

class ConversationChatView extends StatelessWidget {
  final realtime = Get.find<RealtimeService>();

  final ConversationChatController controller;
  final int conversation_id;

  ConversationChatView({
    super.key,
    required this.conversation_id,
    MessageInfo? initial_message,
  }) : controller = Get.isRegistered<ConversationChatController>(
          tag: conversation_id.toString(),
        )
            ? Get.find<ConversationChatController>(
                tag: conversation_id.toString(),
              )
            : Get.put(
                ConversationChatController(
                  conversation_id: conversation_id,
                  initial_message: initial_message,
                ),
                tag: conversation_id.toString(),
              );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final info = controller.info.value;
          if (info != null) {
            return ListTile(
              contentPadding: EdgeInsets.only(),
              leading: avatar(
                context,
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
              subtitle: Text(t.view_details),
              onTap: controller.showContactDetail,
            );
          }
          return Container();
        }),
        actions: [
          Obx(() {
            final resolved = controller.resolved.value;
            if (resolved) {
              return IconButton(
                icon: Icon(Icons.refresh_outlined),
                onPressed: () {
                  print('ok');
                },
              );
            }
            return IconButton(
              icon: Icon(Icons.task_alt_outlined),
              onPressed: () {},
            );
          }),
          IconButton(
            icon: Icon(Icons.menu_outlined),
            onPressed: () {},
          ),
          Padding(padding: EdgeInsets.only(right: 8)),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.error.value.isNotEmpty) {
                    return buildError(context);
                  }
                  return buildMessages();
                }),
              ),
              ConversationInput(conversation_id: controller.conversation_id),
            ],
          ),
          Obx(() {
            final loading = controller.loading.value;
            if (loading) {
              return Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(),
                ),
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }

  Widget buildError(BuildContext context) {
    return error(
      context,
      message: controller.error.value,
      onRetry: () {
        controller.getConversation();
        controller.getMessages();
      },
    );
  }

  Widget buildMessages() {
    return Obx(() {
      var messages = controller.messages;

      return ListView.builder(
        controller: controller.scrollController,
        reverse: true,
        padding: EdgeInsets.only(left: 8, right: 8),
        itemCount: messages.length,
        itemBuilder: (_, i) {
          var item = messages[i];

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
    });
  }
}
