import '/screens/labels/widgets/editor.dart';
import '../widgets/picker.dart';
import '/imports.dart';

class LabelsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final items = RxList<LabelInfo>();

  @override
  void onReady() {
    super.onReady();

    _auth.profile.listen((next) {
      if (next == null) {
        items.value = [];
        return;
      }
      getLabels();
    });
    if (_auth.isSignedIn.value) getLabels();
  }

  Future<LabelsController> init() async {
    return this;
  }

  Future<void> getLabels() async {
    try {
      final result = await _api.labels.list(
        onCacheHit: (data) {
          items.value = data.payload;
        },
      );
      items.value = result.getOrThrow().payload;
      _logger.d('found ${items.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }

  Future<void> add() async {
    Get.bottomSheet(LabelEditor());
  }

  Future<void> edit(LabelInfo info) async {
    Get.bottomSheet(LabelEditor(edit: info));
  }

  Future<void> delete(LabelInfo info) async {
    if (!await confirm(t.confirm_delete_message(info.title))) return;
    _api.labels.delete(label_id: info.id).then((_) {
      items.remove(info);
    });
  }

  Future<List<LabelInfo>> showPicker({List<String>? selected}) async {
    final result = await Get.bottomSheet<List<LabelInfo>?>(
      LabelsPicker(
        selected: selected,
      ),
    );
    return result ?? [];
  }
}
