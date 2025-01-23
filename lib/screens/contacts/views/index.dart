import '../controllers/index.dart';
import '/imports.dart';

class ContactsView extends GetView<ContactsController> {
  final realtime = Get.find<RealtimeService>();

  ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.contacts),
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
            onRefresh: () => controller.getContacts(reset: true),
            child: Obx(() {
              if (controller.loading.value && controller.items.isEmpty) {
                return buildPlaceholder();
              } else if (controller.error.isNotEmpty) {
                return errorState(
                  context,
                  error: controller.error.value,
                  onRetry: () => controller.getContacts(reset: true),
                );
              } else if (controller.items.isEmpty) {
                return emptyState(
                  context,
                  image: 'conversations.png',
                  title: t.contacts_empty_title,
                  description: t.contacts_empty_description,
                );
              }
              return ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    prototypeItem: buildItem(context, controller.items.first),
                    itemCount: controller.items.length,
                    itemBuilder: (_, i) {
                      return buildItem(context, controller.items[i]);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(t.contacts_add),
        icon: Icon(Icons.add_outlined),
      ),
    );
  }

  // TODO: make this better with skeleton
  Widget buildPlaceholder() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildItem(BuildContext context, ContactInfo info) {
    return CustomListTile(
      leading: avatar(
        context,
        url: info.thumbnail,
        fallback: info.name.substring(0, 1),
        isOnline: realtime.online.contains(info.id),
      ),
      title: Text(
        info.name,
        maxLines: 1,
        style: TextStyle(
          fontSize: Get.textTheme.bodyLarge!.fontSize,
        ),
      ),
      subtitle: Text(
        info.phone_number ??
            info.email ??
            info.identifier ??
            info.id.toString(),
        maxLines: 1,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () => controller.showDetail(info),
    );
  }
}
