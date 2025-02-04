import '/imports.dart';

class SettingsChangePasswordController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();

  final formKey = GlobalKey<FormState>();
  final current_password = TextEditingController();
  final password = TextEditingController();
  final password_confirmation = TextEditingController();
  final isLoading = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    _logger.d('submit()');

    try {
      final result = await _api.profile.updatePassword(
        current_password: current_password.text,
        password: password.text,
        password_confirmation: password_confirmation.text,
      );
      result.getOrThrow();
      Get.snackbar(t.successful, t.change_password_successful);
    } catch (error) {
      if (error is! ApiError) _logger.e(error);
      errorHandler(error);
    } finally {
      isLoading.value = false;
    }
  }
}
