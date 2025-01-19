// import '/imports.dart';

class CachedRequest {
  final int id;
  final String url;
  final String data;

  const CachedRequest({
    required this.id,
    required this.url,
    required this.data,
  });

  factory CachedRequest.fromJson(dynamic json) {
    return CachedRequest(
      id: json['id'],
      url: json['url'],
      data: json['data'],
    );
  }
}
