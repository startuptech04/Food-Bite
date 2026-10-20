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

part of 'food_list_bloc.dart';

sealed class FoodListEvent {}

final class FoodListInitialEvent extends FoodListEvent {}

final class FoodListCustomCategoryToggleEvent extends FoodListEvent {
  final int index;
  FoodListCustomCategoryToggleEvent({required this.index});
}

final class FoodListMainCategoryToggleEvent extends FoodListEvent {
  final int index;
  FoodListMainCategoryToggleEvent({required this.index});
}
