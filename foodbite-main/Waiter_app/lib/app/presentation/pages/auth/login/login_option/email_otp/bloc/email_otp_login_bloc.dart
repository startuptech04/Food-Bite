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
import 'package:waiter/app/core/models/otp_verification_response_model.dart';
import 'package:waiter/app/core/models/request/email_otp_login_request_model.dart';
import 'package:waiter/app/core/models/request/email_otp_send_verification_mail_request_model.dart';
import 'package:waiter/app/core/models/request/facebook_account_login_request_model.dart';
import 'package:waiter/app/core/models/request/google_account_login_request_model.dart';
import 'package:waiter/app/core/models/request/push_notification_token_request_model.dart';
import 'package:waiter/app/core/models/server_error_model.dart';
import 'package:waiter/app/core/models/waiter_login_response_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/core/validations/login_form/email_otp_login_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:waiter/app/env.dart';

part 'email_otp_login_event.dart';
part 'email_otp_login_state.dart';

class EmailOtpLoginBloc extends Bloc<EmailOtpLoginEvent, EmailOtpLoginState> {
  final AuthRepository _authRepository = AuthRepository();
  EmailOtpLoginBloc()
    : super(
        EmailOtpLoginState(
          verification: OtpVerificationResponseModel(sent: false, provider: '', mode: '', otpLength: 0, canResendOtp: false, id: ''),
        ),
      ) {
    on<EmailOtpLoginInitialEvent>(_onEmailOtpLoginInitialEvent);
    on<EmailOtpLoginEmailChangedEvent>(_onEmailOtpLoginEmailChangedEvent);
    on<EmailOtpLoginEmailUnfocusedEvent>(_onEmailOtpLoginEmailUnfocusedEvent);
    on<EmailOtpLoginRememberChangedEvent>(_onEmailOtpLoginRememberChangedEvent);
    on<EmailOtpLoginFormSubmitEvent>(_onEmailOtpLoginFormSubmitEvent);
    on<EmailOtpLoginLoginNowEvent>(_onEmailOtpLoginLoginNowEvent);
    on<LoginWithGoogleAccountEvent>(_onLoginWithGoogleAccountEvent);
    on<LoginWithGoogleLoginFailedEvent>(_onLoginWithGoogleLoginFailedEvent);
    on<LoginWithGoogleLoginAfterSuccessEvent>(_onLoginWithGoogleLoginAfterSuccessEvent);
    on<LoginWithFacebookAccountEvent>(_onLoginWithFacebookAccountEvent);
  }

