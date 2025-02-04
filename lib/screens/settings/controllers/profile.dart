import '/imports.dart';

class SettingsProfileController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final full_name = TextEditingController();
  final display_name = TextEditingController();
  final email = TextEditingController();
  final message_signature = TextEditingController();

  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();

    var profile = _auth.profile.value!;
    full_name.text = profile.name;
    display_name.text = profile.display_name;
    email.text = profile.email;
    if (profile.message_signature != null) {
      message_signature.text = profile.message_signature!;
    }
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    _logger.d('submit()');

    try {
      final result = await _api.profile.update(
        name: full_name.text,
        display_name: display_name.text,
        email: email.text,
      );
      _auth.profile.value = result.getOrThrow();
      showSnackBar(t.successful);
    } catch (error) {
      if (error is! ApiError) _logger.e(error);
      errorHandler(error);
    } finally {
      isLoading.value = false;
    }
  }
}
