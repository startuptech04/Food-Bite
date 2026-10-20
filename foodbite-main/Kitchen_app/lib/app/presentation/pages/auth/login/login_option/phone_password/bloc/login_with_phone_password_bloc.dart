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
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/models/kitchen_owner_setting_model.dart';
import 'package:kitchen/app/core/models/owner_email_password_login_response_model.dart';
import 'package:kitchen/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:kitchen/app/core/models/request/google_account_login_request_model.dart';
import 'package:kitchen/app/core/models/request/phone_password_login_request_model.dart';
import 'package:kitchen/app/core/models/request/push_notification_token_request_model.dart';
import 'package:kitchen/app/core/models/server_error_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/core/validations/login_form/phone_password_login_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kitchen/app/env.dart';
import 'package:permission_handler/permission_handler.dart';

part 'login_with_phone_password_event.dart';
part 'login_with_phone_password_state.dart';

class LoginWithPhonePasswordBloc extends Bloc<LoginWithPhonePasswordEvent, LoginWithPhonePasswordState> {
  final AuthRepository _authRepository = AuthRepository();
  LoginWithPhonePasswordBloc() : super(const LoginWithPhonePasswordState()) {
    on<LoginWithPhonePasswordInitialEvent>(_onLoginWithPhonePasswordInitialEvent);
    on<LoginWithPhonePasswordCountryCodeChangedEvent>(_onLoginWithPhonePasswordCountryCodeChangedEvent);
    on<LoginWithPhonePasswordCountryCodeUnfocusedEvent>(_onLoginWithPhonePasswordCountryCodeUnfocusedEvent);
    on<LoginWithPhonePasswordMobileNumberChangedEvent>(_onLoginWithPhonePasswordMobileNumberChangedEvent);
    on<LoginWithPhonePasswordMobileNumberUnfocusedEvent>(_onLoginWithPhonePasswordMobileNumberUnfocusedEvent);
    on<LoginWithPhonePasswordChangedEvent>(_onLoginWithPhonePasswordChangedEvent);
    on<LoginWithPhonePasswordUnfocusedEvent>(_onLoginWithPhonePasswordUnfocusedEvent);
    on<LoginWithPhonePasswordRememberChangedEvent>(_onLoginWithPhonePasswordRememberChangedEvent);
    on<LoginWithPhonePasswordFormSubmitEvent>(_onLoginWithPhonePasswordFormSubmitEvent);
    on<LoginWithGoogleAccountEvent>(_onLoginWithGoogleAccountEvent);
    on<LoginWithGoogleLoginFailedEvent>(_onLoginWithGoogleLoginFailedEvent);
    on<LoginWithGoogleLoginAfterSuccessEvent>(_onLoginWithGoogleLoginAfterSuccessEvent);
    on<LoginWithFacebookAccountEvent>(_onLoginWithFacebookAccountEvent);
  }

