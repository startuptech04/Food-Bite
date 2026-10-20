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

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen/app/core/config/api_endpoints.dart';
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/config/assets_url.dart';
import 'package:kitchen/app/core/config/shared_pref_keys.dart';
import 'package:kitchen/app/core/models/kitchen_owner_setting_model.dart';
import 'package:kitchen/app/core/models/owner_email_password_login_response_model.dart';
import 'package:kitchen/app/core/models/request/account_update_email_after_verification_request_model.dart';
import 'package:kitchen/app/core/models/request/account_update_email_request_model.dart';
import 'package:kitchen/app/core/models/request/account_update_mobile_number_after_firebase_verification_request_model.dart';
import 'package:kitchen/app/core/models/request/account_update_mobile_number_after_verification_request_model.dart';
import 'package:kitchen/app/core/models/request/account_update_mobile_number_request_model.dart';
import 'package:kitchen/app/core/models/request/account_update_notification_setting_request_model.dart';
import 'package:kitchen/app/core/models/request/account_update_password_request_model.dart';
import 'package:kitchen/app/core/models/request/email_otp_login_request_model.dart';
import 'package:kitchen/app/core/models/request/email_otp_send_verification_mail_request_model.dart';
import 'package:kitchen/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:kitchen/app/core/models/request/feedback_form_request_model.dart';
import 'package:kitchen/app/core/models/request/forgot_password_with_email_request_model.dart';
import 'package:kitchen/app/core/models/request/forgot_password_with_phone_request_model.dart';
import 'package:kitchen/app/core/models/request/google_account_login_request_model.dart';
import 'package:kitchen/app/core/models/request/kitchen_owner_account_delete_request_model.dart';
import 'package:kitchen/app/core/models/request/otp_request_model.dart';
import 'package:kitchen/app/core/models/request/owner_login_with_email_password_request_model.dart';
import 'package:kitchen/app/core/models/request/phone_otp_firebase_verify_request_model.dart';
import 'package:kitchen/app/core/models/request/phone_otp_send_verification_sms_request_model.dart';
import 'package:kitchen/app/core/models/request/phone_otp_verified_request_model.dart';
import 'package:kitchen/app/core/models/request/phone_password_login_request_model.dart';
import 'package:kitchen/app/core/models/request/push_notification_token_request_model.dart';
import 'package:kitchen/app/core/models/request/report_emergency_request_model.dart';
import 'package:kitchen/app/core/models/request/update_kitchen_profile_request_model.dart';
import 'package:kitchen/app/core/models/request/update_locale_request_model.dart';
import 'package:kitchen/app/core/models/request/update_password_firebase_request_model.dart';
import 'package:kitchen/app/core/models/request/update_password_request_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kitchen/app/services/shared_pref.dart';

class AuthRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<void> saveEvent(String eventName, Map<String, String> eventParam, String screenClasss, String screenName) async {
    if (!kIsWeb) {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.logEvent(name: eventName, parameters: eventParam);
      await analytics.logScreenView(screenClass: screenClasss, screenName: screenName);
    }
  }

  Future<String> kitchenLoginWith() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.ownerLoginWith) ?? '';
  }

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }

  Future<List<AppDefaultCountryCodeConfigModel>> getCountryList() async {
    final jsonString = await rootBundle.loadString(AssetsUrl.localURL.countryCodeList);
    final listOfJsonElements = jsonDecode(jsonString) as List;
    return listOfJsonElements.map((jsonElement) => AppDefaultCountryCodeConfigModel.fromJson(jsonElement)).toList();
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<bool> isAppleSignInEnabled() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.socialAppleSignIn);
  }

  Future<bool> isGoogleSignInEnabled() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.socialGoogleSignIn);
  }

  Future<bool> isFacebookSignInEnabled() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.socialFacebookSignIn);
  }

  Future<bool> isAuthorized() async {
    bool uid = await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.authKeys.uid);
    bool authToken = await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.authKeys.authToken);
    if (uid && authToken) {
      return true;
    }
    return false;
  }

  Future<String> appLogo() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.appLogo) ?? '';
  }

  Future<String> ownerResetPasswordWith() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.ownerResetPasswordWith) ?? '';
  }

  Future<DioApiResponse> loginWithEmailPassword(OwnerLoginWithEmailAndPasswordRequestModel login) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLogin, body: login);
  }

  Future<DioApiResponse> loginWithEmailOtpSendEmailVerificationMail(LoginWithEmailOtpSendVerificationMailRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLoginWithEmailOtSendVerification, body: param);
  }

  Future<DioApiResponse> loginWithEmailOtp(LoginWithEmailOtpRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLoginWithEmailOtp, body: param);
  }

  Future<DioApiResponse> loginWithPhonePassword(PhonePasswordLoginRequestModel login) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLoginWithPhonePassword, body: login);
  }

  Future<DioApiResponse> loginWithPhoneOtpSendVerificationSMS(LoginWithPhoneOtpSendVerificationSMSRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLoginWithPhoneOTPSendVerification, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpVerified(PhoneOTPVerifiedLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLoginWithPhoneOTPVerified, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpFirebaseVerified(PhoneOTPFirebaseVerifyRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLoginWithPhoneOTPFirebaseverified, body: param);
  }

  Future<DioApiResponse> loginWithGoogleAccount(GoogleAccountLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLoginWithGoogleAccount, body: param);
  }

  Future<DioApiResponse> loginWithFacebookAccount(FacebookAccountLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.ownerLoginWithFacebookAccount, body: param);
  }

  Future<void> saveLoginResponse(OwnerLoginResponseModel response) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.uid, response.user!.id!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authToken, response.tokens!.access!.token!);
    if (response.tokens != null && response.tokens!.refresh != null && response.tokens!.refresh!.token!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authRefreshToken, response.tokens!.refresh!.token!);
    }
    if (response.user!.id!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenFirstName, response.user!.firstName!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenLastName, response.user!.lastName!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenCover, response.user!.image!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenEmail, response.user!.email!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenRole, response.user!.role!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenCountryCode, response.user!.countryCode!.toString());
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenMobile, response.user!.mobile!);
    }
  }

  Future<void> onLogoutSuccess() async {
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authRefreshToken);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authToken);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.uid);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.kitchenCover);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.kitchenEmail);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.kitchenFirstName);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.kitchenLastName);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.kitchenRole);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.kitchenCountryCode);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.kitchenMobile);
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> kitchenFirstName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.kitchenFirstName) ?? '';
  }

  Future<String> kitchenLastName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.kitchenLastName) ?? '';
  }

  Future<String> kitchenEmail() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.kitchenEmail) ?? '';
  }

  Future<String> kitchenCover() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.kitchenCover) ?? '';
  }

  Future<String> userMobile() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.kitchenMobile) ?? '';
  }

  Future<String> userCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.kitchenCountryCode) ?? '';
  }

  Future<bool> currentTheme() async {
    final isDarkTheme = await (_sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isDark));
    return isDarkTheme;
  }

  Future<DioApiResponse> uploadMediaImage(XFile file, String uid) async {
    return await _apiRequestService.uploadImageFile(ApiEndPoints.v1request.uploadImageFile, uid, file);
  }

  Future<String> getRefreshToken() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.authRefreshToken) ?? '';
  }

  Future<DioApiResponse> logout(String refreshToken) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.logout, body: {'refreshToken': refreshToken});
  }

  Future<DioApiResponse> getPageContent(String slug) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getPageContent}$slug/');
  }

  Future<DioApiResponse> updatePushNotificationToken(PushNotificationTokenRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.updatePushNotificationToken, body: param);
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

  Future<DioApiResponse> getMyProfile(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getProfile}/$id');
  }

  Future<DioApiResponse> verifyOTP(OTPRequest otp) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.verifyOTP, body: otp);
  }

  Future<DioApiResponse> resendOTP(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.resendOTP}$id/');
  }

  Future<DioApiResponse> submitFeedbackForm(FeedbackFormRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveFeedbackForm, body: param);
  }

  Future<DioApiResponse> submitReportEmergencyForm(ReportEmergencyFormRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveReportEmergencyForm, body: param);
  }

  Future<DioApiResponse> updateProfile(String uid, UpdateKitchenProfileRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateProfile}$uid', body: param);
  }

  Future<void> updateProfileInfo(String firstName, String lastName, String image) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenFirstName, firstName);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenLastName, lastName);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.kitchenCover, image);
  }

  Future<DioApiResponse> userNotificationSetting() async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.userNotificationSetting}$userId');
  }

  Future<DioApiResponse> updateNotificationSetting(String id, AccountUpdateNotificationSettingRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateNotificationSetting}$id', body: param);
  }

  Future<DioApiResponse> updateAccountPassword(AccountUpdatePasswordRequestModel param) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAccountPassword}$userId', body: param);
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

  Future<DioApiResponse> getAccountDeleteReason() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.accountDeleteReasonList);
  }

  Future<DioApiResponse> userAccountDelete(KitchenOwnerAccountDeleteRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.deleteDeliverymanAccount, body: param);
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

  Future<bool> isGoogleLoggedIn() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isGoogleLoggedIn);
  }

  Future<bool> isFacebookLoggedIn() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isFacebookLoggedIn);
  }

  Future<String> getMediaUrl() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.mediaUrl) ?? '';
  }

  Future<DioApiResponse> updateLocale(UpdateLocaleRequestModel param) async {
    return await _apiRequestService.patch(ApiEndPoints.v1request.updateUserLocale, body: param);
  }
}
