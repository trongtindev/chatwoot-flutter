import '/imports.dart';

class MacrosController extends GetxController {
  final _api = Get.find<ApiService>();
  final _macro = Get.find<MacroService>();

  @override
  void onReady() {
    super.onReady();
    _macro.getMacros();
  }

  Future<void> delete(MacroInfo info) async {
    if (!await confirmDelete(name: info.name)) return;
    _macro.items.remove(info);
    _api.deleteMacro(macro_id: info.id);
  }
}
