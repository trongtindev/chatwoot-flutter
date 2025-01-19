class InboxInfo {
  final String source_id;

  const InboxInfo({
    required this.source_id,
  });

  factory InboxInfo.fromJson(dynamic json) {
    return InboxInfo(
      source_id: json['source_id'],
    );
  }
}
