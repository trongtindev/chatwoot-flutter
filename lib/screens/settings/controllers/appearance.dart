import '/imports.dart';

class SettingsAppearanceController extends GetxController {
  final theme = Get.find<ThemeService>();

  Future<void> changeMode() async {
    var result = await Get.bottomSheet<ThemeMode?>(
      Card(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: ThemeMode.values.length,
          itemBuilder: (_, i) {
            var selected = theme.mode.value == ThemeMode.values[i];
            var mode = ThemeMode.values[i];
            return ListTile(
              title: Text(mode.label),
              onTap: () => Navigator.of(Get.context!).pop(mode),
              selected: selected,
              trailing: selected ? Icon(Icons.check_outlined) : null,
            );
          },
        ),
      ),
      showDragHandle: false,
    );
    if (result == null) return;
    theme.mode.value = result;
  }
}
