/*
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * This file may contain embedded identifiers and watermarks
 * for ownership verification and license enforcement.
 */

class ApiEndPoints {
  static V1Request v1request = const V1Request();
}

class V1Request {
  const V1Request();
  String get getWaiterSettings => 'v1/public/getWaiterSettings/';
  String get getPageContent => 'v1/public/app_pages/getContent/';

  // Auth Request //
  String get loginWithEmailAndPassword => 'v1/auth/waiter/login/';
  String get loginWithPhonePassword => 'v1/auth/waiter/login_cmp/';
  String get loginWithEmailOtSendVerification => 'v1/auth/waiter/login_eo_verification/';
  String get loginWithEmailOtp => 'v1/auth/waiter/login_eo/';
  String get loginWithPhoneOTPSendVerification => 'v1/auth/waiter/login_po_verification/';
  String get loginWithPhoneOTPVerified => 'v1/auth/waiter/login_po/';
  String get loginWithPhoneOTPFirebaseverified => 'v1/auth/waiter/login_po_firebase/';
  String get forgotPasswordWithEmail => 'v1/auth/forgot-password-email/';
  String get forgotPasswordWithPhone => 'v1/auth/forgot-password-phone/';
  String get updatePassword => 'v1/auth/reset-password';
  String get updatePasswordFirebase => 'v1/auth/reset-password-firebase';
  String get refreshToken => 'v1/auth/refresh-tokens-app/';
  String get logout => 'v1/auth/logout/';
  String get verifyOTP => 'v1/auth/verifyOTP/';
  String get resendOTP => 'v1/auth/resendOTP/';
  String get webOTPVerification => 'v1/public/verification/otp/';
  String get loginWithGoogleAccount => 'v1/auth/waiter/login_with_google_account/';
  String get loginWithFacebookAccount => 'v1/auth/waiter/login_with_facebook_account/';
  // Auth Request //

  // Profile Routes //
  String get uploadImageFile => 'v1/file/uploadImage/';
  String get getMyProfile => 'v1/waiter/profile/user/';
  String get updateMyProfile => 'v1/waiter/profile/update/';
  // Profile Routes //

  // Push Notification Token Request //
  String get savePushNotificationToken => 'v1/public/pushTokens/save/';
  String get updatePushNotificationToken => 'v1/public/pushTokens/update/';
  // Push Notification Token Request //

  // Feedback & Report Emergecy Routes //
  String get saveFeedbackForm => 'v1/public/feedback_form/save/';
  String get saveReportEmergencyForm => 'v1/public/report_emergency/save/';
  // Feedback & Report Emergecy Routes //

  // Food Routes //
  String get getFoodList => 'v1/waiter/foods/foodList/';
  // Food Routes //

  // Order Routes //
  String get tableList => 'v1/waiter/restaurant/tableList/';
  String get foodListForOrder => 'v1/waiter/foodListForOrder/';
  String get waiterInitialFoodSearch => 'v1/waiter/waiterInitialFoodSearch/';
  String get waiterFoodSearch => 'v1/waiter/waiterFoodSearch/';
  String get addItemToCart => 'v1/waiter/addItemToCart/';
  String get ongoingTableOrder => 'v1/waiter/ongoingTableOrder/';
  // Order Routes //

  // Account Setting Routes //
  String get updateAccountPassword => 'v1/waiter/account_setting/update_password/';
  String get updateAccountEmail => 'v1/waiter/account_setting/update_email/';
  String get updateAccountEmailAfterVerification => 'v1/waiter/account_setting/update_email_after_verification/';
  String get updateAccountMobileNumber => 'v1/waiter/account_setting/update_mobile_number/';
  String get updateAccountMobileNumberAfterVerification => 'v1/waiter/account_setting/update_mobile_number_after_verification/';
  String get updateAccountMobileNumberAfterFirebaseVerification => 'v1/waiter/account_setting/update_mobile_number_after_firebase_verification/';
  String get userNotificationSetting => 'v1/waiter/account_setting/notification_setting/';
  String get updateNotificationSetting => 'v1/waiter/account_setting/notification_setting/';
  String get accountDeleteReasonList => 'v1/waiter/delete_account_reason_list/';
  String get deleteWaiterAccount => 'v1/waiter/account_setting/delete_account/';
  String get updateUserLocale => 'v1/waiter/account_setting/update_locale';
  // Account Setting Routes //
}
