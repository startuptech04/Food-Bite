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

part of 'table_order_search_food_bloc.dart';

sealed class TableOrderSearchFoodEvent {}

final class TableOrderSearchFoodInitialEvent extends TableOrderSearchFoodEvent {
  final int tableNumber;
  final String tableId;
  TableOrderSearchFoodInitialEvent({required this.tableNumber, required this.tableId});
}

final class TableOrderSearchFoodFindResultEvent extends TableOrderSearchFoodEvent {
  final String searchQuery;
  TableOrderSearchFoodFindResultEvent({required this.searchQuery});
}

final class TableOrderSearchModalResponseEvent extends TableOrderSearchFoodEvent {
  final String id;
  final String collection;
  final PosFoodInfoModalResponseModel response;
  TableOrderSearchModalResponseEvent({required this.id, required this.collection, required this.response});
}

final class TableOrderSearchVariationModalResponseEvent extends TableOrderSearchFoodEvent {
  final String id;
  final PosFoodVariationModalResponseDataModel data;
  TableOrderSearchVariationModalResponseEvent({required this.id, required this.data});
}

final class TableOrderSearchAddCartEvent extends TableOrderSearchFoodEvent {
  final String id;
  TableOrderSearchAddCartEvent({required this.id});
}

final class TableOrderSearchRepeatFoodOrderResponseEvent extends TableOrderSearchFoodEvent {
  final String id;
  final PosRepeatQuantityModalResponseModel data;
  TableOrderSearchRepeatFoodOrderResponseEvent({required this.id, required this.data});
}

final class TableOrderSearchFoodQuantityDecreaseEvent extends TableOrderSearchFoodEvent {
  final String id;
  TableOrderSearchFoodQuantityDecreaseEvent({required this.id});
}

final class TableOrderSearchFoodVariationModalRepeatResponseEvent extends TableOrderSearchFoodEvent {
  final String id;
  PosFoodVariationModalResponseDataModel data;
  TableOrderSearchFoodVariationModalRepeatResponseEvent({required this.id, required this.data});
}

final class TableOrderSearchFoodQuantityIncreaseEvent extends TableOrderSearchFoodEvent {
  final String id;
  TableOrderSearchFoodQuantityIncreaseEvent({required this.id});
}

final class TableOrderSearchFoodExecuteQueryEvent extends TableOrderSearchFoodEvent {
  final String query;
  TableOrderSearchFoodExecuteQueryEvent({required this.query});
}
