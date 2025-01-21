import '/screens/notifications/controllers/index.dart';
import '/imports.dart';

class NotificationsFilterView extends GetView<NotificationsController> {
  const NotificationsFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: Text('common.filter'),
                ),
                Tab(
                  child: Text('common.sort'),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildFilter(),
                  buildSort(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilter() {
    var items = NotificationStatus.values;

    return Obx(() {
      var loading = controller.loading.value;
      return ListView.builder(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        itemCount: items.length,
        itemBuilder: (_, i) {
          var item = items[i];
          return ListTile(
            enabled: !loading,
            title: Text(item.name),
            trailing: Checkbox(
              value: controller.includes.contains(item),
              onChanged: (next) {
                if (next != null && next) {
                  controller.includes.add(item);
                  return;
                }
                controller.includes.remove(item);
              },
            ),
            onTap: () {
              if (controller.includes.contains(item)) {
                controller.includes.remove(item);
                return;
              }
              controller.includes.add(item);
            },
          );
        },
      );
    });
  }

  Widget buildSort() {
    return Text('sprt');
  }
}
