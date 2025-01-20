import '/imports.dart';

class LabelInfo {
  final int id;
  final String title;
  final String description;
  final Color color;
  final bool show_on_sidebar;

  const LabelInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.show_on_sidebar,
  });

  factory LabelInfo.fromJson(dynamic json) {
    return LabelInfo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      color: HexColor.fromHex(json['color']),
      show_on_sidebar: json['show_on_sidebar'],
    );
  }
}
