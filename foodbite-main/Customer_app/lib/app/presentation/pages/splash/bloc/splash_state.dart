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

part of 'splash_bloc.dart';

enum SplashStatus { loading, intro, authorized, unAuthorized, failure, maintenance, connectionError, home, location, appLocale, forceUpdate }

extension SplashStatusX on SplashStatus {
  bool get isLoading => this == SplashStatus.loading;
  bool get isIntro => this == SplashStatus.intro;
  bool get isAuthorized => this == SplashStatus.authorized;
  bool get isUnAuthorized => this == SplashStatus.unAuthorized;
  bool get isFailure => this == SplashStatus.failure;
  bool get isMaintenance => this == SplashStatus.maintenance;
  bool get isConnectionError => this == SplashStatus.connectionError;
  bool get isHome => this == SplashStatus.home;
  bool get isLocation => this == SplashStatus.location;
  bool get isAppLocale => this == SplashStatus.appLocale;
  bool get isForceUpdate => this == SplashStatus.forceUpdate;
}

final class SplashState {
  final String appLocale;
  final String businessEmail;
  final String businessMobile;
  final String newUpdateVersion;
  final String versionUpdateUrl;
  final SplashStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SplashState({
    this.appLocale = '',
    this.businessEmail = '',
    this.businessMobile = '',
    this.newUpdateVersion = '',
    this.versionUpdateUrl = '',
    this.status = SplashStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  SplashState copyWith({String? appLocale, String? businessEmail, String? businessMobile, String? newUpdateVersion, String? versionUpdateUrl, SplashStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return SplashState(
      appLocale: appLocale ?? this.appLocale,
      businessEmail: businessEmail ?? this.businessEmail,
      businessMobile: businessMobile ?? this.businessMobile,
      newUpdateVersion: newUpdateVersion ?? this.newUpdateVersion,
      versionUpdateUrl: versionUpdateUrl ?? this.versionUpdateUrl,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
