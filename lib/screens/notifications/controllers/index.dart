import '../widgets/filter.dart';
import '/imports.dart';

class NotificationsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final _notification = Get.find<NotificationService>();
  final _realtime = Get.find<RealtimeService>();

  final unread_count = 0.obs;
  final includes = NotificationStatus.values.obs;
  final items = RxList<NotificationInfo>();
  final loading = true.obs;
  final error = ''.obs;
  final page = 1.obs;
  final isLoadMore = false.obs;
  final isNoMore = false.obs;

  EventListener<NotificationInfo>? _onCreatedListener;
  EventListener<int>? _onDeletedListener;

  @override
  void onReady() {
    super.onReady();

    _auth.isSignedIn.listen((next) {
      if (!next) return;
      getNotifications();
    });
    if (_auth.isSignedIn.value) getNotifications();

    includes.listen((_) => getNotifications());

    _realtime.events.on(RealtimeEventId.notificationCreated.name, _onCreated);
    _realtime.events.on(RealtimeEventId.notificationDeleted.name, _onDeleted);
  }

  @override
  void onClose() {
    _onCreatedListener?.cancel();
    _onDeletedListener?.cancel();

    super.onClose();
  }

  Future<NotificationsController> init() async {
    return this;
  }

  Future<void> getNotifications({bool? append, bool? reset}) async {
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

      final result = await _api.notifications.list(
        includes: includes,
        page: page.value,
        onCacheHit:
            append || reset
                ? null
                : (data) {
                  items.value = data.payload;
                  unread_count.value = data.meta.unread_count;
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
      unread_count.value = data.meta.unread_count;
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

  Future<void> showFilter() async {
    final result = await Get.bottomSheet<bool>(NotificationsFilterView());
    if (result == null || !result) return;
  }

  Future<void> readAll() async {}

  Future<void> onTap(NotificationInfo info) async {
    if (info.read_at == null) {
      _api.notifications.readAll(
        primary_actor_id: info.primary_actor_id,
        primary_actor_type: info.primary_actor_type,
      );

      info.read_at = DateTime.now();
      items.refresh();
    }

    _notification.handleNavigation(info);
  }

  Future<void> loadMore() async {
    if (isNoMore.value) return;
    if (isLoadMore.value) return;

    page.value += 1;
    isLoadMore.value = true;
    await getNotifications(append: true);
    isLoadMore.value = false;
  }

  void _onCreated(NotificationInfo info) {
    items.insert(0, info);
  }

  void _onDeleted(int id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index < 0) return;
    items.removeAt(index);
  }
}
