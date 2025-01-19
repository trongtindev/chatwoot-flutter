import '../controllers/index.dart';
import '/imports.dart';

class ContactFilterView extends GetView<ContactsController> {
  const ContactFilterView({super.key});

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
              child: Container(
                color: context.theme.colorScheme.surfaceContainer,
                child: TabBarView(
                  children: [
                    buildFilter(),
                    buildSort(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilter() {
    return Container();
  }

  Widget buildSort() {
    return ListView(
      padding: EdgeInsets.all(4),
      children: [
        buildLabel('contact.filter.sort_by'.tr),
        Card(
          child: Obx(() {
            var orderBy = controller.orderBy.value;

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: OrderBy.values.length,
              itemBuilder: (_, i) {
                var item = OrderBy.values[i];
                return RadioListTile(
                  title: Text(item.labelLocalized.tr),
                  value: item,
                  selected: orderBy == item,
                  groupValue: orderBy,
                  onChanged: (next) => controller.orderBy.value = item,
                );
              },
            );
          }),
        ),
        buildLabel('contact.filter.order_by'.tr),
        Card(
          child: Obx(() {
            var sortBy = controller.sortBy.value;

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ContactSortBy.values.length,
              itemBuilder: (_, i) {
                var item = ContactSortBy.values[i];
                return RadioListTile(
                  title: Text(item.labelLocalized.tr),
                  value: item,
                  selected: sortBy == item,
                  groupValue: sortBy,
                  onChanged: (next) => controller.sortBy.value = item,
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(label),
    );
  }
}
