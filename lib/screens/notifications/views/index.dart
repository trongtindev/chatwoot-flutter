import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../controllers/index.dart';
import '/imports.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr),
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
          Padding(padding: EdgeInsets.only(right: 16)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.getNotifications,
        child: Obx(() {
          if (controller.loading.value) {
            return buildPlaceholder();
          } else if (controller.error.isNotEmpty) {
            return buildError();
          } else if (controller.items.isEmpty) {
            return buildEmptyState();
          }
          return ListView.builder(
            prototypeItem: buildItem(controller.items.first),
            itemCount: controller.items.length,
            itemBuilder: (_, i) {
              return buildItem(controller.items[i]);
            },
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
      onRetry: controller.getNotifications,
    );
  }

  Widget buildEmptyState() {
    return Text('empty_state');
  }

  Widget buildItem(NotificationInfo info) {
    var created_at = formatTimeago(info.created_at);

    if (info.primary_actor != null) {
      return ListTile(
        leading: avatar(
          url: info.primary_actor!.meta.sender.thumbnail,
          isOnline: info.primary_actor!.meta.sender.availability_status ==
              AvailabilityStatus.online,
        ),
        title: Text(
          info.push_message_title,
          style: TextStyle(),
        ),
        subtitle: Text('$created_at · ${info.primary_actor!.meta.sender.name}'),
        trailing: Icon(Icons.chevron_right),
      );
    }

    return ListTile(
      leading: avatar(),
      title: Text(info.push_message_title),
      subtitle: Text('$created_at · ${info.notification_type}'),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
