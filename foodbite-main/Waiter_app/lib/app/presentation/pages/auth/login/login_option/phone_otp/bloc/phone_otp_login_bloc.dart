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
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/models/login_with_phone_otp_verification_response_model.dart';
import 'package:waiter/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:waiter/app/core/models/request/google_account_login_request_model.dart';
import 'package:waiter/app/core/models/request/phone_otp_firebase_verify_request_model.dart';
import 'package:waiter/app/core/models/request/phone_otp_login_form.dart';
import 'package:waiter/app/core/models/request/phone_otp_send_verification_sms_request_model.dart';
import 'package:waiter/app/core/models/request/phone_otp_verified_request_model.dart';
import 'package:waiter/app/core/models/request/push_notification_token_request_model.dart';
import 'package:waiter/app/core/models/server_error_model.dart';
import 'package:waiter/app/core/models/waiter_login_response_model.dart';
import 'package:waiter/app/core/models/waiter_settings_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:waiter/app/env.dart';

part 'phone_otp_login_event.dart';
part 'phone_otp_login_state.dart';

class PhoneOtpLoginBloc extends Bloc<PhoneOtpLoginEvent, PhoneOtpLoginState> {
  final AuthRepository _authRepository = AuthRepository();
  PhoneOtpLoginBloc()
    : super(
        PhoneOtpLoginState(
          verification: LoginWithPhoneOtpVerificationResponseModel(sent: false, target: '', method: '', otpLength: 0, canResendOtp: false, id: '', provider: ''),
        ),
      ) {
    on<PhoneOtpLoginInitialEvent>(_onPhoneOtpLoginInitialEvent);
    on<PhoneOtpCountryCodeChangedEvent>(_onPhoneOtpCountryCodeChangedEvent);
    on<PhoneOtpCountryCodeUnfocusedEvent>(_onPhoneOtpCountryCodeUnfocusedEvent);
    on<PhoneOtpMobileNumberChangedEvent>(_onPhoneOtpMobileNumberChangedEvent);
    on<PhoneOtpMobileNumberUnfocusedEvent>(_onPhoneOtpMobileNumberUnfocusedEvent);
    on<PhoneOtpRememberChangedEvent>(_onPhoneOtpRememberChangedEvent);
    on<PhoneOtpFormSubmittedEvent>(_onPhoneOtpFormSubmittedEvent);
    on<PhoneOtpLoginNowEvent>(_onPhoneOtpLoginNowEvent);
    on<PhoneOtpFirebaseVerificationEvent>(_onPhoneOtpFirebaseVerificationEvent);
    on<LoginWithGoogleAccountEvent>(_onLoginWithGoogleAccountEvent);
    on<LoginWithGoogleLoginFailedEvent>(_onLoginWithGoogleLoginFailedEvent);
    on<LoginWithGoogleLoginAfterSuccessEvent>(_onLoginWithGoogleLoginAfterSuccessEvent);
    on<LoginWithFacebookAccountEvent>(_onLoginWithFacebookAccountEvent);
  }

