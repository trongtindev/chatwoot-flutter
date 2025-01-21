import '/imports.dart';

class SettingsService extends GetxService {
  final _logger = Logger();

  final language = Language.en.obs;
  final ignoreConfirm = PersistentRxBool(false, key: 'settings:ignoreConfirm');

  Future<SettingsService> init() async {
    return this;
  }
}
