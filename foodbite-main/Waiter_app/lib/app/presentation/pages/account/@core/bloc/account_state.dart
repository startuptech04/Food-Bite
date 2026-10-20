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
  final String locale;
  final String waiterCover;
  final String waiterName;
  final String waiterEmail;
  final bool lightMode;
  final bool isGoogleLoggedIn;
  final bool isFacebookLoggedIn;
  final AccountStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountState({
    this.appLogo = '',
    this.currentVersion = '',
    this.locale = '',
    this.waiterCover = '',
    this.waiterName = '',
    this.waiterEmail = '',
    this.lightMode = false,
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
    String? locale,
    String? waiterCover,
    String? waiterName,
    String? waiterEmail,
    bool? lightMode,
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
      locale: locale ?? this.locale,
      waiterCover: waiterCover ?? this.waiterCover,
      waiterName: waiterName ?? this.waiterName,
      waiterEmail: waiterEmail ?? this.waiterEmail,
      lightMode: lightMode ?? this.lightMode,
      isGoogleLoggedIn: isGoogleLoggedIn ?? this.isGoogleLoggedIn,
      isFacebookLoggedIn: isFacebookLoggedIn ?? this.isFacebookLoggedIn,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
