import '/screens/contacts/views/detail.dart';
import '/screens/contacts/views/index_filter.dart';
import '/imports.dart';

class ContactsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final _realtime = Get.find<RealtimeService>();

  final items = RxList<ContactInfo>();
  final loading = true.obs;
  final error = ''.obs;
  final sortBy = ContactSortBy.created_at.obs;
  final orderBy = OrderBy.descending.obs;
  final page = 1.obs;
  final isLoadMore = false.obs;
  final isNoMore = false.obs;

  EventListener<ContactInfo>? _onCreatedistener;
  EventListener<ContactInfo>? _onUpdatedistener;

  @override
  void onReady() {
    super.onReady();

    _onCreatedistener = _realtime.events.on(
      RealtimeEventId.contactCreated.name,
      _onCreated,
    );

    _onUpdatedistener = _realtime.events.on(
      RealtimeEventId.contactUpdated.name,
      _onUpdated,
    );

    sortBy.listen((_) => getContacts());
    orderBy.listen((_) => getContacts());

    _auth.isSignedIn.listen((next) {
      if (!next) return;
      getContacts();
    });
    if (_auth.isSignedIn.value) getContacts();
  }

  @override
  void onClose() {
    _onCreatedistener?.cancel();
    _onUpdatedistener?.cancel();

    super.onClose();
  }

  Future<ContactsController> init() async {
    return this;
  }

  Future<void> getContacts({bool? append, bool? reset}) async {
    try {
      append ??= false;
      reset ??= false;

      error.value = '';
      loading.value = true;
      if (reset) {
        page.value = 1;
        isLoadMore.value = false;
        isNoMore.value = false;
      }

      final result = await _api.contacts.list(
        sortBy: sortBy.value,
        orderBy: orderBy.value,
        page: page.value,
        onCacheHit:
            append || reset
                ? null
                : (data) {
                  items.value = data.payload;
                },
      );
      final data = result.getOrThrow();

      if (append) {
        items.addAll(data.payload);
      } else {
        items.value = data.payload;
      }
      isNoMore.value =
          data.payload.isEmpty || data.payload.length < env.PAGE_SIZE;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      _logger.e(reason, stackTrace: reason.stackTrace);
      error.value = reason.toString();
    } finally {
      loading.value = false;
    }
  }

  void showDetail(ContactInfo info) {
    Get.to(() => ContactDetailView(contact_id: info.id, initial: info));
  }

  Future<void> showFilter() async {
    final result = await Get.bottomSheet<bool>(ContactFilterView());
    if (result == null || !result) return;
  }

  Future<void> loadMore() async {
    if (isNoMore.value) return;
    if (isLoadMore.value) return;

    page.value += 1;
    isLoadMore.value = true;
    await getContacts(append: true);
    isLoadMore.value = false;
  }

  void _onCreated(ContactInfo info) {
    final index = items.value.indexWhere((e) => e.id == info.id);
    if (index >= 0) {
      _onUpdated(info);
      return;
    }

    items.insert(0, info);
  }

  void _onUpdated(ContactInfo info) {
    final index = items.value.indexWhere((e) => e.id == info.id);
    if (index < 0) return;

    items.value[index] = info;
    items.refresh();
  }
}
