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

enum IntroStatus { waiting, loading, notificationGranted, notificationDicline, bluetoothGranted, bluetoothDicline, cameraGranted, cameraDicline, locationGranted, locationDicline }

extension IntroStatusX on IntroStatus {
  bool get isWaiting => this == IntroStatus.waiting;
  bool get isLoading => this == IntroStatus.loading;
  bool get isNotificationGranted => this == IntroStatus.notificationGranted;
  bool get isNotificationDicline => this == IntroStatus.notificationDicline;
  bool get isBluetoothGranted => this == IntroStatus.bluetoothGranted;
  bool get isBluetoothDicline => this == IntroStatus.bluetoothDicline;
  bool get isCameraGranted => this == IntroStatus.cameraGranted;
  bool get isCameraDicline => this == IntroStatus.cameraDicline;
  bool get isLocationGranted => this == IntroStatus.locationGranted;
  bool get isLocatoinDicline => this == IntroStatus.locationDicline;
}

final class IntroState {
  final String locale;
  final int currentPageIndex;
  final IntroStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const IntroState({this.locale = '', this.currentPageIndex = 0, this.status = IntroStatus.waiting, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  IntroState copyWith({String? locale, int? currentPageIndex, IntroStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return IntroState(
      locale: locale ?? this.locale,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
