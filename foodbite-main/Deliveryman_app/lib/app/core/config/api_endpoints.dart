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
  String get getDriverSettings => 'v1/public/getDriverSettings/';
  String get getPageContent => 'v1/public/app_pages/getContent/';

  // Auth Request //
  String get driverLogin => 'v1/auth/driver/login/';
  String get driverLoginWithPhonePassword => 'v1/auth/driver/login_cmp/';
  String get driverLoginWithEmailOtSendVerification => 'v1/auth/driver/login_eo_verification/';
  String get verifyOTP => 'v1/auth/verifyOTP/';
  String get resendOTP => 'v1/auth/resendOTP/';
  String get driverLoginWithEmailOtp => 'v1/auth/driver/login_eo/';
  String get webOTPVerification => 'v1/public/verification/otp/';
  String get driverLoginWithPhoneOTPSendVerification => 'v1/auth/driver/login_po_verification/';
  String get driverLoginWithPhoneOTPVerified => 'v1/auth/driver/login_po/';
  String get driverLoginWithPhoneOTPFirebaseverified => 'v1/auth/driver/login_po_firebase/';
  String get driverLoginWithGoogleAccount => 'v1/auth/driver/login_with_google_account/';
  String get driverLoginWithFacebookAccount => 'v1/auth/driver/login_with_facebook_account/';
  String get forgotPasswordWithEmail => 'v1/auth/forgot-password-email/';
  String get forgotPasswordWithPhone => 'v1/auth/forgot-password-phone/';
  String get updatePassword => 'v1/auth/reset-password';
  String get updatePasswordFirebase => 'v1/auth/reset-password-firebase';
  String get refreshToken => 'v1/auth/refresh-tokens-app/';
  String get logout => 'v1/auth/logout/';
  String get getProfile => 'v1/driver/profile/me/';
  String get updateProfile => 'v1/driver/profile/update/';
  // Auth Request //

  // Push Notification Token Request //
  String get savePushNotificationToken => 'v1/public/pushTokens/save/';
  String get updatePushNotificationToken => 'v1/public/pushTokens/update/';
  // Push Notification Token Request //

  // Home Restaurants Routes //
  String get getTrendingRestaurantsNearDriver => 'v1/driver/restaurant/trending/';
  // Home Restaurants Routes //

  // Offline Message Routes //
  String get offlineMessageList => 'v1/driver/driver_offline_messages/getMessagesList';
  // Offline Message Routes //

  // Driver Routes //
  String get goOffline => 'v1/driver/drivers/goOffline/';
  String get goOnline => 'v1/driver/drivers/goOnline/';
  String get updateMyGeoLocation => 'v1/driver/updateMyGeoLocation/';
  // Driver Routes //

  // Orders Routes //
  String get newOrderList => 'v1/driver/orders/newOrder/';
  String get cancellationReason => 'v1/driver/cancellation/driver/';
  String get acceptOrder => 'v1/driver/orders/acceptOrder/';
  String get rejectOrder => 'v1/driver/orders/rejectOrder/';
  String get activeOrder => 'v1/driver/orders/activeOrder/';
  String get orderDetails => 'v1/driver/orders/orderDetails/';
  String get driverReachedRestaurant => 'v1/driver/orders/driverReachRestaurant/';
  String get orderPickup => 'v1/driver/orders/driverPickupOrder/';
  String get driverReachedCustomer => 'v1/driver/orders/driverReachCustomer/';
  String get driverDeliverOrder => 'v1/driver/orders/driverDeliverOrder/';
  String get orderList => 'v1/driver/orders/orderList/';
  // Orders Routes //

  // Media Routes //
  String get uploadImageFile => 'v1/file/uploadImage/';
  String get uploadPublicImageFile => 'v1/public/uploadImage/';
  // Media Routes //

  // Proof Routes //
  String get saveDeliveryPickupProof => 'v1/driver/proof/save/';
  // Proof Routes //

  // Chat Messages Routes //
  String get fetchChatMessages => 'v1/driver/chat_room/fetchMessages/';
  String get sendChatMessage => 'v1/driver/chat_room/sendMessage/';
  String get chatList => 'v1/driver/chat_room/list/';
  String get getChatConversion => 'v1/driver/chat_room/conversion/';
  // Chat Messages Routes //

  // Support Chat Message Routes //
  String get fetchSupportChatMessages => 'v1/driver/support_chat_room/fetchMessages/';
  String get supportChatList => 'v1/driver/support_chat_room/list/';
  String get sendSupportChatMessage => 'v1/driver/support_chat_room/sendMessage/';
  String get getSupportChatConversion => 'v1/driver/support_chat_room/conversion/';
  // Support Chat Message Routes //

  // Feedback & Report Emergecy Routes //
  String get saveFeedbackForm => 'v1/public/feedback_form/save/';
  String get saveReportEmergencyForm => 'v1/public/report_emergency/save/';
  // Feedback & Report Emergecy Routes //

  // Review Routes //
  String get getDeliverymanReviewList => 'v1/driver/reviews/deliveryman/';
  // Review Routes //

  // Deposite Routes //
  String get depositeDetail => 'v1/driver/depositeDetail/';
  // Deposite Routes //

  // Payout Method Routes //
  String get payoutMethodList => 'v1/driver/payoutMethod/list/';
  String get getMyPayoutMethodList => 'v1/driver/payoutMethod/myPayoutList/';
  String get savePayoutMethod => 'v1/driver/payoutMethod/createPayoutMethod/';
  String get deletePayoutMethod => 'v1/driver/payoutMethod/deleteMethod/';
  String get payoutMethodDetail => 'v1/driver/payoutMethod/detail/';
  String get updatePayoutMethodDetail => 'v1/driver/payoutMethod/updatePayoutMethod/';
  String get changeDefaultPayoutMethod => 'v1/driver/payoutMethod/changeDefaultPayoutMethod/';
  // Payout Method Routes //

  // Wallet Routes //
  String get withdrawalDetail => 'v1/driver/wallet/withdrawalDetail/';
  String get walletTransactionList => 'v1/driver/wallet/getWalletTransaction/';
  // Wallet Routes //

  // Withdrawal Routes //
  String get requestWithdrawal => 'v1/driver/wallet/requestWithdrawal/';
  String get withdrawalHistory => 'v1/driver/wallet/withdrawalHistory/';
  // Withdrawal Routes //

  String get localityByCity => 'v1/public/localities_from_city/';

  // Register Request Routes //
  String get getBasicRegisterRequestDetail => 'v1/public/deliveryman_joining/getBasicDataDeliverymanRequest/';
  String get deliverymanJoiningRequest => 'v1/public/deliveryman_joining/request/';
  // Register Request Routes //

  // Deliveryman Insight Routes //
  String get getDeliverymanInsight => 'v1/driver/insight/overall/';
  // Deliveryman Insight Routes //

  // Account Setting Routes //
  String get updateAccountPassword => 'v1/driver/account_setting/update_password/';
  String get updateAccountEmail => 'v1/driver/account_setting/update_email/';
  String get updateAccountEmailAfterVerification => 'v1/driver/account_setting/update_email_after_verification/';
  String get updateAccountMobileNumber => 'v1/driver/account_setting/update_mobile_number/';
  String get updateAccountMobileNumberAfterVerification => 'v1/driver/account_setting/update_mobile_number_after_verification/';
  String get updateAccountMobileNumberAfterFirebaseVerification => 'v1/driver/account_setting/update_mobile_number_after_firebase_verification/';
  String get userNotificationSetting => 'v1/driver/account_setting/notification_setting/';
  String get updateNotificationSetting => 'v1/driver/account_setting/notification_setting/';
  String get accountDeleteReasonList => 'v1/driver/delete_account_reason_list/';
  String get deleteDeliverymanAccount => 'v1/driver/account_setting/delete_account/';
  String get updateUserLocale => 'v1/driver/account_setting/update_locale';
  // Account Setting Routes //

  // Notification Routes //
  String get notificationList => 'v1/driver/notification/list/';
  String get readAllNotification => 'v1/driver/notification/readAll/';
  // Notification Routes //
}
