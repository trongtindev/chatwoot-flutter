import '../controllers/index.dart';
import '/imports.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('contacts'.tr),
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
        onRefresh: () => controller.getContacts(reset: true),
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
                prototypeItem: buildItem(controller.items.first),
                itemCount: controller.items.length,
                itemBuilder: (_, i) {
                  return buildItem(controller.items[i]);
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
      onRetry: () => controller.getContacts(reset: true),
    );
  }

  Widget buildEmptyState() {
    return Text('empty_state');
  }

  Widget buildItem(ContactInfo info) {
    return ListTile(
      leading: avatar(url: info.thumbnail),
      title: Text(info.name, maxLines: 1),
      subtitle: Text(
          info.phone_number ??
              info.email ??
              info.identifier ??
              info.id.toString(),
          maxLines: 1),
      trailing: Icon(Icons.chevron_right),
      onTap: () => controller.showDetail(info),
    );
  }
}
