import '../controllers/index.dart';
import '/imports.dart';

class ConversationsView extends GetView<ConversationsController> {
  const ConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final realtime = Get.find<RealtimeService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('conversations'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: controller.showFilter,
          ),
          Padding(padding: EdgeInsets.only(right: 8)),
        ],
      ),
      body: RefreshIndicator(
        notificationPredicate: (scrollNotification) {
          var pixels = scrollNotification.metrics.pixels;
          var maxScrollExtent = scrollNotification.metrics.maxScrollExtent;
          var isScrollEnded = pixels >= maxScrollExtent * 0.8;
          if (isScrollEnded) controller.loadMore();
          return defaultScrollNotificationPredicate(scrollNotification);
        },
        onRefresh: () => controller.getConversations(reset: true),
        child: Obx(() {
          if (controller.loading.value && controller.items.isEmpty) {
            return buildPlaceholder();
          } else if (controller.error.isNotEmpty) {
            return buildError();
          } else if (controller.items.isEmpty) {
            return buildEmptyState();
          }
          return ListView(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                prototypeItem: buildItem(realtime, controller.items.first),
                itemCount: controller.items.length,
                itemBuilder: (_, i) {
                  return buildItem(realtime, controller.items[i]);
                },
              ),
              if (controller.isLoadMore.value) loadMore(),
              if (controller.isNoMore.value) noMore(),
            ],
          );
        }),
      ),
    );
  }

  // TODO: make this better with skeleton
  Widget buildPlaceholder() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildError() {
    return error(
      message: controller.error.value,
      onRetry: controller.getConversations,
    );
  }

  Widget buildEmptyState() {
    return Text('empty_state');
  }

  Widget buildItem(RealtimeService realtime, ConversationInfo info) {
    var last_activity_at = formatTimeago(info.last_activity_at);
    var typeIcon = (() {
      var type = info.messages.first.message_type;
      switch (type) {
        case MessageType.incoming:
          return Icons.subdirectory_arrow_right_outlined;
        default:
          return null;
      }
    })();
    var lastMessage = (() {
      if (info.last_non_activity_message != null) {
        switch (info.last_non_activity_message!.content_type) {
          case MessageContentType.text:
            return info.last_non_activity_message!.content;
          default:
            return null;
        }
      }
      return null;
    })();

    return ListTile(
      leading: Obx(() {
        return avatar(
          url: info.meta.sender.thumbnail,
          fallback: info.meta.sender.name.substring(0, 1),
          isOnline: realtime.online.contains(info.meta.sender.id),
        );
      }),
      title: Row(
        children: [
          Expanded(
            child: Text(
              info.meta.sender.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(
            last_activity_at,
            style: TextStyle(
              fontSize: Get.textTheme.labelSmall!.fontSize,
              color: Get.theme.colorScheme.outline,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          if (typeIcon != null)
            Icon(
              typeIcon,
              size: 16,
              color: Get.theme.colorScheme.outline,
            ),
          if (lastMessage != null)
            Expanded(
              child: Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Get.theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (info.unread_count > 0)
            Badge(
              label: Text('${info.unread_count}'),
            ),
          Icon(Icons.chevron_right),
        ],
      ),
      tileColor:
          info.unread_count > 0 ? Get.theme.colorScheme.primaryContainer : null,
      onTap: () => controller.onTap(info),
    );
  }
}
