import '/imports.dart';

class InboxesController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final inboxes = RxList<InboxInfo>();

  @override
  void onReady() {
    super.onReady();

    _auth.profile.listen((next) {
      if (next == null) return;
      getInboxes();
    });

    if (_auth.isSignedIn.value) getInboxes();
  }

  Future<InboxesController> init() async {
    return this;
  }

  Future<void> getInboxes() async {
    try {
      final result = await _api.inboxes.list();
      inboxes.value = result.getOrThrow().payload;
      _logger.d('found ${inboxes.length} items');
    } catch (error) {
      errorHandler(error);
    }
  }
}
