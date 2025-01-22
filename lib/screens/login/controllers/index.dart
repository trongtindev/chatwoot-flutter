import '/imports.dart';

class LoginController extends GetxController {
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final _logger = Logger();

  final bool? logout;
  LoginController({this.logout});

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final visiblePassword = false.obs;
  final isSigning = false.obs;
  final canSubmit = false.obs;

  @override
  void onReady() {
    super.onReady();

    if (logout != null && logout!) _auth.logout();
  }

  void toggleVisiblePassword() {
    visiblePassword.value = !visiblePassword.value;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isSigning.value = true;
    _logger.i('submit()');

    try {
      final result = await _api.signIn(
        email: email.text,
        password: password.text,
      );
      final profile = result.getOrThrow();

      _logger.i('Logged in to ${profile.name}#${profile.id}');
      _auth.profile.value = profile;

      Get.offAll(() => DefaultLayout());
    } catch (error) {
      errorHandler(error);
    } finally {
      isSigning.value = false;
    }
  }
}
