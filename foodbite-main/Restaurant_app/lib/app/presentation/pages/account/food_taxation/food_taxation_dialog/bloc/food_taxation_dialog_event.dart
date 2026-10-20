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

part of 'food_taxation_dialog_bloc.dart';

sealed class FoodTaxationDialogEvent {}

final class FoodTaxationDialogInitialEvent extends FoodTaxationDialogEvent {
  final bool isNew;
  final String taxId;
  final String name;
  final double amount;
  FoodTaxationDialogInitialEvent({required this.isNew, required this.taxId, required this.name, required this.amount});
}

final class FoodTaxationDialogNameChangedEvent extends FoodTaxationDialogEvent {
  final String name;
  FoodTaxationDialogNameChangedEvent({required this.name});
}

final class FoodTaxationDialogNameUnfocusedEvent extends FoodTaxationDialogEvent {}

final class FoodTaxationDialogPriceChangedEvent extends FoodTaxationDialogEvent {
  final String amount;
  FoodTaxationDialogPriceChangedEvent({required this.amount});
}

final class FoodTaxationDialogPriceUnfocusedEvent extends FoodTaxationDialogEvent {}

final class FoodTaxationDialogSubmitEvent extends FoodTaxationDialogEvent {
  final List<FoodTaxationFormTranslations> translations;
  FoodTaxationDialogSubmitEvent({required this.translations});
}
