import '/imports.dart';

class SettingsService extends GetxService {
  final _logger = Logger();

  final language = PersistentRxCustom(
    Language.en,
    key: 'settings:language',
    encode: (value) => value.name,
    decode: (name) => Language.values.byName(name),
  );
  final ignoreConfirm = PersistentRxBool(false, key: 'settings:ignoreConfirm');

  @override
  void onReady() {
    super.onReady();

    language.listen((next) {
      _logger.i('language changed: $next');
      Get.updateLocale(next.locale);
    });
  }
}
