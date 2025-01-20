import '/imports.dart';

class InboxInfo {
  final int id;
  final String avatar_url;
  final int channel_id;
  final String name;
  final InboxChannelType channel_type;
  final bool greeting_enabled;
  final String greeting_message;
  final bool working_hours_enabled;
  final bool enable_email_collect;
  final bool csat_survey_enabled;
  final bool enable_auto_assignment;
  final dynamic auto_assignment_config; // TODO: unk type
  final String? out_of_office_message;
  final dynamic working_hours; // TODO: unk type
  final String timezone;
  final String? callback_webhook_url;
  final bool allow_messages_after_resolved;
  final bool lock_to_single_conversation;
  final String sender_name_type; // TODO: make enum
  final String? business_name;
  final String? widget_color;
  final String? website_url;
  final bool? hmac_mandatory;
  final String? welcome_title;
  final String? welcome_tagline;
  final String? web_widget_script;
  final String? website_token;
  final dynamic selected_feature_flags; // TODO: make enum
  final dynamic reply_time; // TODO: make enum
  final String? hmac_token;
  final bool? pre_chat_form_enabled;
  final dynamic pre_chat_form_options; // TODO: unk type
  final bool? continuity_via_email;
  final dynamic messaging_service_sid; // TODO: unk type
  final String? phone_number;
  final dynamic provider; // TODO: unk type

  const InboxInfo({
    required this.id,
    required this.avatar_url,
    required this.channel_id,
    required this.name,
    required this.channel_type,
    required this.greeting_enabled,
    required this.greeting_message,
    required this.working_hours_enabled,
    required this.enable_email_collect,
    required this.csat_survey_enabled,
    required this.enable_auto_assignment,
    required this.auto_assignment_config,
    this.out_of_office_message,
    required this.working_hours,
    required this.timezone,
    this.callback_webhook_url,
    required this.allow_messages_after_resolved,
    required this.lock_to_single_conversation,
    required this.sender_name_type,
    this.business_name,
    this.widget_color,
    this.website_url,
    required this.hmac_mandatory,
    this.welcome_title,
    this.welcome_tagline,
    this.web_widget_script,
    this.website_token,
    this.selected_feature_flags,
    this.reply_time,
    this.hmac_token,
    this.pre_chat_form_enabled,
    this.pre_chat_form_options,
    this.continuity_via_email,
    this.messaging_service_sid,
    this.phone_number,
    this.provider,
  });

  factory InboxInfo.fromJson(dynamic json) {
    return InboxInfo(
      id: json['id'],
      avatar_url: json['avatar_url'],
      channel_id: json['channel_id'],
      name: json['name'],
      channel_type: InboxChannelType.values
          .firstWhere((e) => e.value == json['channel_type']),
      greeting_enabled: json['greeting_enabled'],
      greeting_message: json['greeting_message'],
      working_hours_enabled: json['working_hours_enabled'],
      enable_email_collect: json['enable_email_collect'],
      csat_survey_enabled: json['csat_survey_enabled'],
      enable_auto_assignment: json['enable_auto_assignment'],
      auto_assignment_config: json['auto_assignment_config'],
      out_of_office_message: json['out_of_office_message'],
      working_hours: json['working_hours'],
      timezone: json['timezone'],
      callback_webhook_url: json['callback_webhook_url'],
      allow_messages_after_resolved: json['allow_messages_after_resolved'],
      lock_to_single_conversation: json['lock_to_single_conversation'],
      sender_name_type: json['sender_name_type'],
      business_name: json['business_name'],
      widget_color: json['widget_color'],
      website_url: json['website_url'],
      hmac_mandatory: json['hmac_mandatory'],
      welcome_title: json['welcome_title'],
      welcome_tagline: json['welcome_tagline'],
      web_widget_script: json['web_widget_script'],
      website_token: json['website_token'],
      selected_feature_flags: json['selected_feature_flags'],
      reply_time: json['reply_time'],
      hmac_token: json['hmac_token'],
      pre_chat_form_enabled: json['pre_chat_form_enabled'],
      pre_chat_form_options: json['pre_chat_form_options'],
      continuity_via_email: json['continuity_via_email'],
      messaging_service_sid: json['messaging_service_sid'],
      phone_number: json['phone_number'],
      provider: json['provider'],
    );
  }
}
