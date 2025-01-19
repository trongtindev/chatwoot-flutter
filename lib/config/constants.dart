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

enum InboxType implements Comparable<InboxType> {
  web(value: 'Channel::WebWidget', icon: 'web.png'),
  fb(value: 'Channel::FacebookPage', icon: 'fb.png'),
  twitter(value: 'Channel::TwitterProfile', icon: 'twitter.png'),
  twilio(value: 'Channel::TwilioSms', icon: 'twilio.png'),
  whatsapp(value: 'Channel::Whatsapp', icon: 'whatsapp.png'),
  api(value: 'Channel::Api', icon: 'api.png'),
  email(value: 'Channel::WebWidget', icon: 'email.png'),
  telegram(value: 'Channel::Telegram', icon: 'telegram.png'),
  line(value: 'Channel::Line', icon: 'line.png'),
  sms(value: 'Channel::Sms', icon: 'sms.png');

  final String value;
  final String icon;

  const InboxType({
    required this.value,
    required String icon,
  }) : icon = 'assets/images/icons/$icon';

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

enum NotificationActorType { Conversation }

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

enum AttributeModel { contact_attribute }

enum ContactSortBy implements Comparable<ContactSortBy> {
  name(labelLocalized: 'contact.name'),
  email(labelLocalized: 'contact.email'),
  phone_number(labelLocalized: 'contact.phone_number'),
  company_name(labelLocalized: 'contact.company_name'),
  country(labelLocalized: 'contact.country'),
  city(labelLocalized: 'contact.city'),
  last_activity_at(labelLocalized: 'contact.last_activity_at'),
  created_at(labelLocalized: 'contact.created_at');

  final String labelLocalized;

  const ContactSortBy({
    required this.labelLocalized,
  });

  @override
  int compareTo(ContactSortBy other) => index - other.index;
}

enum OrderBy implements Comparable<OrderBy> {
  ascending(value: '', labelLocalized: 'common.ascending'),
  descending(value: '-', labelLocalized: 'contact.descending');

  final String value;
  final String labelLocalized;

  const OrderBy({
    required this.value,
    required this.labelLocalized,
  });

  @override
  int compareTo(OrderBy other) => index - other.index;
}
