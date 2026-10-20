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

part of 'account_bloc.dart';

enum AccountStatus { initial, logoutStart, logoutSuccess, logoutFailed }

extension AccountStatusX on AccountStatus {
  bool get isInitial => this == AccountStatus.initial;
  bool get isLogoutStart => this == AccountStatus.logoutStart;
  bool get isLogoutSuccess => this == AccountStatus.logoutSuccess;
  bool get isLogoutFailed => this == AccountStatus.logoutFailed;
}

final class AccountState {
  final String appLogo;
  final String currentVersion;
  final String driverName;
  final String driverEmail;
  final String driverCover;
  final bool lightMode;
  final String locale;
  final bool isGoogleLoggedIn;
  final bool isFacebookLoggedIn;
  final AccountStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const AccountState({
    this.appLogo = '',
    this.currentVersion = '',
    this.driverName = '',
    this.driverEmail = '',
    this.driverCover = '',
    this.lightMode = false,
    this.locale = '',
    this.isGoogleLoggedIn = false,
    this.isFacebookLoggedIn = false,
    this.status = AccountStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  AccountState copyWith({
    String? appLogo,
    String? currentVersion,
    String? driverName,
    String? driverEmail,
    String? driverCover,
    bool? lightMode,
    String? locale,
    bool? isGoogleLoggedIn,
    bool? isFacebookLoggedIn,
    AccountStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return AccountState(
      appLogo: appLogo ?? this.appLogo,
      currentVersion: currentVersion ?? this.currentVersion,
      driverName: driverName ?? this.driverName,
      driverEmail: driverEmail ?? this.driverEmail,
      driverCover: driverCover ?? this.driverCover,
      lightMode: lightMode ?? this.lightMode,
      locale: locale ?? this.locale,
      isGoogleLoggedIn: isGoogleLoggedIn ?? this.isGoogleLoggedIn,
      isFacebookLoggedIn: isFacebookLoggedIn ?? this.isFacebookLoggedIn,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
