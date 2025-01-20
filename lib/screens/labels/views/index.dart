import '../controllers/index.dart';
import '/imports.dart';

class LabelsView extends GetView<LabelsController> {
  final labelService = Get.find<LabelService>();

  LabelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LabelsController(),
      builder: (_) {
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
                var items = labelService.items.value;
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
      },
    );
  }

  Widget buildItem(LabelInfo info) {
    return ListTile(
      title: Text(info.title),
      subtitle: Text(info.description),
      trailing: Wrap(
        spacing: 4,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: info.color,
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Icon(Icons.chevron_right_outlined),
        ],
      ),
    );
  }
}
