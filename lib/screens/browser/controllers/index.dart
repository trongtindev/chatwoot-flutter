import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '/imports.dart';

class BrowserController extends GetxController {
  final String initialUrl;
  late InAppWebViewController webView;
  final url = 'about:blank'.obs;
  final title = 'about:blank'.obs;
  final progress = 0.0.obs;

  BrowserController({required this.initialUrl});

  Future<void> onTitleChanged(InAppWebViewController _, String? title) async {
    if (title == null) {
      this.title('about:blank');
      return;
    }
    this.title(title.toString());
  }
}
