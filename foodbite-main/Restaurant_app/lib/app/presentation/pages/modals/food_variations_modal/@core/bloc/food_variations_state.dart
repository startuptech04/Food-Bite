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

part of 'food_variations_bloc.dart';

enum FoodVariationsStatus { loading, success, failure, successClose, emptyClose }

extension FoodVariationsStatusX on FoodVariationsStatus {
  bool get isLoading => this == FoodVariationsStatus.loading;
  bool get isSuccess => this == FoodVariationsStatus.success;
  bool get isFailure => this == FoodVariationsStatus.failure;
  bool get isSuccessClose => this == FoodVariationsStatus.successClose;
  bool get isEmptyClose => this == FoodVariationsStatus.emptyClose;
}

final class FoodVariationsState {
  final PosFoodVariationOptionsModel options;
  final PosFoodVariationModalResponseModel cartItem;
  final String id;
  final String name;
  final String image;
  final double price;
  final double offerPrice;
  final String discountType;
  final double discount;
  final double originalPrice;
  final double discountPrice;
  final int purchaseLimit;
  final int stockNumber;
  final String stockType;
  final int quantity;
  final String instruction;
  final FoodVariationsStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const FoodVariationsState({
    required this.options,
    required this.cartItem,
    this.id = '',
    this.name = '',
    this.image = '',
    this.price = 0.0,
    this.offerPrice = 0.0,
    this.discountType = 'none',
    this.discount = 0.0,
    this.originalPrice = 0.0,
    this.discountPrice = 0.0,
    this.purchaseLimit = 0,
    this.stockNumber = 0,
    this.stockType = '',
    this.quantity = 1,
    this.instruction = '',
    this.status = FoodVariationsStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  FoodVariationsState copyWith({
    PosFoodVariationOptionsModel? options,
    PosFoodVariationModalResponseModel? cartItem,
    String? id,
    String? name,
    String? image,
    double? price,
    double? offerPrice,
    String? discountType,
    double? discount,
    double? originalPrice,
    double? discountPrice,
    int? purchaseLimit,
    int? stockNumber,
    String? stockType,
    int? quantity,
    String? instruction,
    FoodVariationsStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return FoodVariationsState(
      options: options ?? this.options,
      cartItem: cartItem ?? this.cartItem,
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      offerPrice: offerPrice ?? this.offerPrice,
      discountType: discountType ?? this.discountType,
      discount: discount ?? this.discount,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      purchaseLimit: purchaseLimit ?? this.purchaseLimit,
      stockNumber: stockNumber ?? this.stockNumber,
      stockType: stockType ?? this.stockType,
      quantity: quantity ?? this.quantity,
      instruction: instruction ?? this.instruction,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
