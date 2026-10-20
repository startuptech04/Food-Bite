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

part of 'food_info_modal_bloc.dart';

enum FoodInfoModalStatus { loading, success, failure, customError, saveClose, favAdd, favRemove }

extension FoodInfoModalStatusX on FoodInfoModalStatus {
  bool get isLoading => this == FoodInfoModalStatus.loading;
  bool get isSuccess => this == FoodInfoModalStatus.success;
  bool get isFailure => this == FoodInfoModalStatus.failure;
  bool get isCustomError => this == FoodInfoModalStatus.customError;
  bool get isSaveClose => this == FoodInfoModalStatus.saveClose;
}

final class FoodInfoModalState {
  final String id;
  final PosSingleFoodInfoModel info;
  final PosFoodInfoVariationModalResponseModel cartItem;
  final double originalPrice;
  final double discountPrice;
  final String instruction;
  final FoodInfoModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const FoodInfoModalState({
    this.id = '',
    required this.info,
    required this.cartItem,
    this.originalPrice = 0.0,
    this.discountPrice = 0.0,
    this.instruction = '',
    this.status = FoodInfoModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  FoodInfoModalState copyWith({
    String? id,
    PosSingleFoodInfoModel? info,
    PosFoodInfoVariationModalResponseModel? cartItem,
    double? originalPrice,
    double? discountPrice,
    String? instruction,
    FoodInfoModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return FoodInfoModalState(
      info: info ?? this.info,
      id: id ?? this.id,
      cartItem: cartItem ?? this.cartItem,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      instruction: instruction ?? this.instruction,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
