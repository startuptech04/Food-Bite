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

sealed class FoodInfoModalEvent {}

final class FoodInfoModalInitialEvent extends FoodInfoModalEvent {
  final String id;
  final String data;
  FoodInfoModalInitialEvent({required this.id, required this.data});
}

final class FoodInfoModalQuantityEvent extends FoodInfoModalEvent {
  final String action;
  FoodInfoModalQuantityEvent({required this.action});
}

final class FoodInfoModalSaveEvent extends FoodInfoModalEvent {}

final class FoodInfoModalAddonsEvent extends FoodInfoModalEvent {
  final int index;
  FoodInfoModalAddonsEvent({required this.index});
}

final class FoodInfoModalVariationOptionEvent extends FoodInfoModalEvent {
  final int vIndex;
  final int oIndex;
  final String type;
  FoodInfoModalVariationOptionEvent({required this.vIndex, required this.oIndex, required this.type});
}

final class FoodInfoModalCookingInstructionChangeEvent extends FoodInfoModalEvent {
  final String instruction;
  FoodInfoModalCookingInstructionChangeEvent({required this.instruction});
}
