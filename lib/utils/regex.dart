import 'package:chatwoot/utils/common.dart';

bool isEmail(String email) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);
  return email.isNotEmpty && regex.hasMatch(email);
}

bool isUrlWithoutHttp(String value) {
  const pattern = r'^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$';
  final regex = RegExp(pattern);
  return value.isNotEmpty && regex.hasMatch(value);
}

bool isPassword(String value) {
  return value.isNotEmpty && value.length >= 6;
}

bool isFullName(String value) {
  return value.isNotEmpty && value.length >= 6;
}

bool isHexColor(String value) {
  return !isNotNullOrEmpty(value) && value.startsWith('#') && value.length == 7;
}
