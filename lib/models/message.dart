import '/imports.dart';

class MessageSenderInfo {
  int id;
  String name;
  String available_name;
  String avatar_url;
  MessageSenderType type;
  AvailabilityStatus availability_status;
  String thumbnail;

  MessageSenderInfo({
    required this.id,
    required this.name,
    required this.available_name,
    required this.avatar_url,
    required this.type,
    required this.availability_status,
    required this.thumbnail,
  });

  factory MessageSenderInfo.fromJson(Map<String, dynamic> json) {
    return MessageSenderInfo(
      id: json['id'],
      name: json['name'],
      available_name: json['available_name'],
      avatar_url: json['avatar_url'],
      type: MessageSenderType.values.byName(json['type']),
      availability_status:
          AvailabilityStatus.values.byName(json['availability_status']),
      thumbnail: json['thumbnail'],
    );
  }
}

class MessageInfo {
  int id;
  String content;
  int account_id;
  int inbox_id;
  int conversation_id;
  MessageType message_type;
  DateTime created_at;
  DateTime updated_at;
  bool private;
  MessageStatus status;
  String source_id;
  MessageContentType content_type;
  dynamic content_attributes; // TODO: unk type
  MessageSenderType sender_type;
  int sender_id;
  dynamic external_source_ids; // TODO: unk type
  dynamic additional_attributes; // TODO: unk type
  String processed_message_content;
  dynamic sentiment; // TODO: unk type
  dynamic conversation; // TODO: unk type
  MessageSenderInfo sender;

  MessageInfo({
    required this.id,
    required this.content,
    required this.account_id,
    required this.inbox_id,
    required this.conversation_id,
    required this.message_type,
    required this.created_at,
    required this.updated_at,
    required this.private,
    required this.status,
    required this.source_id,
    required this.content_type,
    required this.content_attributes,
    required this.sender_type,
    required this.sender_id,
    required this.external_source_ids,
    required this.additional_attributes,
    required this.processed_message_content,
    required this.sentiment,
    required this.conversation,
    required this.sender,
  });

  factory MessageInfo.fromJson(dynamic json) {
    return MessageInfo(
      id: json['id'],
      content: json['content'],
      account_id: json['account_id'],
      inbox_id: json['inbox_id'],
      conversation_id: json['conversation_id'],
      message_type: MessageType.values.byName(json['message_type']),
      created_at: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000), // 1737167120
      updated_at:
          DateTime.parse(json['updated_at']), // 2025-01-18T02:25:23.830Z
      private: json['private'],
      status: MessageStatus.values.byName(json['status']),
      source_id: json['source_id'],
      content_type: MessageContentType.values.byName(json['content_type']),
      content_attributes: json['content_attributes'],
      sender_type: MessageSenderType.values.byName(json['sender_type']),
      sender_id: json['sender_id'],
      external_source_ids: json['external_source_ids'],
      additional_attributes: json['additional_attributes'],
      processed_message_content: json['processed_message_content'],
      sentiment: json['sentiment'],
      conversation: json['conversation'],
      sender: MessageSenderInfo.fromJson(json['sender']),
    );
  }
}
