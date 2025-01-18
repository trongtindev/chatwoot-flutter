import '/imports.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatTimeago(DateTime dateTime) {
  return timeago.format(dateTime, locale: Get.locale?.languageCode);
}
