import '../../../imports.dart';

class ChangeThemeModeSheet extends GetView<ThemeService> {
  const ChangeThemeModeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = controller.mode.value;

      return ListView.builder(
        shrinkWrap: true,
        itemCount: ThemeMode.values.length,
        itemBuilder: (_, i) {
          final mode = ThemeMode.values[i];

          return CustomRadioListTile(
            title: Text(mode.label),
            onTap: () {
              controller.mode.value = mode;
              Navigator.of(Get.context!).pop();
            },
            value: mode,
            groupValue: current,
            onChanged: (next) {
              controller.mode.value = next;
              Navigator.of(Get.context!).pop();
            },
          );
        },
      );
    });
  }
}
