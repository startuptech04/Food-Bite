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

part of 'pos_management_bloc.dart';

enum PosManagementStatus { loading, success, failure, empty, customError, unauthorized, cartUpdate, cartError }

extension PosManagementStatusX on PosManagementStatus {
  bool get isLoading => this == PosManagementStatus.loading;
  bool get isSuccess => this == PosManagementStatus.success;
  bool get isFailure => this == PosManagementStatus.failure;
  bool get isEmpty => this == PosManagementStatus.empty;
  bool get isCustomError => this == PosManagementStatus.customError;
  bool get isUnauthorized => this == PosManagementStatus.unauthorized;
  bool get isCartUpdate => this == PosManagementStatus.cartUpdate;
  bool get isCartError => this == PosManagementStatus.cartError;
}

final class PosManagementState {
  final String appLocale;
  final PosFoodModel model;
  final List<PosRestaurantModalCategoryModel> category;
  final Map<String, GlobalKey> globalMainCategoriesKey;
  final String categoryInView;
  final int cartTotalItem;
  final double cartTotalAmount;
  final PosManagementStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PosManagementState({
    this.appLocale = '',
    required this.model,
    this.category = const [],
    this.globalMainCategoriesKey = const {},
    this.categoryInView = '',
    this.cartTotalItem = 0,
    this.cartTotalAmount = 0,
    this.status = PosManagementStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  PosManagementState copyWith({
    String? appLocale,
    PosFoodModel? model,
    List<PosRestaurantModalCategoryModel>? category,
    Map<String, GlobalKey>? globalMainCategoriesKey,
    String? categoryInView,
    int? cartTotalItem,
    double? cartTotalAmount,
    PosManagementStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return PosManagementState(
      appLocale: appLocale ?? this.appLocale,
      model: model ?? this.model,
      category: category ?? this.category,
      globalMainCategoriesKey: globalMainCategoriesKey ?? this.globalMainCategoriesKey,
      categoryInView: categoryInView ?? this.categoryInView,
      cartTotalItem: cartTotalItem ?? this.cartTotalItem,
      cartTotalAmount: cartTotalAmount ?? this.cartTotalAmount,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
