import '/imports.dart';

class AccountInfo {
  final int id;
  final String name;
  final AccountStatus status;
  final UserRole role;
  final List<UserRole> permissions;
  final String availability; // TODO: unk
  final AvailabilityStatus availability_status; // TODO: unk
  final bool auto_offline;
  final dynamic custom_role_id; // TODO: unk
  final dynamic custom_role; // TODO: unk

  const AccountInfo({
    required this.id,
    required this.name,
    required this.status,
    required this.role,
    required this.permissions,
    required this.availability,
    required this.availability_status,
    required this.auto_offline,
    required this.custom_role_id,
    required this.custom_role,
  });

  factory AccountInfo.fromJson(dynamic json) {
    List<dynamic> permissions = json['permissions'];
    return AccountInfo(
      id: json['id'],
      name: json['name'],
      status: AccountStatus.fromName(json['status']),
      role: UserRole.fromName(json['role']),
      permissions: permissions.map(UserRole.fromName).toList(),
      availability: json['availability'],
      availability_status:
          AvailabilityStatus.fromName(json['availability_status']),
      auto_offline: json['auto_offline'],
      custom_role_id: json['custom_role_id'],
      custom_role: json['custom_role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.name,
      'role': role.name,
      'permissions': permissions.map((e) => e.name).toList(),
      'availability': availability,
      'availability_status': availability_status.name,
      'auto_offline': auto_offline,
      'custom_role_id': custom_role_id,
      'custom_role': custom_role,
    };
  }
}
