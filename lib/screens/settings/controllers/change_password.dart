import '/imports.dart';

class SettingsChangePasswordController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final current_password = TextEditingController();
  final new_password = TextEditingController();
  final confirm_password = TextEditingController();
  final isLoading = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    _logger.i('submit()');

    try {
      // var result = await _api.getInfo(baseUrl: finalUrl);
      // var info = result.getOrThrow();
      // _logger.i('submit() => successful! version: ${info.version}');
      // _api.baseUrl.value = finalUrl;
    } catch (error) {
      if (error is! ApiError) _logger.e(error);
      errorHandler(error);
    } finally {
      isLoading.value = false;
    }
  }
}
