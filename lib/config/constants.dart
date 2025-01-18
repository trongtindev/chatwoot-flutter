import '/imports.dart';

enum UserType { user }

enum ProfileRole { administrator }

enum ProfileType { SuperAdmin }

enum AvailabilityStatus { online, busy, offline }

enum ConversationStatus { open, resolved, pending, snoozed, all }

enum ConversationPriority { undefined, urgent, high, medium, low, none }

enum ConversationPermission {
  administrator,
  agent,
  conversation_manage,
  conversation_unassigned_manage,
  conversation_participating_manage,
}

enum SortType { latest, sort_on_created_at, sort_on_priority }

enum AssigneeType { mine, unassigned, all }

enum MessageType { incoming, outgoing, activity, template }

enum MessageStatus { failed, sent, progress, delivered, read }

enum MessageContentType { text }

enum MessageSenderType { Contact, User, agent_bot }

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

enum InboxType implements Comparable<InboxType> {
  web(value: 'Channel::WebWidget'),
  fb(value: 'Channel::FacebookPage'),
  twitter(value: 'Channel::TwitterProfile'),
  twilio(value: 'Channel::TwilioSms'),
  whatsapp(value: 'Channel::Whatsapp'),
  api(value: 'Channel::Api'),
  email(value: 'Channel::WebWidget'),
  telegram(value: 'Channel::Telegram'),
  line(value: 'Channel::Line'),
  sms(value: 'Channel::Sms');

  final String value;

  const InboxType({
    required this.value,
  });

  @override
  int compareTo(InboxType other) => index - other.index;
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

enum NotificationStatus { snoozed, read }

enum AttachmentType {
  image,
  audio,
  video,
  file,
  location,
  fallback,
  share,
  story_mention,
  contact,
  ig_reel
}
