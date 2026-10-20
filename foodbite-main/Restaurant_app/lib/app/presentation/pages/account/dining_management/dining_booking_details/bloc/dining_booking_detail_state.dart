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

part of 'dining_booking_detail_bloc.dart';

enum DiningBookingDetailStatus { loading, success, failure, accept, acceptSuccess, reject, rejectSuccess, callCustomer, callCustomerSuccess, customError }

extension DiningBookingDetailStatusX on DiningBookingDetailStatus {
  bool get isLoading => this == DiningBookingDetailStatus.loading;
  bool get isSuccess => this == DiningBookingDetailStatus.success;
  bool get isFailure => this == DiningBookingDetailStatus.failure;
  bool get isAccept => this == DiningBookingDetailStatus.accept;
  bool get isAcceptSuccess => this == DiningBookingDetailStatus.acceptSuccess;
  bool get isReject => this == DiningBookingDetailStatus.reject;
  bool get isRejectSuccess => this == DiningBookingDetailStatus.rejectSuccess;
  bool get isCallCustomer => this == DiningBookingDetailStatus.callCustomer;
  bool get isCallCustomerSuccess => this == DiningBookingDetailStatus.callCustomerSuccess;
  bool get isCustomError => this == DiningBookingDetailStatus.customError;
}

final class DiningBookingDetailState {
  final String bookingId;
  final DiningBookingInformationResponseModel model;
  final DiningBookingDetailStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningBookingDetailState({this.bookingId = '', required this.model, this.status = DiningBookingDetailStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  DiningBookingDetailState copyWith({String? bookingId, DiningBookingInformationResponseModel? model, DiningBookingDetailStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return DiningBookingDetailState(
      bookingId: bookingId ?? this.bookingId,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
