import '/imports.dart';

Widget profileInfo(
  BuildContext context, {
  required ProfileInfo profile,
}) {
  return Column(
    children: [
      Padding(padding: EdgeInsets.all(8)),
      avatar(
        context,
        url: profile.avatar_url,
        isOnline: true,
        width: 128,
        height: 128,
      ),
      Padding(padding: EdgeInsets.all(8)),
      Text(
        profile.display_name,
        style: TextStyle(
          fontSize: Get.textTheme.titleLarge!.fontSize,
        ),
      ),
      Text(
        profile.email,
        style: TextStyle(
          fontSize: Get.textTheme.bodyMedium!.fontSize,
        ),
      ),
      Padding(padding: EdgeInsets.all(8)),
    ],
  );
}
