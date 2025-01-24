import '/imports.dart';
import 'package:flutter/material.dart' as material;

enum AccountStatus {
  active,
  undefined;

  static AccountStatus fromName(dynamic name) {
    if (isNullOrEmpty(name)) return AccountStatus.undefined;
    return AccountStatus.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        AccountStatus.undefined;
  }
}

enum UserRole {
  administrator,
  agent,
  undefined;

  // TODO: make this
  String get label {
    switch (this) {
      default:
        return name;
    }
  }

  static UserRole fromName(dynamic name) {
    if (isNullOrEmpty(name)) return UserRole.undefined;
    return UserRole.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        UserRole.undefined;
  }
}

enum ProfileType {
  SuperAdmin,
  undefined;

  static ProfileType fromName(dynamic name) {
    if (isNullOrEmpty(name)) return ProfileType.undefined;
    return ProfileType.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        ProfileType.undefined;
  }
}

enum AvailabilityStatus {
  online,
  busy,
  offline,
  undefined;

  static AvailabilityStatus fromName(dynamic name) {
    if (isNullOrEmpty(name)) return AvailabilityStatus.undefined;
    return AvailabilityStatus.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        AvailabilityStatus.undefined;
  }
}

enum ConversationStatus implements Comparable<ConversationStatus> {
  open,
  resolved,
  pending,
  snoozed,
  all;

  String get label {
    switch (this) {
      case ConversationStatus.open:
        return t.open;
      case ConversationStatus.resolved:
        return t.resolved;
      case ConversationStatus.pending:
        return t.pending;
      case ConversationStatus.snoozed:
        return t.snoozed;
      case ConversationStatus.all:
        return t.all;
    }
  }

  IconData get icon {
    switch (this) {
      case ConversationStatus.open:
        return Icons.cached_outlined;
      case ConversationStatus.resolved:
        return Icons.task_alt_outlined;
      case ConversationStatus.pending:
        return Icons.pending_outlined;
      case ConversationStatus.snoozed:
        return Icons.notifications_off_outlined;
      default:
        return Icons.abc;
    }
  }

  Color get color {
    switch (this) {
      case ConversationStatus.open:
        return Get.context!.theme.colorScheme.surfaceContainer;
      case ConversationStatus.resolved:
        return Get.context!.theme.colorScheme.primaryContainer;
      case ConversationStatus.pending:
        return Get.context!.theme.colorScheme.tertiaryContainer;
      case ConversationStatus.snoozed:
        return Get.context!.theme.colorScheme.secondaryContainer;
      case ConversationStatus.all:
        return Color(0xff858585);
    }
  }

  Color get outlineColor {
    switch (this) {
      case ConversationStatus.open:
        return Get.context!.theme.colorScheme.outlineVariant;
      case ConversationStatus.resolved:
        return Get.context!.theme.colorScheme.primary;
      case ConversationStatus.pending:
        return Get.context!.theme.colorScheme.tertiary;
      case ConversationStatus.snoozed:
        return Get.context!.theme.colorScheme.secondary;
      case ConversationStatus.all:
        return Color(0xff858585);
    }
  }

  @override
  int compareTo(ConversationStatus other) => index - other.index;
}

enum ConversationPriority { undefined, urgent, high, medium, low, none }

enum ConversationPermission {
  administrator,
  agent,
  conversation_manage,
  conversation_unassigned_manage,
  conversation_participating_manage,
  undefined;

  static ConversationPermission fromName(dynamic name) {
    if (isNullOrEmpty(name)) return ConversationPermission.undefined;
    return ConversationPermission.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        ConversationPermission.undefined;
  }
}

enum ConversationSortType implements Comparable<ConversationSortType> {
  last_activity_at_desc(),
  last_activity_at_asc(),
  created_at_desc(),
  created_at_asc(),
  priority_desc(),
  priority_asc(),
  waiting_since_desc(),
  waiting_since_asc();

  String get label {
    switch (this) {
      case ConversationSortType.last_activity_at_asc:
        return t.last_activity_at_asc;
      case ConversationSortType.last_activity_at_desc:
        return t.last_activity_at_desc;
      case ConversationSortType.created_at_desc:
        return t.created_at_desc;
      case ConversationSortType.created_at_asc:
        return t.created_at_asc;
      case ConversationSortType.waiting_since_desc:
        return t.waiting_since_desc;
      case ConversationSortType.waiting_since_asc:
        return t.waiting_since_asc;
      case ConversationSortType.priority_desc:
        return t.priority_desc;
      case ConversationSortType.priority_asc:
        return t.priority_asc;
    }
  }

