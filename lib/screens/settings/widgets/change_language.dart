import '/imports.dart';

class ChangeLanguageSheet extends GetView<SettingsService> {
  const ChangeLanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final items = Language.values;

    return Obx(() {
      final language = controller.language.value;

      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];

          return CustomRadioListTile(
            title: Text(item.labelLocalized),
            value: item,
            groupValue: language,
            onChanged: (next) {
              controller.language.value = next;
            },
          );
        },
      );
    });
  }
}
