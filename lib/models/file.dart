import '../imports.dart';

class FileInfo {
  final String name;
  final String path;
  final int size;
  final Uint8List? thumbnail;
  final String extension;
  String? contentType;

  FileInfo({
    required this.path,
    required this.size,
    this.thumbnail,
    required this.contentType,
  })  : name = path.split('/').last,
        extension = path.split('.').last;
}
