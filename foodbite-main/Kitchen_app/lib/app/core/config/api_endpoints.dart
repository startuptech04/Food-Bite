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
  String get getKitchenSettings => 'v1/public/getKitchenSetting/';
  String get getPageContent => 'v1/public/app_pages/getContent/';

  // Auth Request //
  String get ownerLogin => 'v1/auth/kitchen/login/';
  String get ownerLoginWithPhonePassword => 'v1/auth/kitchen/login_cmp/';
  String get ownerLoginWithEmailOtSendVerification => 'v1/auth/kitchen/login_eo_verification/';
  String get ownerLoginWithEmailOtp => 'v1/auth/kitchen/login_eo/';
  String get ownerLoginWithPhoneOTPSendVerification => 'v1/auth/kitchen/login_po_verification/';
  String get ownerLoginWithPhoneOTPVerified => 'v1/auth/kitchen/login_po/';
  String get ownerLoginWithPhoneOTPFirebaseverified => 'v1/auth/kitchen/login_po_firebase/';
  String get refreshToken => 'v1/auth/refresh-tokens-app/';
  String get forgotPasswordWithEmail => 'v1/auth/forgot-password-email/';
  String get forgotPasswordWithPhone => 'v1/auth/forgot-password-phone/';
  String get updatePassword => 'v1/auth/reset-password';
  String get updatePasswordFirebase => 'v1/auth/reset-password-firebase';
  String get logout => 'v1/auth/logout/';
  String get verifyOTP => 'v1/auth/verifyOTP/';
  String get resendOTP => 'v1/auth/resendOTP/';
  String get webOTPVerification => 'v1/public/verification/otp/';
  String get getProfile => 'v1/kitchen/profile/me/';
  String get updateProfile => 'v1/kitchen/profile/update/';
  String get ownerLoginWithGoogleAccount => 'v1/auth/kitchen/login_with_google_account/';
  String get ownerLoginWithFacebookAccount => 'v1/auth/kitchen/login_with_facebook_account/';
  // Auth Request //

  // Food Request //
  String get foodList => 'v1/kitchen/food_list/';
  String get updateFoodMetaInfo => 'v1/kitchen/foods/update_meta_detail/';
  String get getFoodInfo => 'v1/kitchen/foods/kitchen_food_detail/';
  String get getAllMyAddons => 'v1/kitchen/foods/addon_list/';
  String get updateFood => 'v1/kitchen/foods/update/';
  // Food Request //

  // Order Request //
  String get orderList => 'v1/kitchen/orders/list/';
  String get prepareOrder => 'v1/kitchen/orders/prepare/';
  String get completeOrder => 'v1/kitchen/orders/complete/';
  String get orderDetail => 'v1/kitchen/orders/order_detail/';
  // Order Request //

  // Profile Routes //
  String get uploadImageFile => 'v1/file/uploadImage/';
  // Profile Routes //

  // Push Notification Token Request //
  String get savePushNotificationToken => 'v1/public/pushTokens/save/';
  String get updatePushNotificationToken => 'v1/public/pushTokens/update/';
  // Push Notification Token Request //

  // Feedback & Report Emergecy Routes //
  String get saveFeedbackForm => 'v1/public/feedback_form/save/';
  String get saveReportEmergencyForm => 'v1/public/report_emergency/save/';
  // Feedback & Report Emergecy Routes //

  // Account Setting Routes //
  String get updateAccountPassword => 'v1/kitchen/account_setting/update_password/';
  String get updateAccountEmail => 'v1/kitchen/account_setting/update_email/';
  String get updateAccountEmailAfterVerification => 'v1/kitchen/account_setting/update_email_after_verification/';
  String get updateAccountMobileNumber => 'v1/kitchen/account_setting/update_mobile_number/';
  String get updateAccountMobileNumberAfterVerification => 'v1/kitchen/account_setting/update_mobile_number_after_verification/';
  String get updateAccountMobileNumberAfterFirebaseVerification => 'v1/kitchen/account_setting/update_mobile_number_after_firebase_verification/';
  String get userNotificationSetting => 'v1/kitchen/account_setting/notification_setting/';
  String get updateNotificationSetting => 'v1/kitchen/account_setting/notification_setting/';
  String get accountDeleteReasonList => 'v1/kitchen/delete_account_reason_list/';
  String get deleteDeliverymanAccount => 'v1/kitchen/account_setting/delete_account/';
  String get updateUserLocale => 'v1/kitchen/account_setting/update_locale';
  // Account Setting Routes //

  // Notification Routes //
  String get notificationList => 'v1/kitchen/notification/list/';
  String get readAllNotification => 'v1/kitchen/notification/readAll/';
  // Notification Routes //
}