  FutureOr<void> _onPhoneOtpLoginInitialEvent(PhoneOtpLoginInitialEvent event, Emitter<PhoneOtpLoginState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "login_phone_otp"}, 'login_with_phone_otp_screen', 'login_with_phone_otp_screen');
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
              status: PhoneOtpLoginStatus.loaded,
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
    final bool appleSignIn = await _authRepository.isAppleSignInEnabled();
    final bool googleSignIn = await _authRepository.isGoogleSignInEnabled();
    final bool facebookSignIn = await _authRepository.isFacebookSignInEnabled();
    emit(state.copyWith(appleSignInEnabled: appleSignIn, googleSignInEnabled: googleSignIn, facebookSignInEnabled: facebookSignIn, status: PhoneOtpLoginStatus.initial));
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

  FutureOr<void> _onPhoneOtpCountryCodeChangedEvent(PhoneOtpCountryCodeChangedEvent event, Emitter<PhoneOtpLoginState> emit) async {
    final countryCode = LoginWithTypeFourCountryCodeField.dirty(event.countryCode);
    emit(state.copyWith(countryCode: countryCode.isValid ? countryCode : LoginWithTypeFourCountryCodeField.pure(event.countryCode), status: PhoneOtpLoginStatus.initial, isValid: Formz.validate([countryCode, state.mobileNumber])));
  }

  FutureOr<void> _onPhoneOtpCountryCodeUnfocusedEvent(PhoneOtpCountryCodeUnfocusedEvent event, Emitter<PhoneOtpLoginState> emit) async {
    final countryCode = LoginWithTypeFourCountryCodeField.dirty(state.countryCode.value);
    emit(state.copyWith(countryCode: countryCode, status: PhoneOtpLoginStatus.initial, isValid: Formz.validate([countryCode, state.mobileNumber])));
  }

  FutureOr<void> _onPhoneOtpMobileNumberChangedEvent(PhoneOtpMobileNumberChangedEvent event, Emitter<PhoneOtpLoginState> emit) async {
    final mobileNumber = LoginWithTypeFourMobileNumberField.dirty(event.mobileNumber);
    emit(
      state.copyWith(
        mobileNumber: mobileNumber.isValid ? mobileNumber : LoginWithTypeFourMobileNumberField.pure(event.mobileNumber),
        status: PhoneOtpLoginStatus.initial,
        isValid: Formz.validate([mobileNumber, state.countryCode]),
      ),
    );
  }

  FutureOr<void> _onPhoneOtpMobileNumberUnfocusedEvent(PhoneOtpMobileNumberUnfocusedEvent event, Emitter<PhoneOtpLoginState> emit) async {
    final mobileNumber = LoginWithTypeFourMobileNumberField.dirty(state.mobileNumber.value);
    emit(state.copyWith(mobileNumber: mobileNumber, status: PhoneOtpLoginStatus.initial, isValid: Formz.validate([mobileNumber, state.countryCode])));
  }

  FutureOr<void> _onPhoneOtpRememberChangedEvent(PhoneOtpRememberChangedEvent event, Emitter<PhoneOtpLoginState> emit) async {
    final remember = LoginWithTypeFourRememberMeField.pure(event.checked);
    emit(state.copyWith(remember: remember, status: PhoneOtpLoginStatus.initial));
  }

  FutureOr<void> _onPhoneOtpFormSubmittedEvent(PhoneOtpFormSubmittedEvent event, Emitter<PhoneOtpLoginState> emit) async {
    final countryCode = LoginWithTypeFourCountryCodeField.dirty(state.countryCode.value);
    final mobileNumber = LoginWithTypeFourMobileNumberField.dirty(state.mobileNumber.value);
    final rememeber = LoginWithTypeFourRememberMeField.dirty(state.remember.value);
    emit(state.copyWith(countryCode: countryCode, mobileNumber: mobileNumber, remember: rememeber, status: PhoneOtpLoginStatus.initial, isValid: Formz.validate([countryCode, mobileNumber])));
    if (state.isValid && state.countryCode.value.isNotEmpty && state.mobileNumber.value.isNotEmpty) {
      try {
        emit(state.copyWith(status: PhoneOtpLoginStatus.inProgress));
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
                status: data.method! == 'firebase' ? PhoneOtpLoginStatus.verifyFirebase : PhoneOtpLoginStatus.verifyWeb,
                locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage,
              ),
            );
          } else {
            emit(state.copyWith(verification: data, status: PhoneOtpLoginStatus.verify, locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: PhoneOtpLoginStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: PhoneOtpLoginStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onPhoneOtpLoginNowEvent(PhoneOtpLoginNowEvent event, Emitter<PhoneOtpLoginState> emit) async {
    try {
      emit(state.copyWith(status: PhoneOtpLoginStatus.inProgress));
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
        WaiterLoginResponseModel data = WaiterLoginResponseModel.fromJson(myMap);
        await _authRepository.saveLoginResponse(data);
        if (!kIsWeb) {
          var notificationStatus = await Permission.notification.status;
          if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
            final String user = await _authRepository.waiterId();
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
        emit(state.copyWith(status: PhoneOtpLoginStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PhoneOtpLoginStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PhoneOtpLoginStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPhoneOtpFirebaseVerificationEvent(PhoneOtpFirebaseVerificationEvent event, Emitter<PhoneOtpLoginState> emit) async {
    try {
      emit(state.copyWith(status: PhoneOtpLoginStatus.inProgress));
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
        WaiterLoginResponseModel data = WaiterLoginResponseModel.fromJson(myMap);
        await _authRepository.saveLoginResponse(data);
        if (!kIsWeb) {
          var notificationStatus = await Permission.notification.status;
          if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
            final String user = await _authRepository.waiterId();
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
        emit(state.copyWith(status: PhoneOtpLoginStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PhoneOtpLoginStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PhoneOtpLoginStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginWithGoogleAccountEvent(LoginWithGoogleAccountEvent event, Emitter<PhoneOtpLoginState> emit) async {
    if (!kIsWeb) {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        emit(state.copyWith(status: PhoneOtpLoginStatus.inProgress, googleSocialLoginClicked: true));
        await GoogleSignIn.instance.authenticate();
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

  FutureOr<void> _onLoginWithGoogleLoginFailedEvent(LoginWithGoogleLoginFailedEvent event, Emitter<PhoneOtpLoginState> emit) async {
    emit(state.copyWith(status: PhoneOtpLoginStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: event.error.toString(), extraMessage: ''));
  }

  FutureOr<void> _onLoginWithGoogleLoginAfterSuccessEvent(LoginWithGoogleLoginAfterSuccessEvent event, Emitter<PhoneOtpLoginState> emit) async {
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
        WaiterLoginResponseModel data = WaiterLoginResponseModel.fromJson(myMap);
        await _authRepository.saveGoogleLogin();
        await _authRepository.saveLoginResponse(data);
        if (!kIsWeb) {
          var notificationStatus = await Permission.notification.status;
          if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
            final String user = await _authRepository.waiterId();
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
        emit(state.copyWith(status: PhoneOtpLoginStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PhoneOtpLoginStatus.failure, googleSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PhoneOtpLoginStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginWithFacebookAccountEvent(LoginWithFacebookAccountEvent event, Emitter<PhoneOtpLoginState> emit) async {
    if (!kIsWeb) {
      try {
        emit(state.copyWith(status: PhoneOtpLoginStatus.inProgress, facebookSocialLoginClicked: true));
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
            WaiterLoginResponseModel data = WaiterLoginResponseModel.fromJson(myMap);
            await _authRepository.saveFacebookLogin();
            await _authRepository.saveLoginResponse(data);
            if (!kIsWeb) {
              var notificationStatus = await Permission.notification.status;
              if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
                final String user = await _authRepository.waiterId();
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
            emit(state.copyWith(status: PhoneOtpLoginStatus.success));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: PhoneOtpLoginStatus.failure, facebookSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          emit(state.copyWith(status: PhoneOtpLoginStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: result.message.toString(), extraMessage: ''));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: PhoneOtpLoginStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
