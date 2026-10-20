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

part of 'food_detail_bloc.dart';

sealed class FoodDetailEvent {}

final class FoodDetailInitialEvent extends FoodDetailEvent {
  final String id;
  FoodDetailInitialEvent({required this.id});
}

final class FoodDetailAddonsModalResponseEvent extends FoodDetailEvent {
  final String ids;
  final String names;
  FoodDetailAddonsModalResponseEvent({required this.ids, required this.names});
}

final class FoodDetailStockChangeEvent extends FoodDetailEvent {
  final String type;
  FoodDetailStockChangeEvent({required this.type});
}

final class FoodDetailStockNumberChangedEvent extends FoodDetailEvent {
  final String value;
  FoodDetailStockNumberChangedEvent({required this.value});
}

final class FoodDetailVariationChangedEvent extends FoodDetailEvent {
  final bool isNew;
  final int index;
  final FoodVariationModel model;
  FoodDetailVariationChangedEvent({required this.isNew, required this.index, required this.model});
}

final class FoodDetailVariationDeleteEvent extends FoodDetailEvent {
  final int index;
  FoodDetailVariationDeleteEvent({required this.index});
}

final class FoodDetailUpdateFormEvent extends FoodDetailEvent {}
