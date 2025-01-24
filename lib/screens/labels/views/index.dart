import '/imports.dart';

class LabelsView extends GetView<LabelsController> {
  final auth = Get.find<AuthService>();

  LabelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(t.labels),
              centerTitle: true,
              background: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    t.labels_description,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            final items = controller.items.value;

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  return buildItem(context, items[i]);
                },
                childCount: items.length,
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.addLabel,
        label: Text(t.labels_add),
        icon: Icon(Icons.add_outlined),
      ),
    );
  }

  Widget buildItem(BuildContext context, LabelInfo info) {
    final isAdmin = auth.profile.value!.role == UserRole.administrator;

    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 8),
      leading: CircleAvatar(
        backgroundColor: info.color,
      ),
      title: Text(info.title),
      subtitle: Text(info.description),
      trailing: Wrap(
        children: [
          if (isAdmin)
            IconButton.filledTonal(
              onPressed: () => {},
              icon: Icon(Icons.edit_outlined),
            ),
          if (isAdmin)
            IconButton.filledTonal(
              onPressed: () => controller.delete(info),
              icon: Icon(
                Icons.delete_outline,
                color: context.theme.colorScheme.error,
              ),
            )
        ],
      ),
    );
  }
}
