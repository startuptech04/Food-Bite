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

part of 'variation_options_modal_bloc.dart';

sealed class VariationOptionsModalEvent {}

final class VariationOptionsModalInitialEvent extends VariationOptionsModalEvent {
  final bool isNew;
  final FoodVariationOptionModel model;
  final String stockType;
  VariationOptionsModalInitialEvent({required this.isNew, required this.model, required this.stockType});
}

final class VariationOptionNameChanged extends VariationOptionsModalEvent {
  final String name;
  VariationOptionNameChanged({required this.name});
}

final class VariationOptionNameUnfocused extends VariationOptionsModalEvent {}

final class VariationOptionPriceChanged extends VariationOptionsModalEvent {
  final String price;
  VariationOptionPriceChanged({required this.price});
}

final class VariationOptionPriceUnfocused extends VariationOptionsModalEvent {}

final class VariationOptionStockChanged extends VariationOptionsModalEvent {
  final String stock;
  VariationOptionStockChanged({required this.stock});
}

final class VariationOptionStockUnfocused extends VariationOptionsModalEvent {}

final class VariationOptionFormSubmit extends VariationOptionsModalEvent {}
