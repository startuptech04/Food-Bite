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

  /// No description provided for @re_auth_required.
  ///
  /// In en, this message translates to:
  /// **'Re-authentication Required'**
  String get re_auth_required;

  /// No description provided for @security_logout_email_phone_change.
  ///
  /// In en, this message translates to:
  /// **'To ensure your account\'s security, you have been logged out.If Email Address or Phone Number changed, Please log in again using your updated credentials.'**
  String get security_logout_email_phone_change;

  /// No description provided for @security_logout_password_change.
  ///
  /// In en, this message translates to:
  /// **'To ensure your account\'s security, you have been logged out.If Password changed, Please log in again using your updated credentials.'**
  String get security_logout_password_change;

  /// No description provided for @auth_mode_using.
  ///
  /// In en, this message translates to:
  /// **'You\'re currently using'**
  String get auth_mode_using;

  /// No description provided for @auth_mode_email_verification.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an OTP to your new email address for verification.'**
  String get auth_mode_email_verification;

  /// No description provided for @auth_mode_mobile_verification.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an OTP to your new mobile number for verification.'**
  String get auth_mode_mobile_verification;

  /// No description provided for @no_matching_record_found.
  ///
  /// In en, this message translates to:
  /// **'No matching records found'**
  String get no_matching_record_found;

  /// No description provided for @no_matching_record_found_sub_title.
  ///
  /// In en, this message translates to:
  /// **'At this time, we regret to inform you that we currently do not have reasons. We understand how disappointing this may be.'**
  String get no_matching_record_found_sub_title;

  /// No description provided for @server_bug_error.
  ///
  /// In en, this message translates to:
  /// **'Oops! Looks like we\'ve found a bug in our kitchen, Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get server_bug_error;

  /// No description provided for @email_verification_reset_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address we\'ll send you a verification code to reset your password'**
  String get email_verification_reset_password;

  /// No description provided for @identity_verified.
  ///
  /// In en, this message translates to:
  /// **'Your identity has been verified! set your new password'**
  String get identity_verified;

  /// No description provided for @mobile_verification_reset_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number we\'ll send you a verification code to reset your password'**
  String get mobile_verification_reset_password;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @single_selection.
  ///
  /// In en, this message translates to:
  /// **'Single Selection'**
  String get single_selection;

  /// No description provided for @multi_selection.
  ///
  /// In en, this message translates to:
  /// **'Multiple Selection'**
  String get multi_selection;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @choose_addons.
  ///
  /// In en, this message translates to:
  /// **'Choose Addon\'s'**
  String get choose_addons;

  /// No description provided for @security_concern_notice.
  ///
  /// In en, this message translates to:
  /// **'Your account security is important to us, and we recommend contacting our support team immediately if you have any concerns.'**
  String get security_concern_notice;

  /// No description provided for @did_not_received_otp_code_resend.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get code? Resend'**
  String get did_not_received_otp_code_resend;

  /// No description provided for @no_order_error_title.
  ///
  /// In en, this message translates to:
  /// **'No orders, no problem!'**
  String get no_order_error_title;

  /// No description provided for @no_order_error_one.
  ///
  /// In en, this message translates to:
  /// **'At this time, we regret to inform you that we currently do not have any'**
  String get no_order_error_one;

  /// No description provided for @no_order_error_two.
  ///
  /// In en, this message translates to:
  /// **'orders available for delivery. We understand how disappointing this may be, especially when you\'re eagerly anticipating a delicious meal delivered straight to your doorstep.'**
  String get no_order_error_two;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

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

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_title;

  /// No description provided for @welcome_to.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcome_to;

  /// No description provided for @forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password_title;

  /// No description provided for @forgot_your_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_your_password_title;

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

  /// No description provided for @food_list.
  ///
  /// In en, this message translates to:
  /// **'Food List'**
  String get food_list;

  /// No description provided for @update_stock_detail.
  ///
  /// In en, this message translates to:
  /// **'Update Stock Detail'**
  String get update_stock_detail;

  /// No description provided for @add_variation.
  ///
  /// In en, this message translates to:
  /// **'Add Variation'**
  String get add_variation;

  /// No description provided for @update_variation.
  ///
  /// In en, this message translates to:
  /// **'Update Variation'**
  String get update_variation;

  /// No description provided for @add_option.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get add_option;

  /// No description provided for @update_option.
  ///
  /// In en, this message translates to:
  /// **'Update Option'**
  String get update_option;

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

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @order_detail.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get order_detail;

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

  /// No description provided for @ok_understand_btn.
  ///
  /// In en, this message translates to:
  /// **'Ok, I Understand'**
  String get ok_understand_btn;

  /// No description provided for @update_required.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get update_required;

  /// No description provided for @new_version_one.
  ///
  /// In en, this message translates to:
  /// **'A new version'**
  String get new_version_one;

  /// No description provided for @new_version_two.
  ///
  /// In en, this message translates to:
  /// **'of the app is available. Please update to continue.'**
  String get new_version_two;

  /// No description provided for @update_now.
  ///
  /// In en, this message translates to:
  /// **'UPDATE NOW'**
  String get update_now;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @ok_thank_you_btn.
  ///
  /// In en, this message translates to:
  /// **'Ok, I Thank you!'**
  String get ok_thank_you_btn;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @form_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get form_required;

  /// No description provided for @form_password_required.
  ///
  /// In en, this message translates to:
  /// **'Required - Please ensure the Password entered is valid'**
  String get form_password_required;

  /// No description provided for @form_confirm_password_required.
  ///
  /// In en, this message translates to:
  /// **'Required - Please ensure the Confirm entered is valid & match'**
  String get form_confirm_password_required;

  /// No description provided for @form_first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get form_first_name;

  /// No description provided for @form_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get form_last_name;

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

  /// No description provided for @form_your_mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Your Mobile Number'**
  String get form_your_mobile_number;

  /// No description provided for @form_feedback.
  ///
  /// In en, this message translates to:
  /// **'Enter feedback'**
  String get form_feedback;

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

  /// No description provided for @form_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get form_name;

  /// No description provided for @form_short_description.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get form_short_description;

  /// No description provided for @form_select_addons.
  ///
  /// In en, this message translates to:
  /// **'Select Addons'**
  String get form_select_addons;

  /// No description provided for @form_item_stock.
  ///
  /// In en, this message translates to:
  /// **'Item Stock'**
  String get form_item_stock;

  /// No description provided for @form_stock_type.
  ///
  /// In en, this message translates to:
  /// **'Stock Type'**
  String get form_stock_type;

  /// No description provided for @form_variation_type.
  ///
  /// In en, this message translates to:
  /// **'Variation Type'**
  String get form_variation_type;

  /// No description provided for @form_variation_title.
  ///
  /// In en, this message translates to:
  /// **'Variation Title'**
  String get form_variation_title;

  /// No description provided for @form_min_option_to_select.
  ///
  /// In en, this message translates to:
  /// **'Min Option to Select'**
  String get form_min_option_to_select;

  /// No description provided for @form_max_option_to_select.
  ///
  /// In en, this message translates to:
  /// **'Max Option to Select'**
  String get form_max_option_to_select;

  /// No description provided for @form_option_name.
  ///
  /// In en, this message translates to:
  /// **'Option Name'**
  String get form_option_name;

  /// No description provided for @form_option_price.
  ///
  /// In en, this message translates to:
  /// **'Option Price'**
  String get form_option_price;

  /// No description provided for @form_option_stock.
  ///
  /// In en, this message translates to:
  /// **'Option Stock'**
  String get form_option_stock;

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

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @share_experience_feedback.
  ///
  /// In en, this message translates to:
  /// **'Let us know your experience with the app and suggest any improvements. Your feedback helps us serve you better!'**
  String get share_experience_feedback;

  /// No description provided for @submit_feedback.
  ///
  /// In en, this message translates to:
  /// **'Submit feedback'**
  String get submit_feedback;

  /// No description provided for @report_emergency_notice.
  ///
  /// In en, this message translates to:
  /// **'Kindly use this page to report only serious incidents or accidents. For any order-related inquiries, please reach out to our chat support.'**
  String get report_emergency_notice;

  /// No description provided for @submit_message.
  ///
  /// In en, this message translates to:
  /// **'Submit Message'**
  String get submit_message;

  /// No description provided for @report_emergency_notice_title.
  ///
  /// In en, this message translates to:
  /// **'Please use this form exclusively for emergencies related to accidents or abuse. For order inquiries or other general questions, kindly contact us through our support portal.'**
  String get report_emergency_notice_title;

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

  /// No description provided for @access_permission_settings.
  ///
  /// In en, this message translates to:
  /// **'Control access to location, camera, and more from your phone settings'**
  String get access_permission_settings;

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

  /// No description provided for @promo_offer.
  ///
  /// In en, this message translates to:
  /// **'Promotions & Offers'**
  String get promo_offer;

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

  /// No description provided for @social_alerts.
  ///
  /// In en, this message translates to:
  /// **'Social Activity Alerts'**
  String get social_alerts;

  /// No description provided for @social_alerts_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Be notified when someone follows you, or interacts with your posts and reviews.'**
  String get social_alerts_sub_title;

  /// No description provided for @order_purchases.
  ///
  /// In en, this message translates to:
  /// **'Orders & Purchases'**
  String get order_purchases;

  /// No description provided for @order_purchases_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Track your order updates, membership details, and booking confirmations.'**
  String get order_purchases_sub_title;

  /// No description provided for @account_updates.
  ///
  /// In en, this message translates to:
  /// **'Important Account Updates'**
  String get account_updates;

  /// No description provided for @account_updates_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Receive critical alerts about your account status, security, or changes to our terms.'**
  String get account_updates_sub_title;

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

  /// No description provided for @sure_to_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want to Delete Your Account?'**
  String get sure_to_delete_account;

  /// No description provided for @sure_to_delete_account_sub_title.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data, including order history, subscriptions, wallet balance, saved addresses, and payment methods, will be permanently deleted.'**
  String get sure_to_delete_account_sub_title;

  /// No description provided for @yes_delete_btn.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get yes_delete_btn;

  /// No description provided for @email_otp_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and otp for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get email_otp_login_title;

  /// No description provided for @remember_me_lbl.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get remember_me_lbl;

  /// No description provided for @social_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in with social account'**
  String get social_sign_in;

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

  /// No description provided for @email_password_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and password for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get email_password_login_title;

  /// No description provided for @forgot_password_btn.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password_btn;

  /// No description provided for @login_btn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login_btn;

  /// No description provided for @mobile_otp_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and otp for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get mobile_otp_login_title;

  /// No description provided for @mobile_password_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and password for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get mobile_password_login_title;

  /// No description provided for @in_stock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get in_stock;

  /// No description provided for @food_variation.
  ///
  /// In en, this message translates to:
  /// **'Food Variations'**
  String get food_variation;

  /// No description provided for @add_new_variation.
  ///
  /// In en, this message translates to:
  /// **'Add new Variation'**
  String get add_new_variation;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @required_field.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required_field;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @min_qty.
  ///
  /// In en, this message translates to:
  /// **'Min Qty'**
  String get min_qty;

  /// No description provided for @max_qty.
  ///
  /// In en, this message translates to:
  /// **'Max Qty'**
  String get max_qty;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add_new_option.
  ///
  /// In en, this message translates to:
  /// **'Add New Option'**
  String get add_new_option;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @verification_code_sent_to.
  ///
  /// In en, this message translates to:
  /// **'A verification code has sent to'**
  String get verification_code_sent_to;

  /// No description provided for @check_sms_box_verification.
  ///
  /// In en, this message translates to:
  /// **'Please check your SMS inbox and enter the verification code below to verify your mobile number.'**
  String get check_sms_box_verification;

  /// No description provided for @check_main_box_verification.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and enter the verification code below to verify your email address.'**
  String get check_main_box_verification;

  /// No description provided for @regular_order.
  ///
  /// In en, this message translates to:
  /// **'Regular Order'**
  String get regular_order;

  /// No description provided for @pos_order.
  ///
  /// In en, this message translates to:
  /// **'POS Order'**
  String get pos_order;

  /// No description provided for @table_order.
  ///
  /// In en, this message translates to:
  /// **'Table Order'**
  String get table_order;

  /// No description provided for @table_no.
  ///
  /// In en, this message translates to:
  /// **'Table No'**
  String get table_no;

  /// No description provided for @cooking_instruction.
  ///
  /// In en, this message translates to:
  /// **'Cooking Instruction'**
  String get cooking_instruction;

  /// No description provided for @prepare_order.
  ///
  /// In en, this message translates to:
  /// **'Prepare Order'**
  String get prepare_order;

  /// No description provided for @complete_order.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get complete_order;

  /// No description provided for @regular_order_no.
  ///
  /// In en, this message translates to:
  /// **'Regular Order Number'**
  String get regular_order_no;

  /// No description provided for @pos_order_no.
  ///
  /// In en, this message translates to:
  /// **'POS Order Number'**
  String get pos_order_no;

  /// No description provided for @order_ref.
  ///
  /// In en, this message translates to:
  /// **'Order Reference'**
  String get order_ref;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get order_details;

  /// No description provided for @sorry_for_deleting_account.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry to see you go! Deleting your account will permanently remove your personal data, order history, saved addresses, payment methods, and preferences from our system.'**
  String get sorry_for_deleting_account;

  /// No description provided for @verification_failed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verification_failed;

  /// No description provided for @please_wait_loader.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get please_wait_loader;

  /// No description provided for @profile_updated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profile_updated;

  /// No description provided for @avatar_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Avatar uploaded'**
  String get avatar_uploaded;

  /// No description provided for @feedback_saved.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback is saved'**
  String get feedback_saved;

  /// No description provided for @report_saved.
  ///
  /// In en, this message translates to:
  /// **'Your Report is saved'**
  String get report_saved;

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

  /// No description provided for @mobile_number_updated.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number Updated'**
  String get mobile_number_updated;

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

  /// No description provided for @food_updated.
  ///
  /// In en, this message translates to:
  /// **'Food updated!'**
  String get food_updated;

  /// No description provided for @otp_sent.
  ///
  /// In en, this message translates to:
  /// **'OTP Sent'**
  String get otp_sent;

  /// No description provided for @order_preparing.
  ///
  /// In en, this message translates to:
  /// **'Order Preparing'**
  String get order_preparing;

  /// No description provided for @order_completed.
  ///
  /// In en, this message translates to:
  /// **'Order Completed'**
  String get order_completed;

  /// No description provided for @delete_reason_one.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone.'**
  String get delete_reason_one;

  /// No description provided for @delete_reason_two.
  ///
  /// In en, this message translates to:
  /// **'All past deliveries, trip history, and performance records will be permanently erased.'**
  String get delete_reason_two;

  /// No description provided for @delete_reason_three.
  ///
  /// In en, this message translates to:
  /// **'You will lose access to any active delivery assignments or schedules.'**
  String get delete_reason_three;

  /// No description provided for @delete_reason_four.
  ///
  /// In en, this message translates to:
  /// **'Any pending earnings, bonuses, or wallet balance will be forfeited.'**
  String get delete_reason_four;

  /// No description provided for @delete_reason_five.
  ///
  /// In en, this message translates to:
  /// **'Your saved delivery zones, route preferences, and availability status will be removed.'**
  String get delete_reason_five;

  /// No description provided for @delete_reason_six.
  ///
  /// In en, this message translates to:
  /// **'Stored bank or payout details will be permanently deleted.'**
  String get delete_reason_six;

  /// No description provided for @delete_reason_seven.
  ///
  /// In en, this message translates to:
  /// **'You will no longer receive notifications about delivery requests or platform updates.'**
  String get delete_reason_seven;

  /// No description provided for @delete_reason_eight.
  ///
  /// In en, this message translates to:
  /// **'Your delivery profile and login credentials will be deactivated.'**
  String get delete_reason_eight;

  /// No description provided for @delete_reason_nine.
  ///
  /// In en, this message translates to:
  /// **'Earnings statements and trip invoices will no longer be available for download.'**
  String get delete_reason_nine;

  /// No description provided for @dd_unlimited_stock.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Stock'**
  String get dd_unlimited_stock;

  /// No description provided for @dd_limited_stock.
  ///
  /// In en, this message translates to:
  /// **'Limited Stock'**
  String get dd_limited_stock;

  /// No description provided for @dd_daily_limit.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit'**
  String get dd_daily_limit;

  /// No description provided for @dd_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get dd_yes;

  /// No description provided for @dd_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get dd_no;

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

  /// No description provided for @tab_new_order.
  ///
  /// In en, this message translates to:
  /// **'New (##dynamic##)'**
  String get tab_new_order;

  /// No description provided for @tab_preparing_order.
  ///
  /// In en, this message translates to:
  /// **'Preparing (##dynamic##)'**
  String get tab_preparing_order;

  /// No description provided for @tab_completed_order.
  ///
  /// In en, this message translates to:
  /// **'Completed (##dynamic##)'**
  String get tab_completed_order;

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

  /// No description provided for @bloc_add_options.
  ///
  /// In en, this message translates to:
  /// **'Please add options'**
  String get bloc_add_options;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_and_conditions;

  /// No description provided for @cookies.
  ///
  /// In en, this message translates to:
  /// **'App Cookies'**
  String get cookies;

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
