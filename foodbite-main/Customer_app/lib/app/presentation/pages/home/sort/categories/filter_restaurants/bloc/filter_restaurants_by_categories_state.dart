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

part of 'filter_restaurants_by_categories_bloc.dart';

enum FilterRestaurantsByCategoriesStatus { loading, success, failure, empty, customError, favUpdate, hidden, unhidden }

extension FilterRestaurantsByCategoriesStatusX on FilterRestaurantsByCategoriesStatus {
  bool get isLoading => this == FilterRestaurantsByCategoriesStatus.loading;
  bool get isSuccess => this == FilterRestaurantsByCategoriesStatus.success;
  bool get isFailure => this == FilterRestaurantsByCategoriesStatus.failure;
  bool get isEmpty => this == FilterRestaurantsByCategoriesStatus.empty;
  bool get isCustomError => this == FilterRestaurantsByCategoriesStatus.customError;
  bool get isFavUpdate => this == FilterRestaurantsByCategoriesStatus.favUpdate;
  bool get isHidden => this == FilterRestaurantsByCategoriesStatus.hidden;
  bool get isUnhidden => this == FilterRestaurantsByCategoriesStatus.unhidden;
}

final class FilterRestaurantsByCategoriesState {
  final RestaurantsByCategoryModel restaurants;
  final List<String> favIds;
  final String hideUnhideId;
  final String slug;
  final int pageSize;
  final int currentPage;
  final bool isAuthorized;
  final bool loadMore;
  final FilterRestaurantsByCategoriesStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const FilterRestaurantsByCategoriesState({
    required this.restaurants,
    this.favIds = const [],
    this.hideUnhideId = '',
    this.slug = '',
    required this.pageSize,
    this.currentPage = 0,
    this.isAuthorized = false,
    this.loadMore = false,
    this.status = FilterRestaurantsByCategoriesStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  FilterRestaurantsByCategoriesState copyWith({
    RestaurantsByCategoryModel? restaurants,
    List<String>? favIds,
    String? hideUnhideId,
    String? slug,
    int? pageSize,
    int? currentPage,
    bool? isAuthorized,
    bool? loadMore,
    FilterRestaurantsByCategoriesStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return FilterRestaurantsByCategoriesState(
      restaurants: restaurants ?? this.restaurants,
      favIds: favIds ?? this.favIds,
      hideUnhideId: hideUnhideId ?? this.hideUnhideId,
      slug: slug ?? this.slug,
      pageSize: pageSize ?? this.pageSize,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      loadMore: loadMore ?? this.loadMore,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
