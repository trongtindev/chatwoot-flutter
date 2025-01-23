import '/imports.dart';

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
      file_type: AttachmentType.fromName(json['file_type']),
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
  final bool deleted;

  const MessageContentAttributes({
    this.in_reply_to,
    this.in_reply_to_external_id,
    required this.deleted,
  });

  factory MessageContentAttributes.fromJson(dynamic json) {
    return MessageContentAttributes(
      in_reply_to: json['in_reply_to'],
      in_reply_to_external_id: json['in_reply_to_external_id'],
      deleted: json['deleted'] ?? false,
    );
  }
}

class MessageInfo {
  final int id;
  final String? content;
  final int? account_id;
  final int inbox_id;
  final String? echo_id;
  final int conversation_id;
  final MessageType message_type;
  final DateTime created_at;
  final DateTime? updated_at;
  final bool private;
  final MessageStatus status;
  final String? source_id;
  final MessageContentType content_type;
  final MessageContentAttributes content_attributes;
  final UserType sender_type;
  final int? sender_id;
  final dynamic external_source_ids; // TODO: unk type
  final ConversationAttribute additional_attributes;
  final String? processed_message_content;
  final dynamic sentiment; // TODO: unk type
  final dynamic conversation; // TODO: unk type
  final UserInfo? sender;
  final List<MessageAttachmentInfo> attachments;

  const MessageInfo({
    required this.id,
    this.content,
    this.account_id,
    required this.inbox_id,
    this.echo_id,
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
    final sender =
        json['sender'] != null ? UserInfo.fromJson(json['sender']) : null;
    final List<dynamic> attachments = json['attachments'] ?? [];
    final additional_attributes =
        ConversationAttribute.fromJson(json['additional_attributes'] ?? {});

    return MessageInfo(
      id: json['id'],
      content: json['content'],
      account_id: json['account_id'],
      inbox_id: json['inbox_id'],
      echo_id: json['echo_id'],
      conversation_id: json['conversation_id'],
      message_type: MessageType.values[json['message_type']],
      created_at: toDateTime(json['created_at'])!,
      updated_at: toDateTime(json['updated_at']),
      private: json['private'],
      status: MessageStatus.fromName(json['status']),
      source_id: json['source_id'],
      content_type: MessageContentType.fromName(json['content_type']),
      content_attributes:
          MessageContentAttributes.fromJson(json['content_attributes']),
      sender_type: UserType.fromName(json['sender_type']),
      sender_id: json['sender_id'],
      external_source_ids: json['external_source_ids'],
      additional_attributes: additional_attributes,
      processed_message_content: json['processed_message_content'],
      sentiment: json['sentiment'],
      conversation: json['conversation'],
      sender: sender,
      attachments: attachments.map(MessageAttachmentInfo.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'account_id': account_id,
      'inbox_id': inbox_id,
      'conversation_id': conversation_id,
      'message_type': message_type.name,
      'created_at': created_at,
      'updated_at': updated_at,
      'private': private,
      'status': status.name,
      'source_id': source_id,
      'content_type': content_type.name,
      // 'content_attributes': content_attributes,
      'sender_type': sender_type.name,
      'sender_id': sender_id,
      'external_source_ids': external_source_ids,
      // 'additional_attributes': additional_attributes,
      'processed_message_content': processed_message_content,
      'sentiment': sentiment,
      // 'conversation': conversation,
      // 'sender': sender,
      // 'attachments': attachments,
    };
  }
}

class ListMessageMeta {
  final List<String> labels;
  final ContactInfo contact;
  final UserInfo? assignee;
  final DateTime? agent_last_seen_at;
  final DateTime? assignee_last_seen_at;

  const ListMessageMeta({
    required this.labels,
    required this.contact,
    this.assignee,
    this.agent_last_seen_at,
    this.assignee_last_seen_at,
  });

  factory ListMessageMeta.fromJson(dynamic json) {
    List<dynamic> labels = json['labels'] ?? [];
    var assignee =
        json['assignee'] != null ? UserInfo.fromJson(json['assignee']) : null;
    var agent_last_seen_at = json['agent_last_seen_at'] != null
        ? DateTime.parse(json['agent_last_seen_at'])
        : null;
    var assignee_last_seen_at = json['assignee_last_seen_at'] != null
        ? DateTime.parse(json['assignee_last_seen_at'])
        : null;

    return ListMessageMeta(
      labels: labels.map((e) => e.toString()).toList(),
      contact: ContactInfo.fromJson(json['contact']),
      assignee: assignee,
      agent_last_seen_at: agent_last_seen_at,
      assignee_last_seen_at: assignee_last_seen_at,
    );
  }
}

class ListMessageResult extends ApiListResult<ListMessageMeta, MessageInfo> {
  const ListMessageResult({
    required super.meta,
    required super.payload,
  });

  factory ListMessageResult.fromJson(dynamic json) {
    List<dynamic> payload = json['payload'];
    return ListMessageResult(
      meta: ListMessageMeta.fromJson(json['meta']),
      payload: payload.map(MessageInfo.fromJson).toList(),
    );
  }
}
