import '/imports.dart';
import 'package:intl/intl.dart';

class ConversationAssigneeInfo {
  final int id;
  final int? account_id;
  final AvailabilityStatus? availability_status;
  final bool auto_offline;
  final bool? confirmed;
  final String? email;
  final String? available_name;
  final String name;
  final ProfileRole? role;
  final String? avatar_url;
  final String thumbnail;
  final dynamic custom_role_id; // TODO: unk type

  const ConversationAssigneeInfo({
    required this.id,
    this.account_id,
    this.availability_status,
    required this.auto_offline,
    this.confirmed,
    this.email,
    this.available_name,
    required this.name,
    required this.role,
    this.avatar_url,
    required this.thumbnail,
    required this.custom_role_id,
  });

  factory ConversationAssigneeInfo.fromJson(dynamic json) {
    var availability_status = json['availability_status'] != null
        ? AvailabilityStatus.values.byName(json['availability_status'])
        : null;
    var role =
        json['role'] != null ? ProfileRole.values.byName(json['role']) : null;

    return ConversationAssigneeInfo(
      id: json['id'],
      account_id: json['account_id'],
      availability_status: availability_status,
      auto_offline: json['auto_offline'] ?? false,
      confirmed: json['confirmed'],
      email: json['email'],
      available_name: json['available_name'],
      name: json['name'],
      role: role,
      avatar_url: json['avatar_url'],
      thumbnail: json['thumbnail'],
      custom_role_id: json['custom_role_id'],
    );
  }
}

class ConversationMeta {
  final SenderInfo sender;
  final InboxChannelType? channel;
  final ConversationAssigneeInfo? assignee;
  final bool hmac_verified;

  const ConversationMeta({
    required this.sender,
    this.channel,
    this.assignee,
    required this.hmac_verified,
  });

  factory ConversationMeta.fromJson(dynamic json) {
    var assignee = json['assignee'] != null
        ? ConversationAssigneeInfo.fromJson(json['assignee'])
        : null;
    var channel = json['channel'] != null
        ? InboxChannelType.values.firstWhere((e) => e.value == json['channel'])
        : null;

    return ConversationMeta(
      sender: SenderInfo.fromJson(json['sender']),
      channel: channel,
      assignee: assignee,
      hmac_verified: json['hmac_verified'],
    );
  }
}

class ConversationAttribute {
  final BrowserAttribute? browser;
  final String? referer;
  final DateTime? initiated_at;
  final String? browser_language;

  const ConversationAttribute({
    this.browser,
    this.referer,
    this.initiated_at,
    this.browser_language,
  });

  factory ConversationAttribute.fromJson(Map<String, dynamic> json) {
    var browser = json['browser'] != null
        ? BrowserAttribute.fromJson(json['browser'])
        : null;
    var timestamp = json['initiated_at'] != null
        ? json['initiated_at']['timestamp'].toString().split(' (').first
        : null;

    return ConversationAttribute(
      browser: browser,
      referer: json['referer'],
      initiated_at: timestamp != null
          ? DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z").parse(timestamp)
          : null,
      browser_language: json['browser_language'],
    );
  }
}

class ConversationInfo {
  final ConversationMeta meta;
  final int id;
  final List<MessageInfo> messages;
  final int account_id;
  final String? uuid;
  final ConversationAttribute? additional_attributes;
  final DateTime? agent_last_seen_at;
  final DateTime? assignee_last_seen_at;
  final bool can_reply;
  final DateTime? contact_last_seen_at;
  final dynamic custom_attributes; // TODO: unk type
  final int inbox_id;
  final List<String> labels; // TODO: unk type
  final bool? muted;
  final dynamic snoozed_until; // TODO: unk type
  final ConversationStatus status;
  final DateTime created_at;
  final DateTime timestamp;
  final DateTime? first_reply_created_at;
  int unread_count;
  MessageInfo? last_non_activity_message;
  DateTime last_activity_at;
  final ConversationPriority priority;
  final int waiting_since;
  final dynamic sla_policy_id; // TODO: unk type

