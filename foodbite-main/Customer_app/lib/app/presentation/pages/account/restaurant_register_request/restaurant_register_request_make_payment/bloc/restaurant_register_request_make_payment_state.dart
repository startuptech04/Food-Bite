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

part of 'restaurant_register_request_make_payment_bloc.dart';

enum RestaurantRegisterRequestMakePaymentStatus { initial, success }

extension RestaurantRegisterRequestMakePaymentStatusX on RestaurantRegisterRequestMakePaymentStatus {
  bool get isInitial => this == RestaurantRegisterRequestMakePaymentStatus.initial;
  bool get isSuccess => this == RestaurantRegisterRequestMakePaymentStatus.success;
}

final class RestaurantRegisterRequestMakePaymentState {
  final RestaurantRegisterRequestMakePaymentStatus status;
  final String alertMessage;
  final String extraMessage;
  const RestaurantRegisterRequestMakePaymentState({this.status = RestaurantRegisterRequestMakePaymentStatus.initial, this.alertMessage = '', this.extraMessage = ''});

  RestaurantRegisterRequestMakePaymentState copyWith({RestaurantRegisterRequestMakePaymentStatus? status, String? alertMessage, String? extraMessage}) {
    return RestaurantRegisterRequestMakePaymentState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
