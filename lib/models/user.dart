import '/imports.dart';

class UserInfo {
  final int id;
  final String name;
  final String available_name;
  final String avatar_url;
  final UserType type;
  final AvailabilityStatus availability_status;
  final String thumbnail;

  const UserInfo({
    required this.id,
    required this.name,
    required this.available_name,
    required this.avatar_url,
    required this.type,
    required this.availability_status,
    required this.thumbnail,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      available_name: json['available_name'],
      avatar_url: json['avatar_url'],
      type: UserType.values.byName(json['type']),
      availability_status:
          AvailabilityStatus.values.byName(json['availability_status']),
      thumbnail: json['thumbnail'],
    );
  }
}
