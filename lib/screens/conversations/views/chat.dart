import '/screens/conversations/views/detail.dart';
import '/screens/conversations/widgets/message.dart';
import '/screens/conversations/controllers/chat.dart';
import '/screens/conversations/widgets/input.dart';
import '/imports.dart';

class ConversationChatView extends StatelessWidget {
  final realtimeService = Get.find<RealtimeService>();

  final ConversationChatController controller;
  final int conversation_id;

  ConversationChatView({
    super.key,
    required this.conversation_id,
    MessageInfo? initial_message,
  }) : controller = Get.putOrFind(
          () => ConversationChatController(
            conversation_id: conversation_id,
            initial_message: initial_message,
          ),
          tag: '$conversation_id',
        );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = controller.info.value;

      return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            final typing = realtimeService.typing.value;

            if (info != null) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: avatar(
                  context,
                  url: info.meta.sender.thumbnail,
                  size: 28,
                  fallback: info.meta.sender.name.substring(0, 1),
                  isOnline:
                      realtimeService.online.contains(info.meta.sender.id),
                  isTyping: typing.contains(info.meta.sender.id),
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
            if (info != null)
              IconButton(
                icon: Icon(info.status.icon),
                onPressed: () {
                  switch (info.status) {
                    case ConversationStatus.open:
                      controller.changeStatus(ConversationStatus.resolved);
                      break;

                    case ConversationStatus.resolved:
                    case ConversationStatus.snoozed:
                      controller.changeStatus(ConversationStatus.open);
                      break;

                    default:
                      break;
                  }
                },
              ),
            IconButton(
              icon: Icon(Icons.menu_outlined),
              onPressed: info == null
                  ? null
                  : () => Get.to(
                        () => ConversationDetailView(
                          conversation_id: conversation_id,
                        ),
                      ),
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
                ConversationInput(id: controller.conversation_id),
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
    });
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
      final messages = controller.messages.value;

      return ListView.builder(
        controller: controller.scrollController,
        reverse: true,
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        itemCount: messages.length,
        itemBuilder: (_, i) {
          final item = messages[i];

          // TODO: make radius
          var topLeft = 8.0;
          var topRight = 8.0;
          var bottomLeft = 8.0;
          var bottomRight = 8.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Message(
              controller: controller,
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
