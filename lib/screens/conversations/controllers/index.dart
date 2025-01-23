import '../widgets/filter.dart';
import '/screens/conversations/views/chat.dart';
import '/imports.dart';

class ConversationsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final _inboxes = Get.find<InboxesController>();
  final _realtime = Get.find<RealtimeService>();

  final all_count = 0.obs;
  final mine_count = 0.obs;
  final unread_count = 0.obs;
  final items = RxList<ConversationInfo>();
  final loading = true.obs;
  final error = ''.obs;
  final page = 1.obs;
  final is_load_more = false.obs;
  final is_no_more = false.obs;
  final assignee_type = PersistentRxCustom(
    AssigneeType.mine,
    key: 'conversations:assignee_type',
    encode: (value) => value.name,
    decode: (value) => AssigneeType.values.byName(value),
  );
  final filter_by_status = PersistentRxCustom(
    ConversationStatus.open,
    key: 'conversations:filter_by_status',
    encode: (value) => value.name,
    decode: (value) => ConversationStatus.values.byName(value),
  );
  final sort_order = ConversationSortType.last_activity_at_desc.obs;
  final filter_by_inbox = Rxn<int>();
  final filter_by_labels = RxList<LabelInfo>();

  EventListener<ConversationInfo>? _onConversationCreatedListener;
  EventListener<ConversationInfo>? _onConversationUpdatedListener;
  EventListener<ConversationInfo>? _onConversationReadListener;
  EventListener<MessageInfo>? _messageCreatedListener;
  EventListener<MessageInfo>? _messageUpdatedListener;

  @override
  void onInit() {
    super.onInit();

    assignee_type.listen((next) => getConversations(reset: true));
    filter_by_status.listen((next) => getConversations(reset: true));
    sort_order.listen((next) => getConversations(reset: true));
    filter_by_inbox.listen((next) => getConversations(reset: true));
    filter_by_labels.listen((next) => getConversations(reset: true));

    _onConversationCreatedListener = _realtime.events.on(
      RealtimeEventId.conversationCreated.name,
      _onConversationCreated,
    );

    _onConversationUpdatedListener = _realtime.events.on(
      RealtimeEventId.conversationUpdated.name,
      _onConversationUpdated,
    );

    _onConversationReadListener = _realtime.events.on(
      RealtimeEventId.conversationRead.name,
      _onConversationRead,
    );

    _messageCreatedListener = _realtime.events.on(
      RealtimeEventId.messageCreated.name,
      _onMessageCreated,
    );

    _messageUpdatedListener = _realtime.events.on(
      RealtimeEventId.messageUpdated.name,
      _onMessageUpdated,
    );
  }

  @override
  void onReady() {
    super.onReady();

    _auth.isSignedIn.listen((next) {
      if (!next) return;
      getConversations();
    });
    if (_auth.isSignedIn.value) getConversations();
  }

  @override
  void onClose() {
    _onConversationCreatedListener?.cancel();
    _onConversationUpdatedListener?.cancel();
    _onConversationReadListener?.cancel();
    _messageCreatedListener?.cancel();
    _messageUpdatedListener?.cancel();

    super.onClose();
  }

  Future<ConversationsController> init() async {
    return this;
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
        is_load_more.value = false;
        is_no_more.value = false;
      }

      final result = await _api.listConversations(
        page: page.value,
        status: filter_by_status.value,
        labels: filter_by_labels.map((e) => e.title).toList(),
        inbox_id: filter_by_inbox.value,
        assignee_type: assignee_type.value,
        sort_order: sort_order.value,
        onCacheHit: append || reset
            ? null
            : (data) {
                items.value = data.payload;
                all_count.value = data.meta.all_count;
                mine_count.value = data.meta.mine_count;
              },
      );
      final data = result.getOrThrow();

      if (append) {
        items.addAll(data.payload);
      } else {
        items.value = data.payload;
      }
      is_no_more.value =
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
    _inboxes.getInboxes();
    var result = await Get.bottomSheet<bool>(
      ConversationsFilterView(),
      showDragHandle: false,
    );
    if (result == null || !result) return;
  }

  Future<void> readAll() async {}

  Future<void> onTap(ConversationInfo info) async {
    if (info.unread_count > 0) {
      unread_count.value -= 1;
      info.unread_count = 0;
      items.refresh();
    }

    Get.to(
      () => ConversationChatView(
        conversation_id: info.id,
        initial_message: info.last_non_activity_message,
      ),
    );
  }

  Future<void> loadMore() async {
    if (is_no_more.value) return;
    if (is_load_more.value) return;

    page.value += 1;
    is_load_more.value = true;
    await getConversations(append: true);
    is_load_more.value = false;
  }

  void _onConversationCreated(ConversationInfo info) {
    items.insert(0, info);
  }

  void _onConversationUpdated(ConversationInfo info) {
    final index = items.indexWhere((e) => e.id == info.id);

    if (filter_by_status.value == info.status) {
      if (index >= 0) {
        items[index] = info;
      } else {
        items.insert(0, info);
      }
      updateSortItems();
      return;
    }

    if (index >= 0) items.removeAt(index);
  }

  void _onConversationRead(ConversationInfo info) {
    final index = items.indexWhere((e) => e.id == info.id);
    if (index < 0) return;

    items[index].unread_count = 0;
    unread_count.value -= 1;
    items.refresh();
  }

  void _onMessageCreated(MessageInfo info) {
    final index = items.indexWhere((e) => e.id == info.conversation_id);
    if (index < 0) return;

    items[index].last_non_activity_message = info;
    items[index].last_activity_at = info.updated_at ?? info.created_at;
    if (info.sender?.type != UserType.user) {
      items[index].unread_count += 1;
      unread_count.value += 1;
    }

    updateSortItems();
  }

  void _onMessageUpdated(MessageInfo info) {
    final index = items.indexWhere((e) => e.id == info.conversation_id);
    if (index < 0) return;

    items[index].last_non_activity_message = info;
    items[index].last_activity_at = info.updated_at ?? info.created_at;

    updateSortItems();
  }

  void toggleLabel(LabelInfo info) {
    if (filter_by_labels.contains(info)) {
      filter_by_labels.remove(info);
      return;
    }
    filter_by_labels.add(info);
  }

  void updateSortItems() {
    items.sort((a, b) => b.last_activity_at.compareTo(a.last_activity_at));
  }
}
