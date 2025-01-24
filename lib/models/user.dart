import '/imports.dart';

class UserInfo {
  final int id;
  final int? account_id;
  final String name;
  final String display_name;
  final AvailabilityStatus availability_status;
  final bool? auto_offline;
  final bool? confirmed;
  final String thumbnail;
  final dynamic custom_role_id; // TODO: unk type
  final UserType type;
  final UserRole role;

  const UserInfo({
    required this.id,
    this.account_id,
    required this.name,
    String? display_name,
    AvailabilityStatus? availability_status,
    required this.thumbnail,
    this.auto_offline,
    this.confirmed,
    this.custom_role_id,
    required this.type,
    UserRole? role,
  })  : display_name = display_name ?? name,
        availability_status =
            availability_status ?? AvailabilityStatus.undefined,
        role = role ?? UserRole.undefined;

  factory UserInfo.fromJson(dynamic json) {
    return UserInfo(
      id: json['id'],
      account_id: json['account_id'],
      name: json['name'],
      display_name:
          json['display_name'] ?? json['available_name'] ?? json['name'],
      availability_status:
          AvailabilityStatus.fromName(json['availability_status']),
      thumbnail: json['avatar_url'] ?? json['thumbnail'],
      auto_offline: json['auto_offline'],
      confirmed: json['confirmed'],
      custom_role_id: json['custom_role_id'],
      type: UserType.fromName(json['type']),
      role: UserRole.fromName(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': account_id,
      'display_name': display_name,
      'availability_status': availability_status.name,
      'thumbnail': thumbnail,
      'auto_offline': auto_offline,
      'confirmed': confirmed,
      'custom_role_id': custom_role_id,
      'type': type.name,
    };
  }
}
