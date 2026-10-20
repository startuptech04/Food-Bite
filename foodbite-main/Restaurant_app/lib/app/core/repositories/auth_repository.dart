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

import 'package:image_picker/image_picker.dart';
import 'package:vendor/app/core/config/api_endpoints.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/config/shared_pref_keys.dart';
import 'package:vendor/app/core/models/request/account_update_email_after_verification_request_model.dart';
import 'package:vendor/app/core/models/request/account_update_email_request_model.dart';
import 'package:vendor/app/core/models/request/account_update_mobile_number_after_firebase_verification_request_model.dart';
import 'package:vendor/app/core/models/request/account_update_mobile_number_after_verification_request_model.dart';
import 'package:vendor/app/core/models/request/account_update_mobile_number_request_model.dart';
import 'package:vendor/app/core/models/request/account_update_notification_setting_request_model.dart';
import 'package:vendor/app/core/models/request/account_update_password_request_model.dart';
import 'package:vendor/app/core/models/request/check_register_request_model.dart';
import 'package:vendor/app/core/models/request/email_otp_login_request_model.dart';
import 'package:vendor/app/core/models/request/email_otp_send_verification_mail_request_model.dart';
import 'package:vendor/app/core/models/request/email_password_login_request_model.dart';
import 'package:vendor/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:vendor/app/core/models/request/forgot_password_with_email_request_model.dart';
import 'package:vendor/app/core/models/request/forgot_password_with_phone_request_model.dart';
import 'package:vendor/app/core/models/request/google_account_login_request_model.dart';
import 'package:vendor/app/core/models/request/otp_request_model.dart';
import 'package:vendor/app/core/models/request/phone_otp_firebase_verify_request_model.dart';
import 'package:vendor/app/core/models/request/phone_otp_send_verification_sms_request_model.dart';
import 'package:vendor/app/core/models/request/phone_otp_verified_request_model.dart';
import 'package:vendor/app/core/models/request/phone_password_login_request_model.dart';
import 'package:vendor/app/core/models/request/push_notification_token_request_model.dart';
import 'package:vendor/app/core/models/request/restaurant_joining_request_model.dart';
import 'package:vendor/app/core/models/request/update_password_firebase_request_model.dart';
import 'package:vendor/app/core/models/request/update_password_request_model.dart';
import 'package:vendor/app/core/models/request/restaurant_account_delete_request_model.dart';
import 'package:vendor/app/core/models/vendor_email_password_login_response_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class AuthRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> restaurantLoginWith() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.restaurantLoginWith) ?? '';
  }

  Future<bool> selfRegistration() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.selfRegistration) ?? false;
  }

  Future<String> restaurantResetPasswordWith() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.restaurantResetPasswordWith) ?? '';
  }

  Future<bool> isAppleSignInEnabled() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.socialAppleSignIn) ?? false;
  }

  Future<bool> isGoogleSignInEnabled() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.socialGoogleSignIn) ?? false;
  }

  Future<bool> isFacebookSignInEnabled() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.socialFacebookSignIn) ?? false;
  }

  Future<DioApiResponse> loginWithEmailPassword(EmailPasswordLoginRequestModel login) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLogin, body: login);
  }

  Future<DioApiResponse> loginWithPhonePassword(PhonePasswordLoginRequestModel login) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLoginWithPhonePassword, body: login);
  }

  Future<DioApiResponse> loginWithEmailOtpSendEmailVerificationMail(LoginWithEmailOtpSendVerificationMailRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLoginWithEmailOtSendVerification, body: param);
  }

  Future<DioApiResponse> verifyOTP(OTPRequestModel otp) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.verifyOTP, body: otp);
  }

  Future<DioApiResponse> resendOTP(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.resendOTP}$id/');
  }

  Future<DioApiResponse> loginWithEmailOtp(LoginWithEmailOtpRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLoginWithEmailOtp, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpSendVerificationSMS(LoginWithPhoneOtpSendVerificationSMSRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLoginWithPhoneOTPSendVerification, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpVerified(PhoneOTPVerifiedLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLoginWithPhoneOTPVerified, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpFirebaseVerified(PhoneOTPFirebaseVerifyRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLoginWithPhoneOTPFirebaseVerified, body: param);
  }

  Future<DioApiResponse> forgotPasswordWithEmail(ForgotPasswordWithEmailRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.forgotPasswordWithEmail, body: param);
  }

  Future<DioApiResponse> forgotPasswordWithPhone(ForgotPasswordWithPhoneRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.forgotPasswordWithPhone, body: param);
  }

  Future<DioApiResponse> updatePassword(UpdatePasswordRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.updatePassword, body: param);
  }

  Future<DioApiResponse> updatePasswordFirebase(UpdatePasswordFirebaseRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.updatePasswordFirebase, body: param);
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<void> saveLoginResponse(VendorLoginResponseModel response) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.uid, response.user!.id!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authToken, response.tokens!.access!.token!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userEmail, response.user!.email!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userCountryCode, response.user!.countryCode!.toString());
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userMobile, response.user!.mobile!);
    if (response.tokens != null && response.tokens!.refresh != null && response.tokens!.refresh!.token!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authRefreshToken, response.tokens!.refresh!.token!);
    }
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authRole, response.user!.role!);
    if (response.user!.id!.isNotEmpty && response.vendor!.id!.isNotEmpty && response.user!.id! == response.vendor!.userId! && response.user!.role == 'vendor') {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorId, response.vendor!.id!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorPOS, response.vendor!.pos!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorOwnDriver, response.vendor!.ownDriver!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorPromote, response.vendor!.promote!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorCustomCategory, response.vendor!.customCategory!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorMultiOutlet, response.vendor!.multiOutlet!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorPreBooking, response.vendor!.preBooking!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorTableOrder, response.vendor!.tableOrder!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorTiffinSubscription, response.vendor!.tiffinSubscription!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorOwnWaiter, response.vendor!.ownWaiter!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorOwnKitchen, response.vendor!.ownKitchen!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorBusinessType, response.vendor!.type!);
    } else if (response.user!.id!.isNotEmpty && response.vendor!.id!.isNotEmpty && response.user!.id! == response.vendor!.userId! && response.user!.role! == 'vendorOutlet' && response.manager!.id!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorId, response.vendor!.id!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorPOS, response.manager!.pos!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorOwnDriver, response.manager!.ownDriver!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorPromote, response.manager!.promote!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorCustomCategory, response.manager!.customCategory!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorMultiOutlet, response.manager!.multiOutlet!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorPreBooking, response.manager!.preBooking!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorTableOrder, response.manager!.tableOrder!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorTiffinSubscription, response.manager!.tiffinSubscription!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorOwnWaiter, response.manager!.ownWaiter!);
      await _sharedPreferencesManager.putBool(SharedPreferencesKey.authKeys.vendorOwnKitchen, response.manager!.ownKitchen!);
    }
    if (response.restaurant != null && response.restaurant!.name!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorName, response.restaurant!.name!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorAddress, response.restaurant!.address!);
      await _sharedPreferencesManager.putDouble(SharedPreferencesKey.authKeys.vendorRating, response.restaurant!.rating!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorLogo, response.restaurant!.logo!);
    }
    if (response.user!.id!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userFirstName, response.user!.firstName!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userLastName, response.user!.lastName!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userCover, response.user!.image!);
    }
  }

  Future<DioApiResponse> updatePushNotificationToken(PushNotificationTokenRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.updatePushNotificationToken, body: param);
  }

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }

  Future<DioApiResponse> getPageContent(String slug) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getPageContent}$slug/');
  }

  Future<DioApiResponse> getRestaurantRegisterRequestBasicDetail() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.registerRequestBasicDetail);
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<DioApiResponse> uploadMediaImage(XFile file, String uid) async {
    return await _apiRequestService.uploadImageFile(ApiEndPoints.v1request.uploadPublicImageFile, uid, file);
  }

  Future<DioApiResponse> checkRegisterStatus(CheckRegisterStatusRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.checkRegisterStatus, body: param);
  }

  Future<DioApiResponse> registerRequest(RestaurantJoiningRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.registerRequest, body: param);
  }

  Future<DioApiResponse> userNotificationSetting() async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.restaurantNotificationSetting}$userId');
  }

  Future<String> userEmail() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.userEmail) ?? '';
  }

  Future<String> userMobile() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.userMobile) ?? '';
  }

  Future<String> userCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.userCountryCode) ?? '';
  }

  Future<DioApiResponse> updateNotificationSetting(String id, AccountUpdateNotificationSettingRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateNotificationSetting}$id', body: param);
  }

  Future<DioApiResponse> updateAccountEmail(AccountUpdateEmailRequestModel param) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAccountEmail}$userId', body: param);
  }

  Future<DioApiResponse> updateAccountEmailAfterVerification(AccountUpdateEmailAfterVerificationRequestModel param) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAccountEmailAfterVerification}$userId', body: param);
  }

  Future<DioApiResponse> updateAccountMobileNumber(AccountUpdateMobileNumberRequestModel param) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAccountMobileNumber}$userId', body: param);
  }

  Future<DioApiResponse> updateAccountMobileNumberAfterVerification(AccountUpdateMobileNumberAfterVerificationRequestModel param) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAccountMobileNumberAfterVerification}$userId', body: param);
  }

  Future<DioApiResponse> updateAccountMobileNumberAfterFirebaseVerification(AccountUpdateMobileNumberAfterFirebaseVerificationRequestModel param) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAccountMobileNumberAfterFirebaseVerification}$userId', body: param);
  }

  Future<DioApiResponse> updateAccountPassword(AccountUpdatePasswordRequestModel param) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAccountPassword}$userId', body: param);
  }

  Future<DioApiResponse> getAccountDeleteReason() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.accountDeleteReasonList);
  }

  Future<DioApiResponse> restaurantAccountDelete(RestaurantAccountDeleteRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.deleteRestaurantAccount, body: param);
  }

  Future<DioApiResponse> loginWithGoogleAccount(GoogleAccountLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLoginWithGoogleAccount, body: param);
  }

  Future<DioApiResponse> loginWithFacebookAccount(FacebookAccountLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.vendorLoginWithFacebookAccount, body: param);
  }

  Future<String> googleOAuthClientId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.googleOAuthClientId) ?? '';
  }

  Future<String> googleOAuthServerId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.googleOAuthServerId) ?? '';
  }

  Future<void> saveGoogleLogin() async {
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.isGoogleLoggedIn, true);
  }

  Future<void> saveFacebookLogin() async {
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.isFacebookLoggedIn, true);
  }

  Future<String> getMediaUrl() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.mediaUrl) ?? '';
  }

  Future<DioApiResponse> localityByCity(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.localityByCity}$id');
  }
}
