import '../controllers/index.dart';
import '/imports.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.notifications),
        centerTitle: true,
        actions: [
          Obx(() {
            var unread_count = controller.unread_count.value;
            if (unread_count == 0) return Container();
            return IconButton(
              icon: Icon(Icons.done_all_outlined),
              onPressed: controller.readAll,
            );
          }),
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
            onRefresh: () => controller.getNotifications(reset: true),
            child: Obx(() {
              final error = controller.error.value;
              final items = controller.items.value;
              final loading = controller.loading.value;

              if (loading && items.isEmpty) {
                return buildPlaceholder();
              } else if (error.isNotEmpty) {
                return errorState(
                  context,
                  error: error,
                  onRetry: controller.getNotifications,
                );
              } else if (items.isEmpty) {
                return emptyState(
                  context,
                  image: 'conversations.png',
                  title: t.notification_empty_title,
                  description: t.notification_empty_description,
                );
              }
              return ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      return buildItem(context, info: items[i]);
                    },
                  ),
                  if (controller.isLoadMore.value) loadMore(),
                  if (controller.isNoMore.value) noMore(),
                ],
              );
            }),
          ),
          Obx(() {
            final loading = controller.loading.value;
            final isLoadMore = controller.loading.value;

            if (loading && !isLoadMore) {
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

  // TODO: better with skeleton
  Widget buildPlaceholder() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildItem(
    BuildContext context, {
    required NotificationInfo info,
  }) {
    final created_at = formatTimeago(info.created_at);

    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 16),
      leading: avatar(
        context,
        url: info.primary_actor.meta.sender.thumbnail,
        fallback: info.primary_actor.meta.sender.name.substring(0, 1),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              info.primary_actor.meta.sender.name,
              style: TextStyle(
                  // fontSize: context.textTheme.titleMedium!.fontSize,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            created_at,
            style: TextStyle(
              fontSize: Get.textTheme.labelSmall!.fontSize,
            ),
          ),
        ],
      ),
      subtitle: Text(
        info.notification_type.content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      tileColor: info.read_at == null
          ? context.theme.colorScheme.primaryContainer
          : null,
      onTap: () => controller.onTap(info),
    );
  }
}
