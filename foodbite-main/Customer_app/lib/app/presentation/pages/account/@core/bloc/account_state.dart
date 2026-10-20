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
  final bool isAuthorized;
  final bool isGuestAuthorized;
  final String locale;
  final String userCover;
  final String userName;
  final String userEmail;
  final bool lightMode;
  final bool vendorRegisterEnable;
  final bool driverRegisterEnable;
  final bool isGoogleLoggedIn;
  final bool isFacebookLoggedIn;
  final AccountStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountState({
    this.appLogo = '',
    this.currentVersion = '',
    this.isAuthorized = false,
    this.isGuestAuthorized = false,
    this.locale = '',
    this.userCover = '',
    this.userName = '',
    this.userEmail = '',
    this.lightMode = false,
    this.vendorRegisterEnable = false,
    this.driverRegisterEnable = false,
    this.isGoogleLoggedIn = false,
    this.isFacebookLoggedIn = false,
    this.status = AccountStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  AccountState copyWith({
    String? appLogo,
    String? currentVersion,
    bool? isAuthorized,
    bool? isGuestAuthorized,
    String? locale,
    String? userCover,
    String? userName,
    String? userEmail,
    bool? lightMode,
    bool? vendorRegisterEnable,
    bool? driverRegisterEnable,
    bool? isGoogleLoggedIn,
    bool? isFacebookLoggedIn,
    AccountStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return AccountState(
      appLogo: appLogo ?? this.appLogo,
      currentVersion: currentVersion ?? this.currentVersion,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      isGuestAuthorized: isGuestAuthorized ?? this.isGuestAuthorized,
      locale: locale ?? this.locale,
      userCover: userCover ?? this.userCover,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      lightMode: lightMode ?? this.lightMode,
      vendorRegisterEnable: vendorRegisterEnable ?? this.vendorRegisterEnable,
      driverRegisterEnable: driverRegisterEnable ?? this.driverRegisterEnable,
      isGoogleLoggedIn: isGoogleLoggedIn ?? this.isGoogleLoggedIn,
      isFacebookLoggedIn: isFacebookLoggedIn ?? this.isFacebookLoggedIn,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
