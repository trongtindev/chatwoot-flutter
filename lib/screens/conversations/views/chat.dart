import '/screens/conversations/views/detail.dart';
import '/screens/conversations/widgets/message.dart';
import '/screens/conversations/controllers/chat.dart';
import '/screens/conversations/widgets/input.dart';
import '/imports.dart';

class ConversationChatView extends StatelessWidget {
  final realtimeService = Get.find<RealtimeService>();

  final ConversationChatController c;
  final int id;

  ConversationChatView({
    super.key,
    required this.id,
    MessageInfo? initial_message,
  }) : c = Get.put(
          ConversationChatController(
            id: id,
            initial_message: initial_message,
          ),
          tag: id.toString(),
        );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = c.info.value;

      return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            final typingUsers = realtimeService.typingUsers.value;

            if (info != null) {
              return ListTile(
                contentPadding: EdgeInsets.only(),
                leading: avatar(
                  context,
                  url: info.meta.sender.thumbnail,
                  size: 28,
                  fallback: info.meta.sender.name.substring(0, 1),
                  isOnline:
                      realtimeService.online.contains(info.meta.sender.id),
                  isTyping: typingUsers.contains(info.meta.sender.id),
                ),
                title: Text(
                  info.meta.sender.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(t.view_details),
                onTap: c.showContactDetail,
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
                      c.changeStatus(ConversationStatus.resolved);
                      break;

                    case ConversationStatus.resolved:
                    case ConversationStatus.snoozed:
                      c.changeStatus(ConversationStatus.open);
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
                  : () => Get.to(() => ConversationDetailView(id: id)),
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
                    if (c.error.value.isNotEmpty) {
                      return buildError(context);
                    }
                    return buildMessages();
                  }),
                ),
                ConversationInput(id: c.id),
              ],
            ),
            Obx(() {
              final loading = c.loading.value;
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
      message: c.error.value,
      onRetry: () {
        c.getConversation();
        c.getMessages();
      },
    );
  }

  Widget buildMessages() {
    return Obx(() {
      var messages = c.messages;

      return ListView.builder(
        controller: c.scrollController,
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
