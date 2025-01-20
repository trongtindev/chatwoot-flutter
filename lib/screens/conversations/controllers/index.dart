import '/screens/conversations/views/index_filter.dart';
import '/screens/conversations/views/chat.dart';
import '/imports.dart';

class ConversationsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final _shared = Get.find<InboxService>();
  final _realtime = Get.find<RealtimeService>();

  final all_count = 0.obs;
  final mine_count = 0.obs;
  final conversations = RxList<ConversationInfo>();
  final loading = true.obs;
  final error = ''.obs;
  final page = 1.obs;
  final isLoadMore = false.obs;
  final isNoMore = false.obs;
  final assigneeType = AssigneeType.mine.obs;
  final status = ConversationStatus.open.obs;
  final sort_order = ConversationSortType.last_activity_at_desc.obs;
  final filterbyInbox = Rxn<int>();

  EventListener<MessageInfo>? _messageCreatedListener;
  EventListener<MessageInfo>? _messageUpdatedListener;

  @override
  void onInit() {
    super.onInit();

    assigneeType.listen((next) => getConversations(reset: true));
    status.listen((next) => getConversations(reset: true));
    sort_order.listen((next) => getConversations(reset: true));
    filterbyInbox.listen((next) => getConversations(reset: true));

    _messageCreatedListener = _realtime.events.on(
      RealtimeEventId.messageCreated.name,
      _onMessageHandle,
    );

    _messageUpdatedListener = _realtime.events.on(
      RealtimeEventId.messageUpdated.name,
      _onMessageHandle,
    );
  }

  @override
  void onReady() {
    super.onReady();
    _logger.d('onReady');

    getConversations();
  }

  @override
  void onClose() {
    _messageCreatedListener?.cancel();
    _messageUpdatedListener?.cancel();

    super.onClose();
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
        status: status.value,
        inbox_id: filterbyInbox.value,
        assignee_type: assigneeType.value,
        sort_order: sort_order.value,
        onCacheHit: append || reset
            ? null
            : (data) {
                conversations.value = data.payload;
                all_count.value = data.meta.all_count;
                mine_count.value = data.meta.mine_count;
              },
      );
      var data = result.getOrThrow();

      if (append) {
        conversations.addAll(data.payload);
      } else {
        conversations.value = data.payload;
      }
      isNoMore.value =
          data.payload.isEmpty || data.payload.length < env.PAGE_SIZE;

      all_count.value = data.meta.all_count;
      mine_count.value = data.meta.mine_count;
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
    _shared.getInboxes();
    var result = await Get.bottomSheet<bool>(ConversationsFilterView());
    if (result == null || !result) return;
  }

  Future<void> readAll() async {}

  Future<void> onTap(ConversationInfo info) async {
    final index = conversations.indexWhere((e) => e.id == info.id);
    conversations[index].unread_count = 0;

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

  void _onMessageHandle(MessageInfo info) {
    var element =
        conversations.firstWhereOrNull((e) => e.id == info.conversation_id);
    if (element == null) {
      _logger.d('_onMessageHandle() => not found element!');
      return;
    }

    element.last_non_activity_message = info;
    element.last_activity_at = info.created_at;

    conversations
        .sort((a, b) => b.last_activity_at.compareTo(a.last_activity_at));
  }
}
