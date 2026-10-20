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

part of 'login_bloc.dart';

enum LoginStatus { initial, notificationGranted, notificationDicline, home }

extension LoginStatusX on LoginStatus {
  bool get isInitial => this == LoginStatus.initial;
  bool get isNotificationGranted => this == LoginStatus.notificationGranted;
  bool get isNotificationDicline => this == LoginStatus.notificationDicline;
  bool get isHome => this == LoginStatus.home;
}

final class LoginState {
  final String waiterLoginWith;
  final bool appleSignInEnabled;
  final bool googleSignInEnabled;
  final bool facebookSignInEnabled;
  final String locale;
  final LoginStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const LoginState({
    this.waiterLoginWith = 'email_password',
    this.locale = '',
    this.appleSignInEnabled = false,
    this.googleSignInEnabled = false,
    this.facebookSignInEnabled = false,
    this.status = LoginStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  LoginState copyWith({String? waiterLoginWith, String? locale, bool? appleSignInEnabled, bool? googleSignInEnabled, bool? facebookSignInEnabled, LoginStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return LoginState(
      waiterLoginWith: waiterLoginWith ?? this.waiterLoginWith,
      locale: locale ?? this.locale,
      appleSignInEnabled: appleSignInEnabled ?? this.appleSignInEnabled,
      googleSignInEnabled: googleSignInEnabled ?? this.googleSignInEnabled,
      facebookSignInEnabled: facebookSignInEnabled ?? this.facebookSignInEnabled,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
