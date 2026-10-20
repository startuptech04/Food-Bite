import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('hi'),
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FoodBite'**
  String get welcome;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get signin;

  /// No description provided for @permission_title.
  ///
  /// In en, this message translates to:
  /// **'App Permission'**
  String get permission_title;

  /// No description provided for @notification_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Enable Notification'**
  String get notification_permission_title;

  /// No description provided for @notification_permission_sub_title.
  ///
  /// In en, this message translates to:
  /// **'needs to access Notification permission so you don\'t miss another update and Enjoy a seamless and engaging experience with timely information'**
  String get notification_permission_sub_title;

  /// No description provided for @bluetooth_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Enable Bluetooth'**
  String get bluetooth_permission_title;

  /// No description provided for @bluetooth_permission_sub_title.
  ///
  /// In en, this message translates to:
  /// **'need to access Bluetooth permission to Select your printer from the list of available devices to pair with it'**
  String get bluetooth_permission_sub_title;

  /// No description provided for @camera_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Enable Camera'**
  String get camera_permission_title;

  /// No description provided for @camera_permission_sub_title.
  ///
  /// In en, this message translates to:
  /// **'need to access Camera and Photo Library to Enable take and upload photos, allowing you to share and showcase your experiences'**
  String get camera_permission_sub_title;

  /// No description provided for @location_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get location_permission_title;

  /// No description provided for @location_permission_sub_title.
  ///
  /// In en, this message translates to:
  /// **'need to access Location so it will enable accurate directions and route planning to enhance your navigation within the app'**
  String get location_permission_sub_title;

  /// No description provided for @permission_allow_text.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get permission_allow_text;

  /// No description provided for @permission_later_text.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get permission_later_text;

  /// No description provided for @skip_title.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip_title;

  /// No description provided for @next_title.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next_title;

  /// No description provided for @notification_permission_granted.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission Granted'**
  String get notification_permission_granted;

  /// No description provided for @notificaiton_permission_declined.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission Declined'**
  String get notificaiton_permission_declined;

  /// No description provided for @bluetooth_permission_granted.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Permission Granted'**
  String get bluetooth_permission_granted;

  /// No description provided for @bluetooth_permission_declined.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Permission Declined'**
  String get bluetooth_permission_declined;

  /// No description provided for @camera_permission_granted.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Granted'**
  String get camera_permission_granted;

  /// No description provided for @camera_permission_declined.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Declined'**
  String get camera_permission_declined;

  /// No description provided for @location_permission_granted.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Granted'**
  String get location_permission_granted;

  /// No description provided for @location_permission_declined.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Declined'**
  String get location_permission_declined;

  /// No description provided for @login_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get login_welcome_title;

  /// No description provided for @login_with_email_password_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and password for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get login_with_email_password_sub_title;

  /// No description provided for @email_lbl.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_lbl;

  /// No description provided for @email_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Required - Please ensure the email entered is valid'**
  String get email_validation_error;

  /// No description provided for @password_lbl.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_lbl;

  /// No description provided for @password_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Required - Please ensure the Password entered is valid'**
  String get password_validation_error;

  /// No description provided for @remember_me_lbl.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get remember_me_lbl;

  /// No description provided for @forgot_password_lbl.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password_lbl;

  /// No description provided for @join_lbl_first.
  ///
  /// In en, this message translates to:
  /// **'Want to join us?'**
  String get join_lbl_first;

  /// No description provided for @no_matching_record_found.
  ///
  /// In en, this message translates to:
  /// **'No matching records found'**
  String get no_matching_record_found;

  /// No description provided for @no_reason_found_error.
  ///
  /// In en, this message translates to:
  /// **'At this time, we regret to inform you that we currently do not have reasons. We understand how disappointing this may be.'**
  String get no_reason_found_error;

  /// No description provided for @no_order_found_error.
  ///
  /// In en, this message translates to:
  /// **'At this time, we regret to inform you that we currently do not have orders. We understand how disappointing this may be.'**
  String get no_order_found_error;

  /// No description provided for @re_auth_required.
  ///
  /// In en, this message translates to:
  /// **'Re-authentication Required'**
  String get re_auth_required;

  /// No description provided for @re_auth_logout_email_phone.
  ///
  /// In en, this message translates to:
  /// **'To ensure your account\'s security, you have been logged out.If Email Address or Phone Number changed, Please log in again using your updated credentials.'**
  String get re_auth_logout_email_phone;

  /// No description provided for @re_auth_logout_password_change.
  ///
  /// In en, this message translates to:
  /// **'To ensure your account\'s security, you have been logged out.If Password changed, Please log in again using your updated credentials.'**
  String get re_auth_logout_password_change;

  /// No description provided for @join_as_deliveryman_title.
  ///
  /// In en, this message translates to:
  /// **'Join Our Team as a Delivery Partner – Earn While You Deliver!'**
  String get join_as_deliveryman_title;

  /// No description provided for @your_reviews.
  ///
  /// In en, this message translates to:
  /// **'Your Review\'s'**
  String get your_reviews;

  /// No description provided for @chat_messages.
  ///
  /// In en, this message translates to:
  /// **'Chat Messages'**
  String get chat_messages;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @notification_sound.
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notification_sound;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get choose_language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms_and_condition.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_and_condition;

  /// No description provided for @refund_policy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get refund_policy;

  /// No description provided for @shipping_policy.
  ///
  /// In en, this message translates to:
  /// **'Shipping Policy'**
  String get shipping_policy;

  /// No description provided for @cancellation_policy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get cancellation_policy;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get send_feedback;

  /// No description provided for @report_emergency.
  ///
  /// In en, this message translates to:
  /// **'Report a safety emergency'**
  String get report_emergency;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @your_profile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get your_profile;

  /// No description provided for @review_list.
  ///
  /// In en, this message translates to:
  /// **'Your Review List'**
  String get review_list;

  /// No description provided for @app_settings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get app_settings;

  /// No description provided for @alert_pref.
  ///
  /// In en, this message translates to:
  /// **'Alerts & Preferences'**
  String get alert_pref;

  /// No description provided for @change_email.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get change_email;

  /// No description provided for @change_mobile.
  ///
  /// In en, this message translates to:
  /// **'Change Mobile Number'**
  String get change_mobile;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @update_password.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @register_request_saved_title.
  ///
  /// In en, this message translates to:
  /// **'Registration Request Saved Successfully'**
  String get register_request_saved_title;

  /// No description provided for @register_request_saved_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Thank you for taking the time to register with us. Your request has been securely recorded in our system. Our team is currently reviewing your details to ensure everything is in order.'**
  String get register_request_saved_sub_title;

  /// No description provided for @ok_thank_you.
  ///
  /// In en, this message translates to:
  /// **'Ok, Thank you'**
  String get ok_thank_you;

  /// No description provided for @forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password_title;

  /// No description provided for @forgot_your_password_lbl.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_your_password_lbl;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @direct_chat.
  ///
  /// In en, this message translates to:
  /// **'Direct Chat'**
  String get direct_chat;

  /// No description provided for @support_chat.
  ///
  /// In en, this message translates to:
  /// **'Support Chat'**
  String get support_chat;

  /// No description provided for @something_went_wrong_error_title.
  ///
  /// In en, this message translates to:
  /// **'Oops! Looks like we\'ve found a bug in our kitchen, Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get something_went_wrong_error_title;

  /// No description provided for @deposite.
  ///
  /// In en, this message translates to:
  /// **'Deposite'**
  String get deposite;

  /// No description provided for @network_error_title.
  ///
  /// In en, this message translates to:
  /// **'Network Issues'**
  String get network_error_title;

  /// No description provided for @network_error_sub_title.
  ///
  /// In en, this message translates to:
  /// **'If you are using Wi-Fi or mobile data, ensure that Wi-Fi or mobile data is enabled on your device. Go to the device settings and turn on Wi-Fi or mobile data. Then, select the appropriate Wi-Fi or mobile data network and connect.'**
  String get network_error_sub_title;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;

  /// No description provided for @maintenance_error_title.
  ///
  /// In en, this message translates to:
  /// **'Apology for the Inconvenience'**
  String get maintenance_error_title;

  /// No description provided for @maintenance_error_sub_title.
  ///
  /// In en, this message translates to:
  /// **'We\'re currently undergoing scheduled maintenance to improve our services. We apologize for any inconvenience this may cause. Thank you for your patience. If you have urgent issues, please contact our support team at'**
  String get maintenance_error_sub_title;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @not_found_error_title.
  ///
  /// In en, this message translates to:
  /// **'Broken Content'**
  String get not_found_error_title;

  /// No description provided for @not_found_error_sub_title.
  ///
  /// In en, this message translates to:
  /// **'If there are links on a website pointing to non-existent pages, users may encounter 404 errors when trying to access those links.'**
  String get not_found_error_sub_title;

  /// No description provided for @server_error_title.
  ///
  /// In en, this message translates to:
  /// **'500 Internal Server Error'**
  String get server_error_title;

  /// No description provided for @server_error_sub_title.
  ///
  /// In en, this message translates to:
  /// **'This is a generic error message that indicates an unspecified problem on the server. It could be due to misconfigurations, server overload, or programming errors'**
  String get server_error_sub_title;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @select_reason.
  ///
  /// In en, this message translates to:
  /// **'Select Reason'**
  String get select_reason;

  /// No description provided for @search_country.
  ///
  /// In en, this message translates to:
  /// **'Search Country'**
  String get search_country;

  /// No description provided for @verification_code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verification_code;

  /// No description provided for @confirm_online.
  ///
  /// In en, this message translates to:
  /// **'Confirm Online'**
  String get confirm_online;

  /// No description provided for @expected_earning.
  ///
  /// In en, this message translates to:
  /// **'Expected earning'**
  String get expected_earning;

  /// No description provided for @order_delivery_proof.
  ///
  /// In en, this message translates to:
  /// **'Order Delivery Proof'**
  String get order_delivery_proof;

  /// No description provided for @order_pickup_proof.
  ///
  /// In en, this message translates to:
  /// **'Order Pickup Proof'**
  String get order_pickup_proof;

  /// No description provided for @verify_otp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verify_otp;

  /// No description provided for @enable_location_service.
  ///
  /// In en, this message translates to:
  /// **'Enable Location Services'**
  String get enable_location_service;

  /// No description provided for @withdrawal_history_detail.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal History Detail'**
  String get withdrawal_history_detail;

  /// No description provided for @payouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get payouts;

  /// No description provided for @withdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get withdrawal;

  /// No description provided for @withdrawal_history.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal History'**
  String get withdrawal_history;

  /// No description provided for @transaction_history.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transaction_history;

  /// No description provided for @payout_accounts.
  ///
  /// In en, this message translates to:
  /// **'Payout Accounts'**
  String get payout_accounts;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @manage_payout_method.
  ///
  /// In en, this message translates to:
  /// **'Manage Payout Method'**
  String get manage_payout_method;

  /// No description provided for @wallet_balance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get wallet_balance;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @choose_from.
  ///
  /// In en, this message translates to:
  /// **'Choose From'**
  String get choose_from;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @no_withdrawal_history_found_title.
  ///
  /// In en, this message translates to:
  /// **'No Withdrawal History Found'**
  String get no_withdrawal_history_found_title;

  /// No description provided for @no_history_found_title.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any history yet.'**
  String get no_history_found_title;

  /// No description provided for @no_transaction_history_found.
  ///
  /// In en, this message translates to:
  /// **'No Transaction History Found'**
  String get no_transaction_history_found;

  /// No description provided for @no_transaction_found_title.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any transactions yet.'**
  String get no_transaction_found_title;

  /// No description provided for @no_payout_method_found_title.
  ///
  /// In en, this message translates to:
  /// **'No Payout Method Found!'**
  String get no_payout_method_found_title;

  /// No description provided for @no_payout_method_found_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Please contact support or check back later for updates.'**
  String get no_payout_method_found_sub_title;

  /// No description provided for @no_payout_method_found_error.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any Payout Method Saved yet.'**
  String get no_payout_method_found_error;

  /// No description provided for @security_concern_title.
  ///
  /// In en, this message translates to:
  /// **'Your account security is important to us, and we recommend contacting our support team immediately if you have any concerns.'**
  String get security_concern_title;

  /// No description provided for @did_not_received_otp_resent_lbl.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get code? Resend'**
  String get did_not_received_otp_resent_lbl;

  /// No description provided for @no_order_found_title.
  ///
  /// In en, this message translates to:
  /// **'No Orders Found'**
  String get no_order_found_title;

  /// No description provided for @no_order_found_sub_title.
  ///
  /// In en, this message translates to:
  /// **'You currently have no orders to deliver. Please check back later for new assignments.'**
  String get no_order_found_sub_title;

  /// No description provided for @no_cash_in_hand_found_title.
  ///
  /// In en, this message translates to:
  /// **'No Cash-In Hand History Found'**
  String get no_cash_in_hand_found_title;

  /// No description provided for @no_submitted_cash_in_hand_found_title.
  ///
  /// In en, this message translates to:
  /// **'No Submitted Cash-In Hand History Found'**
  String get no_submitted_cash_in_hand_found_title;

  /// No description provided for @mobile_otp_verification.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number we\'ll send you a verification code to reset your password'**
  String get mobile_otp_verification;

  /// No description provided for @verification_success.
  ///
  /// In en, this message translates to:
  /// **'Your identity has been verified! set your new password'**
  String get verification_success;

  /// No description provided for @email_otp_verification.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address we\'ll send you a verification code to reset your password'**
  String get email_otp_verification;

  /// No description provided for @auth_mode_using.
  ///
  /// In en, this message translates to:
  /// **'You\'re currently using'**
  String get auth_mode_using;

  /// No description provided for @auth_mode_email_otp.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an OTP to your new email address for verification.'**
  String get auth_mode_email_otp;

  /// No description provided for @auth_mode_phone_otp.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an OTP to your new mobile number for verification.'**
  String get auth_mode_phone_otp;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @driving_license.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get driving_license;

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @feedback_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Let us know your experience with the app and suggest any improvements. Your feedback helps us serve you better!'**
  String get feedback_sub_title;

  /// No description provided for @submit_feedback.
  ///
  /// In en, this message translates to:
  /// **'Submit feedback'**
  String get submit_feedback;

  /// No description provided for @report_emergency_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Kindly use this page to report only serious incidents or accidents. For any order-related inquiries, please reach out to our chat support.'**
  String get report_emergency_sub_title;

  /// No description provided for @report_emergency_description.
  ///
  /// In en, this message translates to:
  /// **'Please use this form exclusively for emergencies related to accidents or abuse. For order inquiries or other general questions, kindly contact us through our support portal.'**
  String get report_emergency_description;

  /// No description provided for @sorry_for_deleting_account.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry to see you go! Deleting your account will permanently remove your personal data, order history, saved addresses, payment methods, and preferences from our system.'**
  String get sorry_for_deleting_account;

  /// No description provided for @register_request_notice.
  ///
  /// In en, this message translates to:
  /// **'Providing incorrect or incomplete details may result in rejection or delays in processing. Do not share sensitive information, such as passwords or PINs, on this form, If you have any doubts or questions, contact the concerned authority for clarification before submitting the form.'**
  String get register_request_notice;

  /// No description provided for @check_email_sms_box.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and enter the verification code below to verify your email address.'**
  String get check_email_sms_box;

  /// No description provided for @check_phone_sms_box.
  ///
  /// In en, this message translates to:
  /// **'Please check your SMS inbox and enter the verification code below to verify your mobile number.'**
  String get check_phone_sms_box;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @confirm_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want to Delete Your Account?'**
  String get confirm_delete_account;

  /// No description provided for @confirm_delete_account_sub_title.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data, including order history, subscriptions, wallet balance, saved addresses, and payment methods, will be permanently deleted.'**
  String get confirm_delete_account_sub_title;

  /// No description provided for @yes_delete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get yes_delete;

  /// No description provided for @update_default_payout_method.
  ///
  /// In en, this message translates to:
  /// **'Update Default Payout Method'**
  String get update_default_payout_method;

  /// No description provided for @update_default_payout_method_sub_title.
  ///
  /// In en, this message translates to:
  /// **'This will update your default payout method. Are you sure you want to proceed?'**
  String get update_default_payout_method_sub_title;

  /// No description provided for @yes_update.
  ///
  /// In en, this message translates to:
  /// **'Yes Update'**
  String get yes_update;

  /// No description provided for @are_you_sure_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get are_you_sure_title;

  /// No description provided for @confirm_delete_payout_method.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete this payout method?'**
  String get confirm_delete_payout_method;

  /// No description provided for @form_first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get form_first_name;

  /// No description provided for @form_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get form_required;

  /// No description provided for @form_password_validation.
  ///
  /// In en, this message translates to:
  /// **'Required - Please ensure the Password entered is valid'**
  String get form_password_validation;

  /// No description provided for @form_confirm_password_validation.
  ///
  /// In en, this message translates to:
  /// **'Required - Please ensure the Confirm entered is valid & match'**
  String get form_confirm_password_validation;

  /// No description provided for @form_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get form_last_name;

  /// No description provided for @form_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get form_city;

  /// No description provided for @form_locality.
  ///
  /// In en, this message translates to:
  /// **'Locality'**
  String get form_locality;

  /// No description provided for @form_your_email.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get form_your_email;

  /// No description provided for @form_your_name.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get form_your_name;

  /// No description provided for @form_country_code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get form_country_code;

  /// No description provided for @form_mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Your Mobile Number'**
  String get form_mobile_number;

  /// No description provided for @form_enter_feedback.
  ///
  /// In en, this message translates to:
  /// **'Enter feedback'**
  String get form_enter_feedback;

  /// No description provided for @form_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get form_email;

  /// No description provided for @form_mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get form_mobile;

  /// No description provided for @form_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get form_password;

  /// No description provided for @form_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get form_confirm_password;

  /// No description provided for @form_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get form_age;

  /// No description provided for @form_dob.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get form_dob;

  /// No description provided for @form_identity_number.
  ///
  /// In en, this message translates to:
  /// **'Indentity Number'**
  String get form_identity_number;

  /// No description provided for @form_country_code_name.
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get form_country_code_name;

  /// No description provided for @form_select_payout_method.
  ///
  /// In en, this message translates to:
  /// **'Select Payout Method'**
  String get form_select_payout_method;

  /// No description provided for @form_withdrawal_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter Withdrawal Amount'**
  String get form_withdrawal_amount;

  /// No description provided for @submit_message.
  ///
  /// In en, this message translates to:
  /// **'Submit Message'**
  String get submit_message;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @verified_order.
  ///
  /// In en, this message translates to:
  /// **'Verified order'**
  String get verified_order;

  /// No description provided for @profile_info.
  ///
  /// In en, this message translates to:
  /// **'Profile Info'**
  String get profile_info;

  /// No description provided for @update_bio.
  ///
  /// In en, this message translates to:
  /// **'Update your name, bio, and profile picture'**
  String get update_bio;

  /// No description provided for @choose_reminders.
  ///
  /// In en, this message translates to:
  /// **'Choose how you receive updates and reminders'**
  String get choose_reminders;

  /// No description provided for @user_account.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get user_account;

  /// No description provided for @manage_login_creds_to_remove_account.
  ///
  /// In en, this message translates to:
  /// **'Manage your login details or remove your account'**
  String get manage_login_creds_to_remove_account;

  /// No description provided for @device_access.
  ///
  /// In en, this message translates to:
  /// **'Device Access'**
  String get device_access;

  /// No description provided for @control_permissions.
  ///
  /// In en, this message translates to:
  /// **'Control access to location, camera, and more from your phone settings'**
  String get control_permissions;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @newsletters.
  ///
  /// In en, this message translates to:
  /// **'Newsletters'**
  String get newsletters;

  /// No description provided for @newsletters_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Stay informed with the latest news, updates, and stories from the food world.'**
  String get newsletters_sub_title;

  /// No description provided for @promo_offer_title.
  ///
  /// In en, this message translates to:
  /// **'Promotions & Offers'**
  String get promo_offer_title;

  /// No description provided for @promo_offer_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Get alerts about exclusive deals, discounts, and special promotions tailored just for you.'**
  String get promo_offer_sub_title;

  /// No description provided for @push.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get push;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @social_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Social Activity Alerts'**
  String get social_alert_title;

  /// No description provided for @social_alert_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Be notified when someone follows you, or interacts with your posts and reviews.'**
  String get social_alert_sub_title;

  /// No description provided for @order_purchase_title.
  ///
  /// In en, this message translates to:
  /// **'Orders & Purchases'**
  String get order_purchase_title;

  /// No description provided for @order_purchase_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Track your order updates, membership details, and booking confirmations.'**
  String get order_purchase_sub_title;

  /// No description provided for @account_update_title.
  ///
  /// In en, this message translates to:
  /// **'Important Account Updates'**
  String get account_update_title;

  /// No description provided for @account_update_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Receive critical alerts about your account status, security, or changes to our terms.'**
  String get account_update_sub_title;

  /// No description provided for @update_pref.
  ///
  /// In en, this message translates to:
  /// **'Update Preference'**
  String get update_pref;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @update_required.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get update_required;

  /// No description provided for @update_now.
  ///
  /// In en, this message translates to:
  /// **'UPDATE NOW'**
  String get update_now;

  /// No description provided for @new_update_one.
  ///
  /// In en, this message translates to:
  /// **'A new version'**
  String get new_update_one;

  /// No description provided for @new_update_two.
  ///
  /// In en, this message translates to:
  /// **'of the app is available. Please update to continue.'**
  String get new_update_two;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @login_back.
  ///
  /// In en, this message translates to:
  /// **'Login back'**
  String get login_back;

  /// No description provided for @ok_understand.
  ///
  /// In en, this message translates to:
  /// **'Ok, I Understand'**
  String get ok_understand;

  /// No description provided for @add_payout_method.
  ///
  /// In en, this message translates to:
  /// **'Add Payout Method'**
  String get add_payout_method;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @away.
  ///
  /// In en, this message translates to:
  /// **'away'**
  String get away;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'KM'**
  String get km;

  /// No description provided for @miles.
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get miles;

  /// No description provided for @earning.
  ///
  /// In en, this message translates to:
  /// **'Earning'**
  String get earning;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @avg_time.
  ///
  /// In en, this message translates to:
  /// **'Avg. Time'**
  String get avg_time;

  /// No description provided for @order_stats.
  ///
  /// In en, this message translates to:
  /// **'Order Stats'**
  String get order_stats;

  /// No description provided for @earning_stats.
  ///
  /// In en, this message translates to:
  /// **'Earning Stats'**
  String get earning_stats;

  /// No description provided for @hourly_performance.
  ///
  /// In en, this message translates to:
  /// **'Hourly Performance'**
  String get hourly_performance;

  /// No description provided for @recent_orders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recent_orders;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @recent_reviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get recent_reviews;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @deliveries.
  ///
  /// In en, this message translates to:
  /// **'Deliveries'**
  String get deliveries;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @bonuses.
  ///
  /// In en, this message translates to:
  /// **'Bonuses'**
  String get bonuses;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @total_earning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get total_earning;

  /// No description provided for @email_otp_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and otp for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get email_otp_login_title;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get remember_me;

  /// No description provided for @register_as_deliveryman.
  ///
  /// In en, this message translates to:
  /// **'Register as Deliveryman'**
  String get register_as_deliveryman;

  /// No description provided for @social_sign_in_lbl.
  ///
  /// In en, this message translates to:
  /// **'Sign in with social account'**
  String get social_sign_in_lbl;

  /// No description provided for @apple_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple_sign_in;

  /// No description provided for @please_wait_progress.
  ///
  /// In en, this message translates to:
  /// **'Please wait....'**
  String get please_wait_progress;

  /// No description provided for @google_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google_sign_in;

  /// No description provided for @facebook_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook_sign_in;

  /// No description provided for @phone_otp_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your email mobile number and otp for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get phone_otp_login_title;

  /// No description provided for @phone_password_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and password for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get phone_password_login_title;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @joining_type.
  ///
  /// In en, this message translates to:
  /// **'Joining Type'**
  String get joining_type;

  /// No description provided for @identity_proof.
  ///
  /// In en, this message translates to:
  /// **'Identity Proof'**
  String get identity_proof;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get in_progress;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @cash_in_hand.
  ///
  /// In en, this message translates to:
  /// **'Cash In-Hand'**
  String get cash_in_hand;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @oops_title.
  ///
  /// In en, this message translates to:
  /// **'Opps!'**
  String get oops_title;

  /// No description provided for @no_result_found_error.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no result found. Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get no_result_found_error;

  /// No description provided for @order_no.
  ///
  /// In en, this message translates to:
  /// **'Order No'**
  String get order_no;

  /// No description provided for @submitted_cash.
  ///
  /// In en, this message translates to:
  /// **'Submitted Cash'**
  String get submitted_cash;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @active_orders.
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get active_orders;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get order_number;

  /// No description provided for @pickup_order.
  ///
  /// In en, this message translates to:
  /// **'PICK-UP ORDER'**
  String get pickup_order;

  /// No description provided for @deliver_order.
  ///
  /// In en, this message translates to:
  /// **'DELIVER ORDER'**
  String get deliver_order;

  /// No description provided for @no_restaurant_found_on_address.
  ///
  /// In en, this message translates to:
  /// **'No restaurants found at this address'**
  String get no_restaurant_found_on_address;

  /// No description provided for @no_active_order_found.
  ///
  /// In en, this message translates to:
  /// **'No active orders found at this time'**
  String get no_active_order_found;

  /// No description provided for @reached_pickup_location.
  ///
  /// In en, this message translates to:
  /// **'Reached pickup location'**
  String get reached_pickup_location;

  /// No description provided for @picked_order.
  ///
  /// In en, this message translates to:
  /// **'Picked order'**
  String get picked_order;

  /// No description provided for @reached_drop_location.
  ///
  /// In en, this message translates to:
  /// **'Reached drop location'**
  String get reached_drop_location;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @go_to_map.
  ///
  /// In en, this message translates to:
  /// **'Go to map'**
  String get go_to_map;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @pick_order_now.
  ///
  /// In en, this message translates to:
  /// **'Pick order now'**
  String get pick_order_now;

  /// No description provided for @order_ref.
  ///
  /// In en, this message translates to:
  /// **'Order Reference'**
  String get order_ref;

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get order_details;

  /// No description provided for @drop_up_detail.
  ///
  /// In en, this message translates to:
  /// **'Drop-up details'**
  String get drop_up_detail;

  /// No description provided for @restaurant_details.
  ///
  /// In en, this message translates to:
  /// **'Restaurant details'**
  String get restaurant_details;

  /// No description provided for @collect_money.
  ///
  /// In en, this message translates to:
  /// **'Collect Money'**
  String get collect_money;

  /// No description provided for @paid_online.
  ///
  /// In en, this message translates to:
  /// **'Paid Online'**
  String get paid_online;

  /// No description provided for @verify_order_with_customer.
  ///
  /// In en, this message translates to:
  /// **'Verify order with customer'**
  String get verify_order_with_customer;

  /// No description provided for @ask_customer_for_otp.
  ///
  /// In en, this message translates to:
  /// **'Please ask customer for OTP'**
  String get ask_customer_for_otp;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @verification_code_sent_to.
  ///
  /// In en, this message translates to:
  /// **'A verification code has sent to'**
  String get verification_code_sent_to;

  /// No description provided for @sure_to_go_online.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to go online, you will start receiving orders'**
  String get sure_to_go_online;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @will_receive_fixed_salary.
  ///
  /// In en, this message translates to:
  /// **'You will receive fixed salary amount, incentive & deliverytip'**
  String get will_receive_fixed_salary;

  /// No description provided for @drop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get drop;

  /// No description provided for @pickup_from.
  ///
  /// In en, this message translates to:
  /// **'Pickup from'**
  String get pickup_from;

  /// No description provided for @order_id.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get order_id;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @reject_order.
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get reject_order;

  /// No description provided for @accept_order.
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get accept_order;

  /// No description provided for @upload_and_save.
  ///
  /// In en, this message translates to:
  /// **'Upload & Save'**
  String get upload_and_save;

  /// No description provided for @enter_verification_one.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification'**
  String get enter_verification_one;

  /// No description provided for @enter_verification_two.
  ///
  /// In en, this message translates to:
  /// **'characters OTP code'**
  String get enter_verification_two;

  /// No description provided for @check_order_detail_and_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Please ask Customer to check order detail and enter the verification code below to verify order.'**
  String get check_order_detail_and_verification_code;

  /// No description provided for @location_settings.
  ///
  /// In en, this message translates to:
  /// **'Please go to settings and enable location services for'**
  String get location_settings;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @payout_method.
  ///
  /// In en, this message translates to:
  /// **'Payout Method'**
  String get payout_method;

  /// No description provided for @payout_credential.
  ///
  /// In en, this message translates to:
  /// **'Payout Credential'**
  String get payout_credential;

  /// No description provided for @approval_notes.
  ///
  /// In en, this message translates to:
  /// **'Approval Note'**
  String get approval_notes;

  /// No description provided for @rejection_notes.
  ///
  /// In en, this message translates to:
  /// **'Rejection Notes'**
  String get rejection_notes;

  /// No description provided for @loader_please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get loader_please_wait;

  /// No description provided for @loader_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get loader_uploading;

  /// No description provided for @profile_updated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profile_updated;

  /// No description provided for @image_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded'**
  String get image_uploaded;

  /// No description provided for @feedback_is_saved.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback is saved'**
  String get feedback_is_saved;

  /// No description provided for @report_is_saved.
  ///
  /// In en, this message translates to:
  /// **'Your Report is saved'**
  String get report_is_saved;

  /// No description provided for @pref_updated.
  ///
  /// In en, this message translates to:
  /// **'Preferences updated'**
  String get pref_updated;

  /// No description provided for @email_updated.
  ///
  /// In en, this message translates to:
  /// **'Email Updated'**
  String get email_updated;

  /// No description provided for @mobile_updated.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number Updated'**
  String get mobile_updated;

  /// No description provided for @account_deleted.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted!'**
  String get account_deleted;

  /// No description provided for @password_updated.
  ///
  /// In en, this message translates to:
  /// **'Password Updated'**
  String get password_updated;

  /// No description provided for @otp_sent.
  ///
  /// In en, this message translates to:
  /// **'OTP Sent'**
  String get otp_sent;

  /// No description provided for @payout_saved.
  ///
  /// In en, this message translates to:
  /// **'Payout Saved!'**
  String get payout_saved;

  /// No description provided for @payout_updated.
  ///
  /// In en, this message translates to:
  /// **'Payout Updated!'**
  String get payout_updated;

  /// No description provided for @withdrawal_request_sent.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request sent'**
  String get withdrawal_request_sent;

  /// No description provided for @verification_failed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verification_failed;

  /// No description provided for @your_account_is_blocked.
  ///
  /// In en, this message translates to:
  /// **'Your Account is Blocked'**
  String get your_account_is_blocked;

  /// No description provided for @delete_reason_one.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone.'**
  String get delete_reason_one;

  /// No description provided for @delete_reason_two.
  ///
  /// In en, this message translates to:
  /// **'All past orders, receipts, and order history will be erased.'**
  String get delete_reason_two;

  /// No description provided for @delete_reason_three.
  ///
  /// In en, this message translates to:
  /// **'You will lose access to any active subscriptions or meal plans.'**
  String get delete_reason_three;

  /// No description provided for @delete_reason_four.
  ///
  /// In en, this message translates to:
  /// **'Any remaining wallet balance, promo codes, or loyalty points will be forfeited.'**
  String get delete_reason_four;

  /// No description provided for @delete_reason_five.
  ///
  /// In en, this message translates to:
  /// **'Your saved addresses and delivery preferences will be removed.'**
  String get delete_reason_five;

  /// No description provided for @delete_reason_six.
  ///
  /// In en, this message translates to:
  /// **'Stored payment methods and billing information will be deleted.'**
  String get delete_reason_six;

  /// No description provided for @delete_reason_seven.
  ///
  /// In en, this message translates to:
  /// **'You will no longer receive notifications or updates about offers or deals.'**
  String get delete_reason_seven;

  /// No description provided for @delete_reason_eight.
  ///
  /// In en, this message translates to:
  /// **'Your profile and login credentials will be deactivated.'**
  String get delete_reason_eight;

  /// No description provided for @delete_reason_nine.
  ///
  /// In en, this message translates to:
  /// **'Invoices or transaction records will no longer be available for download.'**
  String get delete_reason_nine;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_message;

  /// No description provided for @fetching.
  ///
  /// In en, this message translates to:
  /// **'Fetching...'**
  String get fetching;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @you_are_offline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get you_are_offline;

  /// No description provided for @otp_to_restaurant.
  ///
  /// In en, this message translates to:
  /// **'OTP to restaurant'**
  String get otp_to_restaurant;

  /// No description provided for @you_have_received_new_order.
  ///
  /// In en, this message translates to:
  /// **'You have received new order'**
  String get you_have_received_new_order;

  /// No description provided for @you_have_new_order_one.
  ///
  /// In en, this message translates to:
  /// **'You have received'**
  String get you_have_new_order_one;

  /// No description provided for @you_have_new_order_two.
  ///
  /// In en, this message translates to:
  /// **'new orders'**
  String get you_have_new_order_two;

  /// No description provided for @new_order.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get new_order;

  /// No description provided for @feeds.
  ///
  /// In en, this message translates to:
  /// **'Feeds'**
  String get feeds;

  /// No description provided for @payout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get payout;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @server_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get server_not_found_error;

  /// No description provided for @server_please_authenticate_error.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate'**
  String get server_please_authenticate_error;

  /// No description provided for @server_forbidden_error.
  ///
  /// In en, this message translates to:
  /// **'Forbidden'**
  String get server_forbidden_error;

  /// No description provided for @server_already_exist_error.
  ///
  /// In en, this message translates to:
  /// **'Already exist'**
  String get server_already_exist_error;

  /// No description provided for @server_incorrect_email_or_password_error.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get server_incorrect_email_or_password_error;

  /// No description provided for @server_unauthorized_error.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get server_unauthorized_error;

  /// No description provided for @server_account_blocked_error.
  ///
  /// In en, this message translates to:
  /// **'Account Blocked'**
  String get server_account_blocked_error;

  /// No description provided for @server_incorrect_phone_or_password_error.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Phone or password'**
  String get server_incorrect_phone_or_password_error;

  /// No description provided for @server_password_reset_failed_error.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed'**
  String get server_password_reset_failed_error;

  /// No description provided for @server_email_verification_failed_error.
  ///
  /// In en, this message translates to:
  /// **'Email verification failed'**
  String get server_email_verification_failed_error;

  /// No description provided for @server_item_already_exist_in_cart_error.
  ///
  /// In en, this message translates to:
  /// **'Item already exist in cart'**
  String get server_item_already_exist_in_cart_error;

  /// No description provided for @server_something_went_wrong_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get server_something_went_wrong_error;

  /// No description provided for @server_addon_not_available_error.
  ///
  /// In en, this message translates to:
  /// **'One of the addon is not available'**
  String get server_addon_not_available_error;

  /// No description provided for @server_variation_not_available_error.
  ///
  /// In en, this message translates to:
  /// **'One of the variation is not available'**
  String get server_variation_not_available_error;

  /// No description provided for @server_already_created_error.
  ///
  /// In en, this message translates to:
  /// **'Already Created'**
  String get server_already_created_error;

  /// No description provided for @server_coupon_already_redemeed_error.
  ///
  /// In en, this message translates to:
  /// **'Coupon Already redemeed'**
  String get server_coupon_already_redemeed_error;

  /// No description provided for @server_bogo_failed_error.
  ///
  /// In en, this message translates to:
  /// **'Please add one more item to validate BOGO offer'**
  String get server_bogo_failed_error;

  /// No description provided for @server_coupon_limit_crossed_error.
  ///
  /// In en, this message translates to:
  /// **'Coupon Limit Crossed'**
  String get server_coupon_limit_crossed_error;

  /// No description provided for @server_already_requested_error.
  ///
  /// In en, this message translates to:
  /// **'Already requested'**
  String get server_already_requested_error;

  /// No description provided for @server_limit_crossed_error.
  ///
  /// In en, this message translates to:
  /// **'Limit Crossed'**
  String get server_limit_crossed_error;

  /// No description provided for @server_wallet_find_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to find wallet'**
  String get server_wallet_find_error;

  /// No description provided for @server_wallet_balance_error.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds: Withdrawal amount exceeds your available balance'**
  String get server_wallet_balance_error;

  /// No description provided for @server_email_smtp_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to email server. Make sure you have configured the SMTP options'**
  String get server_email_smtp_error;

  /// No description provided for @server_already_saved_error.
  ///
  /// In en, this message translates to:
  /// **'Already saved'**
  String get server_already_saved_error;

  /// No description provided for @server_favourite_error.
  ///
  /// In en, this message translates to:
  /// **'item is already in favourite list'**
  String get server_favourite_error;

  /// No description provided for @server_already_hidden_error.
  ///
  /// In en, this message translates to:
  /// **'Already Hidden'**
  String get server_already_hidden_error;

  /// No description provided for @server_another_deliveryman_accepted_order_error.
  ///
  /// In en, this message translates to:
  /// **'Another Deliveryman Accepted Order'**
  String get server_another_deliveryman_accepted_order_error;

  /// No description provided for @server_invalid_deliveryman_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid Deliveryman'**
  String get server_invalid_deliveryman_error;

  /// No description provided for @server_already_assigned_error.
  ///
  /// In en, this message translates to:
  /// **'Already assigned'**
  String get server_already_assigned_error;

  /// No description provided for @server_wrong_otp_error.
  ///
  /// In en, this message translates to:
  /// **'Wrong OTP'**
  String get server_wrong_otp_error;

  /// No description provided for @server_verification_failed_error.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get server_verification_failed_error;

  /// No description provided for @server_credentials_error.
  ///
  /// In en, this message translates to:
  /// **'credentials not found'**
  String get server_credentials_error;

  /// No description provided for @server_cart_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Cart Item not found'**
  String get server_cart_not_found_error;

  /// No description provided for @server_purchase_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Purchase Not Found'**
  String get server_purchase_not_found_error;

  /// No description provided for @server_wallet_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Wallet Not Found'**
  String get server_wallet_not_found_error;

  /// No description provided for @server_no_user_found_email_error.
  ///
  /// In en, this message translates to:
  /// **'No users found with this email'**
  String get server_no_user_found_email_error;

  /// No description provided for @server_no_user_found_mobile_number_error.
  ///
  /// In en, this message translates to:
  /// **'No users found with this mobile number'**
  String get server_no_user_found_mobile_number_error;

  /// No description provided for @server_email_already_taken_error.
  ///
  /// In en, this message translates to:
  /// **'Email already taken'**
  String get server_email_already_taken_error;

  /// No description provided for @server_phone_already_taken_error.
  ///
  /// In en, this message translates to:
  /// **'Phone already taken'**
  String get server_phone_already_taken_error;

  /// No description provided for @server_account_already_created_error.
  ///
  /// In en, this message translates to:
  /// **'Account already created'**
  String get server_account_already_created_error;

  /// No description provided for @server_user_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get server_user_not_found_error;

  /// No description provided for @server_driver_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Driver not found'**
  String get server_driver_not_found_error;

  /// No description provided for @server_detail_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Detail not found'**
  String get server_detail_not_found_error;

  /// No description provided for @server_restaurant_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Restaurant not found'**
  String get server_restaurant_not_found_error;

  /// No description provided for @server_clear_cash_outlet_error.
  ///
  /// In en, this message translates to:
  /// **'Please clear cash in hand amount before deleting account from your account and from outlet'**
  String get server_clear_cash_outlet_error;

  /// No description provided for @server_clear_cash_restaurant_error.
  ///
  /// In en, this message translates to:
  /// **'Please clear cash in hand amount before deleting account'**
  String get server_clear_cash_restaurant_error;

  /// No description provided for @server_deliveryman_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Deliveryman not found'**
  String get server_deliveryman_not_found_error;

  /// No description provided for @server_waiter_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Waiter not found'**
  String get server_waiter_not_found_error;

  /// No description provided for @server_kitchen_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Owner not found'**
  String get server_kitchen_not_found_error;

  /// No description provided for @server_already_taken_error.
  ///
  /// In en, this message translates to:
  /// **'Already taken'**
  String get server_already_taken_error;

  /// No description provided for @server_file_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get server_file_not_found_error;

  /// No description provided for @server_validation_failed_error.
  ///
  /// In en, this message translates to:
  /// **'Validation failed'**
  String get server_validation_failed_error;

  /// No description provided for @server_invalid_file_type_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid file type'**
  String get server_invalid_file_type_error;

  /// No description provided for @server_select_file_upload_error.
  ///
  /// In en, this message translates to:
  /// **'Please select a file to upload!'**
  String get server_select_file_upload_error;

  /// No description provided for @server_account_not_found_error.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get server_account_not_found_error;

  /// No description provided for @server_contact_admin_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please contact administrator'**
  String get server_contact_admin_error;

  /// No description provided for @server_address_missing_errir.
  ///
  /// In en, this message translates to:
  /// **'Address is missing'**
  String get server_address_missing_errir;

  /// No description provided for @server_home_delivery_disabled_error.
  ///
  /// In en, this message translates to:
  /// **'Home Delivery is disabled'**
  String get server_home_delivery_disabled_error;

  /// No description provided for @server_self_pickup_disabled_error.
  ///
  /// In en, this message translates to:
  /// **'Self Pickup is disabled'**
  String get server_self_pickup_disabled_error;

  /// No description provided for @server_instant_order_disabled_error.
  ///
  /// In en, this message translates to:
  /// **'Instant Order is disabled'**
  String get server_instant_order_disabled_error;

  /// No description provided for @server_schedule_order_disabled_error.
  ///
  /// In en, this message translates to:
  /// **'Schedule Order is disabled'**
  String get server_schedule_order_disabled_error;

  /// No description provided for @server_schedule_date_is_invalid_error.
  ///
  /// In en, this message translates to:
  /// **'Schedule Date is invalid'**
  String get server_schedule_date_is_invalid_error;

  /// No description provided for @server_can_not_deliver_to_address_error.
  ///
  /// In en, this message translates to:
  /// **'Can not deliver order to this address'**
  String get server_can_not_deliver_to_address_error;

  /// No description provided for @server_coupon_wallet_can_not_use_same_error.
  ///
  /// In en, this message translates to:
  /// **'Oops! Looks like you\'ve applied a coupon code for your order.Please note that you can\'t use your wallet balance along with a coupon code'**
  String get server_coupon_wallet_can_not_use_same_error;

  /// No description provided for @server_invalid_coupon_not_available_error.
  ///
  /// In en, this message translates to:
  /// **'Opps, Sorry this coupon is not available for you.'**
  String get server_invalid_coupon_not_available_error;

  /// No description provided for @server_food_is_not_available_error.
  ///
  /// In en, this message translates to:
  /// **'One of the food is not available'**
  String get server_food_is_not_available_error;

  /// No description provided for @server_empty_cart_error.
  ///
  /// In en, this message translates to:
  /// **'Cart is Empty'**
  String get server_empty_cart_error;

  /// No description provided for @server_addon_variation_not_available_error.
  ///
  /// In en, this message translates to:
  /// **'One of the addon or variation is not available'**
  String get server_addon_variation_not_available_error;

  /// No description provided for @server_pos_permmission_error.
  ///
  /// In en, this message translates to:
  /// **'Pos Permission Denied'**
  String get server_pos_permmission_error;

  /// No description provided for @server_no_trial_subscription_package_error.
  ///
  /// In en, this message translates to:
  /// **'Oops! Looks like you\'ve applied a trial subscription package, and it is not available as of now, please select payment method!'**
  String get server_no_trial_subscription_package_error;

  /// No description provided for @server_table_order_permission_error.
  ///
  /// In en, this message translates to:
  /// **'Table Order Permission Denied'**
  String get server_table_order_permission_error;

  /// No description provided for @server_invalid_slot_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid Slot'**
  String get server_invalid_slot_error;

  /// No description provided for @server_max_upload_size_error.
  ///
  /// In en, this message translates to:
  /// **'Maximum file size is ##dynamic## MB'**
  String get server_max_upload_size_error;

  /// No description provided for @server_min_cart_error.
  ///
  /// In en, this message translates to:
  /// **'Opps, Sorry. you required minimum ##dynamic## on your cart.'**
  String get server_min_cart_error;

  /// No description provided for @server_min_amount_error.
  ///
  /// In en, this message translates to:
  /// **'Please note that a minimum order value of ##dynamic## is required to proceed with your order'**
  String get server_min_amount_error;

  /// No description provided for @server_out_of_stock_error.
  ///
  /// In en, this message translates to:
  /// **'Sorry, ##dynamic## is currently out of stock and cannot be added to your order.'**
  String get server_out_of_stock_error;

  /// No description provided for @bloc_something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get bloc_something_went_wrong;

  /// No description provided for @bloc_fill_all_required_inputs.
  ///
  /// In en, this message translates to:
  /// **'Please fill all the required inputs'**
  String get bloc_fill_all_required_inputs;

  /// No description provided for @bloc_invalid_otp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get bloc_invalid_otp;

  /// No description provided for @bloc_insufficient_fund.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds: Withdrawal amount exceeds your available balance.'**
  String get bloc_insufficient_fund;

  /// No description provided for @bloc_location_service_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get bloc_location_service_disabled;

  /// No description provided for @bloc_location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get bloc_location_permission_denied;

  /// No description provided for @bloc_location_permission_permanently_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied, we cannot request permissions.'**
  String get bloc_location_permission_permanently_denied;

  /// No description provided for @dd_passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get dd_passport;

  /// No description provided for @dd_driving_license.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get dd_driving_license;

  /// No description provided for @dd_nic.
  ///
  /// In en, this message translates to:
  /// **'National Identity Card'**
  String get dd_nic;

  /// No description provided for @dd_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get dd_male;

  /// No description provided for @dd_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get dd_female;

  /// No description provided for @dd_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get dd_other;

  /// No description provided for @dd_not_disclose.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to disclose'**
  String get dd_not_disclose;

  /// No description provided for @dd_report_accident.
  ///
  /// In en, this message translates to:
  /// **'Report an Accident'**
  String get dd_report_accident;

  /// No description provided for @dd_report_incident.
  ///
  /// In en, this message translates to:
  /// **'Report an Incident'**
  String get dd_report_incident;

  /// No description provided for @dd_extra_shift.
  ///
  /// In en, this message translates to:
  /// **'Extra Shift'**
  String get dd_extra_shift;

  /// No description provided for @dd_freelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get dd_freelancer;

  /// No description provided for @dd_salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get dd_salary;

  /// No description provided for @dining_bookings.
  ///
  /// In en, this message translates to:
  /// **'Dining Bookings'**
  String get dining_bookings;

  /// No description provided for @tiffin_subscription.
  ///
  /// In en, this message translates to:
  /// **'Tiffin Subscription'**
  String get tiffin_subscription;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @hotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get hotel;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @order_status_ideal.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get order_status_ideal;

  /// No description provided for @order_status_accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get order_status_accepted;

  /// No description provided for @order_status_driver_reached_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Reached restaurant'**
  String get order_status_driver_reached_restaurant;

  /// No description provided for @order_status_driver_pickpup_order.
  ///
  /// In en, this message translates to:
  /// **'Picked order'**
  String get order_status_driver_pickpup_order;

  /// No description provided for @order_status_driver_reached_customer.
  ///
  /// In en, this message translates to:
  /// **'Reached customer'**
  String get order_status_driver_reached_customer;

  /// No description provided for @order_status_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get order_status_rejected;

  /// No description provided for @order_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get order_status_cancelled;

  /// No description provided for @order_status_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get order_status_delivered;

  /// No description provided for @order_status_accepted_another.
  ///
  /// In en, this message translates to:
  /// **'Delayed Acceptance'**
  String get order_status_accepted_another;

  /// No description provided for @order_status_created.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get order_status_created;

  /// No description provided for @order_status_preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get order_status_preparing;

  /// No description provided for @order_status_ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get order_status_ready;

  /// No description provided for @order_status_handover.
  ///
  /// In en, this message translates to:
  /// **'Handover'**
  String get order_status_handover;

  /// No description provided for @order_status_ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get order_status_ongoing;

  /// No description provided for @order_status_refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get order_status_refunded;

  /// No description provided for @order_status_partially_refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get order_status_partially_refunded;

  /// No description provided for @order_status_pending_payments.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get order_status_pending_payments;

  /// No description provided for @cookies.
  ///
  /// In en, this message translates to:
  /// **'App Cookies'**
  String get cookies;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_and_conditions;

  /// No description provided for @frequently_asked_questions.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get frequently_asked_questions;

  /// No description provided for @dining_help.
  ///
  /// In en, this message translates to:
  /// **'Dining Help'**
  String get dining_help;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get mark_all_read;

  /// No description provided for @empty_data.
  ///
  /// In en, this message translates to:
  /// **'Looks like this well\'s dry. No data here! Looks like we hit an empty patch! No data to display here.'**
  String get empty_data;

  /// No description provided for @system_error_one.
  ///
  /// In en, this message translates to:
  /// **'Oops! It seems like something unexpected happened. Our team has been notified and is working diligently to resolve the issue. We apologize for any inconvenience this may have caused. Thank you for your patience and understanding'**
  String get system_error_one;

  /// No description provided for @undestand_and_go_back.
  ///
  /// In en, this message translates to:
  /// **'Okay, I understand, Go Back'**
  String get undestand_and_go_back;

  /// No description provided for @bg_location_title.
  ///
  /// In en, this message translates to:
  /// **'Allow Background Location'**
  String get bg_location_title;

  /// No description provided for @bg_location_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Our app collects your location during an active delivery to enable real-time order tracking, even when the app is running in the background.'**
  String get bg_location_subtitle;

  /// No description provided for @bg_location_btn.
  ///
  /// In en, this message translates to:
  /// **'Allow in Settings'**
  String get bg_location_btn;
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
      <String>['ar', 'en', 'es', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
