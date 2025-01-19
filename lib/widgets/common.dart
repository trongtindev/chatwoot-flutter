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
        color: Get.theme.colorScheme.error,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Get.theme.colorScheme.onError,
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text(
                  'error'.tr,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleLarge!.fontSize,
                    color: Get.theme.colorScheme.onError,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: Get.textTheme.bodyMedium!.fontSize,
                    color: Get.theme.colorScheme.onError,
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

Widget loadMore() {
  return Column(
    children: [
      Divider(),
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ],
  );
}

Widget noMore() {
  return Column(
    children: [
      Divider(),
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
        child: Text(
          'common.no_more'.tr,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
