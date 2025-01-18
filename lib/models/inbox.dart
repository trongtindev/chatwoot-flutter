class InboxInfo {
  String source_id;

  InboxInfo({
    required this.source_id,
  });

  factory InboxInfo.fromJson(dynamic json) {
    return InboxInfo(
      source_id: json['source_id'],
    );
  }
}
