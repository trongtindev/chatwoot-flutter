import '/imports.dart';

class ContactNoteInfo {
  final int id;
  final String content;
  final DateTime created_at;
  final DateTime updated_at;

  ContactNoteInfo({
    required this.id,
    required this.content,
    required this.created_at,
    required this.updated_at,
  });

  factory ContactNoteInfo.fromJson(dynamic json) {
    return ContactNoteInfo(
      id: json['id'],
      content: json['content'],
      created_at: toDateTime(json['created_at'])!,
      updated_at: toDateTime(json['updated_at'])!,
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
  DateTime? created_at;
  DateTime? last_activity_at;

  ContactInfo({
    required this.id,
    this.email,
    required this.name,
    required this.phone_number,
    required this.identifier,
    required this.thumbnail,
    required this.additional_attributes,
    required this.custom_attributes,
    this.created_at,
    this.last_activity_at,
  });

  factory ContactInfo.fromJson(dynamic json) {
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
      created_at: toDateTime(json['created_at']),
      last_activity_at: toDateTime(json['last_activity_at']),
    );
  }
}

class ListContactMeta extends ApiListMeta {
  const ListContactMeta({
    required super.count,
    required super.current_page,
  });

  factory ListContactMeta.fromJson(dynamic json) {
    var base = ApiListMeta.fromJson(json);
    return ListContactMeta(
      count: base.count,
      current_page: base.current_page,
    );
  }
}

class ListContactResult extends ApiListResult<ListContactMeta, ContactInfo> {
  const ListContactResult({
    required super.meta,
    required super.payload,
  });

  factory ListContactResult.fromJson(dynamic json) {
    List<dynamic> payload = json['payload'];
    return ListContactResult(
      meta: ListContactMeta.fromJson(json['meta']),
      payload: payload.map(ContactInfo.fromJson).toList(),
    );
  }
}
