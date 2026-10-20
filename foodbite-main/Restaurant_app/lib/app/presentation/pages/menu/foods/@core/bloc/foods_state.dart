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

part of 'foods_bloc.dart';

enum FoodsStatus { loading, success, failure }

extension FoodsStatusX on FoodsStatus {
  bool get isLoading => this == FoodsStatus.loading;
  bool get isSuccess => this == FoodsStatus.success;
  bool get isFailure => this == FoodsStatus.failure;
}

final class FoodsState {
  final FoodListModel list;
  final List<CustomTabListModel>? tabList;
  final List<FoodModel> foodList;
  final String activeTab;
  final FoodsStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodsState({required this.list, this.tabList = const [], this.foodList = const [], this.activeTab = 'all', this.status = FoodsStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  FoodsState copyWith({FoodListModel? list, List<CustomTabListModel>? tabList, List<FoodModel>? foodList, String? activeTab, FoodsStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return FoodsState(
      list: list ?? this.list,
      tabList: tabList ?? this.tabList,
      foodList: foodList ?? this.foodList,
      activeTab: activeTab ?? this.activeTab,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
