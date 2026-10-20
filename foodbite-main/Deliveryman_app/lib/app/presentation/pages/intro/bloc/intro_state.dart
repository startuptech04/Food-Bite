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

part of 'intro_bloc.dart';

enum IntroStatus { waiting, ignore, loading, notificationGranted, notificationDicline, cameraGranted, cameraDicline, locationGranted, failure, deniedForever }

extension IntroStatusX on IntroStatus {
  bool get isWaiting => this == IntroStatus.waiting;
  bool get isIgnore => this == IntroStatus.ignore;
  bool get isLoading => this == IntroStatus.loading;
  bool get isNotificationGranted => this == IntroStatus.notificationGranted;
  bool get isNotificationDicline => this == IntroStatus.notificationDicline;
  bool get isCameraGranted => this == IntroStatus.cameraGranted;
  bool get isCameraDicline => this == IntroStatus.cameraDicline;
  bool get isLocationGranted => this == IntroStatus.locationGranted;
  bool get isFailure => this == IntroStatus.failure;
  bool get isDeniedForever => this == IntroStatus.deniedForever;
}

final class IntroState {
  final IntroStatus status;
  final int currentPageIndex;
  final String locale;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const IntroState({this.status = IntroStatus.waiting, this.currentPageIndex = 0, this.locale = '', this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  IntroState copyWith({IntroStatus? status, int? currentPageIndex, String? locale, String? alertMessage, String? extraMessage, int? statusCode}) {
    return IntroState(
      status: status ?? this.status,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      locale: locale ?? this.locale,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
