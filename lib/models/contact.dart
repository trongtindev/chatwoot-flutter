import '/imports.dart';

class ListContactMeta extends ApiListMeta {
  ListContactMeta({
    required super.count,
    // required super.current_page,
  });

  factory ListContactMeta.fromJson(Map<String, dynamic> json) {
    // var current_page = int.parse('${json['current_page']}');
    return ListContactMeta(
      count: json['count'],
      // current_page: current_page,
    );
  }
}

class ContactInfo {
  Map<String, dynamic> additional_attributes;
  AvailabilityStatus availability_status;
  String email;
  int id;
  String name;
  String? phone_number;
  String? identifier;
  String thumbnail;
  Map<String, dynamic> custom_attributes;
  DateTime created_at;
  List<InboxInfo> contact_inboxes;

  ContactInfo({
    required this.additional_attributes,
    required this.availability_status,
    required this.email,
    required this.id,
    required this.name,
    required this.phone_number,
    required this.identifier,
    required this.thumbnail,
    required this.custom_attributes,
    required this.created_at,
    required this.contact_inboxes,
  });

  factory ContactInfo.fromJson(dynamic json) {
    List<dynamic> contact_inboxes = json['contact_inboxes'] ?? [];

    return ContactInfo(
      additional_attributes: json['additional_attributes'],
      availability_status:
          AvailabilityStatus.values.byName(json['availability_status']),
      email: json['email'],
      id: json['id'],
      name: json['name'],
      phone_number: json['phone_number'],
      identifier: json['identifier'],
      thumbnail: json['thumbnail'],
      custom_attributes: json['custom_attributes'],
      created_at:
          DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
      contact_inboxes: contact_inboxes.map(InboxInfo.fromJson).toList(),
    );
  }
}
