import '../imports.dart';

void errorHandler(Object error) {
  if (error is ApiError) {
    var apiException = error;
    Get.dialog(AlertDialog(
      title: Text(t.error),
      content: Text(apiException.errors.join(';')),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(t.close),
        ),
      ],
    ));
    return;
  } else if (error is Error) {
    logger.e(error, stackTrace: error.stackTrace);
  }

  Get.dialog(AlertDialog(
    title: Text(t.exception),
    content: Text(t.exception_message(error.toString())),
    actions: [
      TextButton(
        onPressed: () => Get.back(),
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
