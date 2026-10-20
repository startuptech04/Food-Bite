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

part of 'dining_booking_information_bloc.dart';

enum DiningBookingInformationStatus { loading, success, failure, customError, repayOrderRequested, repayOrderSuccess, repayOrderFailed, cancelRequested, cancelSuccess, cancelFailed }

extension DiningBookingInformationStatusX on DiningBookingInformationStatus {
  bool get isLoading => this == DiningBookingInformationStatus.loading;
  bool get isSuccess => this == DiningBookingInformationStatus.success;
  bool get isFailure => this == DiningBookingInformationStatus.failure;
  bool get isCustomError => this == DiningBookingInformationStatus.customError;
  bool get isRepayOrderRequested => this == DiningBookingInformationStatus.repayOrderRequested;
  bool get isRepayOrderSuccess => this == DiningBookingInformationStatus.repayOrderSuccess;
  bool get isRepayOrderFailed => this == DiningBookingInformationStatus.repayOrderFailed;
  bool get isCancelRequested => this == DiningBookingInformationStatus.cancelRequested;
  bool get isCancelSuccess => this == DiningBookingInformationStatus.cancelSuccess;
  bool get isCancelFailed => this == DiningBookingInformationStatus.cancelFailed;
}

final class DiningBookingInformationState {
  final String bookingId;
  final DiningBookingDetailInformationResponseModel model;
  final bool canPayPending;
  final bool canCancelBooking;
  final String newPaymentId;
  final String paymentName;
  final String paymentImageURL;
  final String? paymentURL;
  final DiningBookingInformationStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DiningBookingInformationState({
    this.bookingId = '',
    required this.model,
    this.canPayPending = false,
    this.canCancelBooking = false,
    this.newPaymentId = '',
    this.paymentName = '',
    this.paymentImageURL = '',
    this.paymentURL = '',
    this.status = DiningBookingInformationStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DiningBookingInformationState copyWith({
    String? bookingId,
    DiningBookingDetailInformationResponseModel? model,
    bool? canPayPending,
    bool? canCancelBooking,
    String? newPaymentId,
    String? paymentName,
    String? paymentImageURL,
    String? paymentURL,
    DiningBookingInformationStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DiningBookingInformationState(
      bookingId: bookingId ?? this.bookingId,
      model: model ?? this.model,
      canPayPending: canPayPending ?? this.canPayPending,
      canCancelBooking: canCancelBooking ?? this.canCancelBooking,
      newPaymentId: newPaymentId ?? this.newPaymentId,
      paymentName: paymentName ?? this.paymentName,
      paymentImageURL: paymentImageURL ?? this.paymentImageURL,
      paymentURL: paymentURL ?? this.paymentURL,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
