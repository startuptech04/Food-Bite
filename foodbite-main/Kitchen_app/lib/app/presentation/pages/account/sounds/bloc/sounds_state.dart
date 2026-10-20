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

part of 'sounds_bloc.dart';

enum SoundsStatus { loading, success, failure }

extension SoundsStatusX on SoundsStatus {
  bool get isLoading => this == SoundsStatus.loading;
  bool get isSuccess => this == SoundsStatus.success;
  bool get isFailure => this == SoundsStatus.failure;
}

final class SoundsState {
  final List<NotificationAlertListModel> sounds;
  final String savedBell;
  final String playingSound;
  final SoundsStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SoundsState({this.sounds = const [], this.savedBell = '', this.playingSound = '', this.status = SoundsStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  SoundsState copyWith({List<NotificationAlertListModel>? sounds, String? savedBell, String? playingSound, SoundsStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return SoundsState(
      sounds: sounds ?? this.sounds,
      savedBell: savedBell ?? this.savedBell,
      playingSound: playingSound ?? this.playingSound,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
