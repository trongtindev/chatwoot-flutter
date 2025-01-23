import '/imports.dart';

class LabelsView extends GetView<LabelsController> {
  const LabelsView({super.key});

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
                  return buildItem(items[i]);
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

  Widget buildItem(LabelInfo info) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: info.color,
      ),
      title: Text(info.title),
      subtitle: Text(info.description),
    );
  }
}
