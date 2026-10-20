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

part of 'food_variation_modal_repeat_bloc.dart';

sealed class FoodVariationModalRepeatEvent {}

final class FoodVariationModalRepeatInitialEvent extends FoodVariationModalRepeatEvent {
  final String id;
  final String tableId;
  FoodVariationModalRepeatInitialEvent({required this.id, required this.tableId});
}

final class FoodVariationModalRepeatIncreaseEvent extends FoodVariationModalRepeatEvent {
  final int index;
  final String uuid;
  FoodVariationModalRepeatIncreaseEvent({required this.index, required this.uuid});
}

final class FoodVariationModalRepeatDecreaseEvent extends FoodVariationModalRepeatEvent {
  final int index;
  final String uuid;
  FoodVariationModalRepeatDecreaseEvent({required this.index, required this.uuid});
}
