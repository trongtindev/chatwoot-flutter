import '/imports.dart';

enum AccountStatus { active }

enum AccountRole { administrator }

enum AccountPermission { administrator }

// enum AccountAvailability { online }

class AccountInfo {
  int id;
  String name;
  AccountStatus status;
  AccountRole role;
  List<AccountPermission> permissions;
  String availability; // TODO: unk
  AvailabilityStatus availability_status; // TODO: unk
  bool auto_offline;
  dynamic custom_role_id; // TODO: unk
  dynamic custom_role; // TODO: unk

  AccountInfo({
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
      status: AccountStatus.values.byName(json['status']),
      role: AccountRole.values.byName(json['role']),
      permissions: permissions
          .map((e) => AccountPermission.values.byName(e.toString()))
          .toList(),
      availability: json['availability'],
      availability_status:
          AvailabilityStatus.values.byName(json['availability_status']),
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
