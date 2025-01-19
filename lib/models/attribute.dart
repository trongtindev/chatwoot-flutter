import '/imports.dart';

class BrowserAttribute {
  final String device_name;
  final String browser_name;
  final String platform_name;
  final String browser_version;
  final String platform_version;

  const BrowserAttribute({
    required this.device_name,
    required this.browser_name,
    required this.platform_name,
    required this.browser_version,
    required this.platform_version,
  });

  factory BrowserAttribute.fromJson(Map<String, dynamic> json) {
    return BrowserAttribute(
      device_name: json['device_name'],
      browser_name: json['browser_name'],
      platform_name: json['platform_name'],
      browser_version: json['browser_version'],
      platform_version: json['platform_version'],
    );
  }
}

class CustomAttribute {
  final int id;
  final String attribute_display_name;
  final String attribute_display_type;
  final String attribute_description;
  final String attribute_key;
  final String? regex_pattern;
  final String? regex_cue;
  final dynamic attribute_values; // TODO: unk type
  final AttributeModel attribute_model;
  final String? default_value;
  final DateTime created_at;
  final DateTime updated_at;

  const CustomAttribute({
    required this.id,
    required this.attribute_display_name,
    required this.attribute_display_type,
    required this.attribute_description,
    required this.attribute_key,
    required this.regex_pattern,
    required this.regex_cue,
    required this.attribute_values,
    required this.attribute_model,
    required this.default_value,
    required this.created_at,
    required this.updated_at,
  });

  factory CustomAttribute.fromJson(dynamic json) {
    return CustomAttribute(
      id: json['id'],
      attribute_display_name: json['attribute_display_name'],
      attribute_display_type: json['attribute_display_type'],
      attribute_description: json['attribute_description'],
      attribute_key: json['attribute_key'],
      regex_pattern: json['regex_pattern'],
      regex_cue: json['regex_cue'],
      attribute_values: json['attribute_values'],
      attribute_model: AttributeModel.values.byName(json['attribute_model']),
      default_value: json['default_value'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
    );
  }
}
