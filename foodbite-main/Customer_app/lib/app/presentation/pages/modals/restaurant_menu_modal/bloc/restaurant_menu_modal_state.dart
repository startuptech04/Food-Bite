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

part of 'restaurant_menu_modal_bloc.dart';

enum RestaurantMenuModalStatus { initial, success, failure }

extension RestaurantMenuModalStatusX on RestaurantMenuModalStatus {
  bool get isInitial => this == RestaurantMenuModalStatus.initial;
  bool get isSuccess => this == RestaurantMenuModalStatus.success;
  bool get isFailure => this == RestaurantMenuModalStatus.failure;
}

final class RestaurantMenuModalState {
  final String currentInView;
  final RestaurantMenuModalStatus status;
  final bool isDarkTheme;
  final String alertMessage;
  final String extraMessage;
  const RestaurantMenuModalState({this.currentInView = '', this.status = RestaurantMenuModalStatus.initial, this.isDarkTheme = false, this.alertMessage = '', this.extraMessage = ''});

  RestaurantMenuModalState copyWith({String? currentInView, RestaurantMenuModalStatus? status, bool? isDarkTheme, String? alertMessage, String? extraMessage}) {
    return RestaurantMenuModalState(
      currentInView: currentInView ?? this.currentInView,
      status: status ?? this.status,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
