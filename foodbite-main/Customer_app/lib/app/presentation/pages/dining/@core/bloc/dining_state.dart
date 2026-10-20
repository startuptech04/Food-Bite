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

part of 'dining_bloc.dart';

enum DiningStatus { loading, empty, success, failure, customError, restaurantFav, hidden, unhidden }

extension DiningStatusX on DiningStatus {
  bool get isLoading => this == DiningStatus.loading;
  bool get isEmpty => this == DiningStatus.empty;
  bool get isSuccess => this == DiningStatus.success;
  bool get isFailure => this == DiningStatus.failure;
  bool get isCustomError => this == DiningStatus.customError;
  bool get isRestaurantFav => this == DiningStatus.restaurantFav;
  bool get isHidden => this == DiningStatus.hidden;
  bool get isUnhidden => this == DiningStatus.unhidden;
}

final class DiningState {
  final DiningResponseModel model;
  final String addressTitle;
  final String addressSubTitle;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final bool isAuthorized;
  final String locale;
  final List<String> favIds;
  final String hideUnhideId;
  final DiningStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DiningState({
    required this.model,
    this.addressTitle = '0',
    this.addressSubTitle = '',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.isAuthorized = false,
    this.locale = '',
    this.favIds = const [],
    this.hideUnhideId = '',
    this.status = DiningStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DiningState copyWith({
    DiningResponseModel? model,
    String? addressTitle,
    String? addressSubTitle,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    bool? isAuthorized,
    String? locale,
    List<String>? favIds,
    String? hideUnhideId,
    DiningStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DiningState(
      model: model ?? this.model,
      addressTitle: addressTitle ?? this.addressTitle,
      addressSubTitle: addressSubTitle ?? this.addressSubTitle,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      locale: locale ?? this.locale,
      favIds: favIds ?? this.favIds,
      hideUnhideId: hideUnhideId ?? this.hideUnhideId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
