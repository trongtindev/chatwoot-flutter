import '/imports.dart';

class ListContactMeta extends ApiListMeta {
  const ListContactMeta({
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

class ContactAdditionalAttributes {
  final String? city;
  final String? country;
  final String? description;
  final String? company_name;
  final String? country_code;
  final dynamic social_profiles; // TODO: make better

  const ContactAdditionalAttributes({
    required this.city,
    required this.country,
    required this.description,
    required this.company_name,
    required this.country_code,
    required this.social_profiles,
  });

  factory ContactAdditionalAttributes.fromJson(dynamic json) {
    return ContactAdditionalAttributes(
      city: json['city'],
      country: json['country'],
      description: json['description'],
      company_name: json['company_name'],
      country_code: json['country_code'],
      social_profiles: json['social_profiles'],
    );
  }
}

class ContactInfo {
  int id;
  String? email;
  String name;
  String? phone_number;
  String? identifier;
  String thumbnail;
  ContactAdditionalAttributes additional_attributes;
  Map<String, dynamic> custom_attributes;
  DateTime created_at;
  DateTime last_activity_at;
  List<InboxInfo> contact_inboxes;

  ContactInfo({
    required this.id,
    this.email,
    required this.name,
    required this.phone_number,
    required this.identifier,
    required this.thumbnail,
    required this.additional_attributes,
    required this.custom_attributes,
    required this.created_at,
    required this.last_activity_at,
    required this.contact_inboxes,
  });

  factory ContactInfo.fromJson(dynamic json) {
    List<dynamic> contact_inboxes = json['contact_inboxes'] ?? [];
    var created_at =
        DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000);

    return ContactInfo(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone_number: json['phone_number'],
      identifier: json['identifier'],
      thumbnail: json['thumbnail'],
      additional_attributes:
          ContactAdditionalAttributes.fromJson(json['additional_attributes']),
      custom_attributes: json['custom_attributes'] ?? {},
      created_at: created_at,
      last_activity_at: DateTime.fromMillisecondsSinceEpoch(
          (json['last_activity_at'] ?? json['created_at']) * 1000),
      contact_inboxes: contact_inboxes.map(InboxInfo.fromJson).toList(),
    );
  }
}
