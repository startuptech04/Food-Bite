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

final class FoodListToggleCustomCategoryViewEvent extends FoodListEvent {
  final int categoryIndex;
  FoodListToggleCustomCategoryViewEvent({required this.categoryIndex});
}

final class FoodListToggleMainCategoryViewEvent extends FoodListEvent {
  final int categoryIndex;
  FoodListToggleMainCategoryViewEvent({required this.categoryIndex});
}

final class FoodListUpdateStockEvent extends FoodListEvent {
  final String id;
  final bool status;
  final String listFrom;
  final int categoryIndex;
  FoodListUpdateStockEvent({required this.id, required this.status, required this.listFrom, required this.categoryIndex});
}