  FutureOr<void> _onLoginWithPhonePasswordInitialEvent(LoginWithPhonePasswordInitialEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "login_phone_password"}, 'login_with_phone_password_screen', 'login_with_phone_password_screen');
    await _authRepository.getDefaultCountryCode().then((value) {
      if (value.isNotEmpty) {
        try {
          Map<String, dynamic>? myMap = jsonDecode(value) as Map<String, dynamic>;
          AppDefaultCountryCodeConfigModel countryCodeData = AppDefaultCountryCodeConfigModel.fromJson(myMap);
          final countryCode = LoginWithTypeTwoCountryCodeField.dirty(countryCodeData.dialCode!);
          emit(
            state.copyWith(
              countryCode: countryCode.isValid ? countryCode : LoginWithTypeTwoCountryCodeField.pure(countryCodeData.dialCode!),
              flag: countryCodeData.flag!,
              status: LoginWithPhonePasswordStatus.loaded,
              isValid: Formz.validate([countryCode, state.mobileNumber, state.password, state.remember]),
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
    emit(state.copyWith(appleSignInEnabled: appleSignIn, googleSignInEnabled: googleSignIn, facebookSignInEnabled: facebookSignIn, status: LoginWithPhonePasswordStatus.initial));
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

  FutureOr<void> _onLoginWithPhonePasswordCountryCodeChangedEvent(LoginWithPhonePasswordCountryCodeChangedEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    final countryCode = LoginWithTypeTwoCountryCodeField.dirty(event.countryCode);
    emit(
      state.copyWith(
        countryCode: countryCode.isValid ? countryCode : LoginWithTypeTwoCountryCodeField.pure(event.countryCode),
        status: LoginWithPhonePasswordStatus.initial,
        isValid: Formz.validate([countryCode, state.mobileNumber, state.password]),
      ),
    );
  }

  FutureOr<void> _onLoginWithPhonePasswordCountryCodeUnfocusedEvent(LoginWithPhonePasswordCountryCodeUnfocusedEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    final countryCode = LoginWithTypeTwoCountryCodeField.dirty(state.countryCode.value);
    emit(state.copyWith(countryCode: countryCode, status: LoginWithPhonePasswordStatus.initial, isValid: Formz.validate([countryCode, state.password, state.mobileNumber])));
  }

  FutureOr<void> _onLoginWithPhonePasswordMobileNumberChangedEvent(LoginWithPhonePasswordMobileNumberChangedEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    final mobileNumber = LoginWithTypeTwoMobileNumberField.dirty(event.mobileNumber);
    emit(
      state.copyWith(
        mobileNumber: mobileNumber.isValid ? mobileNumber : LoginWithTypeTwoMobileNumberField.pure(event.mobileNumber),
        status: LoginWithPhonePasswordStatus.initial,
        isValid: Formz.validate([mobileNumber, state.countryCode, state.password]),
      ),
    );
  }

  FutureOr<void> _onLoginWithPhonePasswordMobileNumberUnfocusedEvent(LoginWithPhonePasswordMobileNumberUnfocusedEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    final mobileNumber = LoginWithTypeTwoMobileNumberField.dirty(state.mobileNumber.value);
    emit(state.copyWith(mobileNumber: mobileNumber, status: LoginWithPhonePasswordStatus.initial, isValid: Formz.validate([mobileNumber, state.password, state.countryCode])));
  }

  FutureOr<void> _onLoginWithPhonePasswordChangedEvent(LoginWithPhonePasswordChangedEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    final password = LoginWithTypeTwoPasswordField.dirty(event.password);
    emit(
      state.copyWith(
        password: password.isValid ? password : LoginWithTypeTwoPasswordField.pure(event.password),
        status: LoginWithPhonePasswordStatus.initial,
        isValid: Formz.validate([password, state.countryCode, state.mobileNumber]),
      ),
    );
  }

  FutureOr<void> _onLoginWithPhonePasswordUnfocusedEvent(LoginWithPhonePasswordUnfocusedEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    final password = LoginWithTypeTwoPasswordField.dirty(state.password.value);
    emit(state.copyWith(password: password, status: LoginWithPhonePasswordStatus.initial, isValid: Formz.validate([password, state.countryCode, state.mobileNumber])));
  }

  FutureOr<void> _onLoginWithPhonePasswordRememberChangedEvent(LoginWithPhonePasswordRememberChangedEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    final remember = LoginWithTypeTwoRememberMeField.pure(event.checked);
    emit(state.copyWith(remember: remember, status: LoginWithPhonePasswordStatus.initial));
  }

  FutureOr<void> _onLoginWithPhonePasswordFormSubmitEvent(LoginWithPhonePasswordFormSubmitEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    final countryCode = LoginWithTypeTwoCountryCodeField.dirty(state.countryCode.value);
    final mobileNumber = LoginWithTypeTwoMobileNumberField.dirty(state.mobileNumber.value);
    final password = LoginWithTypeTwoPasswordField.dirty(state.password.value);
    final rememeber = LoginWithTypeTwoRememberMeField.dirty(state.remember.value);
    emit(state.copyWith(countryCode: countryCode, mobileNumber: mobileNumber, password: password, remember: rememeber, status: LoginWithPhonePasswordStatus.initial, isValid: Formz.validate([countryCode, mobileNumber, password])));
    if (state.isValid && state.countryCode.value.isNotEmpty && state.mobileNumber.value.isNotEmpty && state.password.value.isNotEmpty) {
      try {
        emit(state.copyWith(status: LoginWithPhonePasswordStatus.inProgress));
        String userAgent = 'unknown';
        if (kIsWeb) {
          userAgent = 'browser';
        } else if (Platform.isAndroid) {
          userAgent = 'android';
        } else if (Platform.isIOS) {
          userAgent = 'ios';
        }
        final String appLocale = await _authRepository.getLocale();
        PhonePasswordLoginRequestModel loginParam = PhonePasswordLoginRequestModel(
          countryCode: countryCode.value.toString(),
          mobileNumber: mobileNumber.value.toString(),
          password: state.password.value.toString(),
          remember: state.remember.value,
          userAgent: userAgent,
          locale: appLocale.isNotEmpty ? appLocale : Environments.defaultLanguage,
        );
        DioApiResponse response = await _authRepository.loginWithPhonePassword(loginParam);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OwnerLoginResponseModel data = OwnerLoginResponseModel.fromJson(myMap);
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

          emit(state.copyWith(status: LoginWithPhonePasswordStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: LoginWithPhonePasswordStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: LoginWithPhonePasswordStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onLoginWithGoogleAccountEvent(LoginWithGoogleAccountEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    if (!kIsWeb) {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        emit(state.copyWith(status: LoginWithPhonePasswordStatus.inProgress, googleSocialLoginClicked: true));
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

  FutureOr<void> _onLoginWithGoogleLoginFailedEvent(LoginWithGoogleLoginFailedEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    emit(state.copyWith(status: LoginWithPhonePasswordStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: event.error.toString(), extraMessage: ''));
  }

  FutureOr<void> _onLoginWithGoogleLoginAfterSuccessEvent(LoginWithGoogleLoginAfterSuccessEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
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
        OwnerLoginResponseModel data = OwnerLoginResponseModel.fromJson(myMap);
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

        emit(state.copyWith(status: LoginWithPhonePasswordStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: LoginWithPhonePasswordStatus.failure, googleSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: LoginWithPhonePasswordStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginWithFacebookAccountEvent(LoginWithFacebookAccountEvent event, Emitter<LoginWithPhonePasswordState> emit) async {
    if (!kIsWeb) {
      try {
        emit(state.copyWith(status: LoginWithPhonePasswordStatus.inProgress, facebookSocialLoginClicked: true));
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
            OwnerLoginResponseModel data = OwnerLoginResponseModel.fromJson(myMap);
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

            emit(state.copyWith(status: LoginWithPhonePasswordStatus.success));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: LoginWithPhonePasswordStatus.failure, facebookSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          emit(state.copyWith(status: LoginWithPhonePasswordStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: result.message.toString(), extraMessage: ''));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: LoginWithPhonePasswordStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