  FutureOr<void> _onEmailOtpLoginInitialEvent(EmailOtpLoginInitialEvent event, Emitter<EmailOtpLoginState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "login_email_otp"}, 'login_with_email_otp_screen', 'login_with_email_otp_screen');
    final bool appleSignIn = await _authRepository.isAppleSignInEnabled();
    final bool googleSignIn = await _authRepository.isGoogleSignInEnabled();
    final bool facebookSignIn = await _authRepository.isFacebookSignInEnabled();
    emit(state.copyWith(appleSignInEnabled: appleSignIn, googleSignInEnabled: googleSignIn, facebookSignInEnabled: facebookSignIn, status: EmailOtpLoginStatus.initial));
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

  FutureOr<void> _onEmailOtpLoginEmailChangedEvent(EmailOtpLoginEmailChangedEvent event, Emitter<EmailOtpLoginState> emit) async {
    final email = LoginWithTypeThreeEmailField.dirty(event.email);
    emit(state.copyWith(email: email.isValid ? email : LoginWithTypeThreeEmailField.pure(event.email), status: EmailOtpLoginStatus.initial, isValid: Formz.validate([email])));
  }

  FutureOr<void> _onEmailOtpLoginEmailUnfocusedEvent(EmailOtpLoginEmailUnfocusedEvent event, Emitter<EmailOtpLoginState> emit) async {
    final email = LoginWithTypeThreeEmailField.dirty(state.email.value);
    emit(state.copyWith(email: email, status: EmailOtpLoginStatus.initial, isValid: Formz.validate([email])));
  }

  FutureOr<void> _onEmailOtpLoginRememberChangedEvent(EmailOtpLoginRememberChangedEvent event, Emitter<EmailOtpLoginState> emit) async {
    final remember = LoginWithTypeThreeRememberMeField.pure(event.checked);
    emit(state.copyWith(remember: remember, status: EmailOtpLoginStatus.initial));
  }

  FutureOr<void> _onEmailOtpLoginFormSubmitEvent(EmailOtpLoginFormSubmitEvent event, Emitter<EmailOtpLoginState> emit) async {
    final email = LoginWithTypeThreeEmailField.dirty(state.email.value);
    final rememeber = LoginWithTypeThreeRememberMeField.dirty(state.remember.value);
    emit(state.copyWith(email: email, remember: rememeber, status: EmailOtpLoginStatus.initial, isValid: Formz.validate([email])));
    if (state.isValid && state.email.value.isNotEmpty) {
      try {
        emit(state.copyWith(status: EmailOtpLoginStatus.inProgress));
        final String defaultLocale = await _authRepository.getLocale();
        LoginWithEmailOtpSendVerificationMailRequestModel param = LoginWithEmailOtpSendVerificationMailRequestModel(email: state.email.value, locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage);
        DioApiResponse response = await _authRepository.loginWithEmailOtpSendEmailVerificationMail(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OtpVerificationResponseModel data = OtpVerificationResponseModel.fromJson(myMap);
          emit(state.copyWith(verification: data, status: EmailOtpLoginStatus.verify));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: EmailOtpLoginStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: EmailOtpLoginStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onEmailOtpLoginLoginNowEvent(EmailOtpLoginLoginNowEvent event, Emitter<EmailOtpLoginState> emit) async {
    try {
      emit(state.copyWith(status: EmailOtpLoginStatus.inProgress));
      final String defaultLocale = await _authRepository.getLocale();
      String userAgent = 'unknown';
      if (kIsWeb) {
        userAgent = 'browser';
      } else if (Platform.isAndroid) {
        userAgent = 'android';
      } else if (Platform.isIOS) {
        userAgent = 'ios';
      }
      LoginWithEmailOtpRequestModel param = LoginWithEmailOtpRequestModel(
        email: state.email.value,
        locale: defaultLocale.isNotEmpty ? defaultLocale : Environments.defaultLanguage,
        userAgent: userAgent,
        remember: state.remember.value,
        verificationId: state.verification.id!.isNotEmpty ? state.verification.id! : '',
        verificationCode: event.otp.isNotEmpty ? event.otp : '',
      );
      DioApiResponse response = await _authRepository.loginWithEmailOtp(param);
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
        emit(state.copyWith(status: EmailOtpLoginStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: EmailOtpLoginStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: EmailOtpLoginStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginWithGoogleAccountEvent(LoginWithGoogleAccountEvent event, Emitter<EmailOtpLoginState> emit) async {
    if (!kIsWeb) {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        emit(state.copyWith(status: EmailOtpLoginStatus.inProgress, googleSocialLoginClicked: true));
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

  FutureOr<void> _onLoginWithGoogleLoginFailedEvent(LoginWithGoogleLoginFailedEvent event, Emitter<EmailOtpLoginState> emit) async {
    emit(state.copyWith(status: EmailOtpLoginStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: event.error.toString(), extraMessage: ''));
  }

  FutureOr<void> _onLoginWithGoogleLoginAfterSuccessEvent(LoginWithGoogleLoginAfterSuccessEvent event, Emitter<EmailOtpLoginState> emit) async {
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
        emit(state.copyWith(status: EmailOtpLoginStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: EmailOtpLoginStatus.failure, googleSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: EmailOtpLoginStatus.failure, googleSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginWithFacebookAccountEvent(LoginWithFacebookAccountEvent event, Emitter<EmailOtpLoginState> emit) async {
    if (!kIsWeb) {
      try {
        emit(state.copyWith(status: EmailOtpLoginStatus.inProgress, facebookSocialLoginClicked: true));
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
            emit(state.copyWith(status: EmailOtpLoginStatus.success));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: EmailOtpLoginStatus.failure, facebookSocialLoginClicked: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          emit(state.copyWith(status: EmailOtpLoginStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: result.message.toString(), extraMessage: ''));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: EmailOtpLoginStatus.failure, facebookSocialLoginClicked: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
