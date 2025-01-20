import '../controllers/index.dart';
import '/imports.dart';

class ContactFilterView extends GetView<ContactsController> {
  const ContactFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return bottomSheet(
      context,
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
    return Container();
  }

  Widget buildSort() {
    return ListView(
      padding: EdgeInsets.all(4),
      children: [
        buildLabel(t.sort_by),
        Card(
          child: Obx(() {
            var orderBy = controller.orderBy.value;

            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: OrderBy.values.length,
              itemBuilder: (_, i) {
                var item = OrderBy.values[i];
                return RadioListTile(
                  title: Text(item.label),
                  value: item,
                  selected: orderBy == item,
                  groupValue: orderBy,
                  onChanged: (next) => controller.orderBy.value = item,
                );
              },
            );
          }),
        ),
        buildLabel(t.order_by),
        Card(
          child: Obx(() {
            var sortBy = controller.sortBy.value;

            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ContactSortBy.values.length,
              itemBuilder: (_, i) {
                var item = ContactSortBy.values[i];
                return RadioListTile(
                  title: Text(item.label),
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
}
