import '/imports.dart';

bool isImage(PlatformFile file) {
  return ['png', 'gif', 'jpg', 'jpeg'].contains(file.extension ?? '');
}
