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

part of 'restaurants_by_brands_bloc.dart';

enum RestaurantsByBrandsStatus { loading, success, failure, empty, customError, favUpdate, hidden, unhidden }

extension RestaurantsByBrandsStatusX on RestaurantsByBrandsStatus {
  bool get isLoading => this == RestaurantsByBrandsStatus.loading;
  bool get isSuccess => this == RestaurantsByBrandsStatus.success;
  bool get isFailure => this == RestaurantsByBrandsStatus.failure;
  bool get isEmpty => this == RestaurantsByBrandsStatus.empty;
  bool get isCustomError => this == RestaurantsByBrandsStatus.customError;
  bool get isFavUpdate => this == RestaurantsByBrandsStatus.favUpdate;
  bool get isHidden => this == RestaurantsByBrandsStatus.hidden;
  bool get isUnhidden => this == RestaurantsByBrandsStatus.unhidden;
}

final class RestaurantsByBrandsState {
  final RestaurantsByBrandsModel restaurants;
  final List<String> favIds;
  final String hideUnhideId;
  final bool isAuthorized;
  final RestaurantsByBrandsStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const RestaurantsByBrandsState({
    required this.restaurants,
    this.favIds = const [],
    this.hideUnhideId = '',
    this.isAuthorized = false,
    this.status = RestaurantsByBrandsStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  RestaurantsByBrandsState copyWith({
    RestaurantsByBrandsModel? restaurants,
    List<String>? favIds,
    String? hideUnhideId,
    bool? isAuthorized,
    RestaurantsByBrandsStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return RestaurantsByBrandsState(
      restaurants: restaurants ?? this.restaurants,
      favIds: favIds ?? this.favIds,
      hideUnhideId: hideUnhideId ?? this.hideUnhideId,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
