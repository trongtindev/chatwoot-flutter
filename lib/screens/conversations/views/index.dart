import '../controllers/index.dart';
import '/imports.dart';

class ConversationsView extends GetView<ConversationsController> {
  final labels = Get.find<LabelsController>();
  final realtimeService = Get.find<RealtimeService>();

  ConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.conversations),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: controller.showFilter,
          ),
          Padding(padding: EdgeInsets.only(right: 8)),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            notificationPredicate: (scrollNotification) {
              var pixels = scrollNotification.metrics.pixels;
              var maxScrollExtent = scrollNotification.metrics.maxScrollExtent;
              var isScrollEnded = pixels >= maxScrollExtent * 0.8;
              if (isScrollEnded) controller.loadMore();
              return defaultScrollNotificationPredicate(scrollNotification);
            },
            onRefresh: () => controller.getConversations(reset: true),
            child: Obx(() {
              final typingUsers = realtimeService.typingUsers.value;

              if (controller.loading.value && controller.items.isEmpty) {
                return buildPlaceholder();
              } else if (controller.error.isNotEmpty) {
                return buildError(context);
              } else if (controller.items.isEmpty) {
                return emptyState(
                  context,
                  image: 'conversations.png',
                  title: t.conversation_empty_title,
                  description: t.conversation_empty_description,
                );
              }

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.items.length,
                    itemBuilder: (_, i) {
                      final item = controller.items[i];
                      final isTyping =
                          typingUsers.contains(item.meta.sender.id);
                      return buildItem(context, item, isTyping: isTyping);
                    },
                  ),
                  if (controller.is_load_more.value) loadMore(),
                  if (controller.is_no_more.value) noMore(),
                ],
              );
            }),
          ),
          Obx(() {
            if (controller.loading.value && !controller.is_load_more.value) {
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

  // TODO: make this better with skeleton
  Widget buildPlaceholder() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildError(BuildContext context) {
    return error(
      context,
      message: controller.error.value,
      onRetry: controller.getConversations,
    );
  }

  Widget buildItem(
    BuildContext context,
    ConversationInfo info, {
    required bool isTyping,
  }) {
    final last_activity_at = formatTimeago(info.last_activity_at);
    final typeIcon = (() {
      var type = info.messages.first.message_type;
      switch (type) {
        case MessageType.incoming:
          return Icons.subdirectory_arrow_right_outlined;
        default:
          return null;
      }
    })();

    return ListTile(
      isThreeLine: info.labels.isNotEmpty,
      leading: Obx(() {
        return avatar(
          context,
          url: info.meta.sender.thumbnail,
          fallback: info.meta.sender.name.substring(0, 1),
          isOnline: realtimeService.online.contains(info.meta.sender.id),
          isTyping: isTyping,
        );
      }),
      title: Row(
        children: [
          Expanded(
            child: Text(
              info.meta.sender.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: Get.textTheme.bodyLarge!.fontSize,
              ),
            ),
          ),
          Text(
            last_activity_at,
            style: TextStyle(
              fontSize: Get.textTheme.labelSmall!.fontSize,
              color: context.theme.colorScheme.outline,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (typeIcon != null)
                Icon(
                  typeIcon,
                  size: 16,
                  color: context.theme.colorScheme.outline,
                ),
              buildLastMessage(context, info),
              if (info.unread_count > 0)
                Badge(
                  label: Text('${info.unread_count}'),
                ),
            ],
          ),
          if (info.labels.isNotEmpty)
            Obx(() {
              final items = labels.items.value;

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 32,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: info.labels.length,
                    itemBuilder: (_, i) {
                      final item = info.labels[i];
                      final label =
                          items.firstWhereOrNull((e) => e.title == item);
                      return Chip(
                        label: Row(
                          spacing: 4,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: label?.color ??
                                    context
                                        .theme.colorScheme.surfaceContainerHigh,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Text(item),
                          ],
                        ),
                        padding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
              );
            }),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
      tileColor: info.unread_count > 0
          ? context.theme.colorScheme.primaryContainer
          : null,
      onTap: () => controller.onTap(info),
    );
  }

  Widget buildLastMessage(BuildContext context, ConversationInfo info) {
    final message = info.last_non_activity_message;
    final content = (() {
      if (message == null) return null;

      if (message.attachments.isNotEmpty) {
        if (message.attachments.length == 1) {
          return message.attachments.first.file_type.label;
        } else {
          return t.attachment_files_content;
        }
      }

      switch (message.content_type) {
        case MessageContentType.text:
          return message.content;
        default:
          return message.content_type.name;
      }
    })();

    if (content == null) return Container();
    return Expanded(
      child: Text(
        content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: context.theme.colorScheme.outline,
        ),
      ),
    );
  }
}
