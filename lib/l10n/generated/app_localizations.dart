import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save_changes;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get company;

  /// No description provided for @company_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the company name'**
  String get company_hint;

  /// No description provided for @company_invalid.
  ///
  /// In en, this message translates to:
  /// **'company_invalid'**
  String get company_invalid;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @city_hint.
  ///
  /// In en, this message translates to:
  /// **'city_hint'**
  String get city_hint;

  /// No description provided for @last_activity_at.
  ///
  /// In en, this message translates to:
  /// **'Last activity'**
  String get last_activity_at;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get created_at;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sort_by;

  /// No description provided for @order_by.
  ///
  /// In en, this message translates to:
  /// **'Order by'**
  String get order_by;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing'**
  String get typing;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get view_details;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get email_hint;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get email_invalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get password_hint;

  /// No description provided for @password_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid password'**
  String get password_invalid;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Resource not found, please try again.'**
  String get error_not_found;

  /// No description provided for @error_response.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse response from server, please try again. {contentTypes}'**
  String error_response(String contentTypes);

  /// No description provided for @error_fetching.
  ///
  /// In en, this message translates to:
  /// **'There was an error fetching the information, please try again.'**
  String get error_fetching;

  /// No description provided for @error_no_connection.
  ///
  /// In en, this message translates to:
  /// **'You must connect to Wi-fi or a cellular network to get online again.'**
  String get error_no_connection;

  /// No description provided for @error_no_accounts.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to any chatwoot accounts'**
  String get error_no_accounts;

  /// No description provided for @error_message.
  ///
  /// In en, this message translates to:
  /// **'Oops, something went wrong. Please try again later. {reason}'**
  String error_message(String reason);

  /// No description provided for @exception.
  ///
  /// In en, this message translates to:
  /// **'Exception'**
  String get exception;

  /// No description provided for @exception_message.
  ///
  /// In en, this message translates to:
  /// **'Oops, something went wrong. Please try again later. {reason}'**
  String exception_message(String reason);

  /// No description provided for @conversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get conversation;

  /// No description provided for @conversation_id.
  ///
  /// In en, this message translates to:
  /// **'Conversation ID'**
  String get conversation_id;

  /// No description provided for @conversations.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get conversations;

  /// No description provided for @conversation_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet!'**
  String get conversation_empty_title;

  /// No description provided for @conversation_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Once you start receiving conversations, they\'ll appear here.'**
  String get conversation_empty_description;

  /// No description provided for @conversation_unassign.
  ///
  /// In en, this message translates to:
  /// **'Unassign conversation'**
  String get conversation_unassign;

  /// No description provided for @conversation_self_assign.
  ///
  /// In en, this message translates to:
  /// **'Assign to me'**
  String get conversation_self_assign;

  /// No description provided for @conversation_change_status.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get conversation_change_status;

  /// No description provided for @conversation_change_status_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change status from {from} to {to}?'**
  String conversation_change_status_message(String from, String to);

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contacts_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No contacts found in this account'**
  String get contacts_empty_title;

  /// No description provided for @contacts_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Start adding new contacts by clicking on the button below'**
  String get contacts_empty_description;

  /// No description provided for @contacts_add.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get contacts_add;

  /// No description provided for @contacts_editor_title.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get contacts_editor_title;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settings_notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get settings_notification;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get login_title;

  /// No description provided for @login_description.
  ///
  /// In en, this message translates to:
  /// **'You are connected to {base_url}.'**
  String login_description(String base_url);

  /// No description provided for @login_submit.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login_submit;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_password;

  /// No description provided for @forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgot_password_title;

  /// No description provided for @forgot_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address you use to log in to {baseUrl} to get the password reset instructions.'**
  String forgot_password_description(String baseUrl);

  /// No description provided for @forgot_password_submit.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgot_password_submit;

  /// No description provided for @change_url.
  ///
  /// In en, this message translates to:
  /// **'Change URL'**
  String get change_url;

  /// No description provided for @change_url_title.
  ///
  /// In en, this message translates to:
  /// **'Installation URL'**
  String get change_url_title;

  /// No description provided for @change_url_description.
  ///
  /// In en, this message translates to:
  /// **'If you are using a self-hosted Chatwoot installation, input your server URL. Otherwise, use {url}.'**
  String change_url_description(String url);

  /// No description provided for @change_url_url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get change_url_url;

  /// No description provided for @change_url_url_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your URL without http'**
  String get change_url_url_hint;

  /// No description provided for @change_url_url_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL'**
  String get change_url_url_invalid;

  /// No description provided for @change_url_submit.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get change_url_submit;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get change_language;

  /// No description provided for @message_hint.
  ///
  /// In en, this message translates to:
  /// **'Type message...'**
  String get message_hint;

  /// No description provided for @message_private_hint.
  ///
  /// In en, this message translates to:
  /// **'Only visible to Agents'**
  String get message_private_hint;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearance_mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get appearance_mode;

  /// No description provided for @appearance_mode_auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get appearance_mode_auto;

  /// No description provided for @appearance_mode_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearance_mode_dark;

  /// No description provided for @appearance_mode_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearance_mode_light;

  /// No description provided for @appearance_colours.
  ///
  /// In en, this message translates to:
  /// **'Colours'**
  String get appearance_colours;

  /// No description provided for @appearance_colours_subtitle.
  ///
  /// In en, this message translates to:
  /// **'appearance_colours_subtitle'**
  String get appearance_colours_subtitle;

  /// No description provided for @appearance_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get appearance_color;

  /// No description provided for @display_name.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get display_name;

  /// No description provided for @display_name_hint.
  ///
  /// In en, this message translates to:
  /// **'display_name_hint'**
  String get display_name_hint;

  /// No description provided for @display_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'display_name_invalid'**
  String get display_name_invalid;

  /// No description provided for @integrations.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get integrations;

  /// No description provided for @canned_response.
  ///
  /// In en, this message translates to:
  /// **'Canned Response'**
  String get canned_response;

  /// No description provided for @canned_responses.
  ///
  /// In en, this message translates to:
  /// **'Canned Responses'**
  String get canned_responses;

  /// No description provided for @canned_responses_description.
  ///
  /// In en, this message translates to:
  /// **'Canned Responses are pre-written reply templates that help you quickly respond to a conversation. Agents can type the \'/\' character followed by the shortcode to insert a canned response during a conversation.'**
  String get canned_responses_description;

  /// No description provided for @canned_response_add.
  ///
  /// In en, this message translates to:
  /// **'Add canned response'**
  String get canned_response_add;

  /// No description provided for @macros.
  ///
  /// In en, this message translates to:
  /// **'Macros'**
  String get macros;

  /// No description provided for @macros_add.
  ///
  /// In en, this message translates to:
  /// **'Add macro'**
  String get macros_add;

  /// No description provided for @macro_execute_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to execute macro {name}?'**
  String macro_execute_confirm_message(String name);

  /// No description provided for @automation.
  ///
  /// In en, this message translates to:
  /// **'Automation'**
  String get automation;

  /// No description provided for @inboxes.
  ///
  /// In en, this message translates to:
  /// **'Inboxes'**
  String get inboxes;

  /// No description provided for @inboxes_title.
  ///
  /// In en, this message translates to:
  /// **'Inboxes'**
  String get inboxes_title;

  /// No description provided for @inboxes_description.
  ///
  /// In en, this message translates to:
  /// **'A channel is the mode of communication your customer chooses to interact with you. An inbox is where you manage interactions for a specific channel. It can include communications from various sources such as email, live chat, and social media.'**
  String get inboxes_description;

  /// No description provided for @inboxes_add.
  ///
  /// In en, this message translates to:
  /// **'Add inbox'**
  String get inboxes_add;

  /// No description provided for @agent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get agent;

  /// No description provided for @agents.
  ///
  /// In en, this message translates to:
  /// **'Agents'**
  String get agents;

  /// No description provided for @agents_title.
  ///
  /// In en, this message translates to:
  /// **'Agents'**
  String get agents_title;

  /// No description provided for @agents_description.
  ///
  /// In en, this message translates to:
  /// **'An agent is a member of your customer support team who can view and respond to user messages. The list below shows all the agents in your account.'**
  String get agents_description;

  /// No description provided for @agents_add.
  ///
  /// In en, this message translates to:
  /// **'Add agent'**
  String get agents_add;

  /// No description provided for @agents_search.
  ///
  /// In en, this message translates to:
  /// **'Search agents'**
  String get agents_search;

  /// No description provided for @agents_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Type something'**
  String get agents_search_hint;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @change_password_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password of length 6 or more'**
  String get change_password_invalid;

  /// No description provided for @change_password_current.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get change_password_current;

  /// No description provided for @change_password_current_hint.
  ///
  /// In en, this message translates to:
  /// **'Please enter the current password'**
  String get change_password_current_hint;

  /// No description provided for @change_password_new.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get change_password_new;

  /// No description provided for @change_password_new_hint.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get change_password_new_hint;

  /// No description provided for @change_password_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get change_password_confirm;

  /// No description provided for @change_password_confirm_hint.
  ///
  /// In en, this message translates to:
  /// **'Please re-enter your new password'**
  String get change_password_confirm_hint;

  /// No description provided for @change_password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Confirm password should match the password'**
  String get change_password_mismatch;

  /// No description provided for @change_password_successful.
  ///
  /// In en, this message translates to:
  /// **'change_password_successful'**
  String get change_password_successful;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// No description provided for @labels_description.
  ///
  /// In en, this message translates to:
  /// **'Labels help you categorize and prioritize conversations and leads. You can assign a label to a conversation or contact using the side panel.'**
  String get labels_description;

  /// No description provided for @labels_add.
  ///
  /// In en, this message translates to:
  /// **'Add label'**
  String get labels_add;

  /// No description provided for @labels_editor_title.
  ///
  /// In en, this message translates to:
  /// **'Label title'**
  String get labels_editor_title;

  /// No description provided for @labels_editor_title_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter label title'**
  String get labels_editor_title_hint;

  /// No description provided for @labels_editor_title_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid label title'**
  String get labels_editor_title_invalid;

  /// No description provided for @labels_editor_description.
  ///
  /// In en, this message translates to:
  /// **'Label description'**
  String get labels_editor_description;

  /// No description provided for @labels_editor_description_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter label description'**
  String get labels_editor_description_hint;

  /// No description provided for @labels_editor_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get labels_editor_color;

  /// No description provided for @labels_editor_color_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter color code (e.g., #000000)'**
  String get labels_editor_color_hint;

  /// No description provided for @labels_editor_color_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid color code'**
  String get labels_editor_color_invalid;

  /// No description provided for @labels_editor_show_on_sidebar.
  ///
  /// In en, this message translates to:
  /// **'Show label on sidebar'**
  String get labels_editor_show_on_sidebar;

  /// No description provided for @labels_search.
  ///
  /// In en, this message translates to:
  /// **'Search labels'**
  String get labels_search;

  /// No description provided for @labels_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Type something...'**
  String get labels_search_hint;

  /// No description provided for @attributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get attributes;

  /// No description provided for @custom_attributes.
  ///
  /// In en, this message translates to:
  /// **'Custom Attributes'**
  String get custom_attributes;

  /// No description provided for @custom_attributes_title.
  ///
  /// In en, this message translates to:
  /// **'Custom Attributes'**
  String get custom_attributes_title;

  /// No description provided for @custom_attributes_description.
  ///
  /// In en, this message translates to:
  /// **'A custom attribute tracks additional details about your contacts or conversations—such as the subscription plan or the date of their first purchase. You can add different types of custom attributes, such as text, lists, or numbers, to capture the specific information you need.'**
  String get custom_attributes_description;

  /// No description provided for @custom_attributes_add.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Attributes'**
  String get custom_attributes_add;

  /// No description provided for @audit_logs.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get audit_logs;

  /// No description provided for @audit_logs_title.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get audit_logs_title;

  /// No description provided for @audit_logs_description.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs maintain a record of activities in your account, allowing you to track and audit your account, team, or services.'**
  String get audit_logs_description;

  /// No description provided for @set_availability.
  ///
  /// In en, this message translates to:
  /// **'Set availability'**
  String get set_availability;

  /// No description provided for @read_docs.
  ///
  /// In en, this message translates to:
  /// **'Read docs'**
  String get read_docs;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @teams_title.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams_title;

  /// No description provided for @teams_description.
  ///
  /// In en, this message translates to:
  /// **'Teams allow you to organize agents into groups based on their responsibilities. An agent can belong to multiple teams. When working collaboratively, you can assign conversations to specific teams.'**
  String get teams_description;

  /// No description provided for @teams_add.
  ///
  /// In en, this message translates to:
  /// **'Add team'**
  String get teams_add;

  /// No description provided for @permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permission_denied;

  /// No description provided for @permission_denied_message.
  ///
  /// In en, this message translates to:
  /// **'permission_denied_message {name}.'**
  String permission_denied_message(String name);

  /// No description provided for @permission_request.
  ///
  /// In en, this message translates to:
  /// **'Permission requested'**
  String get permission_request;

  /// No description provided for @permission_request_message.
  ///
  /// In en, this message translates to:
  /// **'You need allow permission {name} to use this feature.'**
  String permission_request_message(String name);

  /// No description provided for @open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get open_settings;

  /// No description provided for @attachment_image_content.
  ///
  /// In en, this message translates to:
  /// **'Picture message'**
  String get attachment_image_content;

  /// No description provided for @attachment_audio_content.
  ///
  /// In en, this message translates to:
  /// **'Audio message'**
  String get attachment_audio_content;

  /// No description provided for @attachment_video_content.
  ///
  /// In en, this message translates to:
  /// **'Video message'**
  String get attachment_video_content;

  /// No description provided for @attachment_file_content.
  ///
  /// In en, this message translates to:
  /// **'File Attachment'**
  String get attachment_file_content;

  /// No description provided for @attachment_files_content.
  ///
  /// In en, this message translates to:
  /// **'File Attachments'**
  String get attachment_files_content;

  /// No description provided for @attachment_location_content.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get attachment_location_content;

  /// No description provided for @attachment_fallback_content.
  ///
  /// In en, this message translates to:
  /// **'has shared a url'**
  String get attachment_fallback_content;

  /// No description provided for @attachment_exceeds_limit.
  ///
  /// In en, this message translates to:
  /// **'File exceeds the 5MB attachment limit'**
  String get attachment_exceeds_limit;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @no_results.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @all_inboxes.
  ///
  /// In en, this message translates to:
  /// **'All inboxes'**
  String get all_inboxes;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notification_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get notification_empty_title;

  /// No description provided for @notification_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Once you start receiving notifications, they\'ll appear here.'**
  String get notification_empty_description;

  /// No description provided for @notification_no_more.
  ///
  /// In en, this message translates to:
  /// **'All notifications loaded'**
  String get notification_no_more;

  /// No description provided for @notification_mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notification_mark_all_read;

  /// No description provided for @notification_type.
  ///
  /// In en, this message translates to:
  /// **'Notification type'**
  String get notification_type;

  /// No description provided for @notification_push.
  ///
  /// In en, this message translates to:
  /// **'Push Notification'**
  String get notification_push;

  /// No description provided for @notification_create_push.
  ///
  /// In en, this message translates to:
  /// **'A new conversation is created'**
  String get notification_create_push;

  /// No description provided for @notification_assignee_push.
  ///
  /// In en, this message translates to:
  /// **'A conversation is assigned to you'**
  String get notification_assignee_push;

  /// No description provided for @notification_new_message_push.
  ///
  /// In en, this message translates to:
  /// **'You are mentioned in a conversation'**
  String get notification_new_message_push;

  /// No description provided for @notification_mention_push.
  ///
  /// In en, this message translates to:
  /// **'A new message is created in an assigned conversation'**
  String get notification_mention_push;

  /// No description provided for @notification_participating_new_message_push.
  ///
  /// In en, this message translates to:
  /// **'A new message is created in a participating conversation'**
  String get notification_participating_new_message_push;

  /// No description provided for @notification_content_conversation_creation.
  ///
  /// In en, this message translates to:
  /// **'New conversation created'**
  String get notification_content_conversation_creation;

  /// No description provided for @notification_content_conversation_assignment.
  ///
  /// In en, this message translates to:
  /// **'A conversation has been assigned to you'**
  String get notification_content_conversation_assignment;

  /// No description provided for @notification_content_assigned_conversation_new_message.
  ///
  /// In en, this message translates to:
  /// **'New message in an assigned conversation'**
  String get notification_content_assigned_conversation_new_message;

  /// No description provided for @notification_content_conversation_mention.
  ///
  /// In en, this message translates to:
  /// **'You have been mentioned in a conversation'**
  String get notification_content_conversation_mention;

  /// No description provided for @notification_content_participating_conversation_new_message.
  ///
  /// In en, this message translates to:
  /// **'New message in a conversation you are participating in'**
  String get notification_content_participating_conversation_new_message;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filter_by_assignee_type.
  ///
  /// In en, this message translates to:
  /// **'Filter by assignee type'**
  String get filter_by_assignee_type;

  /// No description provided for @filter_by_status.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filter_by_status;

  /// No description provided for @filter_by_inbox.
  ///
  /// In en, this message translates to:
  /// **'Filter by inbox'**
  String get filter_by_inbox;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @mine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get mine;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @snoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get snoozed;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @sort_on_created_at.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get sort_on_created_at;

  /// No description provided for @sort_on_priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get sort_on_priority;

  /// No description provided for @no_more.
  ///
  /// In en, this message translates to:
  /// **'That\'s all!'**
  String get no_more;

  /// No description provided for @last_activity_at_asc.
  ///
  /// In en, this message translates to:
  /// **'Last activity: Oldest first'**
  String get last_activity_at_asc;

  /// No description provided for @last_activity_at_desc.
  ///
  /// In en, this message translates to:
  /// **'Last activity: Newest first'**
  String get last_activity_at_desc;

  /// No description provided for @created_at_desc.
  ///
  /// In en, this message translates to:
  /// **'Created at: Newest first'**
  String get created_at_desc;

  /// No description provided for @created_at_asc.
  ///
  /// In en, this message translates to:
  /// **'Created at: Oldest first'**
  String get created_at_asc;

  /// No description provided for @priority_desc.
  ///
  /// In en, this message translates to:
  /// **'Priority: Highest first'**
  String get priority_desc;

  /// No description provided for @priority_asc.
  ///
  /// In en, this message translates to:
  /// **'Priority: Lowest first'**
  String get priority_asc;

  /// No description provided for @waiting_since_asc.
  ///
  /// In en, this message translates to:
  /// **'Pending Response: Longest first'**
  String get waiting_since_asc;

  /// No description provided for @waiting_since_desc.
  ///
  /// In en, this message translates to:
  /// **'Pending Response: Shortest first'**
  String get waiting_since_desc;

  /// No description provided for @campaigns_live_chat_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No live chat campaigns are available'**
  String get campaigns_live_chat_empty_title;

  /// No description provided for @campaigns_live_chat_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Connect with your customers using proactive messages. Click \'Create campaign\' to get started.'**
  String get campaigns_live_chat_empty_description;

  /// No description provided for @campaigns_sms_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No SMS campaigns are available'**
  String get campaigns_sms_empty_title;

  /// No description provided for @campaigns_sms_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Launch an SMS campaign to reach your customers directly. Send offers or make announcements with ease. Click \'Create campaign\' to get started.'**
  String get campaigns_sms_empty_description;

  /// No description provided for @macros_title.
  ///
  /// In en, this message translates to:
  /// **'Macros'**
  String get macros_title;

  /// No description provided for @macros_description.
  ///
  /// In en, this message translates to:
  /// **'A macro is a set of saved actions that help customer service agents easily complete tasks. The agents can define a set of actions like tagging a conversation with a label, sending an email transcript, updating a custom attribute, etc., and they can run these actions in a single click.'**
  String get macros_description;

  /// No description provided for @macro_visibility_global.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get macro_visibility_global;

  /// No description provided for @macro_visibility_global_description.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get macro_visibility_global_description;

  /// No description provided for @macro_visibility_personal.
  ///
  /// In en, this message translates to:
  /// **'This macro is available publicly for all agents in this account.'**
  String get macro_visibility_personal;

  /// No description provided for @macro_visibility_personal_description.
  ///
  /// In en, this message translates to:
  /// **'This macro will be private to you and not be available to others.'**
  String get macro_visibility_personal_description;

  /// No description provided for @understand.
  ///
  /// In en, this message translates to:
  /// **'Understand'**
  String get understand;

  /// No description provided for @confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete'**
  String get confirm_delete;

  /// No description provided for @confirm_delete_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String confirm_delete_message(String name);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to do logout?'**
  String get logout_confirm;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @server_upgrade_required.
  ///
  /// In en, this message translates to:
  /// **'Server upgrade required'**
  String get server_upgrade_required;

  /// No description provided for @server_upgrade_required_agent_message.
  ///
  /// In en, this message translates to:
  /// **'It seems like you are using unsupported Chatwoot server for your mobile app. Please contact your admin to upgrade your Chatwoot server.'**
  String get server_upgrade_required_agent_message;

  /// No description provided for @server_upgrade_required_admin_message.
  ///
  /// In en, this message translates to:
  /// **'It seems like you are using unsupported Chatwoot server for your mobile app. Upgrading to server version %{minimum_version} or later is required.'**
  String server_upgrade_required_admin_message(String minimum_version);

  /// No description provided for @snooze_until.
  ///
  /// In en, this message translates to:
  /// **'Snooze until'**
  String get snooze_until;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @tap_to_record.
  ///
  /// In en, this message translates to:
  /// **'Tap to record'**
  String get tap_to_record;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get successful;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @participants_add.
  ///
  /// In en, this message translates to:
  /// **'Add participant'**
  String get participants_add;

  /// No description provided for @initiated_at.
  ///
  /// In en, this message translates to:
  /// **'Initiated at'**
  String get initiated_at;

  /// No description provided for @initiated_from.
  ///
  /// In en, this message translates to:
  /// **'Initiated from'**
  String get initiated_from;

  /// No description provided for @browser.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get browser;

  /// No description provided for @operating_system.
  ///
  /// In en, this message translates to:
  /// **'Operating system'**
  String get operating_system;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @assignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get assignee;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @mark_auto_offline.
  ///
  /// In en, this message translates to:
  /// **'Mark offline automatically'**
  String get mark_auto_offline;

  /// No description provided for @translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name;

  /// No description provided for @full_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the full name'**
  String get full_name_hint;

  /// No description provided for @full_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'full_name_invalid'**
  String get full_name_invalid;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get first_name;

  /// No description provided for @first_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the first name'**
  String get first_name_hint;

  /// No description provided for @first_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'first_name_invalid'**
  String get first_name_invalid;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get last_name;

  /// No description provided for @last_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the last name'**
  String get last_name_hint;

  /// No description provided for @last_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'last_name_invalid'**
  String get last_name_invalid;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Enter the bio'**
  String get bio;

  /// No description provided for @bio_hint.
  ///
  /// In en, this message translates to:
  /// **'bio_hint'**
  String get bio_hint;

  /// No description provided for @bio_invalid.
  ///
  /// In en, this message translates to:
  /// **'bio_hint_invalid'**
  String get bio_invalid;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Type something...'**
  String get search_hint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
