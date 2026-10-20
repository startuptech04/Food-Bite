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

sealed class FoodsEvent {}

final class FoodsInitialEvent extends FoodsEvent {}

final class FoodsTabChangeEvent extends FoodsEvent {
  final String key;
  FoodsTabChangeEvent({required this.key});
}

final class FoodsUpdateRecommendEvent extends FoodsEvent {
  final String id;
  final bool status;
  final String listFrom;
  final int categoryIndex;
  FoodsUpdateRecommendEvent({required this.id, required this.status, required this.listFrom, required this.categoryIndex});
}

final class FoodsUpdateStockEvent extends FoodsEvent {
  final String id;
  final bool status;
  final String listFrom;
  final int categoryIndex;
  FoodsUpdateStockEvent({required this.id, required this.status, required this.listFrom, required this.categoryIndex});
}

final class FoodsToggleCustomCategoryViewEvent extends FoodsEvent {
  final int categoryIndex;
  FoodsToggleCustomCategoryViewEvent({required this.categoryIndex});
}

final class FoodsToggleMainCategoryViewEvent extends FoodsEvent {
  final int categoryIndex;
  FoodsToggleMainCategoryViewEvent({required this.categoryIndex});
}
