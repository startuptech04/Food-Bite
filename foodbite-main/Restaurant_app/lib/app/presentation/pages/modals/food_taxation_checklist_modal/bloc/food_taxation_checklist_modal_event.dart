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

part of 'food_taxation_checklist_modal_bloc.dart';

sealed class FoodTaxationChecklistModalEvent {}

final class FoodTaxationChecklistModalInitialEvent extends FoodTaxationChecklistModalEvent {
  final String savedTaxation;
  FoodTaxationChecklistModalInitialEvent({required this.savedTaxation});
}

final class FoodTaxationChecklistModalSelectEvent extends FoodTaxationChecklistModalEvent {
  final String id;
  final String name;
  FoodTaxationChecklistModalSelectEvent({required this.id, required this.name});
}

final class FoodTaxationCheckListOnSaveEvent extends FoodTaxationChecklistModalEvent {}
