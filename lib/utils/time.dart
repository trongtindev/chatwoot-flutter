import '/imports.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatTimeago(DateTime dateTime) {
  return timeago.format(dateTime, locale: Get.locale?.languageCode);
}

int timestamp() {
  return int.parse(
      DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10));
}

DateTime? toDateTime(dynamic value) {
  if (value == null) {
    return null;
  } else if (value is String) {
    return DateTime.parse(value);
  } else if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value * 1000);
  }
  throw Exception('$value is not supported');
}
