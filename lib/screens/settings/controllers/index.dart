import '../../login/views/index.dart';
import '/imports.dart';

class SettingsController extends GetxController {
  Future<void> logout() async {
    if (!await confirm(t.logout_confirm)) return;
    Get.offAll(() => LoginView(logout: true));
  }
}
