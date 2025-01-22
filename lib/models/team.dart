// import '/imports.dart';

class TeamInfo {
  final int id;
  final String name;
  final String description;
  final bool allow_auto_assign;
  final int account_id;
  final bool is_member;

  const TeamInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.allow_auto_assign,
    required this.account_id,
    required this.is_member,
  });

  factory TeamInfo.fromJson(dynamic json) {
    return TeamInfo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      allow_auto_assign: json['allow_auto_assign'],
      account_id: json['account_id'],
      is_member: json['is_member'],
    );
  }
}
