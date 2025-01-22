import '/imports.dart';

class LabelsPickerController extends GetxController {
  final labels = Get.find<LabelsController>();
  final selected = RxList<LabelInfo>();

  LabelsPickerController({List<String>? selected}) {
    selected ??= [];
    this.selected.value =
        labels.items.where((e) => selected!.contains(e.title)).toList();
  }

  void toggle(LabelInfo info) {
    if (selected.contains(info)) {
      selected.remove(info);
      return;
    }
    selected.add(info);
  }
}

class LabelsPicker extends StatelessWidget {
  final LabelsPickerController c;
  final labels = Get.find<LabelsController>();

  final bool multiple;
  LabelsPicker({super.key, List<String>? selected, bool? multiple})
      : c = Get.put(LabelsPickerController(selected: selected)),
        multiple = multiple ?? false;

  @override
  Widget build(BuildContext context) {
    return bottomSheet(
      context,
      child: Obx(() {
        final items = labels.items.value;

        return Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_outlined),
                label: Text(t.labels_search),
                hintText: t.labels_search_hint,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  return buildItem(items[i]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: primaryButton(
                block: true,
                label: t.save_changes,
                onPressed: () => Navigator.of(context).pop(c.selected.value),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildItem(LabelInfo info) {
    return Obx(() {
      final selected = c.selected.value;

      return ListTile(
        title: Text(info.title),
        subtitle: Text(
          info.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Checkbox(
          value: selected.contains(info),
          onChanged: (next) => c.toggle(info),
        ),
        onTap: () => c.toggle(info),
      );
    });
  }
}
