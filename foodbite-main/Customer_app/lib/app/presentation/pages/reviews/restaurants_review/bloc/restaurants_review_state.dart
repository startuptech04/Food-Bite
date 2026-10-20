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

part of 'restaurants_review_bloc.dart';

enum RestaurantsReviewStatus { loading, empty, success, failure, customError }

extension RestaurantsReviewStatusX on RestaurantsReviewStatus {
  bool get isLoading => this == RestaurantsReviewStatus.loading;
  bool get isEmpty => this == RestaurantsReviewStatus.empty;
  bool get isSuccess => this == RestaurantsReviewStatus.success;
  bool get isFailure => this == RestaurantsReviewStatus.failure;
  bool get isCustomError => this == RestaurantsReviewStatus.customError;
}

final class RestaurantsReviewState {
  final String id;
  final String name;
  final String ratings;
  final RestaurantReviewsResponseModel detail;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final RestaurantsReviewStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const RestaurantsReviewState({
    this.id = '',
    this.name = '',
    this.ratings = '0.0',
    required this.detail,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = RestaurantsReviewStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  RestaurantsReviewState copyWith({
    String? id,
    String? name,
    String? ratings,
    RestaurantReviewsResponseModel? detail,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    RestaurantsReviewStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return RestaurantsReviewState(
      id: id ?? this.id,
      name: name ?? this.name,
      ratings: ratings ?? this.ratings,
      detail: detail ?? this.detail,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
