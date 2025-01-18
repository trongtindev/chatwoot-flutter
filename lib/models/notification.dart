import '/imports.dart';

class ListNotificationMeta extends ApiListMeta {
  int unread_count;

  ListNotificationMeta({
    required this.unread_count,
    required super.count,
    // required super.current_page,
  });

  factory ListNotificationMeta.fromJson(Map<String, dynamic> json) {
    return ListNotificationMeta(
      unread_count: json['unread_count'],
      count: json['count'],
      // current_page: json['current_page'],
    );
  }
}

class NotificationPrimaryActorMeta {
  final SenderInfo sender;

  const NotificationPrimaryActorMeta({
    required this.sender,
  });

  factory NotificationPrimaryActorMeta.fromJson(dynamic json) {
    return NotificationPrimaryActorMeta(
      sender: SenderInfo.fromJson(json['sender']),
    );
  }
}

class NotificationPrimaryActor {
  final NotificationPrimaryActorMeta meta;

  const NotificationPrimaryActor({
    required this.meta,
  });

  factory NotificationPrimaryActor.fromJson(dynamic json) {
    return NotificationPrimaryActor(
      meta: NotificationPrimaryActorMeta.fromJson(json['meta']),
    );
  }
}

class NotificationInfo {
  int id;
  NotificationType notification_type;
  String push_message_title;
  String primary_actor_type; // TODO: unk type
  int primary_actor_id;
  NotificationPrimaryActor? primary_actor;
  DateTime? read_at;
  dynamic secondary_actor; // TODO: unk type
  UserInfo user;
  DateTime created_at;
  DateTime last_activity_at;
  dynamic snoozed_until; // TODO: unk type
  dynamic meta;

  NotificationInfo({
    required this.id,
    required this.notification_type,
    required this.push_message_title,
    required this.primary_actor_type,
    required this.primary_actor_id,
    required this.primary_actor,
    this.read_at,
    required this.secondary_actor,
    required this.user,
    required this.created_at,
    required this.last_activity_at,
    required this.snoozed_until,
    required this.meta,
  });

  factory NotificationInfo.fromJson(dynamic json) {
    var read_at =
        json['read_at'] != null ? DateTime.parse(json['read_at']) : null;
    var primary_actor = json['primary_actor'] != null
        ? NotificationPrimaryActor.fromJson(json['primary_actor'])
        : null;

    return NotificationInfo(
      id: json['id'],
      notification_type:
          NotificationType.values.byName(json['notification_type']),
      push_message_title: json['push_message_title'],
      primary_actor_type: json['primary_actor_type'],
      primary_actor_id: json['primary_actor_id'],
      primary_actor: primary_actor,
      read_at: read_at, // 1737081406
      secondary_actor: json['secondary_actor'],
      user: UserInfo.fromJson(json['user']),
      created_at: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000), // 1737081406
      last_activity_at: DateTime.fromMillisecondsSinceEpoch(
          json['last_activity_at'] * 1000), // 1737081406
      snoozed_until: json['snoozed_until'],
      meta: json['meta'],
    );
  }
}
