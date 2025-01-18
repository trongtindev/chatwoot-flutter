class BrowserAttribute {
  String device_name;
  String browser_name;
  String platform_name;
  String browser_version;
  String platform_version;

  BrowserAttribute({
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