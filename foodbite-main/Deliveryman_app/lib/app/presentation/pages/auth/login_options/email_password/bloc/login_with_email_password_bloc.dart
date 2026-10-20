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
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/models/driver_email_password_login_response_model.dart';
import 'package:driver/app/core/models/request/driver_login_with_email_password_request_model.dart';
import 'package:driver/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:driver/app/core/models/request/google_account_login_request_model.dart';
import 'package:driver/app/core/models/request/push_notification_token_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/env.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:formz/formz.dart';
import 'package:driver/app/core/validations/login_forms/email_password_login_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

part 'login_with_email_password_event.dart';
part 'login_with_email_password_state.dart';

class LoginWithEmailPasswordBloc extends Bloc<LoginWithEmailPasswordEvent, LoginWithEmailPasswordState> {
  final AuthRepository _authRepository = AuthRepository();
  LoginWithEmailPasswordBloc() : super(const LoginWithEmailPasswordState()) {
    on<LoginWithEmailPasswordInitialEvent>(_onLoginWithEmailPasswordInitialEvent);
    on<LoginEmailChangedEvent>(_onLoginEmailChangedEvent);
    on<LoginPasswordChangedEvent>(_onLoginPasswordChangedEvent);
    on<LoginEmailUnfocusedEvent>(_onLoginEmailUnfocusedEvent);
    on<LoginPasswordUnfocusedEvent>(_onLoginPasswordUnfocusedEvent);
    on<LoginRememberChangedEvent>(_onLoginRememberChangedEvent);
    on<LoginFormSubmitEvent>(_onLoginFormSubmitEvent);
    on<LoginWithGoogleAccountEvent>(_onLoginWithGoogleAccountEvent);
    on<LoginWithGoogleLoginFailedEvent>(_onLoginWithGoogleLoginFailedEvent);
    on<LoginWithGoogleLoginAfterSuccessEvent>(_onLoginWithGoogleLoginAfterSuccessEvent);
    on<LoginWithFacebookAccountEvent>(_onLoginWithFacebookAccountEvent);
  }

  FutureOr<void> _onLoginWithEmailPasswordInitialEvent(LoginWithEmailPasswordInitialEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "login_email_password"}, 'login_with_email_password_screen', 'login_with_email_password_screen');
    final bool selfRegistration = await _authRepository.selfRegistration();
    final bool appleSignIn = await _authRepository.isAppleSignInEnabled();
    final bool googleSignIn = await _authRepository.isGoogleSignInEnabled();
    final bool facebookSignIn = await _authRepository.isFacebookSignInEnabled();
    emit(state.copyWith(selfRegistration: selfRegistration, appleSignInEnabled: appleSignIn, googleSignInEnabled: googleSignIn, facebookSignInEnabled: facebookSignIn, status: FormzSubmissionStatus.initial));
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

  FutureOr<void> _onLoginEmailChangedEvent(LoginEmailChangedEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    final email = LoginWithTypeOneEmailField.dirty(event.email);
    emit(state.copyWith(email: email.isValid ? email : LoginWithTypeOneEmailField.pure(event.email), status: FormzSubmissionStatus.initial, isValid: Formz.validate([email, state.password])));
  }

  FutureOr<void> _onLoginPasswordChangedEvent(LoginPasswordChangedEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    final password = LoginWithTypeOnePasswordField.dirty(event.password);
    emit(state.copyWith(password: password.isValid ? password : LoginWithTypeOnePasswordField.pure(event.password), status: FormzSubmissionStatus.initial, isValid: Formz.validate([state.email, password])));
  }

  FutureOr<void> _onLoginRememberChangedEvent(LoginRememberChangedEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    final remember = LoginWithTypeOneRememberMeField.pure(event.checked);
    emit(state.copyWith(remember: remember, status: FormzSubmissionStatus.initial));
  }

  FutureOr<void> _onLoginEmailUnfocusedEvent(LoginEmailUnfocusedEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    final email = LoginWithTypeOneEmailField.dirty(state.email.value);
    emit(state.copyWith(email: email, status: FormzSubmissionStatus.initial, isValid: Formz.validate([email, state.password])));
  }

  FutureOr<void> _onLoginPasswordUnfocusedEvent(LoginPasswordUnfocusedEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    final password = LoginWithTypeOnePasswordField.dirty(state.password.value);
    emit(state.copyWith(password: password, status: FormzSubmissionStatus.initial, isValid: Formz.validate([state.email, password])));
  }

  Future<void> _onLoginFormSubmitEvent(LoginFormSubmitEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    final email = LoginWithTypeOneEmailField.dirty(state.email.value);
    final password = LoginWithTypeOnePasswordField.dirty(state.password.value);
    final rememeber = LoginWithTypeOneRememberMeField.dirty(state.remember.value);
    emit(state.copyWith(email: email, password: password, remember: rememeber, status: FormzSubmissionStatus.initial, isValid: Formz.validate([email, password])));
    if (state.isValid && state.email.value.isNotEmpty && state.password.value.isNotEmpty) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
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
        DriverLoginWithEmailAndPasswordRequestModel loginParam = DriverLoginWithEmailAndPasswordRequestModel(
          email: state.email.value.toString(),
          password: state.password.value.toString(),
          remember: state.remember.value,
          userAgent: userAgent,
          locale: appLocale.isNotEmpty ? appLocale : Environments.defaultLanguage,
        );
        DioApiResponse response = await _authRepository.loginWithEmailPassword(loginParam);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          DriverLoginResponseModel data = DriverLoginResponseModel.fromJson(myMap);
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

          emit(state.copyWith(status: FormzSubmissionStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: FormzSubmissionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onLoginWithGoogleAccountEvent(LoginWithGoogleAccountEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    if (!kIsWeb) {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress, googleSocialLoginClicked: true));
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

  FutureOr<void> _onLoginWithGoogleLoginFailedEvent(LoginWithGoogleLoginFailedEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: event.error.toString(), extraMessage: ''));
  }

  FutureOr<void> _onLoginWithGoogleLoginAfterSuccessEvent(LoginWithGoogleLoginAfterSuccessEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
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
        DriverLoginResponseModel data = DriverLoginResponseModel.fromJson(myMap);
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
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FormzSubmissionStatus.failure, googleSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginWithFacebookAccountEvent(LoginWithFacebookAccountEvent event, Emitter<LoginWithEmailPasswordState> emit) async {
    if (!kIsWeb) {
      try {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress, facebookSocialLoginClicked: true));
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
            DriverLoginResponseModel data = DriverLoginResponseModel.fromJson(myMap);
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

            emit(state.copyWith(status: FormzSubmissionStatus.success));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: FormzSubmissionStatus.failure, facebookSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          emit(state.copyWith(status: FormzSubmissionStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: result.message.toString(), extraMessage: ''));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
