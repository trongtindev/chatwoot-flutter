import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../screens/contacts/views/detail.dart';
import '../screens/conversations/views/chat.dart';
import '/screens/browser/views/index.dart';
import '../imports.dart';

Future<void> openInAppBrowser(String path) async {
  String url = path;

  if (!path.startsWith('http')) {
    final api = Get.find<ApiService>();
    final auth = Get.find<AuthService>();
    final profile = auth.profile.value!;
    url = '${api.baseUrl.value}/app/accounts/${profile.account_id}/$path';
  }

  Get.to(() => BrowserView(url: url));
}

Future<void> openInExternalBrowser(String url) async {
  final webUri = WebUri.uri(Uri.parse(url));
  ChromeSafariBrowser().open(url: webUri);
}

void toConversationChat(
  int conversation_id, {
  MessageInfo? last_non_activity_message,
}) {
  Get.to(
    () => ConversationChatView(
      conversation_id: conversation_id,
      initial_message: last_non_activity_message,
    ),
  );
}

void toContactDetail(int contact_id) {
  Get.to(
    () => ContactDetailView(contact_id: contact_id),
  );
}
