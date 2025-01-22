import '../imports.dart';

void errorHandler(Object error) {
  if (error is ApiError) {
    final apiException = error;
    Get.dialog(AlertDialog(
      title: Text(t.error),
      content: Text(apiException.errors.join(';')),
      actions: [
        TextButton(
          onPressed: () => Get.close(),
          child: Text(t.close),
        ),
      ],
    ));
    return;
  } else if (error is ApiError) {
    logger.w(error, stackTrace: StackTrace.current);
  }
  if (error is Error) {
    logger.e(error, stackTrace: error.stackTrace);
  }

  Get.dialog(AlertDialog(
    title: Text(t.exception),
    content: Text(t.exception_message(error.toString())),
    actions: [
      TextButton(
        onPressed: () => Get.close(),
        child: Text(t.close),
      ),
    ],
  ));
}

bool isNullOrEmpty(String? value) {
  return value == null || value.isEmpty;
}

bool isNotNullOrEmpty(String? value) {
  return !isNullOrEmpty(value);
}

bool isNull(dynamic value) {
  if (value is String) {
    return isNullOrEmpty(value);
  }
  return value == null;
}

T valueOrDefault<T>(T? value, T defaultValue) {
  if (value is String) {
    if (isNullOrEmpty(value)) {
      return defaultValue;
    }
    return value;
  }
  return value ?? defaultValue;
}

Future<bool> confirm(String message, {String? title}) async {
  final result = await Get.dialog<bool?>(AlertDialog(
    title: Text(title ?? t.confirm),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () => Get.close(),
        child: Text(t.cancel),
      ),
      TextButton(
        onPressed: () => Navigator.of(Get.context!).pop(true),
        child: Text(t.confirm),
      )
    ],
  ));
  logger.d('result: $result');
  return result ?? false;
}

Future<bool> confirmDelete({required String name}) async {
  final result = await Get.dialog<bool?>(AlertDialog(
    title: Text(t.confirm_delete),
    content: Text(t.confirm_delete_message(name)),
    actions: [
      TextButton(
        onPressed: () => Get.close(),
        child: Text(t.cancel),
      ),
      TextButton(
        onPressed: () => Navigator.of(Get.context!).pop(true),
        child: Text(t.delete),
      )
    ],
  ));
  logger.d('result: $result');
  return result ?? false;
}
