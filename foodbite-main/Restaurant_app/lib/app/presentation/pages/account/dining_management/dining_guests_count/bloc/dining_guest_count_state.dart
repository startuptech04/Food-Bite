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

part of 'dining_guest_count_bloc.dart';

enum DiningGuestCountStatus { loading, success, failure, updateStart, updateSuccess, updateFailed }

extension DiningGuestCountStatusX on DiningGuestCountStatus {
  bool get isLoading => this == DiningGuestCountStatus.loading;
  bool get isSuccess => this == DiningGuestCountStatus.success;
  bool get isFailure => this == DiningGuestCountStatus.failure;
  bool get isUpdateStart => this == DiningGuestCountStatus.updateStart;
  bool get isUpdateSuccess => this == DiningGuestCountStatus.updateSuccess;
  bool get isUpdateFailed => this == DiningGuestCountStatus.updateFailed;
}

const List<int> guestCountList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200];

final class DiningGuestCountState {
  final List<int> savedGuest;
  final List<int> guestCount;
  final DiningGuestCountStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningGuestCountState({this.savedGuest = const [], this.guestCount = guestCountList, this.status = DiningGuestCountStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  DiningGuestCountState copyWith({List<int>? savedGuest, DiningGuestCountStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return DiningGuestCountState(
      savedGuest: savedGuest ?? this.savedGuest,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
