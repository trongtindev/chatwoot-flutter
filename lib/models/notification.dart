import '/imports.dart';

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
  final int id;
  final NotificationType notification_type;
  final String push_message_title;
  final NotificationActorType primary_actor_type;
  final int primary_actor_id;
  final NotificationPrimaryActor primary_actor;
  DateTime? read_at;
  final dynamic secondary_actor; // TODO: unk type
  final UserInfo? user;
  final DateTime created_at;
  final DateTime last_activity_at;
  final dynamic snoozed_until; // TODO: unk type
  final dynamic meta;

  NotificationInfo({
    required this.id,
    required this.notification_type,
    required this.push_message_title,
    required this.primary_actor_type,
    required this.primary_actor_id,
    required this.primary_actor,
    this.read_at,
    required this.secondary_actor,
    this.user,
    required this.created_at,
    required this.last_activity_at,
    required this.snoozed_until,
    required this.meta,
  });

  factory NotificationInfo.fromJson(dynamic json) {
    final primary_actor =
        NotificationPrimaryActor.fromJson(json['primary_actor']);
    final notification_type =
        NotificationType.fromName(json['notification_type']);
    final primary_actor_type =
        NotificationActorType.fromName(json['primary_actor_type']);

    return NotificationInfo(
      id: json['id'],
      notification_type: notification_type,
      push_message_title: json['push_message_title'],
      primary_actor_type: primary_actor_type,
      primary_actor_id: json['primary_actor_id'],
      primary_actor: primary_actor,
      read_at: toDateTime(json['read_at']),
      secondary_actor: json['secondary_actor'],
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
      created_at: toDateTime(json['created_at'])!,
      last_activity_at: toDateTime(json['last_activity_at'])!,
      snoozed_until: json['snoozed_until'],
      meta: json['meta'],
    );
  }
}

class ListNotificationMeta extends ApiListMeta {
  int unread_count;

  ListNotificationMeta({
    required this.unread_count,
    required super.count,
    required super.current_page,
  });

  factory ListNotificationMeta.fromJson(dynamic json) {
    var base = ApiListMeta.fromJson(json);
    return ListNotificationMeta(
      unread_count: json['unread_count'],
      count: base.count,
      current_page: base.current_page,
    );
  }
}

class ListNotificationResult
    extends ApiListResult<ListNotificationMeta, NotificationInfo> {
  const ListNotificationResult({
    required super.meta,
    required super.payload,
  });

  factory ListNotificationResult.fromJson(dynamic json) {
    List<dynamic> payload = json['payload'];
    return ListNotificationResult(
      meta: ListNotificationMeta.fromJson(json['meta']),
      payload: payload.map(NotificationInfo.fromJson).toList(),
    );
  }
}
