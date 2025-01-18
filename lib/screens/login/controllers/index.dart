import '/imports.dart';

class LoginController extends GetxController {
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final _logger = Logger();

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final visiblePassword = false.obs;
  final isSigning = false.obs;
  final canSubmit = false.obs;

  void toggleVisiblePassword() {
    visiblePassword.value = !visiblePassword.value;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isSigning.value = true;
    _logger.i('submit()');

    try {
      var result = await _api.signIn(
        email: email.text,
        password: password.text,
      );
      var profile = result.getOrThrow();

      _logger.i('submit() => Logged in to ${profile.name}#${profile.id}');
      _auth.profile.value = profile;

      Get.offAll(() => DefaultLayout());
    } catch (error) {
      if (error is! ApiError) _logger.e(error);
      errorHandler(error);
    } finally {
      isSigning.value = false;
    }
  }
}
