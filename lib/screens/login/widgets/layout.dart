import '/imports.dart';

Widget buildBody({
  required double width,
  required Widget header,
  required Widget child,
}) {
  return Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(width: width, child: header),
            Padding(padding: EdgeInsets.only(top: 32)),
            SizedBox(width: width, child: child),
          ],
        ),
      ),
    ),
  );
}

Widget buildHeader({
  required String title,
  required String description,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/adaptive-icon.png',
        width: 64,
        height: 64,
      ),
      Padding(padding: EdgeInsets.only(top: 16)),
      Text(
        title,
        style: TextStyle(
          fontSize: Get.textTheme.titleLarge!.fontSize,
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        description,
        style: TextStyle(
            // fontSize: Get.textTheme.bodySmall!.fontSize,
            ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
