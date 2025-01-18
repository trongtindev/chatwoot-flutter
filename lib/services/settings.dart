import '/imports.dart';

class SettingsService extends GetxService {
  final _logger = Logger();
  final language = Language.en.obs;

  @override
  void onReady() {
    super.onReady();
  }

  Future<SettingsService> init() async {
    _logger.i('init()');

    // timeago.setDefaultLocale(Get.locale!.languageCode);

    _logger.i('init() => successful');
    return this;
  }
}
