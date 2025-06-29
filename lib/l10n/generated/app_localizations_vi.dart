// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get save_changes => 'Save changes';

  @override
  String get profile => 'Profile';

  @override
  String get upload => 'Upload';

  @override
  String get phone_number => 'Phone number';

  @override
  String get company => 'Company name';

  @override
  String get company_hint => 'Enter the company name';

  @override
  String get company_invalid => 'company_invalid';

  @override
  String get country => 'country';

  @override
  String get city => 'City';

  @override
  String get city_hint => 'city_hint';

  @override
  String get last_activity_at => 'Last activity';

  @override
  String get created_at => 'Created at';

  @override
  String get name => 'Name';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get sort_by => 'Sort by';

  @override
  String get order_by => 'Order by';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get typing => 'Typing';

  @override
  String get view_details => 'View details';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get email => 'Email';

  @override
  String get email_hint => 'Enter your email';

  @override
  String get email_invalid => 'Enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get password_hint => 'Enter your password';

  @override
  String get password_invalid => 'Enter a valid password';

  @override
  String get quit => 'Quit';

  @override
  String get error => 'Error';

  @override
  String get error_not_found => 'Resource not found, please try again.';

  @override
  String error_response(String contentTypes) {
    return 'Failed to parse response from server, please try again. $contentTypes';
  }

  @override
  String get error_fetching =>
      'There was an error fetching the information, please try again.';

  @override
  String get error_no_connection =>
      'You must connect to Wi-fi or a cellular network to get online again.';

  @override
  String get error_no_accounts =>
      'You don\'t have access to any chatwoot accounts';

  @override
  String error_message(String reason) {
    return 'Oops, something went wrong. Please try again later. $reason';
  }

  @override
  String get exception => 'Exception';

  @override
  String exception_message(String reason) {
    return 'Oops, something went wrong. Please try again later. $reason';
  }

  @override
  String get conversation => 'Conversation';

  @override
  String get conversation_id => 'Conversation ID';

  @override
  String get conversations => 'Conversations';

  @override
  String get conversation_empty_title => 'No conversations yet!';

  @override
  String get conversation_empty_description =>
      'Once you start receiving conversations, they\'ll appear here.';

  @override
  String get conversation_unassign => 'Unassign conversation';

  @override
  String get conversation_self_assign => 'Assign to me';

  @override
  String get conversation_change_status => 'Change status';

  @override
  String conversation_change_status_message(String from, String to) {
    return 'Are you sure you want to change status from $from to $to?';
  }

  @override
  String get contact => 'Contact';

  @override
  String get contacts => 'Contacts';

  @override
  String get contacts_empty_title => 'No contacts found in this account';

  @override
  String get contacts_empty_description =>
      'Start adding new contacts by clicking on the button below';

  @override
  String get contacts_add => 'Add contact';

  @override
  String get contacts_editor_title => 'Contact details';

  @override
  String get settings => 'Settings';

  @override
  String get settings_notification => 'Notification';

  @override
  String get login_title => 'Log in to your account';

  @override
  String login_description(String base_url) {
    return 'You are connected to $base_url.';
  }

  @override
  String get login_submit => 'Sign In';

  @override
  String get forgot_password => 'Forgot your password?';

  @override
  String get forgot_password_title => 'Reset password';

  @override
  String forgot_password_description(String baseUrl) {
    return 'Enter the email address you use to log in to $baseUrl to get the password reset instructions.';
  }

  @override
  String get forgot_password_submit => 'Reset password';

  @override
  String get change_url => 'Change URL';

  @override
  String get change_url_title => 'Installation URL';

  @override
  String change_url_description(String url) {
    return 'If you are using a self-hosted Chatwoot installation, input your server URL. Otherwise, use $url.';
  }

  @override
  String get change_url_url => 'URL';

  @override
  String get change_url_url_hint => 'Enter your URL without http';

  @override
  String get change_url_url_invalid => 'Enter a valid URL';

  @override
  String get change_url_submit => 'Verify';

  @override
  String get change_language => 'Change language';

  @override
  String get message_hint => 'Type message...';

  @override
  String get message_private_hint => 'Only visible to Agents';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearance_mode => 'Mode';

  @override
  String get appearance_mode_auto => 'Auto';

  @override
  String get appearance_mode_dark => 'Dark';

  @override
  String get appearance_mode_light => 'Light';

  @override
  String get appearance_colours => 'Colours';

  @override
  String get appearance_colours_subtitle => 'appearance_colours_subtitle';

  @override
  String get appearance_color => 'Color';

  @override
  String get display_name => 'Display name';

  @override
  String get display_name_hint => 'display_name_hint';

  @override
  String get display_name_invalid => 'display_name_invalid';

  @override
  String get integrations => 'Integrations';

  @override
  String get canned_response => 'Canned Response';

  @override
  String get canned_responses => 'Canned Responses';

  @override
  String get canned_responses_description =>
      'Canned Responses are pre-written reply templates that help you quickly respond to a conversation. Agents can type the \'/\' character followed by the shortcode to insert a canned response during a conversation.';

  @override
  String get canned_response_add => 'Add canned response';

  @override
  String get macros => 'Macros';

  @override
  String get macros_add => 'Add macro';

  @override
  String macro_execute_confirm_message(String name) {
    return 'Are you sure you want to execute macro $name?';
  }

  @override
  String get automation => 'Automation';

  @override
  String get inboxes => 'Inboxes';

  @override
  String get inboxes_title => 'Inboxes';

  @override
  String get inboxes_description =>
      'A channel is the mode of communication your customer chooses to interact with you. An inbox is where you manage interactions for a specific channel. It can include communications from various sources such as email, live chat, and social media.';

  @override
  String get inboxes_add => 'Add inbox';

  @override
  String get agent => 'Agent';

  @override
  String get agents => 'Agents';

  @override
  String get agents_title => 'Agents';

  @override
  String get agents_description =>
      'An agent is a member of your customer support team who can view and respond to user messages. The list below shows all the agents in your account.';

  @override
  String get agents_add => 'Add agent';

  @override
  String get agents_search => 'Search agents';

  @override
  String get agents_search_hint => 'Type something';

  @override
  String get account => 'Account';

  @override
  String get change_password => 'Change password';

  @override
  String get change_password_invalid =>
      'Please enter a password of length 6 or more';

  @override
  String get change_password_current => 'Current password';

  @override
  String get change_password_current_hint =>
      'Please enter the current password';

  @override
  String get change_password_new => 'New password';

  @override
  String get change_password_new_hint => 'Please enter a new password';

  @override
  String get change_password_confirm => 'Confirm new password';

  @override
  String get change_password_confirm_hint =>
      'Please re-enter your new password';

  @override
  String get change_password_mismatch =>
      'Confirm password should match the password';

  @override
  String get change_password_successful => 'change_password_successful';

  @override
  String get labels => 'Labels';

  @override
  String get labels_description =>
      'Labels help you categorize and prioritize conversations and leads. You can assign a label to a conversation or contact using the side panel.';

  @override
  String get labels_add => 'Add label';

  @override
  String get labels_editor_title => 'Label title';

  @override
  String get labels_editor_title_hint => 'Enter label title';

  @override
  String get labels_editor_title_invalid => 'Invalid label title';

  @override
  String get labels_editor_description => 'Label description';

  @override
  String get labels_editor_description_hint => 'Enter label description';

  @override
  String get labels_editor_color => 'Color';

  @override
  String get labels_editor_color_hint => 'Enter color code (e.g., #000000)';

  @override
  String get labels_editor_color_invalid => 'Invalid color code';

  @override
  String get labels_editor_show_on_sidebar => 'Show label on sidebar';

  @override
  String get labels_search => 'Search labels';

  @override
  String get labels_search_hint => 'Type something...';

  @override
  String get attributes => 'Attributes';

  @override
  String get custom_attributes => 'Custom Attributes';

  @override
  String get custom_attributes_title => 'Custom Attributes';

  @override
  String get custom_attributes_description =>
      'A custom attribute tracks additional details about your contacts or conversations—such as the subscription plan or the date of their first purchase. You can add different types of custom attributes, such as text, lists, or numbers, to capture the specific information you need.';

  @override
  String get custom_attributes_add => 'Add Custom Attributes';

  @override
  String get audit_logs => 'Audit Logs';

  @override
  String get audit_logs_title => 'Audit Logs';

  @override
  String get audit_logs_description =>
      'Audit Logs maintain a record of activities in your account, allowing you to track and audit your account, team, or services.';

  @override
  String get set_availability => 'Set availability';

  @override
  String get read_docs => 'Read docs';

  @override
  String get edit => 'Edit';

  @override
  String get team => 'Team';

  @override
  String get teams => 'Nhóm';

  @override
  String get teams_title => 'Teams';

  @override
  String get teams_description =>
      'Teams allow you to organize agents into groups based on their responsibilities. An agent can belong to multiple teams. When working collaboratively, you can assign conversations to specific teams.';

  @override
  String get teams_add => 'Add team';

  @override
  String get permission_denied => 'Permission denied';

  @override
  String permission_denied_message(String name) {
    return 'permission_denied_message $name.';
  }

  @override
  String get permission_request => 'Permission requested';

  @override
  String permission_request_message(String name) {
    return 'You need allow permission $name to use this feature.';
  }

  @override
  String get open_settings => 'Open settings';

  @override
  String get attachment_image_content => 'Picture message';

  @override
  String get attachment_audio_content => 'Audio message';

  @override
  String get attachment_video_content => 'Video message';

  @override
  String get attachment_file_content => 'File Attachment';

  @override
  String get attachment_files_content => 'File Attachments';

  @override
  String get attachment_location_content => 'Location';

  @override
  String get attachment_fallback_content => 'has shared a url';

  @override
  String get attachment_exceeds_limit =>
      'File exceeds the 5MB attachment limit';

  @override
  String get status => 'Status';

  @override
  String get assign => 'Assign';

  @override
  String get priority => 'Priority';

  @override
  String get none => 'None';

  @override
  String get no_results => 'No results found';

  @override
  String get copy => 'Copy';

  @override
  String get reply => 'Reply';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get all_inboxes => 'All inboxes';

  @override
  String get notifications => 'Notifications';

  @override
  String get notification_empty_title => 'No notifications yet.';

  @override
  String get notification_empty_description =>
      'Once you start receiving notifications, they\'ll appear here.';

  @override
  String get notification_no_more => 'All notifications loaded';

  @override
  String get notification_mark_all_read => 'Mark all as read';

  @override
  String get notification_type => 'Notification type';

  @override
  String get notification_push => 'Push Notification';

  @override
  String get notification_create_push => 'A new conversation is created';

  @override
  String get notification_assignee_push => 'A conversation is assigned to you';

  @override
  String get notification_new_message_push =>
      'You are mentioned in a conversation';

  @override
  String get notification_mention_push =>
      'A new message is created in an assigned conversation';

  @override
  String get notification_participating_new_message_push =>
      'A new message is created in a participating conversation';

  @override
  String get notification_content_conversation_creation =>
      'New conversation created';

  @override
  String get notification_content_conversation_assignment =>
      'A conversation has been assigned to you';

  @override
  String get notification_content_assigned_conversation_new_message =>
      'New message in an assigned conversation';

  @override
  String get notification_content_conversation_mention =>
      'You have been mentioned in a conversation';

  @override
  String get notification_content_participating_conversation_new_message =>
      'New message in a conversation you are participating in';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get oldest => 'Oldest';

  @override
  String get newest => 'Newest';

  @override
  String get filter => 'Filter';

  @override
  String get filter_by_assignee_type => 'Filter by assignee type';

  @override
  String get filter_by_status => 'Filter by status';

  @override
  String get filter_by_inbox => 'Filter by inbox';

  @override
  String get all => 'All';

  @override
  String get mine => 'Mine';

  @override
  String get open => 'Open';

  @override
  String get resolved => 'Resolved';

  @override
  String get pending => 'Pending';

  @override
  String get snoozed => 'Snoozed';

  @override
  String get latest => 'Latest';

  @override
  String get sort_on_created_at => 'Created at';

  @override
  String get sort_on_priority => 'Priority';

  @override
  String get no_more => 'That\'s all!';

  @override
  String get last_activity_at_asc => 'Last activity: Oldest first';

  @override
  String get last_activity_at_desc => 'Last activity: Newest first';

  @override
  String get created_at_desc => 'Created at: Newest first';

  @override
  String get created_at_asc => 'Created at: Oldest first';

  @override
  String get priority_desc => 'Priority: Highest first';

  @override
  String get priority_asc => 'Priority: Lowest first';

  @override
  String get waiting_since_asc => 'Pending Response: Longest first';

  @override
  String get waiting_since_desc => 'Pending Response: Shortest first';

  @override
  String get campaigns_live_chat_empty_title =>
      'No live chat campaigns are available';

  @override
  String get campaigns_live_chat_empty_description =>
      'Connect with your customers using proactive messages. Click \'Create campaign\' to get started.';

  @override
  String get campaigns_sms_empty_title => 'No SMS campaigns are available';

  @override
  String get campaigns_sms_empty_description =>
      'Launch an SMS campaign to reach your customers directly. Send offers or make announcements with ease. Click \'Create campaign\' to get started.';

  @override
  String get macros_title => 'Macros';

  @override
  String get macros_description =>
      'A macro is a set of saved actions that help customer service agents easily complete tasks. The agents can define a set of actions like tagging a conversation with a label, sending an email transcript, updating a custom attribute, etc., and they can run these actions in a single click.';

  @override
  String get macro_visibility_global => 'Public';

  @override
  String get macro_visibility_global_description => 'Public';

  @override
  String get macro_visibility_personal =>
      'This macro is available publicly for all agents in this account.';

  @override
  String get macro_visibility_personal_description =>
      'This macro will be private to you and not be available to others.';

  @override
  String get understand => 'Understand';

  @override
  String get confirm_delete => 'Confirm delete';

  @override
  String confirm_delete_message(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get logout => 'Log out';

  @override
  String get logout_confirm => 'Are you sure you want to do logout?';

  @override
  String get confirm => 'Confirm';

  @override
  String get server_upgrade_required => 'Server upgrade required';

  @override
  String get server_upgrade_required_agent_message =>
      'It seems like you are using unsupported Chatwoot server for your mobile app. Please contact your admin to upgrade your Chatwoot server.';

  @override
  String server_upgrade_required_admin_message(String minimum_version) {
    return 'It seems like you are using unsupported Chatwoot server for your mobile app. Upgrading to server version %$minimum_version or later is required.';
  }

  @override
  String get snooze_until => 'Snooze until';

  @override
  String get private => 'Private';

  @override
  String get tap_to_record => 'Tap to record';

  @override
  String get successful => 'Successful';

  @override
  String get participants => 'Participants';

  @override
  String get participants_add => 'Add participant';

  @override
  String get initiated_at => 'Initiated at';

  @override
  String get initiated_from => 'Initiated from';

  @override
  String get browser => 'Browser';

  @override
  String get operating_system => 'Operating system';

  @override
  String get add => 'Add';

  @override
  String get modify => 'Modify';

  @override
  String get assignee => 'Assignee';

  @override
  String get actions => 'Actions';

  @override
  String get location => 'Location';

  @override
  String get phone => 'Phone';

  @override
  String get call => 'Call';

  @override
  String get message => 'Message';

  @override
  String get mark_auto_offline => 'Mark offline automatically';

  @override
  String get translate => 'Translate';

  @override
  String get full_name => 'Full name';

  @override
  String get full_name_hint => 'Enter the full name';

  @override
  String get full_name_invalid => 'full_name_invalid';

  @override
  String get first_name => 'First name';

  @override
  String get first_name_hint => 'Enter the first name';

  @override
  String get first_name_invalid => 'first_name_invalid';

  @override
  String get last_name => 'Last name';

  @override
  String get last_name_hint => 'Enter the last name';

  @override
  String get last_name_invalid => 'last_name_invalid';

  @override
  String get bio => 'Enter the bio';

  @override
  String get bio_hint => 'bio_hint';

  @override
  String get bio_invalid => 'bio_hint_invalid';

  @override
  String get search => 'Search';

  @override
  String get search_hint => 'Type something...';
}
