import '/imports.dart';

class ChangeUrlController extends GetxController {
  final _api = Get.find<ApiService>();
  final _logger = Logger();

  final formKey = GlobalKey<FormState>();
  final baseUrl = TextEditingController();
  final isValidating = false.obs;

  @override
  void onReady() {
    super.onReady();
    baseUrl.text = Uri.parse(_api.baseUrl.value).host;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isValidating.value = true;
    _logger.i('submit()');

    try {
      var finalUrl = 'https://${baseUrl.text}';
      var result = await _api.getInfo(baseUrl: finalUrl);
      var info = result.getOrThrow();
      _logger.i('submit() => successful! version: ${info.version}');
      _api.baseUrl.value = finalUrl;
      Get.back(result: true);
    } catch (error) {
      if (error is! ApiError) _logger.e(error);
      errorHandler(error);
    } finally {
      isValidating.value = false;
    }
  }
}
