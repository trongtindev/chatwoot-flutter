import 'package:chatwoot/screens/contacts/views/detail.dart';

import '/imports.dart';

class ConversationChatController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final int conversation_id;

  ConversationChatController({
    required this.conversation_id,
    MessageInfo? initial_message,
  })  : messages = RxList<MessageInfo>(
            initial_message != null ? [initial_message] : []),
        message_count = initial_message != null ? 1.obs : 0.obs;

  final info = Rxn<ConversationInfo>();
  final after = 0.obs;
  final error = ''.obs;
  final resolved = false.obs;
  late RxList<MessageInfo> messages;
  late RxInt message_count;

  @override
  void onReady() {
    super.onReady();
    getConversation();
    getMessages();
  }

  Future<void> getConversation() async {
    try {
      var result = await _api.getConversation(
        account_id: _auth.profile.value!.account_id,
        conversation_id: conversation_id,
        onCacheHit: (data) => info.value = data,
      );
      var data = result.getOrThrow();
      info.value = data;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      _logger.e(reason.stackTrace);
      _logger.e(reason);
      error.value = reason.toString();
    }
  }

  Future<void> getMessages() async {
    try {
      var result = await _api.listMessages(
        account_id: _auth.profile.value!.account_id,
        conversation_id: conversation_id,
        after: after.value,
        onCacheHit: (data) {
          messages.value = data.payload.reversed.toList();
          message_count.value = data.payload.length;
        },
      );
      var data = result.getOrThrow();

      messages.value = data.payload.reversed.toList();
      message_count.value = data.payload.length;

      _logger.i('getMessages() => ${message_count.value} items');
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      _logger.e(reason.stackTrace);
      _logger.e(reason);
      error.value = reason.toString();
    }
  }

  void showContactDetail() {
    Get.to(
      () => ContactDetailView(
        contact_id: info.value!.meta.sender.id,
      ),
    );
  }
}
