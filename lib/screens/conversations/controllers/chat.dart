import '/screens/contacts/views/detail.dart';
import '/imports.dart';

class ConversationChatController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();
  final _realtime = Get.find<RealtimeService>();

  final scrollController = ScrollController();
  final int id;
  final loading = false.obs;
  final isNoMore = false.obs;
  final info = Rxn<ConversationInfo>();
  final error = ''.obs;
  late RxList<MessageInfo> messages;

  ConversationChatController({
    required this.id,
    MessageInfo? initial_message,
  }) : messages = RxList<MessageInfo>(
            initial_message != null ? [initial_message] : []);

  EventListener<MessageInfo>? _messageCreatedListener;
  EventListener<MessageInfo>? _messageUpdatedListener;
  EventListener<ConversationInfo>? _conversationUpdatedListener;

  @override
  void onInit() {
    super.onInit();
    _logger.i('onInit(conversation_id:$id)');

    scrollController.addListener(_onScroll);

    _messageCreatedListener = _realtime.events.on(
      RealtimeEventId.messageCreated.name,
      _onMessageCreated,
    );

    _messageUpdatedListener = _realtime.events.on(
      RealtimeEventId.messageUpdated.name,
      _onMessageUpdated,
    );

    _conversationUpdatedListener = _realtime.events.on(
      RealtimeEventId.conversationUpdated.name,
      _onConversationUpdated,
    );
  }

  @override
  void onReady() {
    super.onReady();

    getConversation().then((_) {
      _api.markMessageRead(conversation_id: id);
    });
    getMessages();
  }

  @override
  void onClose() {
    _messageCreatedListener?.cancel();
    _messageUpdatedListener?.cancel();
    _conversationUpdatedListener?.cancel();
    scrollController.dispose();

    super.onClose();
  }

  Future<void> getConversation() async {
    try {
      final result = await _api.getConversation(
        account_id: _auth.profile.value!.account_id,
        conversation_id: id,
        onCacheHit: (data) => info.value = data,
      );

      info.value = result.getOrThrow();
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      _logger.e(reason, stackTrace: reason.stackTrace);
      error.value = reason.toString();
    }
  }

  Future<void> getMessages({int? before}) async {
    try {
      loading.value = true;

      final result = await _api.listMessages(
        account_id: _auth.profile.value!.account_id,
        conversation_id: id,
        before: before,
        onCacheHit: (data) {
          if (before != null) return;
          messages.value = data.payload.reversed.toList();
        },
      );
      final data = result.getOrThrow();

      if (before != null) {
        messages.addAll(data.payload.reversed);
      } else if (data.payload.isNotEmpty) {
        messages.value = data.payload.reversed.toList();
      }

      isNoMore.value =
          data.payload.isEmpty || data.payload.length < env.PAGE_SIZE;

      _logger.d('found ${data.payload.length} items');
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

  void showContactDetail() {
    Get.to(
      () => ContactDetailView(
        id: info.value!.meta.sender.id,
      ),
    );
  }

  void _onMessageCreated(MessageInfo info) {
    if (info.conversation_id != this.info.value?.id) return;
    _logger.d('_onMessageCreated() => insert');

    final element = messages.firstWhereOrNull((e) => e.id == info.id);
    if (element != null) {
      return;
    }

    messages.insert(0, info);
  }

  void _onMessageUpdated(MessageInfo info) {
    if (info.conversation_id != this.info.value?.id) return;

    final index = messages.indexWhere((e) => e.id == info.id);
    messages[index] = info;
  }

  void _onConversationUpdated(ConversationInfo info) {
    if (info.id != this.info.value?.id) return;
    this.info.value = info;
  }

  void _onScroll() {
    if (loading.value) return;
    if (isNoMore.value) return;

    final pixels = scrollController.position.pixels;
    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final ratio = pixels / maxScrollExtent;
    _logger.t('offset: $pixels offset: $maxScrollExtent ratio:$ratio');

    if (ratio < 0.8) return;
    loading.value = true;
    getMessages(before: messages.last.id);
  }

  Future<void> changeStatus(
    ConversationStatus status, {
    DateTime? snoozed_until,
    bool? skipConfirm,
  }) async {
    skipConfirm ??= false;

    if (!skipConfirm) {
      final result = await confirm(
        t.conversation_change_status_message(
          info.value!.status.label,
          status.label,
        ),
        title: t.conversation_change_status,
      );
      if (!result) return;
    }

    info.value!.status = status;
    info.refresh();

    _api.changeConversationStatus(conversation_id: id, status: status);
  }
}
