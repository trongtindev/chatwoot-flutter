import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '/imports.dart';

class LabelEditorController extends GetxController {
  final _api = Get.find<ApiService>();
  final _labels = Get.find<LabelsController>();

  final loading = false.obs;
  final edit = Rxn<LabelInfo>();
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  final color = Colors.green.obs;
  final show_on_sidebar = false.obs;

  LabelEditorController({LabelInfo? edit}) {
    if (edit != null) this.edit.value = edit;
  }

  Future<void> showColorPicker() async {
    final result = await Get.dialog<Color?>(AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: MaterialPicker(
          pickerColor: color.value,
          onColorChanged: (color) {},
          // enableLabel: _enableLabel,
          // portraitOnly: _portraitOnly,
        ),
      ),
    ));
    print(result);
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      loading.value = true;

      final result = await _api.createLabel(
        title: title.text,
        description: description.text,
        color: color.value.toHexString(),
        show_on_sidebar: show_on_sidebar.value,
      );

      _labels.items.insert(0, result.getOrThrow());
      title.text = '';
      description.text = '';
    } finally {
      loading.value = false;
    }
    // Navigator.of(context).pop(c.selected.value)
  }
}

class LabelEditor extends StatelessWidget {
  final LabelEditorController controller;
  final labels = Get.find<LabelsController>();

  LabelEditor({
    super.key,
    LabelInfo? edit,
  }) : controller = Get.put(LabelEditorController(edit: edit));

  @override
  Widget build(BuildContext context) {
    return bottomSheet(
      context,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          final loading = controller.loading.value;

          return Form(
            key: controller.formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  enabled: !loading,
                  controller: controller.title,
                  decoration: InputDecoration(
                    label: Text(t.labels_editor_title),
                    hintText: t.labels_editor_title_hint,
                  ),
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return t.labels_editor_title_invalid;
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                ),
                TextFormField(
                  enabled: !loading,
                  controller: controller.description,
                  decoration: InputDecoration(
                    label: Text(t.labels_editor_description),
                    hintText: t.labels_editor_description_hint,
                  ),
                  minLines: 1,
                  maxLines: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                ),
                Obx(() {
                  final color = controller.color.value;

                  return Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: InkWell(
                          onTap: controller.showColorPicker,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.theme.colorScheme.outlineVariant,
                              ),
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                ),
                Obx(() {
                  final show_on_sidebar = controller.show_on_sidebar.value;
                  return Row(
                    spacing: 8,
                    children: [
                      Switch(
                        value: show_on_sidebar,
                        onChanged: (next) =>
                            controller.show_on_sidebar.value = next,
                      ),
                      Text(t.labels_editor_show_on_sidebar),
                    ],
                  );
                }),
                primaryButton(
                  block: true,
                  label: t.save_changes,
                  onPressed: controller.submit,
                  loading: loading,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
