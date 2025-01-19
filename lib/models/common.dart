import '/imports.dart';

class SenderInfo {
  final dynamic additional_attributes;
  final Map<String, dynamic> custom_attributes;
  final AvailabilityStatus? availability_status;
  final String? email;
  final int id;
  final String name;
  final String? phone_number;
  final String? identifier;
  final String thumbnail;
  final DateTime? last_activity_at;
  final DateTime? created_at;

  const SenderInfo({
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
