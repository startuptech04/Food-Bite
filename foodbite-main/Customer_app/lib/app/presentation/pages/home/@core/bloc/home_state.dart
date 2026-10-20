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

part of 'home_bloc.dart';

enum HomeStatus { loading, empty, success, failure, customError, cartUpdate, cartError, restaurantFav, foodFav, hidden, unhidden }

extension HomeStatusX on HomeStatus {
  bool get isLoading => this == HomeStatus.loading;
  bool get isEmpty => this == HomeStatus.empty;
  bool get isSuccess => this == HomeStatus.success;
  bool get isFailure => this == HomeStatus.failure;
  bool get isCustomError => this == HomeStatus.customError;
  bool get isCartUpdate => this == HomeStatus.cartUpdate;
  bool get isCartError => this == HomeStatus.cartError;
  bool get isRestaurantFav => this == HomeStatus.restaurantFav;
  bool get isFoodFav => this == HomeStatus.foodFav;
  bool get isHidden => this == HomeStatus.hidden;
  bool get isUnhidden => this == HomeStatus.unhidden;
}

final class HomeState {
  final HomeResponseModel homeData;
  final List<CampaignListModel> campaignList;
  final String addressTitle;
  final String addressSubTitle;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final String hideUnhideId;
  final int notificationCount;
  final bool isAuthorized;
  final String locale;
  final List<String> favRestIds;
  final String appLocale;
  final HomeStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const HomeState({
    required this.homeData,
    this.campaignList = const [],
    this.addressTitle = '0',
    this.addressSubTitle = '',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.hideUnhideId = '',
    this.notificationCount = 0,
    this.isAuthorized = false,
    this.locale = '',
    this.favRestIds = const [],
    this.appLocale = '',
    this.status = HomeStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  HomeState copyWith({
    HomeResponseModel? homeData,
    List<CampaignListModel>? campaignList,
    String? addressTitle,
    String? addressSubTitle,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    bool? isAuthorized,
    String? hideUnhideId,
    int? notificationCount,
    String? locale,
    List<String>? favRestIds,
    String? appLocale,
    HomeStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return HomeState(
      homeData: homeData ?? this.homeData,
      campaignList: campaignList ?? this.campaignList,
      addressTitle: addressTitle ?? this.addressTitle,
      addressSubTitle: addressSubTitle ?? this.addressSubTitle,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      hideUnhideId: hideUnhideId ?? this.hideUnhideId,
      notificationCount: notificationCount ?? this.notificationCount,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      locale: locale ?? this.locale,
      favRestIds: favRestIds ?? this.favRestIds,
      appLocale: appLocale ?? this.appLocale,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
