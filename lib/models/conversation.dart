import '/imports.dart';

class ListConversationMeta {
  int mine_count;
  int assigned_count;
  int unassigned_count;
  int all_count;

  ListConversationMeta({
    required this.mine_count,
    required this.assigned_count,
    required this.unassigned_count,
    required this.all_count,
  });

  factory ListConversationMeta.fromJson(Map<String, dynamic> json) {
    return ListConversationMeta(
      mine_count: json['mine_count'],
      assigned_count: json['assigned_count'],
      unassigned_count: json['unassigned_count'],
      all_count: json['all_count'],
    );
  }
}

class ConversationAssigneeInfo {
  int id;
  int account_id;
  AvailabilityStatus availability_status;
  bool auto_offline;
  bool confirmed;
  String email;
  String available_name;
  String name;
  ProfileRole role;
  String thumbnail;
  dynamic custom_role_id; // TODO: unk type

  ConversationAssigneeInfo({
    required this.id,
    required this.account_id,
    required this.availability_status,
    required this.auto_offline,
    required this.confirmed,
    required this.email,
    required this.available_name,
    required this.name,
    required this.role,
    required this.thumbnail,
    required this.custom_role_id,
  });

  factory ConversationAssigneeInfo.fromJson(Map<String, dynamic> json) {
    return ConversationAssigneeInfo(
      id: json['id'],
      account_id: json['account_id'],
      availability_status:
          AvailabilityStatus.values.byName(json['availability_status']),
      auto_offline: json['auto_offline'],
      confirmed: json['confirmed'],
      email: json['email'],
      available_name: json['available_name'],
      name: json['name'],
      role: ProfileRole.values.byName(json['role']),
      thumbnail: json['thumbnail'],
      custom_role_id: json['custom_role_id'],
    );
  }
}

class ConversationMeta {
  SenderInfo sender;
  InboxType channel;
  ConversationAssigneeInfo? assignee;
  bool hmac_verified;

  ConversationMeta({
    required this.sender,
    required this.channel,
    required this.assignee,
    required this.hmac_verified,
  });

  factory ConversationMeta.fromJson(Map<String, dynamic> json) {
    return ConversationMeta(
      sender: SenderInfo.fromJson(json['sender']),
      channel: InboxType.values.firstWhere((e) => e.value == json['channel']),
      assignee: json['assignee']
          ? ConversationAssigneeInfo.fromJson(json['assignee'])
          : null,
      hmac_verified: json['hmac_verified'],
    );
  }
}

class ConversationAttribute {
  BrowserAttribute browser;
  String? referer;
  DateTime initiated_at;
  String browser_language;

  ConversationAttribute({
    required this.browser,
    this.referer,
    required this.initiated_at,
    required this.browser_language,
  });

  factory ConversationAttribute.fromJson(Map<String, dynamic> json) {
    return ConversationAttribute(
      browser: BrowserAttribute.fromJson(json['browser']),
      referer: json['referer'],
      initiated_at: DateTime.parse(json['initiated_at']['timestamp']),
      browser_language: json['browser_language'],
    );
  }
}

class ConversationInfo {
  ConversationMeta meta;
  int id;
  List<MessageInfo> messages;
  int account_id;
  String uuid;
  ConversationAttribute additional_attributes;
  DateTime agent_last_seen_at;
  DateTime? assignee_last_seen_at;
  bool can_reply;
  DateTime? contact_last_seen_at;
  dynamic custom_attributes; // TODO: unk type
  int inbox_id;
  List<String> labels; // TODO: unk type
  bool muted;
  dynamic snoozed_until; // TODO: unk type
  ConversationStatus status;
  DateTime created_at;
  DateTime timestamp;
  DateTime? first_reply_created_at;
  int unread_count;
  MessageInfo? last_non_activity_message;
  DateTime? last_activity_at;
  ConversationPriority priority;
  int waiting_since;
  dynamic sla_policy_id; // TODO: unk type

  ConversationInfo({
    required this.meta,
    required this.id,
    required this.messages,
    required this.account_id,
    required this.uuid,
    required this.additional_attributes,
    required this.agent_last_seen_at,
    this.assignee_last_seen_at,
    required this.can_reply,
    required this.contact_last_seen_at,
    required this.custom_attributes,
    required this.inbox_id,
    required this.labels,
    required this.muted,
    required this.snoozed_until,
    required this.status,
    required this.created_at,
    required this.timestamp,
    this.first_reply_created_at,
    required this.unread_count,
    this.last_non_activity_message,
    this.last_activity_at,
    required this.priority,
    required this.waiting_since,
    required this.sla_policy_id,
  });

  factory ConversationInfo.fromJson(dynamic json) {
    List<dynamic> messages = json['messages'];
    var assignee_last_seen_at = json['assignee_last_seen_at']
        ? DateTime.fromMillisecondsSinceEpoch(
            json['assignee_last_seen_at'] * 1000)
        : null;
    var contact_last_seen_at = json['contact_last_seen_at']
        ? DateTime.fromMillisecondsSinceEpoch(
            json['contact_last_seen_at'] * 1000)
        : null;
    List<dynamic> labels = json['labels'];
    var first_reply_created_at = json['first_reply_created_at']
        ? DateTime.fromMillisecondsSinceEpoch(
            json['first_reply_created_at'] * 1000)
        : null;
    var last_non_activity_message = json['last_non_activity_message']
        ? MessageInfo.fromJson(json['last_non_activity_message'])
        : null;
    var last_activity_at = json['last_activity_at']
        ? DateTime.fromMillisecondsSinceEpoch(json['last_activity_at'] * 1000)
        : null;

    return ConversationInfo(
      meta: ConversationMeta.fromJson(json['meta']),
      id: json['id'],
      messages: messages.map(MessageInfo.fromJson).toList(),
      account_id: json['account_id'],
      uuid: json['uuid'],
      additional_attributes:
          ConversationAttribute.fromJson(json['additional_attributes']),
      agent_last_seen_at: DateTime.fromMillisecondsSinceEpoch(
          json['agent_last_seen_at'] * 1000), // 1737180144
      assignee_last_seen_at: assignee_last_seen_at, // 1737180144
      can_reply: json['can_reply'],
      contact_last_seen_at: contact_last_seen_at,
      custom_attributes: json['custom_attributes'],
      inbox_id: json['inbox_id'],
      labels: labels.map((e) => e.toString()).toList(),
      muted: json['muted'],
      snoozed_until: json['snoozed_until'],
      status: ConversationStatus.values.byName(json['status']),
      created_at: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000), // 1737180144
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          json['timestamp'] * 1000), // 1737180144
      first_reply_created_at: first_reply_created_at,
      unread_count: json['unread_count'],
      last_non_activity_message: last_non_activity_message,
      last_activity_at: last_activity_at,
      priority: ConversationPriority.values.byName(json['priority']),
      waiting_since: json['waiting_since'],
      sla_policy_id: json['sla_policy_id'],
    );
  }
}
