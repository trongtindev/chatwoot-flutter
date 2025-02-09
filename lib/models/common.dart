class CountryCode {
  final String name;
  final String dialCode;
  final String code;

  CountryCode({
    required this.name,
    required this.dialCode,
    required this.code,
  });

  factory CountryCode.fromJson(dynamic json) {
    return CountryCode(
      name: json['name'],
      dialCode: json['dialCode'],
      code: json['code'],
    );
  }
}
