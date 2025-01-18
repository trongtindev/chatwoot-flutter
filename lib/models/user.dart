import '/imports.dart';

class UserInfo {
  int id;
  String name;
  String available_name;
  String avatar_url;
  UserType type;
  AvailabilityStatus availability_status;
  String thumbnail;

  UserInfo({
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
