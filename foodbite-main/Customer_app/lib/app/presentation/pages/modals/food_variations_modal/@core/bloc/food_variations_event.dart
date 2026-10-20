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

sealed class FoodVariationsEvent {}

final class FoodVariationsInitialEvent extends FoodVariationsEvent {
  final String id;
  final String name;
  final String image;
  final String options;
  final double price;
  final double offerPrice;
  final String discountType;
  final double discount;
  final int purchaseLimit;
  final int stockNumber;
  final String stockType;
  FoodVariationsInitialEvent({
    required this.id,
    required this.name,
    required this.image,
    required this.options,
    required this.price,
    required this.offerPrice,
    required this.discountType,
    required this.discount,
    required this.purchaseLimit,
    required this.stockNumber,
    required this.stockType,
  });
}

final class FoodVariationsAddonsEvent extends FoodVariationsEvent {
  final int index;
  FoodVariationsAddonsEvent({required this.index});
}

final class FoodVariationOptionEvent extends FoodVariationsEvent {
  final int vIndex;
  final int oIndex;
  final String type;
  FoodVariationOptionEvent({required this.vIndex, required this.oIndex, required this.type});
}

final class FoodVariationQuantityEvent extends FoodVariationsEvent {
  final String action;
  FoodVariationQuantityEvent({required this.action});
}

final class FoodVariationInstructionChangeEvent extends FoodVariationsEvent {
  final String instruction;
  FoodVariationInstructionChangeEvent({required this.instruction});
}

final class FoodVariationSaveEvent extends FoodVariationsEvent {}
