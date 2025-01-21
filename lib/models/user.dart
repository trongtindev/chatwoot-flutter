import '/imports.dart';

class UserInfo {
  final int id;
  final int? account_id;
  final String name;
  final String available_name;
  final String? avatar_url;
  final AvailabilityStatus? availability_status;
  final bool auto_offline;
  final bool confirmed;
  final String thumbnail;
  final dynamic custom_role_id; // TODO: unk type

  const UserInfo({
    required this.id,
    this.account_id,
    required this.name,
    required this.available_name,
    this.avatar_url,
    this.availability_status,
    required this.thumbnail,
    required this.auto_offline,
    required this.confirmed,
    required this.custom_role_id,
  });

  factory UserInfo.fromJson(dynamic json) {
    final availability_status = json['availability_status'] != null
        ? AvailabilityStatus.values.byName(json['availability_status'])
        : null;

    return UserInfo(
      id: json['id'],
      account_id: json['account_id'],
      name: json['name'],
      available_name: json['available_name'],
      avatar_url: json['avatar_url'],
      availability_status: availability_status,
      thumbnail: json['thumbnail'],
      auto_offline: json['auto_offline'] ?? false,
      confirmed: json['confirmed'] ?? false,
      custom_role_id: json['custom_role_id'],
    );
  }
}
