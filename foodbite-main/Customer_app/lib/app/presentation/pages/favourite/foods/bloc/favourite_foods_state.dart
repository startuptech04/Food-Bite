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

part of 'favourite_foods_bloc.dart';

enum FavouriteFoodsStatus { loading, success, failure, unAuthorized, empty, removeFavStart, removeFavDone, removeFavFailed, customError, cartUpdate, cartError, removeSilence }

extension FavouriteFoodsStatusX on FavouriteFoodsStatus {
  bool get isLoading => this == FavouriteFoodsStatus.loading;
  bool get isSuccess => this == FavouriteFoodsStatus.success;
  bool get isFailure => this == FavouriteFoodsStatus.failure;
  bool get isUnAuthorized => this == FavouriteFoodsStatus.unAuthorized;
  bool get isEmpty => this == FavouriteFoodsStatus.empty;
  bool get isRemoveFavStart => this == FavouriteFoodsStatus.removeFavStart;
  bool get isRemoveFavDone => this == FavouriteFoodsStatus.removeFavDone;
  bool get isRemoveFailed => this == FavouriteFoodsStatus.removeFavFailed;
  bool get isCustomError => this == FavouriteFoodsStatus.customError;
  bool get isCartUpdate => this == FavouriteFoodsStatus.cartUpdate;
  bool get isCartError => this == FavouriteFoodsStatus.cartError;
  bool get isRemoveSilence => this == FavouriteFoodsStatus.removeSilence;
}

final class FavouriteFoodsState {
  final FavouriteFoodListModel foods;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final String appLocale;
  final FavouriteFoodsStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const FavouriteFoodsState({
    required this.foods,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.appLocale = '',
    this.status = FavouriteFoodsStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  FavouriteFoodsState copyWith({FavouriteFoodListModel? foods, int? pageSize, int? currentPage, bool? loadMore, String? appLocale, FavouriteFoodsStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return FavouriteFoodsState(
      foods: foods ?? this.foods,
      pageSize: pageSize ?? this.pageSize,
      loadMore: loadMore ?? this.loadMore,
      appLocale: appLocale ?? this.appLocale,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