  @override
  int compareTo(ConversationSortType other) => index - other.index;
}

enum AssigneeType implements Comparable<AssigneeType> {
  mine(name: 'me'),
  unassigned(name: 'unassigned'),
  all(name: 'all');

  final String name;

  String get label {
    switch (this) {
      case AssigneeType.mine:
        return t.mine;
      case AssigneeType.unassigned:
        return t.unassigned;
      case AssigneeType.all:
        return t.all;
    }
  }

  const AssigneeType({required this.name});

  @override
  int compareTo(AssigneeType other) => index - other.index;
}

enum MessageType { incoming, outgoing, activity, template }

enum MessageStatus {
  failed,
  sent,
  progress,
  delivered,
  read,
  undefined;

  static MessageStatus fromName(dynamic name) {
    if (isNullOrEmpty(name)) return MessageStatus.undefined;
    return MessageStatus.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        MessageStatus.undefined;
  }
}

enum MessageContentType {
  text,
  input_email,
  undefined;

  static MessageContentType fromName(dynamic name) {
    if (isNullOrEmpty(name)) return MessageContentType.undefined;
    return MessageContentType.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        MessageContentType.undefined;
  }
}

enum UserType {
  contact,
  user,
  agent_bot,
  undefined;

  static UserType fromName(dynamic name) {
    if (isNullOrEmpty(name)) return UserType.undefined;
    return UserType.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        UserType.undefined;
  }
}

enum MessageVariant {
  date,
  user,
  agent,
  activity,
  private,
  bot,
  error,
  template,
  email,
  unsupported,
  undefined;

  static MessageVariant fromName(dynamic name) {
    if (isNullOrEmpty(name)) return MessageVariant.undefined;
    return MessageVariant.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        MessageVariant.undefined;
  }
}

enum Language implements Comparable<Language> {
  en(label: 'English', labelLocalized: 'English'),
  vi(label: 'Vietnamese', labelLocalized: 'Tiếng Việt');

  final String label;
  final String labelLocalized;

  Locale get locale => Locale(name);

  const Language({
    required this.label,
    required this.labelLocalized,
  });

  @override
  int compareTo(Language other) => index - other.index;
}

enum InboxChannelType implements Comparable<InboxChannelType> {
  web(value: 'Channel::WebWidget'),
  fb(value: 'Channel::FacebookPage', iconName: 'fb.png'),
  twitter(value: 'Channel::TwitterProfile', iconName: 'twitter.png'),
  twilio(value: 'Channel::TwilioSms'),
  whatsapp(value: 'Channel::Whatsapp', iconName: 'whatsapp.png'),
  api(value: 'Channel::Api'),
  email(value: 'Channel::WebWidget', iconName: 'email.png'),
  telegram(value: 'Channel::Telegram', iconName: 'telegram.png'),
  line(value: 'Channel::Line', iconName: 'line.png'),
  sms(value: 'Channel::Sms', iconName: 'sms.png'),
  undefined(value: '', iconData: Icons.question_mark_outlined);

  final String value;
  final String? iconPath;
  final IconData? iconData;

  const InboxChannelType({
    required this.value,
    String? iconName,
    this.iconData,
  }) : iconPath = iconName != null ? 'assets/images/icons/$iconName' : null;

  Widget get icon {
    if (isNotNullOrEmpty(iconPath)) {
      return Image.asset(iconPath!);
    } else if (iconData != null) {
      return CircleAvatar(child: Icon(iconData));
    }
    return CircleAvatar(child: Icon(Icons.inbox_outlined));
  }

  // TODO: make this completed
  String get label {
    switch (this) {
      case InboxChannelType.telegram:
        return 'Telegram';
      default:
        return name;
    }
  }

  @override
  int compareTo(InboxChannelType other) => index - other.index;

  static InboxChannelType fromName(dynamic name) {
    if (isNullOrEmpty(name)) return InboxChannelType.undefined;
    return InboxChannelType.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        InboxChannelType.undefined;
  }
}

enum NotificationType implements Comparable<NotificationType> {
  conversation_creation,
  conversation_assignment,
  assigned_conversation_new_message,
  conversation_mention,
  participating_conversation_new_message,
  sla_missed_first_response,
  sla_missed_next_response,
  sla_missed_resolution,
  undefined;

