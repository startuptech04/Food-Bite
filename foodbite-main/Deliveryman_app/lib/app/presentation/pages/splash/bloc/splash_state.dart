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

enum SplashStatus { loading, authorized, unAuthorized, failure, intro, maintenance, connectionError, newNotification, forceUpdate, appLocale }

extension SplashStatusX on SplashStatus {
  bool get isLoading => this == SplashStatus.loading;
  bool get isAuthorized => this == SplashStatus.authorized;
  bool get isUnAuthorized => this == SplashStatus.unAuthorized;
  bool get isFailure => this == SplashStatus.failure;
  bool get isIntro => this == SplashStatus.intro;
  bool get isMaintenance => this == SplashStatus.maintenance;
  bool get isConnectionError => this == SplashStatus.connectionError;
  bool get isNewNotification => this == SplashStatus.newNotification;
  bool get isForceUpdate => this == SplashStatus.forceUpdate;
  bool get isAppLocale => this == SplashStatus.appLocale;
}

final class SplashState {
  final String appLocale;
  final String businessEmail;
  final String businessMobile;
  final String newUpdateVersion;
  final String versionUpdateUrl;
  final String defaultLanguage;
  final String currentVersion;
  final SplashStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SplashState({
    this.appLocale = '',
    this.businessEmail = '',
    this.businessMobile = '',
    this.newUpdateVersion = '',
    this.versionUpdateUrl = '',
    this.defaultLanguage = Environments.defaultLanguage,
    this.currentVersion = '',
    this.status = SplashStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  SplashState copyWith({
    String? appLocale,
    String? businessEmail,
    String? businessMobile,
    String? newUpdateVersion,
    String? versionUpdateUrl,
    String? defaultLanguage,
    String? currentVersion,
    SplashStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return SplashState(
      appLocale: appLocale ?? this.appLocale,
      businessEmail: businessEmail ?? this.businessEmail,
      businessMobile: businessMobile ?? this.businessMobile,
      newUpdateVersion: newUpdateVersion ?? this.newUpdateVersion,
      versionUpdateUrl: versionUpdateUrl ?? this.versionUpdateUrl,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      currentVersion: currentVersion ?? this.currentVersion,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
