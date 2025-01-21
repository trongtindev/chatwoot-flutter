import '/imports.dart';

class CannedResponseInfo {
  final int id;
  final int account_id;
  final String short_code;
  final String content;
  final DateTime created_at;
  final DateTime updated_at;

  const CannedResponseInfo({
    required this.id,
    required this.account_id,
    required this.short_code,
    required this.content,
    required this.created_at,
    required this.updated_at,
  });

  factory CannedResponseInfo.fromJson(dynamic json) {
    return CannedResponseInfo(
      id: json['id'],
      account_id: json['account_id'],
      short_code: json['short_code'],
      content: json['content'],
      created_at: toDateTime(json['created_at'])!,
      updated_at: toDateTime(json['updated_at'])!,
    );
  }
}
