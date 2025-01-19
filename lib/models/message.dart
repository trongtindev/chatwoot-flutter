import '/imports.dart';

class ListMessageMeta {
  const ListMessageMeta();

  factory ListMessageMeta.fromJson(dynamic json) {
    return ListMessageMeta();
  }
}

class ListMessageResult extends ApiListResult<ListMessageMeta, MessageInfo> {
  const ListMessageResult({
    required super.meta,
    required super.payload,
  });

  factory ListMessageResult.fromJson(dynamic json) {
    // if (kDebugMode) {
    //   print('---ListMessageResult.fromJson:START---');
    //   print(json);
    //   print('---ListMessageResult.fromJson:END---');
    // }

    List<dynamic> payload = json['payload'];
    return ListMessageResult(
      meta: ListMessageMeta.fromJson(json['meta']),
      payload: payload.map(MessageInfo.fromJson).toList(),
    );
  }
}

class MessageSenderInfo {
  final int id;
  final String name;
  final String? available_name;
  final String? avatar_url;
  final MessageSenderType type;
  final AvailabilityStatus? availability_status;
  final String thumbnail;

  const MessageSenderInfo({
    required this.id,
    required this.name,
    this.available_name,
    this.avatar_url,
    required this.type,
    this.availability_status,
    required this.thumbnail,
  });

  factory MessageSenderInfo.fromJson(Map<String, dynamic> json) {
    var availability_status = json['availability_status'] != null
        ? AvailabilityStatus.values.byName(json['availability_status'])
        : null;

    return MessageSenderInfo(
      id: json['id'],
      name: json['name'],
      available_name: json['available_name'],
      avatar_url: json['avatar_url'],
      type: MessageSenderType.values.byName(json['type']),
      availability_status: availability_status,
      thumbnail: json['thumbnail'],
    );
  }
}

class MessageAttachmentInfo {
  final int id;
  final int message_id;
  final AttachmentType file_type;
  final int account_id;
  final dynamic extension; // TODO: unk type
  final String? data_url;
  final String? thumbnail;
  final String? thumb_url;
  final int? file_size;
  final int? width;
  final int? height;

  const MessageAttachmentInfo({
    required this.id,
    required this.message_id,
    required this.file_type,
    required this.account_id,
    required this.extension,
    required this.data_url,
    required this.thumbnail,
    required this.thumb_url,
    required this.file_size,
    required this.width,
    required this.height,
  });

  factory MessageAttachmentInfo.fromJson(dynamic json) {
    return MessageAttachmentInfo(
      id: json['id'],
      message_id: json['message_id'],
      file_type: AttachmentType.values.byName(json['file_type']),
      account_id: json['account_id'],
      extension: json['extension'],
      data_url: json['data_url'],
      thumbnail: json['thumbnail'],
      thumb_url: json['thumb_url'],
      file_size: json['file_size'],
      width: json['width'],
      height: json['height'],
    );
  }
}

class MessageContentAttributes {
  final int? in_reply_to;
  final dynamic in_reply_to_external_id; // TODO: unk type

  const MessageContentAttributes({
    this.in_reply_to,
    this.in_reply_to_external_id,
  });

  factory MessageContentAttributes.fromJson(dynamic json) {
    return MessageContentAttributes(
      in_reply_to: json['in_reply_to'],
      in_reply_to_external_id: json['in_reply_to_external_id'],
    );
  }
}

class MessageInfo {
  final int id;
  final String? content;
  final int? account_id;
  final int inbox_id;
  final int conversation_id;
  final MessageType message_type;
  final DateTime created_at;
  final DateTime? updated_at;
  final bool private;
  final MessageStatus status;
  final String? source_id;
  final MessageContentType content_type;
  final MessageContentAttributes content_attributes;
  final MessageSenderType sender_type;
  final int? sender_id;
  final dynamic external_source_ids; // TODO: unk type
  final dynamic additional_attributes; // TODO: unk type
  final String? processed_message_content;
  final dynamic sentiment; // TODO: unk type
  final dynamic conversation; // TODO: unk type
  final MessageSenderInfo? sender;
  final List<MessageAttachmentInfo> attachments;

  const MessageInfo({
    required this.id,
    this.content,
    this.account_id,
    required this.inbox_id,
    required this.conversation_id,
    required this.message_type,
    required this.created_at,
    this.updated_at,
    required this.private,
    required this.status,
    this.source_id,
    required this.content_type,
    required this.content_attributes,
    required this.sender_type,
    this.sender_id,
    required this.external_source_ids,
    required this.additional_attributes,
    this.processed_message_content,
    required this.sentiment,
    required this.conversation,
    this.sender,
    required this.attachments,
  });

  factory MessageInfo.fromJson(dynamic json) {
    var sender_type = json['sender_type'] == null
        ? MessageSenderType.none
        : MessageSenderType.values
            .byName(json['sender_type'].toString().toLowerCase());
    var sender = json['sender'] != null
        ? MessageSenderInfo.fromJson(json['sender'])
        : null;
    var updated_at = json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null; // 2025-01-18T02:25:23.830Z
    List<dynamic> attachments = json['attachments'] ?? [];

    return MessageInfo(
      id: json['id'],
      content: json['content'],
      account_id: json['account_id'],
      inbox_id: json['inbox_id'],
      conversation_id: json['conversation_id'],
      message_type: MessageType.values[json['message_type']],
      created_at: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000), // 1737167120
      updated_at: updated_at,
      private: json['private'],
      status: MessageStatus.values.byName(json['status']),
      source_id: json['source_id'],
      content_type: MessageContentType.values.byName(json['content_type']),
      content_attributes:
          MessageContentAttributes.fromJson(json['content_attributes']),
      sender_type: sender_type,
      sender_id: json['sender_id'],
      external_source_ids: json['external_source_ids'],
      additional_attributes: json['additional_attributes'],
      processed_message_content: json['processed_message_content'],
      sentiment: json['sentiment'],
      conversation: json['conversation'],
      sender: sender,
      attachments: attachments.map(MessageAttachmentInfo.fromJson).toList(),
    );
  }
}
