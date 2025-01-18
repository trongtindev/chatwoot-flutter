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
