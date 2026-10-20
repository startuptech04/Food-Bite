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

part of 'food_bloc.dart';

sealed class FoodEvent {}

final class FoodInitialEvent extends FoodEvent {
  final String id;
  final String from;
  final String data;
  final String extraInfo;
  FoodInitialEvent({required this.id, required this.from, required this.data, required this.extraInfo});
}

final class FoodQuantityEvent extends FoodEvent {
  final String action;
  FoodQuantityEvent({required this.action});
}

final class FoodSaveEvent extends FoodEvent {}

final class FoodFavouriteEvent extends FoodEvent {}

final class FoodAddonsEvent extends FoodEvent {
  final int index;
  FoodAddonsEvent({required this.index});
}

final class FoodVariationOptionEvent extends FoodEvent {
  final int vIndex;
  final int oIndex;
  final String type;
  FoodVariationOptionEvent({required this.vIndex, required this.oIndex, required this.type});
}

final class FoodInstructionChangeEvent extends FoodEvent {
  final String instruction;
  FoodInstructionChangeEvent({required this.instruction});
}

final class FoodShareEvent extends FoodEvent {}
