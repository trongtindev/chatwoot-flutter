import '/imports.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatTimeago(DateTime dateTime) {
  return timeago.format(dateTime, locale: Get.locale?.languageCode);
}

int timestamp() {
  return int.parse(
      DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10));
}
