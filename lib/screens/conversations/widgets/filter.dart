import '../controllers/index.dart';
import '/imports.dart';

class ConversationsFilterView extends GetView<ConversationsController> {
  final inboxes = Get.find<InboxesController>();
  final labels = Get.find<LabelsController>();

  ConversationsFilterView({super.key});

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
                  child: Text(t.filter),
                ),
                Tab(
                  child: Text(t.sort_by),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildFilter(context),
                  buildSort(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilter(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(4),
      children: [
        buildFilterAssigneeType(),
        buildFilterStatus(),
        buildFilterLabels(context),
        buildFilterInbox(context),
      ],
    );
  }

  Widget buildFilterAssigneeType() {
    final items = AssigneeType.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.filter_by_assignee_type),
        Obx(() {
          final assigneeType = controller.assignee_type.value;

          return Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (_, i) {
                var item = items[i];
                return CustomRadioListTile(
                  title: Text(item.label),
                  value: item,
                  selected: assigneeType == item,
                  groupValue: assigneeType,
                  onChanged: (next) => controller.assignee_type.value = item,
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildFilterStatus() {
    final items = ConversationStatus.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.filter_by_status),
        Obx(() {
          final status = controller.filter_by_status.value;

          return Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (_, i) {
                var item = items[i];
                return RadioListTile(
                  title: Text(item.label),
                  value: item,
                  selected: status == item,
                  groupValue: status,
                  onChanged: (next) => controller.filter_by_status.value = item,
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildFilterLabels(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.filter_by_inbox),
        Obx(() {
          final items = labels.items.value;
          final filterbyLabels = controller.filter_by_labels.value;

          return Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (_, i) {
                var item = items[i];
                return CustomListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.color,
                  ),
                  title: Text(item.title),
                  subtitle: Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Checkbox(
                    value: filterbyLabels.contains(item),
                    onChanged: (next) => controller.toggleLabel(item),
                  ),
                  onTap: () => controller.toggleLabel(item),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildFilterInbox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.filter_by_inbox),
        Obx(() {
          final items = inboxes.inboxes.value;
          final filterbyInbox = controller.filter_by_inbox.value;

          return Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (_, i) {
                var item = items[i];
                return CustomListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        context.theme.colorScheme.surfaceContainerHigh,
                    child: isNullOrEmpty(item.avatar_url)
                        ? item.channel_type.icon
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: ExtendedImage.network(
                              item.avatar_url,
                            ),
                          ),
                  ),
                  title: Text(item.name),
                  trailing: Radio(
                    value: item.id,
                    groupValue: filterbyInbox,
                    onChanged: (next) =>
                        controller.filter_by_inbox.value = item.id,
                  ),
                  onTap: () => controller.filter_by_inbox.value = item.id,
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildSort() {
    final items = ConversationSortType.values;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Obx(() {
        final sort = controller.sort_order.value;
        return ListView(
          children: [
            Card(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  var item = items[i];
                  return RadioListTile(
                    title: Text(item.label),
                    value: item,
                    selected: sort == item,
                    groupValue: sort,
                    onChanged: (next) => controller.sort_order.value = item,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
