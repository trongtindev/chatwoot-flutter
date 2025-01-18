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
      ),
      body: Obx(() {
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
      onRetry: controller.getContacts,
    );
  }

  Widget buildEmptyState() {
    return Text('empty_state');
  }

  Widget buildItem(ContactInfo info) {
    return ListTile(
      leading: avatar(url: info.thumbnail),
      title: Text(info.name, maxLines: 1),
      subtitle: Text(info.phone_number ?? info.email, maxLines: 1),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
