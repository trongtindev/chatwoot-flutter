import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../controllers/index.dart';
import '/imports.dart';

class BrowserView extends StatelessWidget {
  final BrowserController controller;

  BrowserView({
    super.key,
    required String url,
  }) : controller = Get.put(BrowserController(initialUrl: url), tag: url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final url = controller.url.value;
          final title = controller.title.value;

          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  url,
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close),
          ),
          Padding(padding: EdgeInsets.only(right: 8)),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(
                Uri.parse(controller.initialUrl),
              ),
            ),
            initialSettings: InAppWebViewSettings(
              cacheEnabled: kReleaseMode,
              sharedCookiesEnabled: true,
            ),
            onWebViewCreated: (webview) {
              controller.webView = webview;
            },
            onLoadStart: (_, url) async {
              controller.url(url == null ? 'about:blank' : url.toString());
              controller.progress(null);
            },
            onTitleChanged: controller.onTitleChanged,
            onProgressChanged: (_, progress) {
              controller.progress(progress / 100);
            },
          ),
          Obx(() {
            final progress = controller.progress.value;
            if (progress >= 1.0) return Container();

            return Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(
                  value: controller.progress.value,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
