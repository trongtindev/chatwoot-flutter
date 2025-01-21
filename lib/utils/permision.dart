import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import '/imports.dart';

Future<bool> ensurePermissionsGranted({
  required List<Permission> permissions,
}) async {
  try {
    for (var permission in permissions) {
      var status = await permission.status;

      if (status == PermissionStatus.granted) {
        continue;
      } else if (status == PermissionStatus.permanentlyDenied) {
        await Get.dialog(AlertDialog(
          title: Text(t.permission_denied),
          content: Text(t.permission_denied_message(permission.toString())),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(t.close),
            ),
            TextButton(
              onPressed: () {
                Get.back();

                // TODO: handle
                switch (permission) {
                  default:
                    AppSettings.openAppSettings();
                    break;
                }
              },
              child: Text(t.open_settings),
            )
          ],
        ));
        return false;
      }

      await Get.dialog(AlertDialog(
        title: Text(t.permission_request),
        content: Text(t.permission_request_message(permission.toString())),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(t.understand),
          )
        ],
      ));

      var result = await permission.request();
      if (result != PermissionStatus.granted) return false;
    }

    return true;
  } on Error catch (error) {
    logger.e(error, stackTrace: error.stackTrace);
    Get.dialog(AlertDialog(
      title: Text(t.exception),
      content: Text(t.exception_message(error.toString())),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(t.close),
        )
      ],
    ));
    return false;
  }
}
