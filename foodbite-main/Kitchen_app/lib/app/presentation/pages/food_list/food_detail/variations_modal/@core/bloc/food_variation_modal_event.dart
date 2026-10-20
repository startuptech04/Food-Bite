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

part of 'food_variation_modal_bloc.dart';

sealed class FoodVariationModalEvent {}

final class FoodVariationModalInitialEvent extends FoodVariationModalEvent {
  final bool isNew;
  final FoodVariationModel model;
  final String stockType;
  FoodVariationModalInitialEvent({required this.isNew, required this.model, required this.stockType});
}

final class FoodVariationNameChanged extends FoodVariationModalEvent {
  final String name;
  FoodVariationNameChanged({required this.name});
}

final class FoodVariationNameUnfocused extends FoodVariationModalEvent {}

final class FoodVariationMinChanged extends FoodVariationModalEvent {
  final String min;
  FoodVariationMinChanged({required this.min});
}

final class FoodVariationMinUnfocused extends FoodVariationModalEvent {}

final class FoodVariationMaxChanged extends FoodVariationModalEvent {
  final String max;
  FoodVariationMaxChanged({required this.max});
}

final class FoodVariationMaxUnfocused extends FoodVariationModalEvent {}

final class FoodVariationRequiredChanged extends FoodVariationModalEvent {
  final bool checked;
  FoodVariationRequiredChanged({required this.checked});
}

final class FoodVariationTypeChanged extends FoodVariationModalEvent {
  final String value;
  FoodVariationTypeChanged({required this.value});
}

final class FoodVariationOptionChanged extends FoodVariationModalEvent {
  final bool isNew;
  final int index;
  final String name;
  final String price;
  final String stock;
  FoodVariationOptionChanged({required this.isNew, required this.index, required this.name, required this.price, required this.stock});
}

final class FoodVariationRemoveEvent extends FoodVariationModalEvent {
  final int index;
  FoodVariationRemoveEvent({required this.index});
}

final class FoodVaritionFormSubmit extends FoodVariationModalEvent {}
