import '/imports.dart';

class MacrosController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final items = RxList<MacroInfo>();

  @override
  void onReady() {
    super.onReady();

    _auth.profile.listen((next) {
      if (next == null) return;
      getMacros();
    });

    if (_auth.isSignedIn.value) getMacros();
  }

  Future<void> getMacros() async {
    try {
      final result = await _api.listMacros();
      items.value = result.getOrThrow();
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }

  Future<MacrosController> init() async {
    return this;
  }

  Future<void> delete(MacroInfo info) async {
    if (!await confirmDelete(name: info.name)) return;
    items.remove(info);
    _api.deleteMacro(macro_id: info.id);
  }
}
