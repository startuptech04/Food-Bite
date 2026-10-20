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

import 'package:driver/app/core/config/api_endpoints.dart';
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/config/shared_pref_keys.dart';
import 'package:driver/app/core/models/driver_email_password_login_response_model.dart';
import 'package:driver/app/core/models/driver_settings_model.dart';
import 'package:driver/app/core/models/request/account_update_email_after_verification_request_model.dart';
import 'package:driver/app/core/models/request/account_update_email_request_model.dart';
import 'package:driver/app/core/models/request/account_update_mobile_number_after_firebase_verification_request_model.dart';
import 'package:driver/app/core/models/request/account_update_mobile_number_after_verification_request_model.dart';
import 'package:driver/app/core/models/request/account_update_mobile_number_request_model.dart';
import 'package:driver/app/core/models/request/account_update_notification_setting_request_model.dart';
import 'package:driver/app/core/models/request/account_update_password_request_model.dart';
import 'package:driver/app/core/models/request/deliveryman_account_delete_request_model.dart';
import 'package:driver/app/core/models/request/deliveryman_joining_request_model.dart';
import 'package:driver/app/core/models/request/driver_login_with_email_password_request_model.dart';
import 'package:driver/app/core/models/request/email_otp_login_request_model.dart';
import 'package:driver/app/core/models/request/email_otp_send_verification_mail_request_model.dart';
import 'package:driver/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:driver/app/core/models/request/feedback_form_request_model.dart';
import 'package:driver/app/core/models/request/forgot_password_with_email_request_model.dart';
import 'package:driver/app/core/models/request/forgot_password_with_phone_request_model.dart';
import 'package:driver/app/core/models/request/google_account_login_request_model.dart';
import 'package:driver/app/core/models/request/otp_request_model.dart';
import 'package:driver/app/core/models/request/phone_otp_firebase_verify_request_model.dart';
import 'package:driver/app/core/models/request/phone_otp_send_verification_sms_request_model.dart';
import 'package:driver/app/core/models/request/phone_otp_verified_request_model.dart';
import 'package:driver/app/core/models/request/phone_password_login_request_model.dart';
import 'package:driver/app/core/models/request/push_notification_token_request_model.dart';
import 'package:driver/app/core/models/request/report_emergency_request_model.dart';
import 'package:driver/app/core/models/request/review_list_request_model.dart';
import 'package:driver/app/core/models/request/update_deliveryman_profile_request_model.dart';
import 'package:driver/app/core/models/request/update_locale_request_model.dart';
import 'package:driver/app/core/models/request/update_password_firebase_request_model.dart';
import 'package:driver/app/core/models/request/update_password_request_model.dart';
import 'package:driver/app/services/shared_pref.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  Future<String> driverLoginWith() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.driverLoginWith) ?? '';
  }

  Future<bool> selfRegistration() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.selfRegistration);
  }

  Future<String> driverResetPasswordWith() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.driverResetPasswordWith) ?? '';
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

  Future<DioApiResponse> logout(String refreshToken) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.logout, body: {'refreshToken': refreshToken});
  }

  Future<String> getRefreshToken() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.authRefreshToken) ?? '';
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<DioApiResponse> submitFeedbackForm(FeedbackFormRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveFeedbackForm, body: param);
  }

  Future<DioApiResponse> submitReportEmergencyForm(ReportEmergencyFormRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveReportEmergencyForm, body: param);
  }

  Future<DioApiResponse> loginWithEmailPassword(DriverLoginWithEmailAndPasswordRequestModel login) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLogin, body: login);
  }

  Future<DioApiResponse> loginWithPhonePassword(PhonePasswordLoginRequestModel login) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLoginWithPhonePassword, body: login);
  }

  Future<DioApiResponse> loginWithEmailOtpSendEmailVerificationMail(LoginWithEmailOtpSendVerificationMailRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLoginWithEmailOtSendVerification, body: param);
  }

  Future<DioApiResponse> loginWithGoogleAccount(GoogleAccountLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLoginWithGoogleAccount, body: param);
  }

  Future<DioApiResponse> loginWithFacebookAccount(FacebookAccountLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLoginWithFacebookAccount, body: param);
  }

  Future<DioApiResponse> verifyOTP(OTPRequest otp) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.verifyOTP, body: otp);
  }

  Future<DioApiResponse> resendOTP(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.resendOTP}$id/');
  }

  Future<DioApiResponse> loginWithEmailOtp(LoginWithEmailOtpRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLoginWithEmailOtp, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpSendVerificationSMS(LoginWithPhoneOtpSendVerificationSMSRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLoginWithPhoneOTPSendVerification, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpVerified(PhoneOTPVerifiedLoginRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLoginWithPhoneOTPVerified, body: param);
  }

  Future<DioApiResponse> loginWithPhoneOtpFirebaseVerified(PhoneOTPFirebaseVerifyRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverLoginWithPhoneOTPFirebaseverified, body: param);
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

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> driverFirstName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.driverFirstName) ?? '';
  }

  Future<String> driverLastName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.driverLastName) ?? '';
  }

  Future<String> driverEmail() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.driverEmail) ?? '';
  }

  Future<String> driverCover() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.driverCover) ?? '';
  }

  Future<bool> currentTheme() async {
    final isDarkTheme = await (_sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isDark));
    return isDarkTheme;
  }

  Future<List<AppDefaultCountryCodeConfigModel>> getCountryList() async {
    final jsonString = await rootBundle.loadString(AssetsUrl.localURL.countryCodeList);
    final listOfJsonElements = jsonDecode(jsonString) as List;
    return listOfJsonElements.map((jsonElement) => AppDefaultCountryCodeConfigModel.fromJson(jsonElement)).toList();
  }

  Future<DioApiResponse> getPageContent(String slug) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getPageContent}$slug/');
  }

  Future<void> saveLoginResponse(DriverLoginResponseModel response) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.uid, response.user!.id!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authToken, response.tokens!.access!.token!);
    if (response.tokens != null && response.tokens!.refresh != null && response.tokens!.refresh!.token!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.authRefreshToken, response.tokens!.refresh!.token!);
    }
    if (response.user!.id!.isNotEmpty) {
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.driverFirstName, response.user!.firstName!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.driverLastName, response.user!.lastName!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.driverCover, response.user!.image!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.driverEmail, response.user!.email!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.driverRole, response.user!.role!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userEmail, response.user!.email!);
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userCountryCode, response.user!.countryCode!.toString());
      await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.userMobile, response.user!.mobile!);
    }
  }

  Future<void> onLogoutSuccess() async {
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authRefreshToken);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authToken);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.uid);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.driverCover);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.driverEmail);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.driverFirstName);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.driverLastName);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.driverRole);
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

  Future<DioApiResponse> getMyProfile(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getProfile}/$id');
  }

  Future<DioApiResponse> uploadMediaImage(XFile file, String uid) async {
    return await _apiRequestService.uploadImageFile(ApiEndPoints.v1request.uploadImageFile, uid, file);
  }

  Future<DioApiResponse> uploadMediaImagePublic(XFile file, String uid) async {
    return await _apiRequestService.uploadImageFile(ApiEndPoints.v1request.uploadPublicImageFile, uid, file);
  }

  Future<DioApiResponse> updateProfile(String uid, UpdateDeliverymanProfileRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateProfile}$uid', body: param);
  }

  Future<void> updateProfileInfo(String firstName, String lastName, String image) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.driverFirstName, firstName);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.driverLastName, lastName);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.driverCover, image);
  }

  Future<DioApiResponse> getMyReviewList(ReviewListRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getDeliverymanReviewList, body: param);
  }

  Future<DioApiResponse> getBasicRegisterRequestDetail() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getBasicRegisterRequestDetail);
  }

  Future<DioApiResponse> delivermanJoiningRequest(DeliverymanJoiningRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.deliverymanJoiningRequest, body: param);
  }

  Future<String> appLogo() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.appLogo) ?? '';
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

  Future<String> userEmail() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.userEmail) ?? '';
  }

  Future<String> userMobile() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.userMobile) ?? '';
  }

  Future<String> userCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.userCountryCode) ?? '';
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

  Future<DioApiResponse> userAccountDelete(DeliverymanAccountDeleteRequestModel param) async {
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

  Future<DioApiResponse> localityByCity(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.localityByCity}$id');
  }

  Future<DioApiResponse> updateLocale(UpdateLocaleRequestModel param) async {
    return await _apiRequestService.patch(ApiEndPoints.v1request.updateUserLocale, body: param);
  }
}
