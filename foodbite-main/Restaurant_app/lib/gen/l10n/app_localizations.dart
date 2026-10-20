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

  /// No description provided for @password_lbl.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_lbl;

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

  /// No description provided for @join_lbl_second.
  ///
  /// In en, this message translates to:
  /// **'Register as Restaurant'**
  String get join_lbl_second;

  /// No description provided for @social_login_lbl.
  ///
  /// In en, this message translates to:
  /// **'Sign in with apple or google'**
  String get social_login_lbl;

  /// No description provided for @apple_login_lbl.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple_login_lbl;

  /// No description provided for @google_login_lbl.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google_login_lbl;

  /// No description provided for @account_title.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account_title;

  /// No description provided for @business_title.
  ///
  /// In en, this message translates to:
  /// **'Business Insight'**
  String get business_title;

  /// No description provided for @campaign_title.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get campaign_title;

  /// No description provided for @menu_title.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu_title;

  /// No description provided for @menu_food_tab_head.
  ///
  /// In en, this message translates to:
  /// **'All items'**
  String get menu_food_tab_head;

  /// No description provided for @menu_addon_tab_head.
  ///
  /// In en, this message translates to:
  /// **'Add-ons'**
  String get menu_addon_tab_head;

  /// No description provided for @menu_category_tab_head.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get menu_category_tab_head;

  /// No description provided for @menu_sub_category_tab_head.
  ///
  /// In en, this message translates to:
  /// **'Sub Categories'**
  String get menu_sub_category_tab_head;

  /// No description provided for @add_lbl.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add_lbl;

  /// No description provided for @edit_lbl.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit_lbl;

  /// No description provided for @delete_lbl.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_lbl;

  /// No description provided for @alert_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get alert_confirm_title;

  /// No description provided for @alert_confirm_addon_sub_title.
  ///
  /// In en, this message translates to:
  /// **'If yes this addon will be removed from the system and the action cannot be undone'**
  String get alert_confirm_addon_sub_title;

  /// No description provided for @cancel_lbl.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_lbl;

  /// No description provided for @confirm_delete_lbl.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete it!'**
  String get confirm_delete_lbl;

  /// No description provided for @addon_action_new_toast.
  ///
  /// In en, this message translates to:
  /// **'Addon added!'**
  String get addon_action_new_toast;

  /// No description provided for @addon_action_edit_toast.
  ///
  /// In en, this message translates to:
  /// **'Addon updated!'**
  String get addon_action_edit_toast;

  /// No description provided for @addon_action_new_title.
  ///
  /// In en, this message translates to:
  /// **'Add Add-ons'**
  String get addon_action_new_title;

  /// No description provided for @addon_action_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Add-ons'**
  String get addon_action_edit_title;

  /// No description provided for @addon_txt_name.
  ///
  /// In en, this message translates to:
  /// **'Add-on\'s Name'**
  String get addon_txt_name;

  /// No description provided for @addon_txt_price.
  ///
  /// In en, this message translates to:
  /// **'Add-on\'s Price'**
  String get addon_txt_price;

  /// No description provided for @submit_lbl.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit_lbl;

  /// No description provided for @loading_lbl.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading_lbl;

  /// No description provided for @please_waiter.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get please_waiter;

  /// No description provided for @edit_restaurant_detail.
  ///
  /// In en, this message translates to:
  /// **'Edit Restaurant Details'**
  String get edit_restaurant_detail;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @expense_report.
  ///
  /// In en, this message translates to:
  /// **'Expense Report'**
  String get expense_report;

  /// No description provided for @outlets.
  ///
  /// In en, this message translates to:
  /// **'Outlets'**
  String get outlets;

  /// No description provided for @deliveryman.
  ///
  /// In en, this message translates to:
  /// **'Deliveryman'**
  String get deliveryman;

  /// No description provided for @waiters.
  ///
  /// In en, this message translates to:
  /// **'Waiter\'s'**
  String get waiters;

  /// No description provided for @kitchen_owner.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Owner'**
  String get kitchen_owner;

  /// No description provided for @food_taxation.
  ///
  /// In en, this message translates to:
  /// **'Food Taxation'**
  String get food_taxation;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @menu_photos.
  ///
  /// In en, this message translates to:
  /// **'Menu & Photos'**
  String get menu_photos;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @chat_messages.
  ///
  /// In en, this message translates to:
  /// **'Chat Messages'**
  String get chat_messages;

  /// No description provided for @coupon_management.
  ///
  /// In en, this message translates to:
  /// **'Coupon Management'**
  String get coupon_management;

  /// No description provided for @subscription_packages.
  ///
  /// In en, this message translates to:
  /// **'Subscription Package'**
  String get subscription_packages;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notification_sound.
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notification_sound;

  /// No description provided for @order_management.
  ///
  /// In en, this message translates to:
  /// **'Orders Management'**
  String get order_management;

  /// No description provided for @table_orders.
  ///
  /// In en, this message translates to:
  /// **'Table Orders'**
  String get table_orders;

  /// No description provided for @tiffin_subscription_packages.
  ///
  /// In en, this message translates to:
  /// **'Tiffin Subscription Packages'**
  String get tiffin_subscription_packages;

  /// No description provided for @campaign.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get campaign;

  /// No description provided for @online_order_help.
  ///
  /// In en, this message translates to:
  /// **'Online Ordering Help'**
  String get online_order_help;

  /// No description provided for @dining.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get dining;

  /// No description provided for @dining_help.
  ///
  /// In en, this message translates to:
  /// **'Dining Help'**
  String get dining_help;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faqs;

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

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_and_conditions;

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

  /// No description provided for @send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get send_feedback;

  /// No description provided for @report_a_safety_emergency.
  ///
  /// In en, this message translates to:
  /// **'Report a safety emergency'**
  String get report_a_safety_emergency;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

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

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Oops! Looks like we\'ve found a bug in our kitchen, Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get error;

  /// No description provided for @no_record_found_title.
  ///
  /// In en, this message translates to:
  /// **'No matching records found'**
  String get no_record_found_title;

  /// No description provided for @no_record_found_sub_title.
  ///
  /// In en, this message translates to:
  /// **'At this time, we regret to inform you that we currently do not have reasons. We understand how disappointing this may be.'**
  String get no_record_found_sub_title;

  /// No description provided for @ticket_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get ticket_open;

  /// No description provided for @ticket_in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get ticket_in_progress;

  /// No description provided for @ticket_resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get ticket_resolved;

  /// No description provided for @order_coupon.
  ///
  /// In en, this message translates to:
  /// **'Order Coupons'**
  String get order_coupon;

  /// No description provided for @dining_coupon.
  ///
  /// In en, this message translates to:
  /// **'Dining Coupons'**
  String get dining_coupon;

  /// No description provided for @add_coupon.
  ///
  /// In en, this message translates to:
  /// **'Add Coupon'**
  String get add_coupon;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @pre_booking_charge.
  ///
  /// In en, this message translates to:
  /// **'Pre Booking Charge'**
  String get pre_booking_charge;

  /// No description provided for @coupon_requested.
  ///
  /// In en, this message translates to:
  /// **'Coupon Requested'**
  String get coupon_requested;

  /// No description provided for @hide_lbl.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide_lbl;

  /// No description provided for @yes_hide_btn.
  ///
  /// In en, this message translates to:
  /// **'Yes Hide'**
  String get yes_hide_btn;

  /// No description provided for @hide_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to hide'**
  String get hide_confirm_title;

  /// No description provided for @no_coupon_found.
  ///
  /// In en, this message translates to:
  /// **'No Coupons Available'**
  String get no_coupon_found;

  /// No description provided for @no_coupon_found_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Currently, there are no active coupons. Please add new coupon for special offers and discounts.'**
  String get no_coupon_found_sub_title;

  /// No description provided for @confirm_delete_alert.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete'**
  String get confirm_delete_alert;

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

  /// No description provided for @save_lbl.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_lbl;

  /// No description provided for @table_booking.
  ///
  /// In en, this message translates to:
  /// **'Table bookings'**
  String get table_booking;

  /// No description provided for @coupon_type.
  ///
  /// In en, this message translates to:
  /// **'Coupon Type'**
  String get coupon_type;

  /// No description provided for @coupon_availability.
  ///
  /// In en, this message translates to:
  /// **'Coupon Availability'**
  String get coupon_availability;

  /// No description provided for @coupon_prebooking_charge_required.
  ///
  /// In en, this message translates to:
  /// **'Coupon PreBooking Charge Required'**
  String get coupon_prebooking_charge_required;

  /// No description provided for @min_cart.
  ///
  /// In en, this message translates to:
  /// **'Min Cart'**
  String get min_cart;

  /// No description provided for @min_discount.
  ///
  /// In en, this message translates to:
  /// **'Min Discount'**
  String get min_discount;

  /// No description provided for @max_discount.
  ///
  /// In en, this message translates to:
  /// **'Max Discount'**
  String get max_discount;

  /// No description provided for @deliveryman_list.
  ///
  /// In en, this message translates to:
  /// **'Deliveryman List'**
  String get deliveryman_list;

  /// No description provided for @salaried.
  ///
  /// In en, this message translates to:
  /// **'Salaried'**
  String get salaried;

  /// No description provided for @freelancing.
  ///
  /// In en, this message translates to:
  /// **'Freelancing'**
  String get freelancing;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked?'**
  String get blocked;

  /// No description provided for @add_deliveryman.
  ///
  /// In en, this message translates to:
  /// **'Add Deliveryman'**
  String get add_deliveryman;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

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

  /// No description provided for @no_deliveryman_added.
  ///
  /// In en, this message translates to:
  /// **'No Deliverymen Added'**
  String get no_deliveryman_added;

  /// No description provided for @no_deliveryman_added_sub_title.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any deliveryman yet. Start by creating a new profile.'**
  String get no_deliveryman_added_sub_title;

  /// No description provided for @no_booking_found.
  ///
  /// In en, this message translates to:
  /// **'No bookings, no problem!'**
  String get no_booking_found;

  /// No description provided for @no_title.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no_title;

  /// No description provided for @no_booking_sub_title.
  ///
  /// In en, this message translates to:
  /// **'bookings have been found for the restaurants at this time. It appears that there are currently no recent reservations or scheduling updates in the system.'**
  String get no_booking_sub_title;

  /// No description provided for @dining_guest_available_count_title.
  ///
  /// In en, this message translates to:
  /// **'After selecting the guest count, the system will display a list of available tables count that can accommodate the specified number of guests.'**
  String get dining_guest_available_count_title;

  /// No description provided for @dining_guest_available_count_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Ensure that the selected table meets any specific requirements requested by the guest.'**
  String get dining_guest_available_count_sub_title;

  /// No description provided for @no_expense_found_title.
  ///
  /// In en, this message translates to:
  /// **'No Expenses Found'**
  String get no_expense_found_title;

  /// No description provided for @no_expense_found_sub_title.
  ///
  /// In en, this message translates to:
  /// **'No expenses found. Please add one to continue.'**
  String get no_expense_found_sub_title;

  /// No description provided for @no_waiter_added_title.
  ///
  /// In en, this message translates to:
  /// **'No Waiter Added'**
  String get no_waiter_added_title;

  /// No description provided for @no_waiter_added_sub_title.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any waiter yet. Start by creating a new profile.'**
  String get no_waiter_added_sub_title;

  /// No description provided for @no_data_found.
  ///
  /// In en, this message translates to:
  /// **'Looks like this well\'s dry. No data here! Looks like we hit an empty patch! No data to display here.'**
  String get no_data_found;

  /// No description provided for @no_outlet_added_title.
  ///
  /// In en, this message translates to:
  /// **'No Outlet Added'**
  String get no_outlet_added_title;

  /// No description provided for @no_outlet_added_sub_title.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any outlet yet. Start by creating a new profile.'**
  String get no_outlet_added_sub_title;

  /// No description provided for @no_review_title.
  ///
  /// In en, this message translates to:
  /// **'No review, no problem!'**
  String get no_review_title;

  /// No description provided for @no_review_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Review list is eagerly anticipating your next delicious decision, Your orders list is like a blank canvas, waiting for your culinary masterpiece.'**
  String get no_review_sub_title;

  /// No description provided for @re_auth_required.
  ///
  /// In en, this message translates to:
  /// **'Re-authentication Required'**
  String get re_auth_required;

  /// No description provided for @oops_error.
  ///
  /// In en, this message translates to:
  /// **'Opps!'**
  String get oops_error;

  /// No description provided for @reorder_sub_title.
  ///
  /// In en, this message translates to:
  /// **'I need a little more information. Can you please clarify what you\'d like to order?, We couldn\'t make sense of that. Please try rephrasing your request.'**
  String get reorder_sub_title;

  /// No description provided for @error_found_title.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no result found. Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get error_found_title;

  /// No description provided for @no_order_found_title.
  ///
  /// In en, this message translates to:
  /// **'No orders, no problem!'**
  String get no_order_found_title;

  /// No description provided for @no_order_found_sub_title.
  ///
  /// In en, this message translates to:
  /// **'At this time, we regret to inform you that we currently do not have any pos or table orders available for delivery. We understand how disappointing this may be, especially when you\'re eagerly anticipating a delicious meal delivered straight to your doorstep.'**
  String get no_order_found_sub_title;

  /// No description provided for @no_order_found_one_title.
  ///
  /// In en, this message translates to:
  /// **'At this time, we regret to inform you that we currently do not have any'**
  String get no_order_found_one_title;

  /// No description provided for @no_order_found_two_title.
  ///
  /// In en, this message translates to:
  /// **'orders available for delivery. We understand how disappointing this may be, especially when you\'re eagerly anticipating a delicious meal delivered straight to your doorstep.'**
  String get no_order_found_two_title;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @re_auth_logout_title.
  ///
  /// In en, this message translates to:
  /// **'To ensure your account\'s security, you have been logged out.If Email Address or Phone Number changed, Please log in again using your updated credentials.'**
  String get re_auth_logout_title;

  /// No description provided for @re_auth_mode_used_one_title.
  ///
  /// In en, this message translates to:
  /// **'You\'re currently using'**
  String get re_auth_mode_used_one_title;

  /// No description provided for @re_auth_email_mode_used_title.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an OTP to your new email address for verification'**
  String get re_auth_email_mode_used_title;

  /// No description provided for @re_auth_phone_mode_used_title.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an OTP to your new mobile number for verification.'**
  String get re_auth_phone_mode_used_title;

  /// No description provided for @re_auth_password_logout_title.
  ///
  /// In en, this message translates to:
  /// **'To ensure your account\'s security, you have been logged out.If Password changed, Please log in again using your updated credentials.'**
  String get re_auth_password_logout_title;

  /// No description provided for @no_tiffin_package_title.
  ///
  /// In en, this message translates to:
  /// **'No Tiffin Subscription Available'**
  String get no_tiffin_package_title;

  /// No description provided for @no_tiffin_package_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Currently, there are no active tiffin subcription. Please add new tiffin subscription'**
  String get no_tiffin_package_sub_title;

  /// No description provided for @no_cash_in_hand_history_title.
  ///
  /// In en, this message translates to:
  /// **'No Cash-In Hand History Found'**
  String get no_cash_in_hand_history_title;

  /// No description provided for @no_history_found_title.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any history yet.'**
  String get no_history_found_title;

  /// No description provided for @no_submited_cash_title.
  ///
  /// In en, this message translates to:
  /// **'No Submitted Cash-In Hand History Found'**
  String get no_submited_cash_title;

  /// No description provided for @no_pos_table_order_commission_found.
  ///
  /// In en, this message translates to:
  /// **'No POS & Table Order Commission History Found'**
  String get no_pos_table_order_commission_found;

  /// No description provided for @no_payout_method_title.
  ///
  /// In en, this message translates to:
  /// **'No Payout Method Found'**
  String get no_payout_method_title;

  /// No description provided for @no_payout_method_sub_title.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any Payout Method Saved yet.'**
  String get no_payout_method_sub_title;

  /// No description provided for @contact_support_team_error.
  ///
  /// In en, this message translates to:
  /// **'Please contact support or check back later for updates.'**
  String get contact_support_team_error;

  /// No description provided for @no_result_found.
  ///
  /// In en, this message translates to:
  /// **'No Result Found'**
  String get no_result_found;

  /// No description provided for @no_transaction_history_title.
  ///
  /// In en, this message translates to:
  /// **'No Transaction History Found'**
  String get no_transaction_history_title;

  /// No description provided for @no_transaction_history_sub_title.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any transactions yet.'**
  String get no_transaction_history_sub_title;

  /// No description provided for @no_withdrawal_history_title.
  ///
  /// In en, this message translates to:
  /// **'No Withdrawal History Found'**
  String get no_withdrawal_history_title;

  /// No description provided for @email_verification_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address we\'ll send you a verification code to reset your password'**
  String get email_verification_title;

  /// No description provided for @password_verified_account_title.
  ///
  /// In en, this message translates to:
  /// **'Your identity has been verified! set your new password'**
  String get password_verified_account_title;

  /// No description provided for @phone_verification_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number we\'ll send you a verification code to reset your password'**
  String get phone_verification_title;

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

  /// No description provided for @no_media_file_title.
  ///
  /// In en, this message translates to:
  /// **'No Media File Available'**
  String get no_media_file_title;

  /// No description provided for @no_media_file_sub_title.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any media files to display. Please check if the file exists or try re-uploading. If the problem persists, contact support for further assistance.'**
  String get no_media_file_sub_title;

  /// No description provided for @choose_addon.
  ///
  /// In en, this message translates to:
  /// **'Choose Addon\'s'**
  String get choose_addon;

  /// No description provided for @choose_dining_categories.
  ///
  /// In en, this message translates to:
  /// **'Choose Dining Categories'**
  String get choose_dining_categories;

  /// No description provided for @select_addon.
  ///
  /// In en, this message translates to:
  /// **'Select Addon\'s'**
  String get select_addon;

  /// No description provided for @account_security_concern.
  ///
  /// In en, this message translates to:
  /// **'Your account security is important to us, and we recommend contacting our support team immediately if you have any concerns.'**
  String get account_security_concern;

  /// No description provided for @resend_otp_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get code? Resend'**
  String get resend_otp_code;

  /// No description provided for @form_coupon_title.
  ///
  /// In en, this message translates to:
  /// **'Coupon Title'**
  String get form_coupon_title;

  /// No description provided for @form_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get form_name;

  /// No description provided for @form_coupon_code.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get form_coupon_code;

  /// No description provided for @form_coupon_limit.
  ///
  /// In en, this message translates to:
  /// **'Coupon Limit'**
  String get form_coupon_limit;

  /// No description provided for @form_start_date.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get form_start_date;

  /// No description provided for @form_expire_date.
  ///
  /// In en, this message translates to:
  /// **'Expire Date'**
  String get form_expire_date;

  /// No description provided for @form_end_date.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get form_end_date;

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

  /// No description provided for @form_country_code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get form_country_code;

  /// No description provided for @form_mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get form_mobile_number;

  /// No description provided for @form_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get form_age;

  /// No description provided for @form_date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'DOB'**
  String get form_date_of_birth;

  /// No description provided for @form_identity_number.
  ///
  /// In en, this message translates to:
  /// **'Identity Number'**
  String get form_identity_number;

  /// No description provided for @form_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get form_time;

  /// No description provided for @select_dining_categories.
  ///
  /// In en, this message translates to:
  /// **'Select Dining Categories'**
  String get select_dining_categories;

  /// No description provided for @form_restaurant_name.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Name'**
  String get form_restaurant_name;

  /// No description provided for @form_short_description.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get form_short_description;

  /// No description provided for @form_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get form_address;

  /// No description provided for @form_cuisine.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get form_cuisine;

  /// No description provided for @form_restaurant_type.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Type'**
  String get form_restaurant_type;

  /// No description provided for @form_restaurant_facilities.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Facilities'**
  String get form_restaurant_facilities;

  /// No description provided for @form_food_license.
  ///
  /// In en, this message translates to:
  /// **'Food License'**
  String get form_food_license;

  /// No description provided for @form_min_order_amount.
  ///
  /// In en, this message translates to:
  /// **'Min Order Amount'**
  String get form_min_order_amount;

  /// No description provided for @form_dish_for_two.
  ///
  /// In en, this message translates to:
  /// **'Dish Price For Two Persion'**
  String get form_dish_for_two;

  /// No description provided for @form_appx_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Approx Delivery Time'**
  String get form_appx_delivery_time;

  /// No description provided for @form_social_fb.
  ///
  /// In en, this message translates to:
  /// **'Social Media Facebook URL'**
  String get form_social_fb;

  /// No description provided for @form_social_instagram.
  ///
  /// In en, this message translates to:
  /// **'Social Media Instagram URL'**
  String get form_social_instagram;

  /// No description provided for @form_social_x.
  ///
  /// In en, this message translates to:
  /// **'Social Media X URL'**
  String get form_social_x;

  /// No description provided for @form_social_youtube.
  ///
  /// In en, this message translates to:
  /// **'Social Media Youtube URL'**
  String get form_social_youtube;

  /// No description provided for @form_social_linkedin.
  ///
  /// In en, this message translates to:
  /// **'Social Media LinkedIn URL'**
  String get form_social_linkedin;

  /// No description provided for @form_social_pinterest.
  ///
  /// In en, this message translates to:
  /// **'Social Media Pinterest URL'**
  String get form_social_pinterest;

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

  /// No description provided for @form_your_mobile.
  ///
  /// In en, this message translates to:
  /// **'Your Mobile Number'**
  String get form_your_mobile;

  /// No description provided for @form_feedback.
  ///
  /// In en, this message translates to:
  /// **'Enter feedback'**
  String get form_feedback;

  /// No description provided for @form_tax_amount.
  ///
  /// In en, this message translates to:
  /// **'Tax Amount'**
  String get form_tax_amount;

  /// No description provided for @form_outlet_name.
  ///
  /// In en, this message translates to:
  /// **'Outlet Name'**
  String get form_outlet_name;

  /// No description provided for @outlet_latitude.
  ///
  /// In en, this message translates to:
  /// **'Outlet Latitude'**
  String get outlet_latitude;

  /// No description provided for @outlet_longitude.
  ///
  /// In en, this message translates to:
  /// **'Outlet Longitude'**
  String get outlet_longitude;

  /// No description provided for @outlet_type.
  ///
  /// In en, this message translates to:
  /// **'Outlet Type'**
  String get outlet_type;

  /// No description provided for @outlet_facilities.
  ///
  /// In en, this message translates to:
  /// **'Outlet Facilities'**
  String get outlet_facilities;

  /// No description provided for @form_start_time.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get form_start_time;

  /// No description provided for @form_end_time.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get form_end_time;

  /// No description provided for @form_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get form_confirm_password;

  /// No description provided for @form_customer_mobile.
  ///
  /// In en, this message translates to:
  /// **'Customer Mobile Number'**
  String get form_customer_mobile;

  /// No description provided for @form_customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get form_customer_name;

  /// No description provided for @form_customer_type.
  ///
  /// In en, this message translates to:
  /// **'Customer Type'**
  String get form_customer_type;

  /// No description provided for @form_discount_type.
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get form_discount_type;

  /// No description provided for @form_discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get form_discount;

  /// No description provided for @form_instruction.
  ///
  /// In en, this message translates to:
  /// **'Instruction'**
  String get form_instruction;

  /// No description provided for @form_package_name.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get form_package_name;

  /// No description provided for @form_package_short_description.
  ///
  /// In en, this message translates to:
  /// **'Package Short Description'**
  String get form_package_short_description;

  /// No description provided for @form_food_included.
  ///
  /// In en, this message translates to:
  /// **'Foods Included'**
  String get form_food_included;

  /// No description provided for @form_delivery_area.
  ///
  /// In en, this message translates to:
  /// **'Delivery Area'**
  String get form_delivery_area;

  /// No description provided for @form_package_price.
  ///
  /// In en, this message translates to:
  /// **'Package Price'**
  String get form_package_price;

  /// No description provided for @form_total_orders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get form_total_orders;

  /// No description provided for @form_off_days.
  ///
  /// In en, this message translates to:
  /// **'Off Days'**
  String get form_off_days;

  /// No description provided for @form_select_payout_method.
  ///
  /// In en, this message translates to:
  /// **'Select Payout Method'**
  String get form_select_payout_method;

  /// No description provided for @form_country_code_name.
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get form_country_code_name;

  /// No description provided for @form_withdrawal_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter Withdrawal Amount'**
  String get form_withdrawal_amount;

  /// No description provided for @form_restaurant_latitude.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Latitude'**
  String get form_restaurant_latitude;

  /// No description provided for @form_restaurant_longitude.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Longitude'**
  String get form_restaurant_longitude;

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

  /// No description provided for @form_category_name.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get form_category_name;

  /// No description provided for @form_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get form_price;

  /// No description provided for @form_select_taxation.
  ///
  /// In en, this message translates to:
  /// **'Select Taxation'**
  String get form_select_taxation;

  /// No description provided for @form_choose_custom_category.
  ///
  /// In en, this message translates to:
  /// **'Choose Custom Category?'**
  String get form_choose_custom_category;

  /// No description provided for @form_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get form_category;

  /// No description provided for @form_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Sub Category'**
  String get form_sub_category;

  /// No description provided for @form_max_purchase_limit.
  ///
  /// In en, this message translates to:
  /// **'Maximum Purchase Quantity Limit'**
  String get form_max_purchase_limit;

  /// No description provided for @form_food_pref.
  ///
  /// In en, this message translates to:
  /// **'Food Preferences'**
  String get form_food_pref;

  /// No description provided for @form_select_addon.
  ///
  /// In en, this message translates to:
  /// **'Select Addons'**
  String get form_select_addon;

  /// No description provided for @form_available_start_time.
  ///
  /// In en, this message translates to:
  /// **'Availability Start Time'**
  String get form_available_start_time;

  /// No description provided for @form_available_end_time.
  ///
  /// In en, this message translates to:
  /// **'Availability End Time'**
  String get form_available_end_time;

  /// No description provided for @form_add_tags.
  ///
  /// In en, this message translates to:
  /// **'Add Tags'**
  String get form_add_tags;

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

  /// No description provided for @form_min_option_select.
  ///
  /// In en, this message translates to:
  /// **'Min Option to Select'**
  String get form_min_option_select;

  /// No description provided for @form_max_option_select.
  ///
  /// In en, this message translates to:
  /// **'Max Option to Select'**
  String get form_max_option_select;

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

  /// No description provided for @form_select_category.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get form_select_category;

  /// No description provided for @form_sub_category_name.
  ///
  /// In en, this message translates to:
  /// **'Sub Category Name'**
  String get form_sub_category_name;

  /// No description provided for @form_expense_amount.
  ///
  /// In en, this message translates to:
  /// **'Expense Amount'**
  String get form_expense_amount;

  /// No description provided for @form_billing_total_amount.
  ///
  /// In en, this message translates to:
  /// **'Billing Total Amount'**
  String get form_billing_total_amount;

  /// No description provided for @form_coupon_discount_amount.
  ///
  /// In en, this message translates to:
  /// **'Coupon Discount Amount'**
  String get form_coupon_discount_amount;

  /// No description provided for @form_cooking_instructions.
  ///
  /// In en, this message translates to:
  /// **'Cooking Instructions'**
  String get form_cooking_instructions;

  /// No description provided for @form_table_number.
  ///
  /// In en, this message translates to:
  /// **'Table Number'**
  String get form_table_number;

  /// No description provided for @form_table_capacity.
  ///
  /// In en, this message translates to:
  /// **'Table Capacity'**
  String get form_table_capacity;

  /// No description provided for @form_menu_name.
  ///
  /// In en, this message translates to:
  /// **'Menu Name'**
  String get form_menu_name;

  /// No description provided for @form_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get form_title;

  /// No description provided for @form_brief.
  ///
  /// In en, this message translates to:
  /// **'Brief'**
  String get form_brief;

  /// No description provided for @form_min_time.
  ///
  /// In en, this message translates to:
  /// **'Min Time'**
  String get form_min_time;

  /// No description provided for @form_max_time.
  ///
  /// In en, this message translates to:
  /// **'Max Time'**
  String get form_max_time;

  /// No description provided for @update_coupon.
  ///
  /// In en, this message translates to:
  /// **'Update Coupon'**
  String get update_coupon;

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

  /// No description provided for @update_deliveryman.
  ///
  /// In en, this message translates to:
  /// **'Update Deliveryman'**
  String get update_deliveryman;

  /// No description provided for @identity_type.
  ///
  /// In en, this message translates to:
  /// **'Identity Type'**
  String get identity_type;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @identity_proof.
  ///
  /// In en, this message translates to:
  /// **'Identity Proof'**
  String get identity_proof;

  /// No description provided for @driving_license.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get driving_license;

  /// No description provided for @dining_bookings.
  ///
  /// In en, this message translates to:
  /// **'Dining Bookings'**
  String get dining_bookings;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @coupon_cover_charge.
  ///
  /// In en, this message translates to:
  /// **'Coupon Cover Charges'**
  String get coupon_cover_charge;

  /// No description provided for @grand_total.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grand_total;

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// No description provided for @reject_booking.
  ///
  /// In en, this message translates to:
  /// **'Reject Booking'**
  String get reject_booking;

  /// No description provided for @accept_booking.
  ///
  /// In en, this message translates to:
  /// **'Accept Booking'**
  String get accept_booking;

  /// No description provided for @mark_as_complete.
  ///
  /// In en, this message translates to:
  /// **'Mark as complete'**
  String get mark_as_complete;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @booking_detail.
  ///
  /// In en, this message translates to:
  /// **'Booking Detail'**
  String get booking_detail;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @number_of_guests.
  ///
  /// In en, this message translates to:
  /// **'Number of guests'**
  String get number_of_guests;

  /// No description provided for @reservation_detail.
  ///
  /// In en, this message translates to:
  /// **'Reservation details'**
  String get reservation_detail;

  /// No description provided for @customer_details.
  ///
  /// In en, this message translates to:
  /// **'Customer details'**
  String get customer_details;

  /// No description provided for @more_details.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get more_details;

  /// No description provided for @billing_summary.
  ///
  /// In en, this message translates to:
  /// **'Billing Summary'**
  String get billing_summary;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @coupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get coupon;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimum;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// No description provided for @your_special_request.
  ///
  /// In en, this message translates to:
  /// **'Your special request'**
  String get your_special_request;

  /// No description provided for @amount_will_adjusted_in_finla_bill.
  ///
  /// In en, this message translates to:
  /// **'This amount will be adjusted in your final bill'**
  String get amount_will_adjusted_in_finla_bill;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @dining_guest_availability.
  ///
  /// In en, this message translates to:
  /// **'Dining Guest Availability'**
  String get dining_guest_availability;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save_changes;

  /// No description provided for @dining_booking_schedule.
  ///
  /// In en, this message translates to:
  /// **'Dining Booking Schedule'**
  String get dining_booking_schedule;

  /// No description provided for @offday.
  ///
  /// In en, this message translates to:
  /// **'Offday'**
  String get offday;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @add_slot_to.
  ///
  /// In en, this message translates to:
  /// **'Add Slot to'**
  String get add_slot_to;

  /// No description provided for @update_slot_to.
  ///
  /// In en, this message translates to:
  /// **'Update Slot to'**
  String get update_slot_to;

  /// No description provided for @select_meal.
  ///
  /// In en, this message translates to:
  /// **'Select meals'**
  String get select_meal;

  /// No description provided for @update_dining_menu.
  ///
  /// In en, this message translates to:
  /// **'Update Dining Menu & Photos'**
  String get update_dining_menu;

  /// No description provided for @update_dining_menu_sub_title.
  ///
  /// In en, this message translates to:
  /// **'distinct dining styles, the restaurant enables customers to easily find the type of atmosphere, service, and cuisine that best suits their needs.'**
  String get update_dining_menu_sub_title;

  /// No description provided for @add_new_menu.
  ///
  /// In en, this message translates to:
  /// **'Add new Menu'**
  String get add_new_menu;

  /// No description provided for @dining_photos.
  ///
  /// In en, this message translates to:
  /// **'Dining Photos'**
  String get dining_photos;

  /// No description provided for @add_new_photo.
  ///
  /// In en, this message translates to:
  /// **'Add new photo'**
  String get add_new_photo;

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @restaurant_logo.
  ///
  /// In en, this message translates to:
  /// **'Restaurant LOGO'**
  String get restaurant_logo;

  /// No description provided for @restaurant_cover.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Cover'**
  String get restaurant_cover;

  /// No description provided for @home_delivery_available.
  ///
  /// In en, this message translates to:
  /// **'Home Delivery Available'**
  String get home_delivery_available;

  /// No description provided for @take_away_available.
  ///
  /// In en, this message translates to:
  /// **'TakeAway Available'**
  String get take_away_available;

  /// No description provided for @schedule_orders.
  ///
  /// In en, this message translates to:
  /// **'Schedule Orders?'**
  String get schedule_orders;

  /// No description provided for @add_expense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get add_expense;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @expense_type.
  ///
  /// In en, this message translates to:
  /// **'Expense Type'**
  String get expense_type;

  /// No description provided for @expense_order_product.
  ///
  /// In en, this message translates to:
  /// **'Order Product Discount'**
  String get expense_order_product;

  /// No description provided for @expense_pos_order_product.
  ///
  /// In en, this message translates to:
  /// **'POS Order Product Discount'**
  String get expense_pos_order_product;

  /// No description provided for @expense_table_order_product.
  ///
  /// In en, this message translates to:
  /// **'Table Order Product Discount'**
  String get expense_table_order_product;

  /// No description provided for @expense_pos_order_extra.
  ///
  /// In en, this message translates to:
  /// **'POS Order Extra Discount'**
  String get expense_pos_order_extra;

  /// No description provided for @expense_table_order_extra.
  ///
  /// In en, this message translates to:
  /// **'Table Order Extra Discount'**
  String get expense_table_order_extra;

  /// No description provided for @expense_dining_booking.
  ///
  /// In en, this message translates to:
  /// **'Dining Booking Discount'**
  String get expense_dining_booking;

  /// No description provided for @expense_order_refund.
  ///
  /// In en, this message translates to:
  /// **'Order Refund'**
  String get expense_order_refund;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

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

  /// No description provided for @dining_booking.
  ///
  /// In en, this message translates to:
  /// **'Dining Booking'**
  String get dining_booking;

  /// No description provided for @total_expense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get total_expense;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

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

  /// No description provided for @add_tax.
  ///
  /// In en, this message translates to:
  /// **'Add Tax'**
  String get add_tax;

  /// No description provided for @kitchen_owner_list.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Owner List'**
  String get kitchen_owner_list;

  /// No description provided for @add_kitchen_owner.
  ///
  /// In en, this message translates to:
  /// **'Add Kitchen Owner'**
  String get add_kitchen_owner;

  /// No description provided for @update_restaurant_menu.
  ///
  /// In en, this message translates to:
  /// **'Update Restaurant Menu & Photos'**
  String get update_restaurant_menu;

  /// No description provided for @mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get mark_all_read;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'Oops! It seems like something unexpected happened. Our team has been notified and is working diligently to resolve the issue. We apologize for any inconvenience this may have caused. Thank you for your patience and understanding'**
  String get unexpected_error;

  /// No description provided for @understand_btn_go_back.
  ///
  /// In en, this message translates to:
  /// **'Okay, I understand, Go Back'**
  String get understand_btn_go_back;

  /// No description provided for @your_outlet.
  ///
  /// In en, this message translates to:
  /// **'Your Outlet'**
  String get your_outlet;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @locality.
  ///
  /// In en, this message translates to:
  /// **'Locality'**
  String get locality;

  /// No description provided for @add_outlet.
  ///
  /// In en, this message translates to:
  /// **'Add Outlet'**
  String get add_outlet;

  /// No description provided for @outlet_logo.
  ///
  /// In en, this message translates to:
  /// **'Outlet LOGO'**
  String get outlet_logo;

  /// No description provided for @outlet_cover.
  ///
  /// In en, this message translates to:
  /// **'Outlet Cover'**
  String get outlet_cover;

  /// No description provided for @google_map_here.
  ///
  /// In en, this message translates to:
  /// **'Google Maps Here'**
  String get google_map_here;

  /// No description provided for @report_emergency_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Kindly use this page to report only serious incidents or accidents. For any order-related inquiries, please reach out to our chat support.'**
  String get report_emergency_sub_title;

  /// No description provided for @submit_message.
  ///
  /// In en, this message translates to:
  /// **'Submit Message'**
  String get submit_message;

  /// No description provided for @your_review_list.
  ///
  /// In en, this message translates to:
  /// **'Your Review List'**
  String get your_review_list;

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

  /// No description provided for @restaurant_opening_closing_schedule.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Opening & Closing Schedules'**
  String get restaurant_opening_closing_schedule;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @profile_info.
  ///
  /// In en, this message translates to:
  /// **'Profile Info'**
  String get profile_info;

  /// No description provided for @update_name_bio.
  ///
  /// In en, this message translates to:
  /// **'Update your name, bio, and profile picture'**
  String get update_name_bio;

  /// No description provided for @alert_pref.
  ///
  /// In en, this message translates to:
  /// **'Alerts & Preferences'**
  String get alert_pref;

  /// No description provided for @alert_pref_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Choose how you receive updates and reminders'**
  String get alert_pref_sub_title;

  /// No description provided for @user_account.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get user_account;

  /// No description provided for @manage_your_login_to_remove_account.
  ///
  /// In en, this message translates to:
  /// **'Manage your login details or remove your account'**
  String get manage_your_login_to_remove_account;

  /// No description provided for @device_access.
  ///
  /// In en, this message translates to:
  /// **'Device Access'**
  String get device_access;

  /// No description provided for @control_access_location_camera_permission.
  ///
  /// In en, this message translates to:
  /// **'Control access to location, camera, and more from your phone settings'**
  String get control_access_location_camera_permission;

  /// No description provided for @app_settings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get app_settings;

  /// No description provided for @change_email.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get change_email;

  /// No description provided for @change_mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Change Mobile Number'**
  String get change_mobile_number;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @newsletters_title.
  ///
  /// In en, this message translates to:
  /// **'Newsletters'**
  String get newsletters_title;

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

  /// No description provided for @social_activity_title.
  ///
  /// In en, this message translates to:
  /// **'Social Activity Alerts'**
  String get social_activity_title;

  /// No description provided for @social_activity_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Be notified when someone follows you, or interacts with your posts and reviews.'**
  String get social_activity_sub_title;

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

  /// No description provided for @account_updates_title.
  ///
  /// In en, this message translates to:
  /// **'Important Account Updates'**
  String get account_updates_title;

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

  /// No description provided for @delete_account_sub_title.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry to see you go! Deleting your account will permanently remove your personal data, order history, saved addresses, payment methods, and preferences from our system.'**
  String get delete_account_sub_title;

  /// No description provided for @update_password.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// No description provided for @your_subscription_package.
  ///
  /// In en, this message translates to:
  /// **'Your Subscription Package'**
  String get your_subscription_package;

  /// No description provided for @pay_using.
  ///
  /// In en, this message translates to:
  /// **'PAY USING'**
  String get pay_using;

  /// No description provided for @renew_now.
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get renew_now;

  /// No description provided for @validity.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get validity;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @order_limit.
  ///
  /// In en, this message translates to:
  /// **'Order Limit'**
  String get order_limit;

  /// No description provided for @per_month.
  ///
  /// In en, this message translates to:
  /// **'Per Month'**
  String get per_month;

  /// No description provided for @product_limit.
  ///
  /// In en, this message translates to:
  /// **'Product Limit'**
  String get product_limit;

  /// No description provided for @pos_permission.
  ///
  /// In en, this message translates to:
  /// **'POS'**
  String get pos_permission;

  /// No description provided for @own_deliveryman_permission.
  ///
  /// In en, this message translates to:
  /// **'Own Deliveryman'**
  String get own_deliveryman_permission;

  /// No description provided for @promote_permission.
  ///
  /// In en, this message translates to:
  /// **'Promote On Entire System'**
  String get promote_permission;

  /// No description provided for @custom_category_permission.
  ///
  /// In en, this message translates to:
  /// **'Custom Category'**
  String get custom_category_permission;

  /// No description provided for @outlet_permission.
  ///
  /// In en, this message translates to:
  /// **'Multi Outlet'**
  String get outlet_permission;

  /// No description provided for @table_booking_permission.
  ///
  /// In en, this message translates to:
  /// **'Table Booking'**
  String get table_booking_permission;

  /// No description provided for @table_order_permission.
  ///
  /// In en, this message translates to:
  /// **'Table Order'**
  String get table_order_permission;

  /// No description provided for @tiffin_subcription_permission.
  ///
  /// In en, this message translates to:
  /// **'Subscription / Tiffin Service'**
  String get tiffin_subcription_permission;

  /// No description provided for @waiter_service_permission.
  ///
  /// In en, this message translates to:
  /// **'Waiter Service'**
  String get waiter_service_permission;

  /// No description provided for @own_kitchen_owner_permission.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Owners'**
  String get own_kitchen_owner_permission;

  /// No description provided for @table_order_list.
  ///
  /// In en, this message translates to:
  /// **'Table Order List'**
  String get table_order_list;

  /// No description provided for @add_table.
  ///
  /// In en, this message translates to:
  /// **'Add Table'**
  String get add_table;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get order_number;

  /// No description provided for @guest_customer.
  ///
  /// In en, this message translates to:
  /// **'Guest Customer'**
  String get guest_customer;

  /// No description provided for @table_number.
  ///
  /// In en, this message translates to:
  /// **'Table No'**
  String get table_number;

  /// No description provided for @total_bill.
  ///
  /// In en, this message translates to:
  /// **'Total Bill'**
  String get total_bill;

  /// No description provided for @print_table_qr.
  ///
  /// In en, this message translates to:
  /// **'Print Table QR'**
  String get print_table_qr;

  /// No description provided for @pair_bluetooth_devices.
  ///
  /// In en, this message translates to:
  /// **'Paired Bluetooth Devices'**
  String get pair_bluetooth_devices;

  /// No description provided for @print_size.
  ///
  /// In en, this message translates to:
  /// **'Print Size'**
  String get print_size;

  /// No description provided for @printing_progress.
  ///
  /// In en, this message translates to:
  /// **'Printing.....'**
  String get printing_progress;

  /// No description provided for @print_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Print QR Code'**
  String get print_qr_code;

  /// No description provided for @scan_qr_code_to_place_order.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code to place order'**
  String get scan_qr_code_to_place_order;

  /// No description provided for @order_detail.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get order_detail;

  /// No description provided for @cash_payment.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get cash_payment;

  /// No description provided for @online_payment.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get online_payment;

  /// No description provided for @complete_order.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get complete_order;

  /// No description provided for @table_list.
  ///
  /// In en, this message translates to:
  /// **'Table List'**
  String get table_list;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @order_ref.
  ///
  /// In en, this message translates to:
  /// **'Order Reference'**
  String get order_ref;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @order_charges.
  ///
  /// In en, this message translates to:
  /// **'Order Charges'**
  String get order_charges;

  /// No description provided for @package_list.
  ///
  /// In en, this message translates to:
  /// **'Package List'**
  String get package_list;

  /// No description provided for @total_food.
  ///
  /// In en, this message translates to:
  /// **'Total Food'**
  String get total_food;

  /// No description provided for @total_purchase.
  ///
  /// In en, this message translates to:
  /// **'Total Purchase'**
  String get total_purchase;

  /// No description provided for @on_hold.
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get on_hold;

  /// No description provided for @purchaser.
  ///
  /// In en, this message translates to:
  /// **'Purchaser'**
  String get purchaser;

  /// No description provided for @add_package.
  ///
  /// In en, this message translates to:
  /// **'Add Package'**
  String get add_package;

  /// No description provided for @can_select_addon.
  ///
  /// In en, this message translates to:
  /// **'Can Select Addon'**
  String get can_select_addon;

  /// No description provided for @can_select_variation.
  ///
  /// In en, this message translates to:
  /// **'Can Select Variation'**
  String get can_select_variation;

  /// No description provided for @support_only.
  ///
  /// In en, this message translates to:
  /// **'Support Only'**
  String get support_only;

  /// No description provided for @total_days.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get total_days;

  /// No description provided for @available_slots.
  ///
  /// In en, this message translates to:
  /// **'Availability Slots'**
  String get available_slots;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @package_instruction.
  ///
  /// In en, this message translates to:
  /// **'Package Instructions'**
  String get package_instruction;

  /// No description provided for @all_purchased.
  ///
  /// In en, this message translates to:
  /// **'All Purchased'**
  String get all_purchased;

  /// No description provided for @home_delivery.
  ///
  /// In en, this message translates to:
  /// **'Home Delivery'**
  String get home_delivery;

  /// No description provided for @self_pickup.
  ///
  /// In en, this message translates to:
  /// **'Self Pickup'**
  String get self_pickup;

  /// No description provided for @purchase_detail.
  ///
  /// In en, this message translates to:
  /// **'Purchase Details'**
  String get purchase_detail;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @purchase_charge.
  ///
  /// In en, this message translates to:
  /// **'Purchase Charges'**
  String get purchase_charge;

  /// No description provided for @purchase_id.
  ///
  /// In en, this message translates to:
  /// **'Purchase ID'**
  String get purchase_id;

  /// No description provided for @receiver.
  ///
  /// In en, this message translates to:
  /// **'Receiver'**
  String get receiver;

  /// No description provided for @deliver_to.
  ///
  /// In en, this message translates to:
  /// **'Deliver To'**
  String get deliver_to;

  /// No description provided for @delivery_instruction.
  ///
  /// In en, this message translates to:
  /// **'Delivery Instruction'**
  String get delivery_instruction;

  /// No description provided for @waiter_list.
  ///
  /// In en, this message translates to:
  /// **'Waiter List'**
  String get waiter_list;

  /// No description provided for @add_waiter.
  ///
  /// In en, this message translates to:
  /// **'Add Waiter'**
  String get add_waiter;

  /// No description provided for @total_earning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get total_earning;

  /// No description provided for @wallet_balance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get wallet_balance;

  /// No description provided for @cash_in_hand.
  ///
  /// In en, this message translates to:
  /// **'Cash In-Hand'**
  String get cash_in_hand;

  /// No description provided for @cash_in_hand_history.
  ///
  /// In en, this message translates to:
  /// **'Cash In-Hand History'**
  String get cash_in_hand_history;

  /// No description provided for @submitted_cash_history.
  ///
  /// In en, this message translates to:
  /// **'Submitted Cash History'**
  String get submitted_cash_history;

  /// No description provided for @pos_table_order_commission.
  ///
  /// In en, this message translates to:
  /// **'POS & Table Order Commission'**
  String get pos_table_order_commission;

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

  /// No description provided for @wallet_credit_amount.
  ///
  /// In en, this message translates to:
  /// **'Wallet Credit Amount'**
  String get wallet_credit_amount;

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

  /// No description provided for @wallet_detail.
  ///
  /// In en, this message translates to:
  /// **'Wallet Detail'**
  String get wallet_detail;

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

  /// No description provided for @manage_payout_method.
  ///
  /// In en, this message translates to:
  /// **'Manage Payout Method'**
  String get manage_payout_method;

  /// No description provided for @deposite.
  ///
  /// In en, this message translates to:
  /// **'Deposite'**
  String get deposite;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

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

  /// No description provided for @add_payout_method.
  ///
  /// In en, this message translates to:
  /// **'Add Payout Method'**
  String get add_payout_method;

  /// No description provided for @uploading_progress.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading_progress;

  /// No description provided for @coupon_added.
  ///
  /// In en, this message translates to:
  /// **'Coupon added'**
  String get coupon_added;

  /// No description provided for @coupon_updated.
  ///
  /// In en, this message translates to:
  /// **'Coupon updated'**
  String get coupon_updated;

  /// No description provided for @deliveryman_added.
  ///
  /// In en, this message translates to:
  /// **'Deliveryman added'**
  String get deliveryman_added;

  /// No description provided for @deliveryman_updated.
  ///
  /// In en, this message translates to:
  /// **'Deliveryman updated'**
  String get deliveryman_updated;

  /// No description provided for @booking_accepted.
  ///
  /// In en, this message translates to:
  /// **'Booking Accepted'**
  String get booking_accepted;

  /// No description provided for @booking_rejected.
  ///
  /// In en, this message translates to:
  /// **'Booking Rejected'**
  String get booking_rejected;

  /// No description provided for @booking_completed.
  ///
  /// In en, this message translates to:
  /// **'Booking Completed'**
  String get booking_completed;

  /// No description provided for @verification_failed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verification_failed;

  /// No description provided for @no_orders.
  ///
  /// In en, this message translates to:
  /// **'No Orders'**
  String get no_orders;

  /// No description provided for @guest_availability_updated.
  ///
  /// In en, this message translates to:
  /// **'Guest Availability Updated'**
  String get guest_availability_updated;

  /// No description provided for @slot_updated.
  ///
  /// In en, this message translates to:
  /// **'Slot Updated'**
  String get slot_updated;

  /// No description provided for @setting_saved.
  ///
  /// In en, this message translates to:
  /// **'Setting Saved!'**
  String get setting_saved;

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

  /// No description provided for @detail_updated.
  ///
  /// In en, this message translates to:
  /// **'Detail Updated'**
  String get detail_updated;

  /// No description provided for @feedback_saved.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback is saved'**
  String get feedback_saved;

  /// No description provided for @taxation_deleted.
  ///
  /// In en, this message translates to:
  /// **'Taxation Deleted'**
  String get taxation_deleted;

  /// No description provided for @kitchen_owner_added.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Owner added'**
  String get kitchen_owner_added;

  /// No description provided for @kitchen_owner_updated.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Owner updated'**
  String get kitchen_owner_updated;

  /// No description provided for @order_rejected.
  ///
  /// In en, this message translates to:
  /// **'Order Rejected'**
  String get order_rejected;

  /// No description provided for @order_accepted.
  ///
  /// In en, this message translates to:
  /// **'Order Accepted'**
  String get order_accepted;

  /// No description provided for @order_ready.
  ///
  /// In en, this message translates to:
  /// **'Order Ready'**
  String get order_ready;

  /// No description provided for @order_handover.
  ///
  /// In en, this message translates to:
  /// **'Order Handover'**
  String get order_handover;

  /// No description provided for @otp_sent.
  ///
  /// In en, this message translates to:
  /// **'OTP Sent'**
  String get otp_sent;

  /// No description provided for @file_downloaded_to.
  ///
  /// In en, this message translates to:
  /// **'File Downloaded to'**
  String get file_downloaded_to;

  /// No description provided for @complaint_registered.
  ///
  /// In en, this message translates to:
  /// **'Complaint Registered'**
  String get complaint_registered;

  /// No description provided for @image_deleted.
  ///
  /// In en, this message translates to:
  /// **'Image Deleted'**
  String get image_deleted;

  /// No description provided for @image_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Image Uploaded'**
  String get image_uploaded;

  /// No description provided for @table_added.
  ///
  /// In en, this message translates to:
  /// **'New Table Added'**
  String get table_added;

  /// No description provided for @table_updated.
  ///
  /// In en, this message translates to:
  /// **'Table Updated'**
  String get table_updated;

  /// No description provided for @outlet_saved.
  ///
  /// In en, this message translates to:
  /// **'Outlet Saved'**
  String get outlet_saved;

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

  /// No description provided for @tiffin_subscription_added.
  ///
  /// In en, this message translates to:
  /// **'Tiffin Subscription added'**
  String get tiffin_subscription_added;

  /// No description provided for @tiffin_subscription_updated.
  ///
  /// In en, this message translates to:
  /// **'Tiffin Subscription updated'**
  String get tiffin_subscription_updated;

  /// No description provided for @waiter_added.
  ///
  /// In en, this message translates to:
  /// **'Waiter added'**
  String get waiter_added;

  /// No description provided for @waiter_updated.
  ///
  /// In en, this message translates to:
  /// **'Waiter updated'**
  String get waiter_updated;

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

  /// No description provided for @request_sent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get request_sent;

  /// No description provided for @removed_from_campaign.
  ///
  /// In en, this message translates to:
  /// **'Removed from campaign'**
  String get removed_from_campaign;

  /// No description provided for @expense_saved.
  ///
  /// In en, this message translates to:
  /// **'Expense Saved'**
  String get expense_saved;

  /// No description provided for @category_added.
  ///
  /// In en, this message translates to:
  /// **'Category added!'**
  String get category_added;

  /// No description provided for @category_updated.
  ///
  /// In en, this message translates to:
  /// **'Category updated!'**
  String get category_updated;

  /// No description provided for @food_added.
  ///
  /// In en, this message translates to:
  /// **'Food added!'**
  String get food_added;

  /// No description provided for @food_updated.
  ///
  /// In en, this message translates to:
  /// **'Food updated!'**
  String get food_updated;

  /// No description provided for @sub_category_added.
  ///
  /// In en, this message translates to:
  /// **'Sub Category added!'**
  String get sub_category_added;

  /// No description provided for @sub_category_updated.
  ///
  /// In en, this message translates to:
  /// **'Sub Category updated!'**
  String get sub_category_updated;

  /// No description provided for @sure_to_block.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to blocked'**
  String get sure_to_block;

  /// No description provided for @block_deliveryman.
  ///
  /// In en, this message translates to:
  /// **'deliveryman?'**
  String get block_deliveryman;

  /// No description provided for @yes_blocked.
  ///
  /// In en, this message translates to:
  /// **'Yes blocked'**
  String get yes_blocked;

  /// No description provided for @alert_slot_removed.
  ///
  /// In en, this message translates to:
  /// **'If yes this slot will be removed from the system and the action cannot be undone'**
  String get alert_slot_removed;

  /// No description provided for @yes_delete_btn.
  ///
  /// In en, this message translates to:
  /// **'Yes Delete'**
  String get yes_delete_btn;

  /// No description provided for @alert_taxation_removed.
  ///
  /// In en, this message translates to:
  /// **'If yes this taxation will be removed from the system and the action cannot be undone'**
  String get alert_taxation_removed;

  /// No description provided for @block_kitchen_owner.
  ///
  /// In en, this message translates to:
  /// **'kitchen owner?'**
  String get block_kitchen_owner;

  /// No description provided for @alert_delete_account_title.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want to Delete Your Account?'**
  String get alert_delete_account_title;

  /// No description provided for @alert_delete_account_sub_title.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data, including order history, subscriptions, wallet balance, saved addresses, and payment methods, will be permanently deleted.'**
  String get alert_delete_account_sub_title;

  /// No description provided for @alert_remove_cart_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this item from your cart? This action cannot be undone.'**
  String get alert_remove_cart_title;

  /// No description provided for @alert_yes_remove.
  ///
  /// In en, this message translates to:
  /// **'Yes Remove'**
  String get alert_yes_remove;

  /// No description provided for @block_table.
  ///
  /// In en, this message translates to:
  /// **'table?'**
  String get block_table;

  /// No description provided for @alert_remove_table_title.
  ///
  /// In en, this message translates to:
  /// **'If yes this table will be removed from the system and the action cannot be undone'**
  String get alert_remove_table_title;

  /// No description provided for @block_waiter.
  ///
  /// In en, this message translates to:
  /// **'waiter?'**
  String get block_waiter;

  /// No description provided for @alert_update_payout_method_title.
  ///
  /// In en, this message translates to:
  /// **'Update Default Payout Method'**
  String get alert_update_payout_method_title;

  /// No description provided for @alert_update_payout_method_sub_title.
  ///
  /// In en, this message translates to:
  /// **'This will update your default payout method. Are you sure you want to proceed?'**
  String get alert_update_payout_method_sub_title;

  /// No description provided for @yes_update_btn.
  ///
  /// In en, this message translates to:
  /// **'Yes Update'**
  String get yes_update_btn;

  /// No description provided for @block_payout_method.
  ///
  /// In en, this message translates to:
  /// **'this payout method?'**
  String get block_payout_method;

  /// No description provided for @alert_confirm_leave_campaign.
  ///
  /// In en, this message translates to:
  /// **'If yes this you will be removed from campaign and action cannot be undone'**
  String get alert_confirm_leave_campaign;

  /// No description provided for @alert_yes_leave_campaign.
  ///
  /// In en, this message translates to:
  /// **'Yes, Leave Campaign!'**
  String get alert_yes_leave_campaign;

  /// No description provided for @alert_confirm_update_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to update'**
  String get alert_confirm_update_title;

  /// No description provided for @block_stock.
  ///
  /// In en, this message translates to:
  /// **'stock?'**
  String get block_stock;

  /// No description provided for @block_addon.
  ///
  /// In en, this message translates to:
  /// **'addon?'**
  String get block_addon;

  /// No description provided for @alert_confirm_delete_category.
  ///
  /// In en, this message translates to:
  /// **'If yes this category will be removed from the system and the action cannot be undone'**
  String get alert_confirm_delete_category;

  /// No description provided for @alert_confirm_delete_sub_category.
  ///
  /// In en, this message translates to:
  /// **'If yes this sub category will be removed from the system and the action cannot be undone'**
  String get alert_confirm_delete_sub_category;

  /// No description provided for @alert_restaurant_close_title.
  ///
  /// In en, this message translates to:
  /// **'Temporary Restaurant Closure'**
  String get alert_restaurant_close_title;

  /// No description provided for @alert_restaurant_close_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to temporarily close your restaurant? You can reopen it anytime.'**
  String get alert_restaurant_close_sub_title;

  /// No description provided for @alert_confirm_close_temp.
  ///
  /// In en, this message translates to:
  /// **'Yes, Close Temporary'**
  String get alert_confirm_close_temp;

  /// No description provided for @alert_confirm_schedule_order_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Scheduled Orders'**
  String get alert_confirm_schedule_order_title;

  /// No description provided for @alert_confirm_schedule_order_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this schedule orders? Once Accepted, they cannot be modified. Please review your selections carefully.'**
  String get alert_confirm_schedule_order_sub_title;

  /// No description provided for @alert_confirm_accept.
  ///
  /// In en, this message translates to:
  /// **'Yes Accept'**
  String get alert_confirm_accept;

  /// No description provided for @alert_collect_cash_title.
  ///
  /// In en, this message translates to:
  /// **'Please collect cash'**
  String get alert_collect_cash_title;

  /// No description provided for @alert_collect_cash_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Since customer choose cash on delivery payment, Please collect cash from customer'**
  String get alert_collect_cash_sub_title;

  /// No description provided for @collect_cash_btn.
  ///
  /// In en, this message translates to:
  /// **'Collect Cash'**
  String get collect_cash_btn;

  /// No description provided for @order_by.
  ///
  /// In en, this message translates to:
  /// **'order by'**
  String get order_by;

  /// No description provided for @email_otp_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and otp for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get email_otp_login_title;

  /// No description provided for @social_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in with social account'**
  String get social_sign_in;

  /// No description provided for @apple_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign In'**
  String get apple_sign_in;

  /// No description provided for @please_wait_progress.
  ///
  /// In en, this message translates to:
  /// **'Please wait....'**
  String get please_wait_progress;

  /// No description provided for @google_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Google Sign In'**
  String get google_sign_in;

  /// No description provided for @facebook_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Facebook Sign In'**
  String get facebook_sign_in;

  /// No description provided for @phone_otp_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and otp for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get phone_otp_login_title;

  /// No description provided for @phone_password_login_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and password for sign-in. Feast at Your Fingertips: Seamless Login for Savory Delights!'**
  String get phone_password_login_title;

  /// No description provided for @register_as_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Partner with us as a restaurant'**
  String get register_as_restaurant;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @commission_system.
  ///
  /// In en, this message translates to:
  /// **'Commission-Based System'**
  String get commission_system;

  /// No description provided for @commission_system_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Pay a small percentage for each order placed through our platform. This model requires no upfront costs, making it perfect for restaurants looking to grow gradually. Only pay when you earn!'**
  String get commission_system_sub_title;

  /// No description provided for @subscription_system.
  ///
  /// In en, this message translates to:
  /// **'Subscription-Based System'**
  String get subscription_system;

  /// No description provided for @subscription_system_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Choose a flat monthly or yearly fee for unlimited orders. This model is ideal for high-volume restaurants seeking predictable expenses and full control over their profits.'**
  String get subscription_system_sub_title;

  /// No description provided for @choose_subscription_package.
  ///
  /// In en, this message translates to:
  /// **'Choose Subscription Package'**
  String get choose_subscription_package;

  /// No description provided for @enjoy.
  ///
  /// In en, this message translates to:
  /// **'Enjoy'**
  String get enjoy;

  /// No description provided for @a.
  ///
  /// In en, this message translates to:
  /// **'a'**
  String get a;

  /// No description provided for @trial_started.
  ///
  /// In en, this message translates to:
  /// **'day free trial to get started.'**
  String get trial_started;

  /// No description provided for @commission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

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

  /// No description provided for @thank_you_btn.
  ///
  /// In en, this message translates to:
  /// **'Ok, Thank you'**
  String get thank_you_btn;

  /// No description provided for @order_insight.
  ///
  /// In en, this message translates to:
  /// **'Orders Insight'**
  String get order_insight;

  /// No description provided for @pos_insight.
  ///
  /// In en, this message translates to:
  /// **'POS Insight'**
  String get pos_insight;

  /// No description provided for @table_order_insight.
  ///
  /// In en, this message translates to:
  /// **'Table Orders Insight'**
  String get table_order_insight;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @get_result.
  ///
  /// In en, this message translates to:
  /// **'Get Results'**
  String get get_result;

  /// No description provided for @trending_food_items.
  ///
  /// In en, this message translates to:
  /// **'Trending Food Items'**
  String get trending_food_items;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @total_sales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get total_sales;

  /// No description provided for @avg_sales.
  ///
  /// In en, this message translates to:
  /// **'Avg. Sales'**
  String get avg_sales;

  /// No description provided for @chart_orders.
  ///
  /// In en, this message translates to:
  /// **'Chart Orders'**
  String get chart_orders;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @restaurant_campaign.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Campaign'**
  String get restaurant_campaign;

  /// No description provided for @dining_campaign.
  ///
  /// In en, this message translates to:
  /// **'Dining Campaign'**
  String get dining_campaign;

  /// No description provided for @food_campaign.
  ///
  /// In en, this message translates to:
  /// **'Food Campaign'**
  String get food_campaign;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @leave_campaign.
  ///
  /// In en, this message translates to:
  /// **'Leave Campaign'**
  String get leave_campaign;

  /// No description provided for @join_campaign.
  ///
  /// In en, this message translates to:
  /// **'Join Campaign'**
  String get join_campaign;

  /// No description provided for @total_addon.
  ///
  /// In en, this message translates to:
  /// **'Total Addons'**
  String get total_addon;

  /// No description provided for @total_variation.
  ///
  /// In en, this message translates to:
  /// **'Total Variations'**
  String get total_variation;

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

  /// No description provided for @maintenance_title.
  ///
  /// In en, this message translates to:
  /// **'Apology for the Inconvenience'**
  String get maintenance_title;

  /// No description provided for @maintenance_sub_title.
  ///
  /// In en, this message translates to:
  /// **'We\'re currently undergoing scheduled maintenance to improve our services. We apologize for any inconvenience this may cause. Thank you for your patience. If you have urgent issues, please contact our support team at '**
  String get maintenance_sub_title;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @not_found_title.
  ///
  /// In en, this message translates to:
  /// **'Broken Content'**
  String get not_found_title;

  /// No description provided for @not_found_sub_title.
  ///
  /// In en, this message translates to:
  /// **'If there are links on a website pointing to non-existent pages, users may encounter 404 errors when trying to access those links.'**
  String get not_found_sub_title;

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

  /// No description provided for @image_gallery.
  ///
  /// In en, this message translates to:
  /// **'Image Gallery'**
  String get image_gallery;

  /// No description provided for @upload_files.
  ///
  /// In en, this message translates to:
  /// **'Upload files'**
  String get upload_files;

  /// No description provided for @set_image.
  ///
  /// In en, this message translates to:
  /// **'Set image'**
  String get set_image;

  /// No description provided for @upload_and_save.
  ///
  /// In en, this message translates to:
  /// **'Upload & Save'**
  String get upload_and_save;

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get load_more;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @in_stock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get in_stock;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @recommend.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get recommend;

  /// No description provided for @add_taxation.
  ///
  /// In en, this message translates to:
  /// **'Add Taxation'**
  String get add_taxation;

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

  /// No description provided for @add_new_option.
  ///
  /// In en, this message translates to:
  /// **'Add New Option'**
  String get add_new_option;

  /// No description provided for @media_files.
  ///
  /// In en, this message translates to:
  /// **'Media Files'**
  String get media_files;

  /// No description provided for @bill_summary.
  ///
  /// In en, this message translates to:
  /// **'Bill Summary'**
  String get bill_summary;

  /// No description provided for @item_total.
  ///
  /// In en, this message translates to:
  /// **'Item Total'**
  String get item_total;

  /// No description provided for @item_discount.
  ///
  /// In en, this message translates to:
  /// **'Item Discount'**
  String get item_discount;

  /// No description provided for @sub_total.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get sub_total;

  /// No description provided for @food_service_charge.
  ///
  /// In en, this message translates to:
  /// **'Food Service Charge'**
  String get food_service_charge;

  /// No description provided for @service_charge.
  ///
  /// In en, this message translates to:
  /// **'Service Charge'**
  String get service_charge;

  /// No description provided for @extra_service_charge.
  ///
  /// In en, this message translates to:
  /// **'Extra Service Charge'**
  String get extra_service_charge;

  /// No description provided for @delivery_charge.
  ///
  /// In en, this message translates to:
  /// **'Delivery Charge'**
  String get delivery_charge;

  /// No description provided for @delivery_partner_tip.
  ///
  /// In en, this message translates to:
  /// **'Delivery Partner Tip'**
  String get delivery_partner_tip;

  /// No description provided for @packaging_charge.
  ///
  /// In en, this message translates to:
  /// **'Packaging Charge'**
  String get packaging_charge;

  /// No description provided for @packaging_charge_tax.
  ///
  /// In en, this message translates to:
  /// **'Packaging Charge Tax'**
  String get packaging_charge_tax;

  /// No description provided for @waiter_tip.
  ///
  /// In en, this message translates to:
  /// **'Waiter Tip'**
  String get waiter_tip;

  /// No description provided for @coupon_discount.
  ///
  /// In en, this message translates to:
  /// **'Coupon Discount'**
  String get coupon_discount;

  /// No description provided for @wallet_money.
  ///
  /// In en, this message translates to:
  /// **'Wallet Money'**
  String get wallet_money;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @select_reason.
  ///
  /// In en, this message translates to:
  /// **'Select Reason'**
  String get select_reason;

  /// No description provided for @complete_dining_booking.
  ///
  /// In en, this message translates to:
  /// **'Complete Dining Booking'**
  String get complete_dining_booking;

  /// No description provided for @select_dining_coupon_discount.
  ///
  /// In en, this message translates to:
  /// **'Select Dining Coupon Discount'**
  String get select_dining_coupon_discount;

  /// No description provided for @total_billing.
  ///
  /// In en, this message translates to:
  /// **'Total Billing'**
  String get total_billing;

  /// No description provided for @choose_category.
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get choose_category;

  /// No description provided for @choose_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Choose Sub Category'**
  String get choose_sub_category;

  /// No description provided for @offline_reason.
  ///
  /// In en, this message translates to:
  /// **'Offline reason'**
  String get offline_reason;

  /// No description provided for @choose_dining_settings.
  ///
  /// In en, this message translates to:
  /// **'Choose Dining Settings'**
  String get choose_dining_settings;

  /// No description provided for @set_dining_schedule.
  ///
  /// In en, this message translates to:
  /// **'Set Dining Schedule'**
  String get set_dining_schedule;

  /// No description provided for @set_dining_guest_availability.
  ///
  /// In en, this message translates to:
  /// **'Set Dining Guest Availability'**
  String get set_dining_guest_availability;

  /// No description provided for @find_deliveryman_near_you.
  ///
  /// In en, this message translates to:
  /// **'Find Driver Near You'**
  String get find_deliveryman_near_you;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @verification_code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verification_code;

  /// No description provided for @verification_code_sent_to.
  ///
  /// In en, this message translates to:
  /// **'A verification code has sent to'**
  String get verification_code_sent_to;

  /// No description provided for @check_mobile_sms_box.
  ///
  /// In en, this message translates to:
  /// **'Please check your SMS inbox and enter the verification code below to verify your mobile number.'**
  String get check_mobile_sms_box;

  /// No description provided for @select_any_one_option.
  ///
  /// In en, this message translates to:
  /// **'Select any 1 option'**
  String get select_any_one_option;

  /// No description provided for @select_min.
  ///
  /// In en, this message translates to:
  /// **'Select min'**
  String get select_min;

  /// No description provided for @and_upto.
  ///
  /// In en, this message translates to:
  /// **'and upto'**
  String get and_upto;

  /// No description provided for @only.
  ///
  /// In en, this message translates to:
  /// **'Only'**
  String get only;

  /// No description provided for @item_available.
  ///
  /// In en, this message translates to:
  /// **'item available'**
  String get item_available;

  /// No description provided for @out_of_stock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get out_of_stock;

  /// No description provided for @addon.
  ///
  /// In en, this message translates to:
  /// **'Add On'**
  String get addon;

  /// No description provided for @total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get add_to_cart;

  /// No description provided for @select_food_taxation.
  ///
  /// In en, this message translates to:
  /// **'Select Food Taxation'**
  String get select_food_taxation;

  /// No description provided for @repeat_customization.
  ///
  /// In en, this message translates to:
  /// **'Repeat last used customization?'**
  String get repeat_customization;

  /// No description provided for @add_new_customization.
  ///
  /// In en, this message translates to:
  /// **'Add new customisation'**
  String get add_new_customization;

  /// No description provided for @add_menu.
  ///
  /// In en, this message translates to:
  /// **'Add Menu'**
  String get add_menu;

  /// No description provided for @order_complaints.
  ///
  /// In en, this message translates to:
  /// **'Order Complaints'**
  String get order_complaints;

  /// No description provided for @complaint_to.
  ///
  /// In en, this message translates to:
  /// **'Complaint to'**
  String get complaint_to;

  /// No description provided for @complaint_title.
  ///
  /// In en, this message translates to:
  /// **'Complaint Title'**
  String get complaint_title;

  /// No description provided for @complaint_brief.
  ///
  /// In en, this message translates to:
  /// **'Complaint Brief'**
  String get complaint_brief;

  /// No description provided for @upload_max_images.
  ///
  /// In en, this message translates to:
  /// **'Upload Image Proof Max 3 Images'**
  String get upload_max_images;

  /// No description provided for @upload_proof.
  ///
  /// In en, this message translates to:
  /// **'Upload Proof'**
  String get upload_proof;

  /// No description provided for @order_help.
  ///
  /// In en, this message translates to:
  /// **'Order Help'**
  String get order_help;

  /// No description provided for @print_invoice.
  ///
  /// In en, this message translates to:
  /// **'Print Invoice'**
  String get print_invoice;

  /// No description provided for @download_invoice.
  ///
  /// In en, this message translates to:
  /// **'Download invoice'**
  String get download_invoice;

  /// No description provided for @download_summary.
  ///
  /// In en, this message translates to:
  /// **'Download summary'**
  String get download_summary;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @verify_otp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verify_otp;

  /// No description provided for @enter_verification.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification'**
  String get enter_verification;

  /// No description provided for @otp_code_length.
  ///
  /// In en, this message translates to:
  /// **'characters OTP code'**
  String get otp_code_length;

  /// No description provided for @please_ask.
  ///
  /// In en, this message translates to:
  /// **'Please ask'**
  String get please_ask;

  /// No description provided for @check_verification_code.
  ///
  /// In en, this message translates to:
  /// **'to check order detail and enter the verification code below to verify order.'**
  String get check_verification_code;

  /// No description provided for @cash_on_delivery.
  ///
  /// In en, this message translates to:
  /// **'Cash On Delivery'**
  String get cash_on_delivery;

  /// No description provided for @paid_online.
  ///
  /// In en, this message translates to:
  /// **'Paid Online'**
  String get paid_online;

  /// No description provided for @collect_cash_from_customer.
  ///
  /// In en, this message translates to:
  /// **'Please collect cash from customer'**
  String get collect_cash_from_customer;

  /// No description provided for @check_email_box.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and enter the verification code below to verify your email address.'**
  String get check_email_box;

  /// No description provided for @pay_total.
  ///
  /// In en, this message translates to:
  /// **'Pay total'**
  String get pay_total;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @food_tax.
  ///
  /// In en, this message translates to:
  /// **'Food Tax'**
  String get food_tax;

  /// No description provided for @platform_fee.
  ///
  /// In en, this message translates to:
  /// **'Platform Fee'**
  String get platform_fee;

  /// No description provided for @delivery_fee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get delivery_fee;

  /// No description provided for @extra_charge.
  ///
  /// In en, this message translates to:
  /// **'Extra Charge'**
  String get extra_charge;

  /// No description provided for @paid_by.
  ///
  /// In en, this message translates to:
  /// **'Paid By'**
  String get paid_by;

  /// No description provided for @thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thank_you;

  /// No description provided for @visit_again.
  ///
  /// In en, this message translates to:
  /// **'Visit again'**
  String get visit_again;

  /// No description provided for @all_right_reserved.
  ///
  /// In en, this message translates to:
  /// **'All right reserved'**
  String get all_right_reserved;

  /// No description provided for @select_cuisine.
  ///
  /// In en, this message translates to:
  /// **'Select Cuisine'**
  String get select_cuisine;

  /// No description provided for @change_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Change Deliverytime'**
  String get change_delivery_time;

  /// No description provided for @select_deliveryman.
  ///
  /// In en, this message translates to:
  /// **'Select Driver'**
  String get select_deliveryman;

  /// No description provided for @select_restaurant_facilities.
  ///
  /// In en, this message translates to:
  /// **'Select Restaurant Facilities'**
  String get select_restaurant_facilities;

  /// No description provided for @select_restaurant_type.
  ///
  /// In en, this message translates to:
  /// **'Select Restaurant Type'**
  String get select_restaurant_type;

  /// No description provided for @select_food_for_tiffin_packages.
  ///
  /// In en, this message translates to:
  /// **'Select foods for tiffin subscription'**
  String get select_food_for_tiffin_packages;

  /// No description provided for @addons.
  ///
  /// In en, this message translates to:
  /// **'Addons'**
  String get addons;

  /// No description provided for @variation.
  ///
  /// In en, this message translates to:
  /// **'Variation'**
  String get variation;

  /// No description provided for @add_update_off_days_tiffin_packages.
  ///
  /// In en, this message translates to:
  /// **'Add / Update Offdays to Tiffin Subscription'**
  String get add_update_off_days_tiffin_packages;

  /// No description provided for @withdrawal_history_detail.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal History Detail'**
  String get withdrawal_history_detail;

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

  /// No description provided for @payout_creds.
  ///
  /// In en, this message translates to:
  /// **'Payout Credential'**
  String get payout_creds;

  /// No description provided for @approval_notes.
  ///
  /// In en, this message translates to:
  /// **'Approval Note'**
  String get approval_notes;

  /// No description provided for @rejection_notes.
  ///
  /// In en, this message translates to:
  /// **'Rejected Notes'**
  String get rejection_notes;

  /// No description provided for @account_blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get account_blocked;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @accept_order.
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get accept_order;

  /// No description provided for @prepare_schedule_order.
  ///
  /// In en, this message translates to:
  /// **'Prepare Schedule Order'**
  String get prepare_schedule_order;

  /// No description provided for @riders_nearby.
  ///
  /// In en, this message translates to:
  /// **'riders nearby, assigning one soon'**
  String get riders_nearby;

  /// No description provided for @deliveryman_waiting_for_ready_order.
  ///
  /// In en, this message translates to:
  /// **'Our Driver Awaits For Order Being Ready'**
  String get deliveryman_waiting_for_ready_order;

  /// No description provided for @customer_waiting_for_ready_order.
  ///
  /// In en, this message translates to:
  /// **'Awaits For Order Being Ready'**
  String get customer_waiting_for_ready_order;

  /// No description provided for @find_deliveryman.
  ///
  /// In en, this message translates to:
  /// **'Find Deliveryman'**
  String get find_deliveryman;

  /// No description provided for @set_food_prepare_time.
  ///
  /// In en, this message translates to:
  /// **'Set food preparation time'**
  String get set_food_prepare_time;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get mins;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @customer_information.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customer_information;

  /// No description provided for @deliveryman_information.
  ///
  /// In en, this message translates to:
  /// **'Deliveryman Information'**
  String get deliveryman_information;

  /// No description provided for @pos_orders.
  ///
  /// In en, this message translates to:
  /// **'POS Orders'**
  String get pos_orders;

  /// No description provided for @search_menu.
  ///
  /// In en, this message translates to:
  /// **'Search \'menu\''**
  String get search_menu;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get added;

  /// No description provided for @place_order.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get place_order;

  /// No description provided for @customisable.
  ///
  /// In en, this message translates to:
  /// **'Customisable'**
  String get customisable;

  /// No description provided for @pos_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'In-house POS services are currently unavailable at your restaurant.'**
  String get pos_permission_denied;

  /// No description provided for @pos_order_detail.
  ///
  /// In en, this message translates to:
  /// **'POS Order Detail'**
  String get pos_order_detail;

  /// No description provided for @no_food_found_error.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no foods found with your menu. Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get no_food_found_error;

  /// No description provided for @no_food_found_error_two.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no foods found with your menu. Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get no_food_found_error_two;

  /// No description provided for @pos_order_list.
  ///
  /// In en, this message translates to:
  /// **'POS Order List'**
  String get pos_order_list;

  /// No description provided for @renew_your.
  ///
  /// In en, this message translates to:
  /// **'Renew Your'**
  String get renew_your;

  /// No description provided for @expire_package.
  ///
  /// In en, this message translates to:
  /// **'Subscription Package Before It Expires!'**
  String get expire_package;

  /// No description provided for @expire_on.
  ///
  /// In en, this message translates to:
  /// **'Expire on'**
  String get expire_on;

  /// No description provided for @menu_tabs.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu_tabs;

  /// No description provided for @business_tabs.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business_tabs;

  /// No description provided for @pos_tabs.
  ///
  /// In en, this message translates to:
  /// **'POS'**
  String get pos_tabs;

  /// No description provided for @more_tabs.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more_tabs;

  /// No description provided for @error_lbl.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_lbl;

  /// No description provided for @login_back.
  ///
  /// In en, this message translates to:
  /// **'Login back'**
  String get login_back;

  /// No description provided for @understand_btn.
  ///
  /// In en, this message translates to:
  /// **'Ok, I Understand'**
  String get understand_btn;

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

  /// No description provided for @update_now_btn.
  ///
  /// In en, this message translates to:
  /// **'UPDATE NOW'**
  String get update_now_btn;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @search_menu_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search menu...'**
  String get search_menu_placeholder;

  /// No description provided for @search_country.
  ///
  /// In en, this message translates to:
  /// **'Search Country'**
  String get search_country;

  /// No description provided for @report_emergency_message.
  ///
  /// In en, this message translates to:
  /// **'Please use this form exclusively for emergencies related to accidents or abuse. For order inquiries or other general questions, kindly contact us through our support portal.'**
  String get report_emergency_message;

  /// No description provided for @month_business_insight.
  ///
  /// In en, this message translates to:
  /// **'This Month Business Insight'**
  String get month_business_insight;

  /// No description provided for @week_business_insight.
  ///
  /// In en, this message translates to:
  /// **'This Week Business Insight'**
  String get week_business_insight;

  /// No description provided for @today_business_insight.
  ///
  /// In en, this message translates to:
  /// **'Today Business Insight'**
  String get today_business_insight;

  /// No description provided for @update_taxation.
  ///
  /// In en, this message translates to:
  /// **'Update Taxation'**
  String get update_taxation;

  /// No description provided for @save_taxation.
  ///
  /// In en, this message translates to:
  /// **'Save Taxation'**
  String get save_taxation;

  /// No description provided for @update_kitchen_owner.
  ///
  /// In en, this message translates to:
  /// **'Update Kitchen Owner'**
  String get update_kitchen_owner;

  /// No description provided for @add_new_outlet.
  ///
  /// In en, this message translates to:
  /// **'Add New Outlet'**
  String get add_new_outlet;

  /// No description provided for @update_outlet.
  ///
  /// In en, this message translates to:
  /// **'Update Outlet'**
  String get update_outlet;

  /// No description provided for @current_subscription_will_expire.
  ///
  /// In en, this message translates to:
  /// **'Your subscription is currently active. It will be expired on'**
  String get current_subscription_will_expire;

  /// No description provided for @table_order_error.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no foods found with restaurant. Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get table_order_error;

  /// No description provided for @add_tiffin_subscription.
  ///
  /// In en, this message translates to:
  /// **'Add Tiffin Subscription'**
  String get add_tiffin_subscription;

  /// No description provided for @update_tiffin_subscription.
  ///
  /// In en, this message translates to:
  /// **'Update Tiffin Subscription'**
  String get update_tiffin_subscription;

  /// No description provided for @update_waiter.
  ///
  /// In en, this message translates to:
  /// **'Update Waiter'**
  String get update_waiter;

  /// No description provided for @valid_payout_method_message.
  ///
  /// In en, this message translates to:
  /// **'Providing incorrect or incomplete details may result in rejection or delays in processing. Do not share sensitive information, such as passwords or PINs, on this form, If you have any doubts or questions, contact the concerned authority for clarification before submitting the form.'**
  String get valid_payout_method_message;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @add_food_in_campaign.
  ///
  /// In en, this message translates to:
  /// **'Add foods in campaign'**
  String get add_food_in_campaign;

  /// No description provided for @food_in_campaign.
  ///
  /// In en, this message translates to:
  /// **'Your foods in campaign'**
  String get food_in_campaign;

  /// No description provided for @add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category;

  /// No description provided for @update_category.
  ///
  /// In en, this message translates to:
  /// **'Update Category'**
  String get update_category;

  /// No description provided for @add_food.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get add_food;

  /// No description provided for @update_food.
  ///
  /// In en, this message translates to:
  /// **'Update Food'**
  String get update_food;

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

  /// No description provided for @add_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Add Sub Category'**
  String get add_sub_category;

  /// No description provided for @update_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Update Sub Category'**
  String get update_sub_category;

  /// No description provided for @flat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get flat;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @add_new_table.
  ///
  /// In en, this message translates to:
  /// **'Add New Table'**
  String get add_new_table;

  /// No description provided for @update_table.
  ///
  /// In en, this message translates to:
  /// **'Update Table'**
  String get update_table;

  /// No description provided for @something_went_wrong_error.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, something went wrong!. Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get something_went_wrong_error;

  /// No description provided for @no_deliveryman_found_error.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no drivers found near you. Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get no_deliveryman_found_error;

  /// No description provided for @no_tiffin_food_found_error.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no food found in menu. Please accept our heartfelt apologies for any inconvenience this may have caused. Our team is working diligently to resolve the situation and ensure that we can resume our full menu and service as soon as possible.'**
  String get no_tiffin_food_found_error;

  /// No description provided for @add_instruction.
  ///
  /// In en, this message translates to:
  /// **'Add Instruction'**
  String get add_instruction;

  /// No description provided for @update_instruction.
  ///
  /// In en, this message translates to:
  /// **'Update Instruction'**
  String get update_instruction;

  /// No description provided for @add_slot.
  ///
  /// In en, this message translates to:
  /// **'Add Slot'**
  String get add_slot;

  /// No description provided for @update_slot.
  ///
  /// In en, this message translates to:
  /// **'Update Slot'**
  String get update_slot;

  /// No description provided for @save_slot.
  ///
  /// In en, this message translates to:
  /// **'Save Slot'**
  String get save_slot;

  /// No description provided for @instant_order.
  ///
  /// In en, this message translates to:
  /// **'Instant Order'**
  String get instant_order;

  /// No description provided for @schedule_order.
  ///
  /// In en, this message translates to:
  /// **'Schedule Order'**
  String get schedule_order;

  /// No description provided for @handover_to_deliveryman.
  ///
  /// In en, this message translates to:
  /// **'Handover to Deliveryman'**
  String get handover_to_deliveryman;

  /// No description provided for @deliver_to_customer.
  ///
  /// In en, this message translates to:
  /// **'Deliver to Customer'**
  String get deliver_to_customer;

  /// No description provided for @ok_lbl.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok_lbl;

  /// No description provided for @hour_lbl.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour_lbl;

  /// No description provided for @minute_lbl.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute_lbl;

  /// No description provided for @select_time_lbl.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get select_time_lbl;

  /// No description provided for @select_start_time_lbl.
  ///
  /// In en, this message translates to:
  /// **'Select Start Time'**
  String get select_start_time_lbl;

  /// No description provided for @select_end_time_lbl.
  ///
  /// In en, this message translates to:
  /// **'Select End Time'**
  String get select_end_time_lbl;

  /// No description provided for @select_availability_start_time.
  ///
  /// In en, this message translates to:
  /// **'Select Availability Start Time'**
  String get select_availability_start_time;

  /// No description provided for @select_availability_end_time.
  ///
  /// In en, this message translates to:
  /// **'Select Availability End Time'**
  String get select_availability_end_time;

  /// No description provided for @select_start_date.
  ///
  /// In en, this message translates to:
  /// **'Select Start Date'**
  String get select_start_date;

  /// No description provided for @select_end_date.
  ///
  /// In en, this message translates to:
  /// **'Select End Date'**
  String get select_end_date;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_message;

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

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @bluetooth_connect.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Connect'**
  String get bluetooth_connect;

  /// No description provided for @bluetooth_scan.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Scan'**
  String get bluetooth_scan;

  /// No description provided for @unlimited_stock.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Stock'**
  String get unlimited_stock;

  /// No description provided for @limited_stock.
  ///
  /// In en, this message translates to:
  /// **'Limited Stock'**
  String get limited_stock;

  /// No description provided for @daily_limit.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit'**
  String get daily_limit;

  /// No description provided for @percentage_lbl.
  ///
  /// In en, this message translates to:
  /// **'Percent (%)'**
  String get percentage_lbl;

  /// No description provided for @amount_lbl.
  ///
  /// In en, this message translates to:
  /// **'Amount (\$)'**
  String get amount_lbl;

  /// No description provided for @main_category.
  ///
  /// In en, this message translates to:
  /// **'Main Category'**
  String get main_category;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @veg.
  ///
  /// In en, this message translates to:
  /// **'Veg'**
  String get veg;

  /// No description provided for @non_veg.
  ///
  /// In en, this message translates to:
  /// **'Non Veg'**
  String get non_veg;

  /// No description provided for @vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegan;

  /// No description provided for @yes_lbl.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes_lbl;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

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

  /// No description provided for @bloc_slot_already_exist.
  ///
  /// In en, this message translates to:
  /// **'Slot already exist'**
  String get bloc_slot_already_exist;

  /// No description provided for @bloc_pre_booking_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you don\'t have pre booking permission'**
  String get bloc_pre_booking_permission_denied;

  /// No description provided for @bloc_low_wallet_fund.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds: Withdrawal amount exceeds your available balance.'**
  String get bloc_low_wallet_fund;

  /// No description provided for @bloc_fill_required_input.
  ///
  /// In en, this message translates to:
  /// **'Please fill all the required inputs'**
  String get bloc_fill_required_input;

  /// No description provided for @bloc_select_package.
  ///
  /// In en, this message translates to:
  /// **'Please select package'**
  String get bloc_select_package;

  /// No description provided for @bloc_please_add_options.
  ///
  /// In en, this message translates to:
  /// **'Please add options'**
  String get bloc_please_add_options;

  /// No description provided for @bloc_variation_limit.
  ///
  /// In en, this message translates to:
  /// **'Sorry, our variation limited to ##dynamic## items right now.'**
  String get bloc_variation_limit;

  /// No description provided for @bloc_stock_limit.
  ///
  /// In en, this message translates to:
  /// **'Sorry, our stock is limited to ##dynamic## items right now.'**
  String get bloc_stock_limit;

  /// No description provided for @bloc_food_limit.
  ///
  /// In en, this message translates to:
  /// **'Sorry, You can purchase upto ##dynamic## items on this food'**
  String get bloc_food_limit;

  /// No description provided for @bloc_validation_failed.
  ///
  /// In en, this message translates to:
  /// **'Validation Failed, Please select required items'**
  String get bloc_validation_failed;

  /// No description provided for @bloc_download_failed.
  ///
  /// In en, this message translates to:
  /// **'Unable to get downloads directory'**
  String get bloc_download_failed;

  /// No description provided for @bloc_storage_permission_error.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied'**
  String get bloc_storage_permission_error;

  /// No description provided for @bloc_download_browser_failed.
  ///
  /// In en, this message translates to:
  /// **'File cannot be downloaded from the browser. Please use a mobile device to download.'**
  String get bloc_download_browser_failed;

  /// No description provided for @bloc_invalid_otp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get bloc_invalid_otp;

  /// No description provided for @bloc_enter_valid_otp.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid OTP'**
  String get bloc_enter_valid_otp;

  /// No description provided for @bloc_print_permission_error.
  ///
  /// In en, this message translates to:
  /// **'##d_y_n_a_m_i_c## Permission Denied'**
  String get bloc_print_permission_error;

  /// No description provided for @dd_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get dd_amount;

  /// No description provided for @dd_percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get dd_percentage;

  /// No description provided for @dd_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get dd_breakfast;

  /// No description provided for @dd_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get dd_lunch;

  /// No description provided for @dd_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dd_dinner;

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

  /// No description provided for @dd_ongoing_orders.
  ///
  /// In en, this message translates to:
  /// **'Ongoing Orders'**
  String get dd_ongoing_orders;

  /// No description provided for @dd_completed_orders.
  ///
  /// In en, this message translates to:
  /// **'Completed Orders'**
  String get dd_completed_orders;

  /// No description provided for @dd_percent_price.
  ///
  /// In en, this message translates to:
  /// **'Percent (%)'**
  String get dd_percent_price;

  /// No description provided for @dd_amount_price.
  ///
  /// In en, this message translates to:
  /// **'Amount (\$)'**
  String get dd_amount_price;

  /// No description provided for @dd_guest_customer.
  ///
  /// In en, this message translates to:
  /// **'Guest Customer'**
  String get dd_guest_customer;

  /// No description provided for @dd_regular_customer.
  ///
  /// In en, this message translates to:
  /// **'Regular Customer'**
  String get dd_regular_customer;

  /// No description provided for @dd_home_delivery.
  ///
  /// In en, this message translates to:
  /// **'Home Delivery'**
  String get dd_home_delivery;

  /// No description provided for @dd_self_pickup.
  ///
  /// In en, this message translates to:
  /// **'Self Pickup'**
  String get dd_self_pickup;

  /// No description provided for @dd_week_days.
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get dd_week_days;

  /// No description provided for @dd_fortnight_days.
  ///
  /// In en, this message translates to:
  /// **'15 Days'**
  String get dd_fortnight_days;

  /// No description provided for @dd_month_days.
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get dd_month_days;

  /// No description provided for @dd_breakfast_food.
  ///
  /// In en, this message translates to:
  /// **'Breakfast Food'**
  String get dd_breakfast_food;

  /// No description provided for @dd_lunch_food.
  ///
  /// In en, this message translates to:
  /// **'Lunch Food'**
  String get dd_lunch_food;

  /// No description provided for @dd_dinner_food.
  ///
  /// In en, this message translates to:
  /// **'Dinner Food'**
  String get dd_dinner_food;

  /// No description provided for @dd_min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get dd_min;

  /// No description provided for @dd_hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get dd_hour;

  /// No description provided for @dd_yes_home_delivery.
  ///
  /// In en, this message translates to:
  /// **'Yes Home Delivery Available'**
  String get dd_yes_home_delivery;

  /// No description provided for @dd_no_home_delivery.
  ///
  /// In en, this message translates to:
  /// **'No Home Delivery Not Availble'**
  String get dd_no_home_delivery;

  /// No description provided for @dd_yes_takeaway.
  ///
  /// In en, this message translates to:
  /// **'Yes Takeaway Available'**
  String get dd_yes_takeaway;

  /// No description provided for @dd_no_takeaway.
  ///
  /// In en, this message translates to:
  /// **'No Takaway Not Available'**
  String get dd_no_takeaway;

  /// No description provided for @dd_yes_schedule_order.
  ///
  /// In en, this message translates to:
  /// **'Yes can Place Schedule Orders'**
  String get dd_yes_schedule_order;

  /// No description provided for @dd_no_schedule_order.
  ///
  /// In en, this message translates to:
  /// **'No Can Not Place Schedule Orders'**
  String get dd_no_schedule_order;

  /// No description provided for @dd_customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get dd_customer;

  /// No description provided for @dd_deliveryman.
  ///
  /// In en, this message translates to:
  /// **'Deliveryman'**
  String get dd_deliveryman;

  /// No description provided for @dd_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get dd_select;

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

  /// No description provided for @tab_ready_order.
  ///
  /// In en, this message translates to:
  /// **'Ready (##dynamic##)'**
  String get tab_ready_order;

  /// No description provided for @tab_picked_order.
  ///
  /// In en, this message translates to:
  /// **'Pickd up (##dynamic##)'**
  String get tab_picked_order;

  /// No description provided for @tab_ongoing_order.
  ///
  /// In en, this message translates to:
  /// **'Ongoing (##dynamic##)'**
  String get tab_ongoing_order;

  /// No description provided for @tab_delivered_order.
  ///
  /// In en, this message translates to:
  /// **'Delivered (##dynamic##)'**
  String get tab_delivered_order;

  /// No description provided for @tab_rejected_order.
  ///
  /// In en, this message translates to:
  /// **'Rejected (##dynamic##)'**
  String get tab_rejected_order;

  /// No description provided for @tab_accepted_order.
  ///
  /// In en, this message translates to:
  /// **'Accepted (##dynamic##)'**
  String get tab_accepted_order;

  /// No description provided for @tab_completed_order.
  ///
  /// In en, this message translates to:
  /// **'Completed (##dynamic##)'**
  String get tab_completed_order;

  /// No description provided for @tab_cancelled_order.
  ///
  /// In en, this message translates to:
  /// **'Cancelled (##dynamic##)'**
  String get tab_cancelled_order;

  /// No description provided for @tab_refunded_order.
  ///
  /// In en, this message translates to:
  /// **'Refunded (##dynamic##)'**
  String get tab_refunded_order;

  /// No description provided for @tab_partial_refund_order.
  ///
  /// In en, this message translates to:
  /// **'Partially Refunded (##dynamic##)'**
  String get tab_partial_refund_order;

  /// No description provided for @tab_all_food.
  ///
  /// In en, this message translates to:
  /// **'All (##dynamic##)'**
  String get tab_all_food;

  /// No description provided for @tab_rejected_food.
  ///
  /// In en, this message translates to:
  /// **'Item Rejected (##dynamic##)'**
  String get tab_rejected_food;

  /// No description provided for @tab_hold_food.
  ///
  /// In en, this message translates to:
  /// **'On Hold (##dynamic##)'**
  String get tab_hold_food;

  /// No description provided for @tab_photo_rejected_food.
  ///
  /// In en, this message translates to:
  /// **'Photo Rejected (##dynamic##)'**
  String get tab_photo_rejected_food;

  /// No description provided for @tab_quality_rejected_food.
  ///
  /// In en, this message translates to:
  /// **'Quality Rejected (##dynamic##)'**
  String get tab_quality_rejected_food;

  /// No description provided for @tab_size_rejected_food.
  ///
  /// In en, this message translates to:
  /// **'Size Rejected (##dynamic##)'**
  String get tab_size_rejected_food;

  /// No description provided for @tab_hidden_food.
  ///
  /// In en, this message translates to:
  /// **'Hidden (##dynamic##)'**
  String get tab_hidden_food;

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

  /// No description provided for @tiffin_subscription.
  ///
  /// In en, this message translates to:
  /// **'Tiffin Subscription'**
  String get tiffin_subscription;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @expense_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get expense_all;

  /// No description provided for @expense_pos_product_discount.
  ///
  /// In en, this message translates to:
  /// **'POS Product Discount'**
  String get expense_pos_product_discount;

  /// No description provided for @expense_table_product_discount.
  ///
  /// In en, this message translates to:
  /// **'Table Product Discount'**
  String get expense_table_product_discount;

  /// No description provided for @expense_pos_extra_discount.
  ///
  /// In en, this message translates to:
  /// **'POS Extra Discount'**
  String get expense_pos_extra_discount;

  /// No description provided for @expense_table_extra_discount.
  ///
  /// In en, this message translates to:
  /// **'Table Extra Discount'**
  String get expense_table_extra_discount;

  /// No description provided for @expense_order_coupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon Expense'**
  String get expense_order_coupon;

  /// No description provided for @expense_dining_coupon.
  ///
  /// In en, this message translates to:
  /// **'Dining Coupon'**
  String get expense_dining_coupon;

  /// No description provided for @expense_others.
  ///
  /// In en, this message translates to:
  /// **'Others Expense'**
  String get expense_others;

  /// No description provided for @expense_total.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get expense_total;

  /// No description provided for @expense_pos_order_product_discount.
  ///
  /// In en, this message translates to:
  /// **'Pos Order Product Discount'**
  String get expense_pos_order_product_discount;

  /// No description provided for @expense_order_refund_expense.
  ///
  /// In en, this message translates to:
  /// **'Order Refund Expenses'**
  String get expense_order_refund_expense;

  /// No description provided for @order_status_created.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get order_status_created;

  /// No description provided for @order_status_accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get order_status_accepted;

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
  /// **'On The Way'**
  String get order_status_ongoing;

  /// No description provided for @order_status_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get order_status_delivered;

  /// No description provided for @order_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get order_status_cancelled;

  /// No description provided for @order_status_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get order_status_rejected;

  /// No description provided for @order_status_refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get order_status_refunded;

  /// No description provided for @order_status_partially_refunded.
  ///
  /// In en, this message translates to:
  /// **'Partially Refunded'**
  String get order_status_partially_refunded;

  /// No description provided for @order_status_pending_payments.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get order_status_pending_payments;

  /// No description provided for @order_status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get order_status_completed;

  /// No description provided for @booking_status_created.
  ///
  /// In en, this message translates to:
  /// **'Booking Created!'**
  String get booking_status_created;

  /// No description provided for @booking_status_accepted.
  ///
  /// In en, this message translates to:
  /// **'Booking Accepted!'**
  String get booking_status_accepted;

  /// No description provided for @booking_status_completed.
  ///
  /// In en, this message translates to:
  /// **'Booking Completed!'**
  String get booking_status_completed;

  /// No description provided for @booking_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking Cancelled'**
  String get booking_status_cancelled;

  /// No description provided for @booking_status_rejected.
  ///
  /// In en, this message translates to:
  /// **'Booking Rejected'**
  String get booking_status_rejected;

  /// No description provided for @booking_status_refunded.
  ///
  /// In en, this message translates to:
  /// **'Booking Amount Refunded!'**
  String get booking_status_refunded;

  /// No description provided for @booking_status_payment_pending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending!'**
  String get booking_status_payment_pending;

  /// No description provided for @frequently_asked_questions.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get frequently_asked_questions;

  /// No description provided for @cookies.
  ///
  /// In en, this message translates to:
  /// **'App Cookies'**
  String get cookies;
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
