import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../imports.dart';

Future<void> openBrowser(String url) async {
  final webUri = WebUri.uri(Uri.parse(url));
  ChromeSafariBrowser().open(url: webUri);

  // TODO: make settings
  // InAppBrowser.openWithSystemBrowser(url: webUri);
}

Future<void> openInternalBrowser(String path) async {
  final api = Get.find<ApiService>();
  final auth = Get.find<AuthService>();
  final webUri = WebUri.uri(
    Uri.parse(
      '${api.baseUrl.value}/app/accounts/${auth.profile.value!.account_id}/$path',
    ),
  );

  ChromeSafariBrowser().open(url: webUri);
}
