import '../imports.dart';

Widget error({
  required String message,
  void Function()? onRetry,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Card(
        color: Get.theme.colorScheme.onError,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 48),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text(
                  'error'.tr,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleLarge!.fontSize,
                    color: Get.theme.colorScheme.onErrorContainer,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: Get.textTheme.bodyMedium!.fontSize,
                    color: Get.theme.colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      if (onRetry != null)
        defaultButton(
          label: 'common.retry'.tr,
          onPressed: onRetry,
        ),
    ],
  );
}
