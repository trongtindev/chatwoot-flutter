import '/screens/conversations/views/chat.dart';
import '/screens/notifications/views/index_filter.dart';
import '/imports.dart';

class NotificationsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final unread_count = 0.obs;
  final includes = NotificationStatus.values.obs;
  final items = RxList<NotificationInfo>();
  final loading = true.obs;
  final error = ''.obs;
  final page = 1.obs;
  final isLoadMore = false.obs;
  final isNoMore = false.obs;

  @override
  void onReady() {
    super.onReady();
    getNotifications();
    includes.listen((_) => getNotifications());
  }

  Future<void> getNotifications({
    bool? append,
    bool? reset,
  }) async {
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

      var result = await _api.listNotifications(
        account_id: _auth.profile.value!.account_id,
        includes: includes,
        page: page.value,
        onCacheHit: append || reset
            ? null
            : (data) {
                items.value = data.payload;
                unread_count.value = data.meta.unread_count;
              },
      );
      var data = result.getOrThrow();

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
    var result = await Get.bottomSheet<bool>(NotificationsFilterView());
    if (result == null || !result) return;
    getNotifications();
  }

  Future<void> readAll() async {}

  Future<void> onTap(NotificationInfo info) async {
    if (info.primary_actor_type == NotificationActorType.Conversation) {
      Get.to(
        () => ConversationChatView(conversation_id: info.primary_actor_id),
      );
      return;
    }
  }

  Future<void> loadMore() async {
    if (isNoMore.value) return;
    if (isLoadMore.value) return;

    page.value += 1;
    isLoadMore.value = true;
    await getNotifications(append: true);
    isLoadMore.value = false;
  }
}
