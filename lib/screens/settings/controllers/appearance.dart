import '../widgets/change_theme_mode.dart';
import '/imports.dart';

class SettingsAppearanceController extends GetxController {
  final theme = Get.find<ThemeService>();

  void changeMode() {
    Get.bottomSheet(ChangeThemeModeSheet());
  }
}
