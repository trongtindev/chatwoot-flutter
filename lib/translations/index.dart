import 'package:get/get.dart' as getx;
import './messages/en.dart' as en;
import './messages/vi.dart' as vi;

class Translations extends getx.Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'en': en.keys,
      'vi': vi.keys,
    };
  }
}