  ConversationInfo({
    required this.meta,
    required this.id,
    required this.messages,
    required this.account_id,
    this.uuid,
    this.additional_attributes,
    this.agent_last_seen_at,
    this.assignee_last_seen_at,
    required this.can_reply,
    this.contact_last_seen_at,
    required this.custom_attributes,
    required this.inbox_id,
    required this.labels,
    this.muted,
    required this.snoozed_until,
    required this.status,
    required this.created_at,
    required this.timestamp,
    this.first_reply_created_at,
    required this.unread_count,
    this.last_non_activity_message,
    required this.last_activity_at,
    required this.priority,
    required this.waiting_since,
    required this.sla_policy_id,
  });

  factory ConversationInfo.fromJson(dynamic json) {
    List<dynamic> messages = json['messages'];
    var additional_attributes = json['additional_attributes'] != null
        ? ConversationAttribute.fromJson(json['additional_attributes'])
        : null;
    var assignee_last_seen_at = toDateTime(json['assignee_last_seen_at']);
    var contact_last_seen_at = toDateTime(json['contact_last_seen_at']);
    List<dynamic> labels = json['labels'];

    var first_reply_created_at = toDateTime(json['first_reply_created_at']);
    var last_non_activity_message = json['last_non_activity_message'] != null
        ? MessageInfo.fromJson(json['last_non_activity_message'])
        : null;
    var last_activity_at = toDateTime(json['last_activity_at']);
    var priority = json['priority'] != null
        ? ConversationPriority.values.byName(json['priority'])
        : ConversationPriority.none;
    var created_at = toDateTime(json['created_at'])!;

    return ConversationInfo(
      meta: ConversationMeta.fromJson(json['meta']),
      id: json['id'],
      messages: messages.map(MessageInfo.fromJson).toList(),
      account_id: json['account_id'],
      uuid: json['uuid'],
      additional_attributes: additional_attributes,
      agent_last_seen_at: toDateTime(json['agent_last_seen_at']),
      assignee_last_seen_at: assignee_last_seen_at,
      can_reply: json['can_reply'],
      contact_last_seen_at: contact_last_seen_at,
      custom_attributes: json['custom_attributes'],
      inbox_id: json['inbox_id'],
      labels: labels.map((e) => e.toString()).toList(),
      muted: json['muted'],
      snoozed_until: json['snoozed_until'],
      status: ConversationStatus.values.byName(json['status']),
      created_at: created_at,
      timestamp: toDateTime(json['timestamp'])!,
      first_reply_created_at: first_reply_created_at,
      unread_count: json['unread_count'],
      last_non_activity_message: last_non_activity_message,
      last_activity_at: last_activity_at ?? created_at,
      priority: priority,
      waiting_since: json['waiting_since'],
      sla_policy_id: json['sla_policy_id'],
    );
  }
}

class ListConversationMeta {
  final int mine_count;
  final int assigned_count;
  final int unassigned_count;
  final int all_count;

  const ListConversationMeta({
    required this.mine_count,
    required this.assigned_count,
    required this.unassigned_count,
    required this.all_count,
  });

  factory ListConversationMeta.fromJson(dynamic json) {
    return ListConversationMeta(
      mine_count: json['mine_count'],
      assigned_count: json['assigned_count'],
      unassigned_count: json['unassigned_count'],
      all_count: json['all_count'],
    );
  }
}

class ListConversationResult
    extends ApiListResult<ListConversationMeta, ConversationInfo> {
  const ListConversationResult({
    required super.meta,
    required super.payload,
  });

  factory ListConversationResult.fromJson(dynamic json) {
    List<dynamic> payload = json['payload'];
    return ListConversationResult(
      meta: ListConversationMeta.fromJson(json['meta']),
      payload: payload.map(ConversationInfo.fromJson).toList(),
    );
  }
}
