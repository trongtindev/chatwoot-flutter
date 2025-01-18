import '/imports.dart';

class SenderInfo {
  dynamic additional_attributes;
  Map<String, dynamic> custom_attributes;
  AvailabilityStatus? availability_status;
  String? email;
  int id;
  String name;
  String phone_number;
  String? identifier;
  String thumbnail;
  DateTime? last_activity_at;
  DateTime? created_at;

  SenderInfo({
    required this.additional_attributes,
    required this.custom_attributes,
    this.availability_status,
    this.email,
    required this.id,
    required this.name,
    required this.phone_number,
    required this.identifier,
    required this.thumbnail,
    required this.last_activity_at,
    required this.created_at,
  });

  factory SenderInfo.fromJson(dynamic json) {
    var availability_status = json['availability_status'] != null
        ? AvailabilityStatus.values.byName(json['availability_status'])
        : null;
    var last_activity_at = json['last_activity_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['last_activity_at'] * 1000)
        : null;
    var created_at = json['created_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000)
        : null;

    return SenderInfo(
      additional_attributes: json['additional_attributes'],
      custom_attributes: json['custom_attributes'],
      availability_status: availability_status,
      email: json['email'],
      id: json['id'],
      name: json['name'],
      phone_number: json['phone_number'],
      identifier: json['identifier'],
      thumbnail: json['thumbnail'],
      last_activity_at: last_activity_at,
      created_at: created_at,
    );
  }
}