  String get content {
    switch (this) {
      case NotificationType.conversation_creation:
        return t.notification_content_conversation_creation;
      case NotificationType.conversation_assignment:
        return t.notification_content_conversation_assignment;
      case NotificationType.assigned_conversation_new_message:
        return t.notification_content_assigned_conversation_new_message;
      case NotificationType.conversation_mention:
        return t.notification_content_conversation_mention;
      case NotificationType.participating_conversation_new_message:
        return t.notification_content_participating_conversation_new_message;
      default:
        return 'unhandled $this';
    }
  }

  @override
  int compareTo(NotificationType other) => index - other.index;

  static NotificationType fromName(dynamic name) {
    if (isNullOrEmpty(name)) return NotificationType.undefined;
    return NotificationType.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        NotificationType.undefined;
  }
}

enum NotificationActorType {
  conversation,
  undefined;

  static NotificationActorType fromName(dynamic name) {
    if (isNullOrEmpty(name)) return NotificationActorType.undefined;
    return NotificationActorType.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        NotificationActorType.undefined;
  }
}

enum NotificationStatus {
  snoozed,
  read,
  undefined;

  static NotificationStatus fromName(dynamic name) {
    if (isNullOrEmpty(name)) return NotificationStatus.undefined;
    return NotificationStatus.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        NotificationStatus.undefined;
  }
}

enum AttachmentType implements Comparable<AttachmentType> {
  image,
  audio,
  video,
  file,
  location,
  fallback,
  share,
  story_mention,
  contact,
  ig_reel,
  undefined;

  String get label {
    switch (this) {
      case AttachmentType.image:
        return t.attachment_image_content;
      case AttachmentType.audio:
        return t.attachment_audio_content;
      case AttachmentType.video:
        return t.attachment_video_content;
      case AttachmentType.file:
        return t.attachment_file_content;
      case AttachmentType.location:
        return t.attachment_location_content;
      default:
        return t.attachment_fallback_content;
    }
  }

  @override
  int compareTo(AttachmentType other) => index - other.index;

  static AttachmentType fromName(dynamic name) {
    if (isNullOrEmpty(name)) return AttachmentType.undefined;
    return AttachmentType.values
            .firstWhereOrNull((e) => e.name == name.toString().toLowerCase()) ??
        AttachmentType.undefined;
  }
}

enum AttributeModel implements Comparable<AttributeModel> {
  conversation_attribute,
  contact_attribute;

  String get label {
    switch (this) {
      case AttributeModel.conversation_attribute:
        return t.conversation;
      case AttributeModel.contact_attribute:
        return t.contact;
    }
  }

  @override
  int compareTo(AttributeModel other) => index - other.index;
}

enum ContactSortBy implements Comparable<ContactSortBy> {
  name(),
  email(),
  phone_number(),
  company_name(),
  country(),
  city(),
  last_activity_at(),
  created_at();

  String get label {
    switch (this) {
      case ContactSortBy.name:
        return t.name;
      case ContactSortBy.email:
        return t.email;
      case ContactSortBy.phone_number:
        return t.phone_number;
      case ContactSortBy.company_name:
        return t.company;
      case ContactSortBy.country:
        return t.country;
      case ContactSortBy.city:
        return t.city;
      case ContactSortBy.last_activity_at:
        return t.last_activity_at;
      case ContactSortBy.created_at:
        return t.created_at;
    }
  }

  @override
  int compareTo(ContactSortBy other) => index - other.index;
}

enum OrderBy implements Comparable<OrderBy> {
  ascending(value: ''),
  descending(value: '-');

  final String value;

  const OrderBy({required this.value});

  String get label {
    switch (this) {
      case OrderBy.ascending:
        return t.ascending;
      case OrderBy.descending:
        return t.descending;
    }
  }

  @override
  int compareTo(OrderBy other) => index - other.index;
}

enum ThemeMode implements Comparable<ThemeMode> {
  auto(),
  light(),
  dark();

  String get label {
    switch (this) {
      case ThemeMode.auto:
        return t.appearance_mode_auto;
      case ThemeMode.light:
        return t.appearance_mode_light;
      case ThemeMode.dark:
        return t.appearance_mode_dark;
    }
  }

  material.ThemeMode get buitin {
    return material.ThemeMode.values[index];
  }

  @override
  int compareTo(ThemeMode other) => index - other.index;
}

enum MacroVisibility implements Comparable<MacroVisibility> {
  global,
  personal;

  String get label {
    switch (this) {
      case MacroVisibility.global:
        return t.macro_visibility_global;
      case MacroVisibility.personal:
        return t.macro_visibility_personal;
    }
  }

  @override
  int compareTo(MacroVisibility other) => index - other.index;
}
