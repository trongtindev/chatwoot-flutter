import '/imports.dart';

// class UISettings {
//   bool rtl_view;
//   bool is_macro_open;
//   InboxFilterBy inbox_filter_by;
//   String notification_tone;
//   String enable_audio_alerts;
//   bool is_conv_actions_open;
//   bool is_conv_details_open;
//   bool is_previous_conv_open;
//   bool is_contact_sidebar_open;
//   bool is_contact_attributes_open;
//   bool is_open_ai_cta_modal_dismissed;
//   bool channel_webwidget_signature_enabled;
// }

class ProfileInfo {
  final String access_token;
  final int account_id;
  final String available_name;
  final String avatar_url;
  final bool confirmed;
  final String display_name;
  final String? message_signature;
  final String email;
  final int id;
  final dynamic inviter_id; // TODO: unk type
  final String name;
  final String provider;
  final String pubsub_token;
  final UserRole role; // administrator
  // final UISettings ui_settings;
  final String uid;
  final ProfileType? type;
  final List<AccountInfo> accounts;

  const ProfileInfo({
    required this.access_token,
    required this.account_id,
    required this.available_name,
    required this.avatar_url,
    required this.confirmed,
    required this.display_name,
    this.message_signature,
    required this.email,
    required this.id,
    required this.inviter_id,
    required this.name,
    required this.provider,
    required this.pubsub_token,
    required this.role,
    required this.uid,
    this.type,
    required this.accounts,
  });

  factory ProfileInfo.fromJson(dynamic json) {
    final List<dynamic> accounts = json['accounts'];

    return ProfileInfo(
      access_token: json['access_token'],
      account_id: json['account_id'],
      available_name: json['available_name'],
      avatar_url: json['avatar_url'],
      confirmed: json['confirmed'],
      display_name: json['display_name'] ?? json['name'],
      message_signature: json['message_signature'],
      email: json['email'],
      id: json['id'],
      inviter_id: json['inviter_id'],
      name: json['name'],
      provider: json['provider'],
      pubsub_token: json['pubsub_token'],
      role: UserRole.fromName(json['role']),
      uid: json['uid'],
      type: ProfileType.fromName(json['type']),
      accounts: accounts.map(AccountInfo.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': access_token,
      'account_id': account_id,
      'available_name': available_name,
      'avatar_url': avatar_url,
      'confirmed': confirmed,
      'display_name': display_name,
      'message_signature': message_signature,
      'email': email,
      'id': id,
      'inviter_id': inviter_id,
      'name': name,
      'provider': provider,
      'pubsub_token': pubsub_token,
      'role': role.name,
      'uid': uid,
      'type': type?.name,
      'accounts': accounts.map((e) => e.toJson()).toList(),
    };
  }
}
