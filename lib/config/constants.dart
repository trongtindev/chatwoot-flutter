import '/imports.dart';
import 'package:flutter/material.dart' as material;

enum AccountStatus { active }

enum UserRole { administrator, agent }

enum ProfileType { SuperAdmin }

enum AvailabilityStatus { online, busy, offline }

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

enum MessageStatus { failed, sent, progress, delivered, read }

enum MessageContentType { text, input_email }

enum MessageSenderType { none, contact, user, agent_bot }

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
  unsupported
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
  sms(value: 'Channel::Sms', iconName: 'sms.png');

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
      return Icon(iconData);
    }
    return Icon(Icons.inbox_outlined);
  }

  @override
  int compareTo(InboxChannelType other) => index - other.index;
}

enum NotificationType {
  conversation_creation,
  conversation_assignment,
  assigned_conversation_new_message,
  conversation_mention,
  participating_conversation_new_message,
  sla_missed_first_response,
  sla_missed_next_response,
  sla_missed_resolution
}

enum NotificationActorType { Conversation }

enum NotificationStatus { snoozed, read }

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
  ig_reel;

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
        return t.company_name;
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
