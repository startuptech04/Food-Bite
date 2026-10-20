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

part of 'select_restaurant_type_modal_bloc.dart';

sealed class SelectRestaurantTypeModalEvent {}

final class SelectRestaurantTypeModalInitialEvent extends SelectRestaurantTypeModalEvent {
  final List<String> type;
  SelectRestaurantTypeModalInitialEvent({required this.type});
}

final class SelectRestaurantTypeModalSelectEvent extends SelectRestaurantTypeModalEvent {
  final String id;
  SelectRestaurantTypeModalSelectEvent({required this.id});
}

final class SelectRestaurantTypeModalSaveEvent extends SelectRestaurantTypeModalEvent {}
