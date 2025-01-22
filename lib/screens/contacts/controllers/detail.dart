import '/imports.dart';

class ContactDetailController extends GetxController {
  final _logger = Logger();
  final _labels = Get.find<LabelsController>();
  final _api = Get.find<ApiService>();
  final _realtime = Get.find<RealtimeService>();

  final int id;

  ContactDetailController(
    this.id, {
    ContactInfo? initial,
  }) : info = Rxn<ContactInfo>(initial);

  late Rxn<ContactInfo> info;
  final after = 0.obs;
  final error = ''.obs;
  final labels = RxList<String>();
  final conversations = RxList<ConversationInfo>();

  @override
  void onInit() {
    super.onInit();

    _realtime.events.on(
      RealtimeEventId.contactUpdated.name,
      _oncontactUpdated,
    );
  }

  @override
  void onReady() {
    super.onReady();

    getContact();
    getLabels();
    getConversations();
  }

  Future<void> getContact() async {
    try {
      final result = await _api.getContact(
        contact_id: id,
        onCacheHit: (data) => info.value = data,
      );
      final data = result.getOrThrow();
      info.value = data;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      _logger.e(reason, stackTrace: reason.stackTrace);
      error.value = reason.toString();
    }
  }

  Future<void> getLabels() async {
    try {
      final result = await _api.getContactLabels(
        contact_id: id,
        onCacheHit: (data) => labels.value = data,
      );
      final data = result.getOrThrow();
      labels.value = data;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      _logger.e(reason, stackTrace: reason.stackTrace);
      error.value = reason.toString();
    }
  }

  Future<void> getConversations() async {
    try {
      final result = await _api.getContactConversations(
        contact_id: id,
        onCacheHit: (data) => conversations.value = data,
      );
      final data = result.getOrThrow();
      conversations.value = data;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      _logger.e(reason, stackTrace: reason.stackTrace);
      error.value = reason.toString();
    }
  }

  Future<void> modifyLabels() async {
    final items = await _labels.showPicker(selected: labels.value);
    if (items.isEmpty) return;
    labels.value = items.map((e) => e.title).toList();
    await _api.updateContactLabels(
      contact_id: id,
      labels: items.map((e) => e.title).toList(),
    );
  }

  void _oncontactUpdated(ContactInfo info) {
    if (info.id != this.info.value?.id) return;
    this.info.value = info;
  }
}
