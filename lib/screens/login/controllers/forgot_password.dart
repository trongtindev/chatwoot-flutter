import '/imports.dart';

class ForgotPasswordController extends GetxController {
  final _api = Get.find<ApiService>();
  final _logger = Logger();

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final isLoading = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    _logger.i('submit()');

    try {
      final result = await _api.resetPassword(
        email: email.text,
      );
      final message = result.getOrThrow();

      Get.dialog(
        AlertDialog(
          title: Text(t.successful),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Get.close(),
              child: Text(t.understand),
            )
          ],
        ),
      );
    } catch (error) {
      if (error is! ApiError) _logger.e(error);
      errorHandler(error);
    } finally {
      isLoading.value = false;
    }
  }
}
