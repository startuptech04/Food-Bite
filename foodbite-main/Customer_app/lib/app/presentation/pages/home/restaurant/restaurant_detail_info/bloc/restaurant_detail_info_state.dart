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

part of 'restaurant_detail_info_bloc.dart';

enum RestaurantDetailInfoStatus { loading, success, failure, customError, favAdd, favRemove, callRequested }

extension RestaurantDetailInfoStatusX on RestaurantDetailInfoStatus {
  bool get isLoading => this == RestaurantDetailInfoStatus.loading;
  bool get isSuccess => this == RestaurantDetailInfoStatus.success;
  bool get isFailure => this == RestaurantDetailInfoStatus.failure;
  bool get isCustomError => this == RestaurantDetailInfoStatus.customError;
  bool get isFavAdd => this == RestaurantDetailInfoStatus.favAdd;
  bool get isFavRemove => this == RestaurantDetailInfoStatus.favRemove;
  bool get isCallRequested => this == RestaurantDetailInfoStatus.callRequested;
}

const List<String> daysList = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

final class RestaurantDetailInfoState {
  final RestaurantDetailInformationResponseModel model;
  final List<String> daysName;
  final bool isAuthorized;
  final String slug;
  final String name;
  final RestaurantDetailInfoStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const RestaurantDetailInfoState({
    required this.model,
    this.daysName = daysList,
    this.isAuthorized = false,
    this.slug = '',
    this.name = '',
    this.status = RestaurantDetailInfoStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  RestaurantDetailInfoState copyWith({
    RestaurantDetailInformationResponseModel? model,
    bool? isAuthorized,
    String? slug,
    String? name,
    RestaurantDetailInfoStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return RestaurantDetailInfoState(
      model: model ?? this.model,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
