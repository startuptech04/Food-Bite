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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/login_with_phone_otp_verification_response_model.dart';
import 'package:vendor/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:vendor/app/core/models/request/google_account_login_request_model.dart';
import 'package:vendor/app/core/models/request/phone_otp_firebase_verify_request_model.dart';
import 'package:vendor/app/core/models/request/phone_otp_send_verification_sms_request_model.dart';
import 'package:vendor/app/core/models/request/phone_otp_verified_request_model.dart';
import 'package:vendor/app/core/models/request/push_notification_token_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/vendor_email_password_login_response_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/auth_repository.dart';
import 'package:vendor/app/core/validations/login_forms/phone_otp_login_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vendor/app/env.dart';

part 'login_with_phone_otp_event.dart';
part 'login_with_phone_otp_state.dart';

class LoginWithPhoneOtpBloc extends Bloc<LoginWithPhoneOtpEvent, LoginWithPhoneOtpState> {
  final AuthRepository _authRepository = AuthRepository();
  final AccountRepository _accountRepository = AccountRepository();
  LoginWithPhoneOtpBloc()
    : super(
        LoginWithPhoneOtpState(
          verification: LoginWithPhoneOtpVerificationResponseModel(sent: false, target: '', method: '', otpLength: 0, canResendOtp: false, id: '', provider: ''),
        ),
      ) {
    on<LoginWithPhoneOtpInitialEvent>(_onLoginWithPhoneOtpInitialEvent);
    on<LoginWithTypeFourCountryCodeChangedEvent>(_onLoginWithTypeFourCountryCodeChangedEvent);
    on<LoginWithTypeFourCountryCodeUnfocusedEvent>(_onLoginWithTypeFourCountryCodeUnfocusedEvent);
    on<LoginWithTypeFourMobileNumberChangedEvent>(_onLoginWithTypeFourMobileNumberChangedEvent);
    on<LoginWithTypeFourMobileNumberUnfocusedEvent>(_onLoginWithTypeFourMobileNumberUnfocusedEvent);
    on<LoginWithTypeFourRememberChangedEvent>(_onLoginWithTypeFourRememberChangedEvent);
    on<LoginWithTypeFourFormSubmitEvent>(_onLoginWithTypeFourFormSubmitEvent);
    on<LoginWithPhoneOtpLoginNowEvent>(_onLoginWithPhoneOtpLoginNowEvent);
    on<LoginWithPhoneOtpFirebaseVerificationEvent>(_onLoginWithPhoneOtpFirebaseVerificationEvent);
    on<LoginWithPhoneOtpGoogleAccountEvent>(_onLoginWithPhoneOtpGoogleAccountEvent);
    on<LoginWithGoogleLoginFailedEvent>(_onLoginWithGoogleLoginFailedEvent);
    on<LoginWithGoogleLoginAfterSuccessEvent>(_onLoginWithGoogleLoginAfterSuccessEvent);
    on<LoginWithPhoneOtpFacebookAccountEvent>(_onLoginWithPhoneOtpFacebookAccountEvent);
  }

