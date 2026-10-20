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
import 'package:waiter/app/core/config/api_endpoints.dart';
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/config/assets_url.dart';
import 'package:waiter/app/core/config/shared_pref_keys.dart';
import 'package:waiter/app/core/models/request/account_update_email_after_verification_request_model.dart';
import 'package:waiter/app/core/models/request/account_update_email_request_model.dart';
import 'package:waiter/app/core/models/request/account_update_mobile_number_after_firebase_verification_request_model.dart';
import 'package:waiter/app/core/models/request/account_update_mobile_number_after_verification_request_model.dart';
import 'package:waiter/app/core/models/request/account_update_mobile_number_request_model.dart';
import 'package:waiter/app/core/models/request/account_update_notification_setting_request_model.dart';
import 'package:waiter/app/core/models/request/account_update_password_request_model.dart';
import 'package:waiter/app/core/models/request/email_otp_login_request_model.dart';
import 'package:waiter/app/core/models/request/email_otp_send_verification_mail_request_model.dart';
import 'package:waiter/app/core/models/request/email_password_login_request_model.dart';
import 'package:waiter/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:waiter/app/core/models/request/feedback_form_request_model.dart';
import 'package:waiter/app/core/models/request/forgot_password_with_email_request_model.dart';
import 'package:waiter/app/core/models/request/forgot_password_with_phone_request_model.dart';
import 'package:waiter/app/core/models/request/google_account_login_request_model.dart';
import 'package:waiter/app/core/models/request/otp_request_model.dart';
import 'package:waiter/app/core/models/request/phone_otp_firebase_verify_request_model.dart';
import 'package:waiter/app/core/models/request/phone_otp_send_verification_sms_request_model.dart';
import 'package:waiter/app/core/models/request/phone_otp_verified_request_model.dart';
import 'package:waiter/app/core/models/request/phone_password_login_request_model.dart';
import 'package:waiter/app/core/models/request/push_notification_token_request_model.dart';
import 'package:waiter/app/core/models/request/report_emergency_request_model.dart';
import 'package:waiter/app/core/models/request/update_locale_request_model.dart';
import 'package:waiter/app/core/models/request/update_password_firebase_request_model.dart';
import 'package:waiter/app/core/models/request/update_password_request_model.dart';
import 'package:waiter/app/core/models/request/update_waiter_profile_request_model.dart';
import 'package:waiter/app/core/models/request/waiter_account_delete_request_model.dart';
import 'package:waiter/app/core/models/waiter_login_response_model.dart';
import 'package:waiter/app/core/models/waiter_settings_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:waiter/app/services/shared_pref.dart';

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

  Future<String> waiterLoginWith() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.waiterLoginWith) ?? '';
  }

  Future<String> getRefreshToken() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.authRefreshToken) ?? '';
  }

  Future<DioApiResponse> logout(String refreshToken) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.logout, body: {'refreshToken': refreshToken});
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<String> waiterId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> waiterFirstName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterFirstName) ?? '';
  }

  Future<String> waiterLastName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterLastName) ?? '';
  }

  Future<String> waiterEmail() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterEmail) ?? '';
  }

  Future<String> waiterMobile() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterMobile) ?? '';
  }

  Future<String> waiterCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterCountryCode) ?? '';
  }

  Future<String> waiterCover() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterCover) ?? '';
  }

  Future<bool> currentTheme() async {
    final isDarkTheme = await (_sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isDark));
    return isDarkTheme;
  }

  Future<bool> isAuthorized() async {
    bool uid = await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.authKeys.uid);
    bool authToken = await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.authKeys.authToken);
    if (uid && authToken) {
      return true;
    }
    return false;
  }

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
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

  Future<DioApiResponse> loginWithEmailPassword(EmailPasswordLoginRequest login) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithEmailAndPassword, body: login);
  }

  Future<DioApiResponse> loginWithPhonePassword(PhonePasswordLoginRequestModel login) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithPhonePassword, body: login);
  }

  Future<DioApiResponse> loginWithEmailOtpSendEmailVerificationMail(LoginWithEmailOtpSendVerificationMailRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithEmailOtSendVerification, body: param);
  }

  Future<DioApiResponse> loginWithEmailOtp(LoginWithEmailOtpRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithEmailOtp, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpSendVerificationSMS(LoginWithPhoneOtpSendVerificationSMSRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithPhoneOTPSendVerification, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpVerified(PhoneOTPVerifiedLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithPhoneOTPVerified, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpFirebaseVerified(PhoneOTPFirebaseVerifyRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithPhoneOTPFirebaseverified, body: param);
  }

  Future<DioApiResponse> loginWithGoogleAccount(GoogleAccountLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithGoogleAccount, body: param);
  }

  Future<DioApiResponse> loginWithFacebookAccount(FacebookAccountLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.loginWithFacebookAccount, body: param);
  }

  Future<DioApiResponse> updatePushNotificationToken(PushNotificationTokenRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.updatePushNotificationToken, body: param);
  }

  Future<void> saveLoginResponse(WaiterLoginResponseModel response) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.uid, response.user!.id!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authToken, response.tokens!.access!.token!);
    if (response.tokens != null && response.tokens!.refresh != null && response.tokens!.refresh!.token!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authRefreshToken, response.tokens!.refresh!.token!);
    }
    if (response.user!.id!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterFirstName, response.user!.firstName!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterLastName, response.user!.lastName!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterCover, response.user!.image!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterCountryCode, response.user!.countryCode!.toString());
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterEmail, response.user!.email!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterMobile, response.user!.mobile!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterRole, response.user!.role!);
    }
    if (response.waiter!.id!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterRestaurant, response.waiter!.restaurant!);
    }
  }

  Future<void> updateProfileInfo(String firstName, String lastName, String image) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterFirstName, firstName);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterLastName, lastName);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.waiterCover, image);
  }

  Future<void> onLogoutSuccess() async {
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authRefreshToken);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authToken);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.uid);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.waiterFirstName);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.waiterLastName);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.waiterMobile);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.waiterCover);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.waiterRole);
  }

  Future<DioApiResponse> getPageContent(String slug) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getPageContent}$slug/');
  }

  Future<List<AppDefaultCountryCodeConfigModel>> getCountryList() async {
    final jsonString = await rootBundle.loadString(AssetsUrl.localURL.countryCodeList);
    final listOfJsonElements = jsonDecode(jsonString) as List;
    return listOfJsonElements.map((jsonElement) => AppDefaultCountryCodeConfigModel.fromJson(jsonElement)).toList();
  }

  Future<DioApiResponse> submitFeedbackForm(FeedbackFormRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveFeedbackForm, body: param);
  }

  Future<DioApiResponse> submitReportEmergencyForm(ReportEmergencyFormRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveReportEmergencyForm, body: param);
  }

  Future<String> appLogo() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.appLogo) ?? '';
  }

  Future<DioApiResponse> getMyProfile(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyProfile}$id');
  }

  Future<DioApiResponse> updateMyProfile(String id, UpdateWaiterProfileRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateMyProfile}$id', body: param);
  }

  Future<DioApiResponse> uploadMediaImage(XFile file, String uid) async {
    return await _apiRequestService.uploadImageFile(ApiEndPoints.v1request.uploadImageFile, uid, file);
  }

  Future<DioApiResponse> verifyOTP(OTPRequest otp) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.verifyOTP, body: otp);
  }

  Future<DioApiResponse> resendOTP(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.resendOTP}$id/');
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

  Future<DioApiResponse> userAccountDelete(WaiterAccountDeleteRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.deleteWaiterAccount, body: param);
  }

  Future<String> waiterResetPasswordWith() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.waiterResetPasswordWith) ?? '';
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
