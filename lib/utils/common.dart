import '../imports.dart';

void errorHandler(Object error) {
  if (error is ApiError) {
    var apiException = error;
    Get.dialog(AlertDialog(
      title: Text('error'.tr),
      content: Text(apiException.errors.join(';')),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('ok'.tr),
        ),
      ],
    ));
    return;
  }

  Get.dialog(AlertDialog(
    title: Text('exception'.tr),
    content: Text('exception_message'.trParams({
      'reason': error.toString(),
    })),
    actions: [
      TextButton(
        onPressed: () => Get.back(),
        child: Text('ok'.tr),
      ),
    ],
  ));
}
