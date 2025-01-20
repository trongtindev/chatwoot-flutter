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
              if (controller.loading.value && controller.items.isEmpty) {
                return buildPlaceholder();
              } else if (controller.error.isNotEmpty) {
                return buildError(context);
              } else if (controller.items.isEmpty) {
                return buildEmptyState();
              }
              return ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    prototypeItem:
                        buildItem(context, info: controller.items.first),
                    itemCount: controller.items.length,
                    itemBuilder: (_, i) {
                      return buildItem(context, info: controller.items[i]);
                    },
                  ),
                  if (controller.isLoadMore.value) loadMore(),
                  if (controller.isNoMore.value) noMore(),
                ],
              );
            }),
          ),
          Obx(() {
            if (controller.loading.value && !controller.isLoadMore.value) {
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
      onRetry: controller.getNotifications,
    );
  }

  Widget buildEmptyState() {
    return Text('empty_state');
  }

  Widget buildItem(
    BuildContext context, {
    required NotificationInfo info,
  }) {
    var created_at = formatTimeago(info.created_at);

    return ListTile(
      leading: avatar(
        context,
        url: info.primary_actor.meta.sender.thumbnail,
        fallback: info.primary_actor.meta.sender.name.substring(0, 1),
      ),
      title: Text(
        info.push_message_title,
        style: TextStyle(
          fontSize: Get.textTheme.bodyLarge!.fontSize,
        ),
      ),
      subtitle: Text(
        '${info.primary_actor.meta.sender.name} · $created_at',
        style: TextStyle(
          fontSize: Get.textTheme.labelSmall!.fontSize,
        ),
      ),
      trailing: Icon(Icons.chevron_right),
      tileColor: info.read_at == null
          ? context.theme.colorScheme.primaryContainer
          : null,
      onTap: () => controller.onTap(info),
    );
  }
}
