import 'package:chatwoot/imports.dart';

Widget imageViewer({
  required String url,
  required String title,
}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: ExtendedImage.network(
      url,
      mode: ExtendedImageMode.gesture,
      width: double.infinity,
      height: double.infinity,
    ),
  );
}