  FutureOr<void> _onLoginWithPhoneOtpInitialEvent(LoginWithPhoneOtpInitialEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "login_phone_otp"}, 'login_with_phone_otp_screen', 'login_with_phone_otp_screen');
    await _authRepository.getDefaultCountryCode().then((value) {
      if (value.isNotEmpty) {
        try {
          Map<String, dynamic>? myMap = jsonDecode(value) as Map<String, dynamic>;
          AppDefaultCountryCodeConfigModel countryCodeData = AppDefaultCountryCodeConfigModel.fromJson(myMap);
          final countryCode = LoginWithTypeFourCountryCodeField.dirty(countryCodeData.dialCode!);
          emit(
            state.copyWith(
              countryCode: countryCode.isValid ? countryCode : LoginWithTypeFourCountryCodeField.pure(countryCodeData.dialCode!),
              flag: countryCodeData.flag!,
              status: LoginWithPhoneOtpStatus.loaded,
              isValid: Formz.validate([countryCode, state.mobileNumber, state.remember]),
            ),
          );
        } catch (e, stacktrace) {
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    });
    final bool selfRegistration = await _authRepository.selfRegistration();
    final bool appleSignIn = await _authRepository.isAppleSignInEnabled();
    final bool googleSignIn = await _authRepository.isGoogleSignInEnabled();
    final bool facebookSignIn = await _authRepository.isFacebookSignInEnabled();
    emit(state.copyWith(selfRegistration: selfRegistration, appleSignInEnabled: appleSignIn, googleSignInEnabled: googleSignIn, facebookSignInEnabled: facebookSignIn, status: LoginWithPhoneOtpStatus.initial));
    if (googleSignIn && !kIsWeb) {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      final String clientId = await _authRepository.googleOAuthClientId();
      final String serverId = await _authRepository.googleOAuthServerId();
      unawaited(
        signIn.initialize(clientId: clientId, serverClientId: serverId).then((_) {
          signIn.authenticationEvents.listen(_handleAuthenticationEvent).onError(_handleAuthenticationError);
        }),
      );
    }
  }

  FutureOr<void> _onLoginWithTypeFourCountryCodeChangedEvent(LoginWithTypeFourCountryCodeChangedEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    final countryCode = LoginWithTypeFourCountryCodeField.dirty(event.countryCode);
    emit(
      state.copyWith(countryCode: countryCode.isValid ? countryCode : LoginWithTypeFourCountryCodeField.pure(event.countryCode), status: LoginWithPhoneOtpStatus.initial, isValid: Formz.validate([countryCode, state.mobileNumber])),
    );
  }

  FutureOr<void> _onLoginWithTypeFourCountryCodeUnfocusedEvent(LoginWithTypeFourCountryCodeUnfocusedEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    final countryCode = LoginWithTypeFourCountryCodeField.dirty(state.countryCode.value);
    emit(state.copyWith(countryCode: countryCode, status: LoginWithPhoneOtpStatus.initial, isValid: Formz.validate([countryCode, state.mobileNumber])));
  }

  FutureOr<void> _onLoginWithTypeFourMobileNumberChangedEvent(LoginWithTypeFourMobileNumberChangedEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    final mobileNumber = LoginWithTypeFourMobileNumberField.dirty(event.mobileNumber);
    emit(
      state.copyWith(
        mobileNumber: mobileNumber.isValid ? mobileNumber : LoginWithTypeFourMobileNumberField.pure(event.mobileNumber),
        status: LoginWithPhoneOtpStatus.initial,
        isValid: Formz.validate([mobileNumber, state.countryCode]),
      ),
    );
  }

  FutureOr<void> _onLoginWithTypeFourMobileNumberUnfocusedEvent(LoginWithTypeFourMobileNumberUnfocusedEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    final mobileNumber = LoginWithTypeFourMobileNumberField.dirty(state.mobileNumber.value);
    emit(state.copyWith(mobileNumber: mobileNumber, status: LoginWithPhoneOtpStatus.initial, isValid: Formz.validate([mobileNumber, state.countryCode])));
  }

  FutureOr<void> _onLoginWithTypeFourRememberChangedEvent(LoginWithTypeFourRememberChangedEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    final remember = LoginWithTypeFourRememberMeField.pure(event.checked);
    emit(state.copyWith(remember: remember, status: LoginWithPhoneOtpStatus.initial));
  }

  FutureOr<void> _onLoginWithTypeFourFormSubmitEvent(LoginWithTypeFourFormSubmitEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    final countryCode = LoginWithTypeFourCountryCodeField.dirty(state.countryCode.value);
    final mobileNumber = LoginWithTypeFourMobileNumberField.dirty(state.mobileNumber.value);
    final rememeber = LoginWithTypeFourRememberMeField.dirty(state.remember.value);
    emit(state.copyWith(countryCode: countryCode, mobileNumber: mobileNumber, remember: rememeber, status: LoginWithPhoneOtpStatus.initial, isValid: Formz.validate([countryCode, mobileNumber])));
    if (state.isValid && state.countryCode.value.isNotEmpty && state.mobileNumber.value.isNotEmpty) {
      try {
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.inProgress));
        final String defaultLocale = await _authRepository.getLocale();
        LoginWithPhoneOtpSendVerificationSMSRequestModel param = LoginWithPhoneOtpSendVerificationSMSRequestModel(
          countryCode: state.countryCode.value,
          mobileNumber: int.parse(state.mobileNumber.value.toString()),
          locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage,
        );
        DioApiResponse response = await _authRepository.loginWithPhoneOtpSendVerificationSMS(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          LoginWithPhoneOtpVerificationResponseModel data = LoginWithPhoneOtpVerificationResponseModel.fromJson(myMap);
          if (data.sent == false && data.target == 'web_modal') {
            emit(
              state.copyWith(
                verification: data,
                status: data.method! == 'firebase' ? LoginWithPhoneOtpStatus.verifyFirebase : LoginWithPhoneOtpStatus.verifyWeb,
                locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage,
              ),
            );
          } else {
            emit(state.copyWith(verification: data, status: LoginWithPhoneOtpStatus.verify, locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onLoginWithPhoneOtpLoginNowEvent(LoginWithPhoneOtpLoginNowEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    try {
      emit(state.copyWith(status: LoginWithPhoneOtpStatus.inProgress));
      final String defaultLocale = await _authRepository.getLocale();
      String userAgent = 'unknown';
      if (kIsWeb) {
        userAgent = 'browser';
      } else if (Platform.isAndroid) {
        userAgent = 'android';
      } else if (Platform.isIOS) {
        userAgent = 'ios';
      }
      PhoneOTPVerifiedLoginRequestModel param = PhoneOTPVerifiedLoginRequestModel(
        id: state.verification.id!.isNotEmpty ? state.verification.id! : '',
        remember: state.remember.value,
        locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage,
        userAgent: userAgent,
      );
      DioApiResponse response = await _authRepository.loginWithPhoneOtpVerified(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        VendorLoginResponseModel data = VendorLoginResponseModel.fromJson(myMap);
        await _authRepository.saveLoginResponse(data);
        if (!kIsWeb) {
          var notificationStatus = await Permission.notification.status;
          if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
            final String user = await _authRepository.userId();
            String? pushToken = '';
            String deviceType = '';
            String deviceId = '';
            final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
            await FirebaseMessaging.instance.getToken().then((value) async {
              pushToken = value;
            });
            if (pushToken != null && pushToken!.isNotEmpty) {
              if (Platform.isAndroid) {
                deviceType = 'android';
                var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
                deviceId = '${androidDeviceInfo.host}:${androidDeviceInfo.device}:${androidDeviceInfo.id}:${androidDeviceInfo.model}:${androidDeviceInfo.brand}';
              } else if (Platform.isIOS) {
                deviceType = 'ios';
                var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
                deviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.model}:${iosDeviceInfo.identifierForVendor}';
              }
              if (Platform.isAndroid || Platform.isIOS) {
                PushNotificationTokenRequestModel tokenParam = PushNotificationTokenRequestModel(user: user, deviceId: deviceId, deviceType: deviceType, token: pushToken!);
                await _authRepository.updatePushNotificationToken(tokenParam);
              }
            }
          }
        }
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginWithPhoneOtpFirebaseVerificationEvent(LoginWithPhoneOtpFirebaseVerificationEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    try {
      emit(state.copyWith(status: LoginWithPhoneOtpStatus.inProgress));
      final String defaultLocale = await _authRepository.getLocale();
      String userAgent = 'unknown';
      if (kIsWeb) {
        userAgent = 'browser';
      } else if (Platform.isAndroid) {
        userAgent = 'android';
      } else if (Platform.isIOS) {
        userAgent = 'ios';
      }
      PhoneOTPFirebaseVerifyRequestModel param = PhoneOTPFirebaseVerifyRequestModel(
        token: event.accessToken,
        countryCode: state.countryCode.value,
        mobileNumber: int.parse(state.mobileNumber.value.toString()),
        remember: state.remember.value,
        locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage,
        userAgent: userAgent,
      );
      DioApiResponse response = await _authRepository.loginWithPhoneOtpFirebaseVerified(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        VendorLoginResponseModel data = VendorLoginResponseModel.fromJson(myMap);
        await _authRepository.saveLoginResponse(data);
        if (!kIsWeb) {
          var notificationStatus = await Permission.notification.status;
          if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
            final String user = await _authRepository.userId();
            String? pushToken = '';
            String deviceType = '';
            String deviceId = '';
            final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
            await FirebaseMessaging.instance.getToken().then((value) async {
              pushToken = value;
            });
            if (pushToken != null && pushToken!.isNotEmpty) {
              if (Platform.isAndroid) {
                deviceType = 'android';
                var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
                deviceId = '${androidDeviceInfo.host}:${androidDeviceInfo.device}:${androidDeviceInfo.id}:${androidDeviceInfo.model}:${androidDeviceInfo.brand}';
              } else if (Platform.isIOS) {
                deviceType = 'ios';
                var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
                deviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.model}:${iosDeviceInfo.identifierForVendor}';
              }
              if (Platform.isAndroid || Platform.isIOS) {
                PushNotificationTokenRequestModel tokenParam = PushNotificationTokenRequestModel(user: user, deviceId: deviceId, deviceType: deviceType, token: pushToken!);
                await _authRepository.updatePushNotificationToken(tokenParam);
              }
            }
          }
        }
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginWithPhoneOtpGoogleAccountEvent(LoginWithPhoneOtpGoogleAccountEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    if (!kIsWeb) {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.inProgress, googleSocialLoginClicked: true));
        await GoogleSignIn.instance.authenticate();
      }
    }
  }

  FutureOr<void> _onLoginWithGoogleLoginFailedEvent(LoginWithGoogleLoginFailedEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: event.error.toString(), extraMessage: ''));
  }

  FutureOr<void> _onLoginWithGoogleLoginAfterSuccessEvent(LoginWithGoogleLoginAfterSuccessEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    try {
      String userAgent = 'unknown';
      if (kIsWeb) {
        userAgent = 'browser';
      } else if (Platform.isAndroid) {
        userAgent = 'android';
      } else if (Platform.isIOS) {
        userAgent = 'ios';
      }
      final String appLocale = await _authRepository.getLocale();
      GoogleAccountLoginRequestModel param = GoogleAccountLoginRequestModel(idToken: event.token, remember: state.remember.value, userAgent: userAgent, locale: appLocale.isNotEmpty ? appLocale : Environments.defaultLanguage);
      DioApiResponse response = await _authRepository.loginWithGoogleAccount(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        VendorLoginResponseModel data = VendorLoginResponseModel.fromJson(myMap);
        await _authRepository.saveGoogleLogin();
        await _authRepository.saveLoginResponse(data);
        if (!kIsWeb) {
          var notificationStatus = await Permission.notification.status;
          if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
            final String user = await _authRepository.userId();
            String? pushToken = '';
            String deviceType = '';
            String deviceId = '';
            final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
            await FirebaseMessaging.instance.getToken().then((value) async {
              pushToken = value;
            });
            if (pushToken != null && pushToken!.isNotEmpty) {
              if (Platform.isAndroid) {
                deviceType = 'android';
                var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
                deviceId = '${androidDeviceInfo.host}:${androidDeviceInfo.device}:${androidDeviceInfo.id}:${androidDeviceInfo.model}:${androidDeviceInfo.brand}';
              } else if (Platform.isIOS) {
                deviceType = 'ios';
                var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
                deviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.model}:${iosDeviceInfo.identifierForVendor}';
              }
              if (Platform.isAndroid || Platform.isIOS) {
                PushNotificationTokenRequestModel tokenParam = PushNotificationTokenRequestModel(user: user, deviceId: deviceId, deviceType: deviceType, token: pushToken!);
                await _authRepository.updatePushNotificationToken(tokenParam);
              }
            }
          }
        }
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, googleSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  Future<void> _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) async {
    final GoogleSignInAccount? user = // ...
    switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };
    const List<String> scopes = <String>['email'];
    final GoogleSignInClientAuthorization? authorization = await user?.authorizationClient.authorizationForScopes(scopes);
    if (user != null && authorization != null) {
      add(LoginWithGoogleLoginAfterSuccessEvent(token: user.authentication.idToken!));
    } else {
      add(LoginWithGoogleLoginFailedEvent(error: 'Something went wrong'));
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    final String error = e is GoogleSignInException ? 'GoogleSignInException ${e.code}: ${e.description}' : 'Unknown error: $e';
    add(LoginWithGoogleLoginFailedEvent(error: error));
  }

  FutureOr<void> _onLoginWithPhoneOtpFacebookAccountEvent(LoginWithPhoneOtpFacebookAccountEvent event, Emitter<LoginWithPhoneOtpState> emit) async {
    if (!kIsWeb) {
      try {
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.inProgress, facebookSocialLoginClicked: true));
        final LoginResult result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;
          String userAgent = 'unknown';
          if (kIsWeb) {
            userAgent = 'browser';
          } else if (Platform.isAndroid) {
            userAgent = 'android';
          } else if (Platform.isIOS) {
            userAgent = 'ios';
          }
          final String appLocale = await _authRepository.getLocale();
          FacebookAccountLoginRequestModel param = FacebookAccountLoginRequestModel(
            accessToken: accessToken.tokenString,
            remember: state.remember.value,
            userAgent: userAgent,
            locale: appLocale.isNotEmpty ? appLocale : Environments.defaultLanguage,
          );
          DioApiResponse response = await _authRepository.loginWithFacebookAccount(param);
          if (response.errorType == NetErrorType.none) {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            VendorLoginResponseModel data = VendorLoginResponseModel.fromJson(myMap);
            await _authRepository.saveFacebookLogin();
            await _authRepository.saveLoginResponse(data);
            if (!kIsWeb) {
              var notificationStatus = await Permission.notification.status;
              if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
                final String user = await _authRepository.userId();
                String? pushToken = '';
                String deviceType = '';
                String deviceId = '';
                final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                await FirebaseMessaging.instance.getToken().then((value) async {
                  pushToken = value;
                });
                if (pushToken != null && pushToken!.isNotEmpty) {
                  if (Platform.isAndroid) {
                    deviceType = 'android';
                    var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
                    deviceId = '${androidDeviceInfo.host}:${androidDeviceInfo.device}:${androidDeviceInfo.id}:${androidDeviceInfo.model}:${androidDeviceInfo.brand}';
                  } else if (Platform.isIOS) {
                    deviceType = 'ios';
                    var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
                    deviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.model}:${iosDeviceInfo.identifierForVendor}';
                  }
                  if (Platform.isAndroid || Platform.isIOS) {
                    PushNotificationTokenRequestModel tokenParam = PushNotificationTokenRequestModel(user: user, deviceId: deviceId, deviceType: deviceType, token: pushToken!);
                    await _authRepository.updatePushNotificationToken(tokenParam);
                  }
                }
              }
            }
            emit(state.copyWith(status: LoginWithPhoneOtpStatus.success));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, facebookSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: result.message.toString(), extraMessage: ''));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: LoginWithPhoneOtpStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
