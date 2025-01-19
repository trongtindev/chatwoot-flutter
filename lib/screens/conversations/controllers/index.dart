import '/screens/conversations/views/index_filter.dart';
import '/screens/conversations/views/chat.dart';
import '/imports.dart';

class ConversationsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final all_count = 0.obs;
  final mine_count = 0.obs;
  final items = RxList<ConversationInfo>();
  final loading = true.obs;
  final error = ''.obs;
  final page = 1.obs;
  final isLoadMore = false.obs;
  final isNoMore = false.obs;

  @override
  void onReady() {
    super.onReady();
    getConversations();
    // includes.listen((_) => getConversations());
  }

  Future<void> getConversations({
    bool? append,
    bool? reset,
  }) async {
    try {
      append ??= false;
      reset ??= false;

      loading.value = true;
      if (reset) {
        page.value = 1;
        isLoadMore.value = false;
        isNoMore.value = false;
      }

      var result = await _api.listConversations(
        account_id: _auth.profile.value!.account_id,
        page: page.value,
        onCacheHit: append || reset
            ? null
            : (data) {
                items.value = data.payload;
                all_count.value = data.meta.all_count;
                mine_count.value = data.meta.mine_count;
              },
      );
      var data = result.getOrThrow();

      if (append) {
        items.value.addAll(data.payload);
        isNoMore.value = data.payload.isEmpty;
      } else {
        items.value = data.payload;
      }

      all_count.value = data.meta.all_count;
      mine_count.value = data.meta.mine_count;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      print(reason.stackTrace);
      _logger.e(reason);
      error.value = reason.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> showFilter() async {
    var result = await Get.bottomSheet<bool>(ConversationsFilterView());
    if (result == null || !result) return;
    getConversations();
  }

  Future<void> readAll() async {}

  Future<void> onTap(ConversationInfo info) async {
    Get.to(
      () => ConversationChatView(
        conversation_id: info.id,
        initial_message: info.last_non_activity_message,
      ),
    );
  }

  Future<void> loadMore() async {
    if (isNoMore.value) return;
    if (isLoadMore.value) return;

    page.value += 1;
    isLoadMore.value = true;
    await getConversations(append: true);
    isLoadMore.value = false;
  }
}
