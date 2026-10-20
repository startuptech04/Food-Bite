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

part of 'dining_booking_request_modal_bloc.dart';

enum DiningBookingRequestModalStatus { success, failure }

extension DiningBookingRequestModalStatusX on DiningBookingRequestModalStatus {
  bool get isSuccess => this == DiningBookingRequestModalStatus.success;
  bool get isFailure => this == DiningBookingRequestModalStatus.failure;
}

final class DiningBookingRequestModalState {
  final String instructions;
  final DiningBookingRequestModalStatus status;
  final String alertMessage;
  final String extraMessage;
  const DiningBookingRequestModalState({this.status = DiningBookingRequestModalStatus.success, this.instructions = '', this.alertMessage = '', this.extraMessage = ''});

  DiningBookingRequestModalState copyWith({String? instructions, DiningBookingRequestModalStatus? status, String? alertMessage, String? extraMessage}) {
    return DiningBookingRequestModalState(instructions: instructions ?? this.instructions, status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
