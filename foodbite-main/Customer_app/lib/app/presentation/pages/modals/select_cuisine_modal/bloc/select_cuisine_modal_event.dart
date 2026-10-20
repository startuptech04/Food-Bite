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

part of 'select_cuisine_modal_bloc.dart';

sealed class SelectCuisineModalEvent {}

final class SelectCuisineModalInitialEvent extends SelectCuisineModalEvent {
  final List<String> cuisine;
  SelectCuisineModalInitialEvent({required this.cuisine});
}

final class SelectCuisineModalSelectEvent extends SelectCuisineModalEvent {
  final String id;
  SelectCuisineModalSelectEvent({required this.id});
}

final class SelectCuisineModalSaveEvent extends SelectCuisineModalEvent {}
