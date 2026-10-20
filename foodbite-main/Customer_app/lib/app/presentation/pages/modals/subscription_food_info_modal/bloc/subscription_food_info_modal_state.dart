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

part of 'subscription_food_info_modal_bloc.dart';

enum SubscriptionFoodInfoModalStatus { loading, success, failure, customError, saveClose, favAdd, favRemove }

extension SubscriptionFoodInfoModalStatusX on SubscriptionFoodInfoModalStatus {
  bool get isLoading => this == SubscriptionFoodInfoModalStatus.loading;
  bool get isSuccess => this == SubscriptionFoodInfoModalStatus.success;
  bool get isFailure => this == SubscriptionFoodInfoModalStatus.failure;
  bool get isCustomError => this == SubscriptionFoodInfoModalStatus.customError;
  bool get isFavAdd => this == SubscriptionFoodInfoModalStatus.favAdd;
  bool get isFavRemove => this == SubscriptionFoodInfoModalStatus.favRemove;
  bool get isSaveClose => this == SubscriptionFoodInfoModalStatus.saveClose;
}

final class SubscriptionFoodInfoModalState {
  final SingleFoodInfoModel info;
  final FoodVariationModalResponseModel cartItem;
  final double originalPrice;
  final double discountPrice;
  final String id;
  final bool canAddAddons;
  final bool canAddVariations;
  final SubscriptionFoodInfoModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SubscriptionFoodInfoModalState({
    required this.info,
    required this.cartItem,
    this.originalPrice = 0.0,
    this.discountPrice = 0.0,
    this.id = '',
    this.canAddAddons = false,
    this.canAddVariations = false,
    this.status = SubscriptionFoodInfoModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  SubscriptionFoodInfoModalState copyWith({
    SingleFoodInfoModel? info,
    FoodVariationModalResponseModel? cartItem,
    double? originalPrice,
    double? discountPrice,
    String? id,
    bool? canAddAddons,
    bool? canAddVariations,
    String? categoryInView,
    SubscriptionFoodInfoModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return SubscriptionFoodInfoModalState(
      info: info ?? this.info,
      cartItem: cartItem ?? this.cartItem,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      id: id ?? this.id,
      canAddAddons: canAddAddons ?? this.canAddAddons,
      canAddVariations: canAddVariations ?? this.canAddVariations,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
