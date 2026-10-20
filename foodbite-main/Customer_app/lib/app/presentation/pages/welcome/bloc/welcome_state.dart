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

part of 'welcome_bloc.dart';

enum WelcomeStatus { loading, authorized, unAuthorized, failure, maintenance, connectionError, home, location, appLocale, forceUpdate }

extension WelcomeStatusX on WelcomeStatus {
  bool get isLoading => this == WelcomeStatus.loading;
  bool get isAuthorized => this == WelcomeStatus.authorized;
  bool get isUnAuthorized => this == WelcomeStatus.unAuthorized;
  bool get isFailure => this == WelcomeStatus.failure;
  bool get isHome => this == WelcomeStatus.home;
  bool get isLocation => this == WelcomeStatus.location;
  bool get isAppLocale => this == WelcomeStatus.appLocale;
}

final class WelcomeState {
  final String locale;
  final int currentPageIndex;
  final WelcomeStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const WelcomeState({this.locale = '', this.currentPageIndex = 0, this.status = WelcomeStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  WelcomeState copyWith({String? locale, int? currentPageIndex, WelcomeStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return WelcomeState(
      locale: locale ?? this.locale,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
