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

part of 'table_order_dashboard_bloc.dart';

sealed class TableOrderDashboardEvent {}

final class TableOrderDashboardInitialEvent extends TableOrderDashboardEvent {
  final int tableNumber;
  final String tableId;
  TableOrderDashboardInitialEvent({required this.tableNumber, required this.tableId});
}

final class TableOrderDashboardScrollToCategoryEvent extends TableOrderDashboardEvent {
  final String categoryId;
  TableOrderDashboardScrollToCategoryEvent({required this.categoryId});
}

final class TableOrderDashboardToggleCustomCategoryViewEvent extends TableOrderDashboardEvent {
  final int categoryIndex;
  TableOrderDashboardToggleCustomCategoryViewEvent({required this.categoryIndex});
}

final class TableOrderDashboardToggleMainCategoryViewEvent extends TableOrderDashboardEvent {
  final int categoryIndex;
  TableOrderDashboardToggleMainCategoryViewEvent({required this.categoryIndex});
}

final class TableOrderDashboardFoodModalResponseEvent extends TableOrderDashboardEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final PosFoodInfoModalResponseModel response;
  TableOrderDashboardFoodModalResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.response});
}

final class TableOrderDashboardVariationModalResponseEvent extends TableOrderDashboardEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final PosFoodVariationModalResponseDataModel data;
  TableOrderDashboardVariationModalResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}

final class TableOrderDashboardAddCartEvent extends TableOrderDashboardEvent {
  final String id;
  final String from;
  final int categoryIndex;
  TableOrderDashboardAddCartEvent({required this.id, required this.from, required this.categoryIndex});
}

final class TableOrderDashboardRefreshCartDataEvent extends TableOrderDashboardEvent {}

final class TableOrderDashboardFoodQuantityDecreaseEvent extends TableOrderDashboardEvent {
  final String id;
  final String from;
  final int categoryIndex;
  TableOrderDashboardFoodQuantityDecreaseEvent({required this.id, required this.from, required this.categoryIndex});
}

final class TableOrderDashboardFoodQuantityIncreaseEvent extends TableOrderDashboardEvent {
  final String id;
  final String from;
  final int categoryIndex;
  TableOrderDashboardFoodQuantityIncreaseEvent({required this.id, required this.from, required this.categoryIndex});
}

final class TableOrderDashboardRepeatFoodOrderResponseEvent extends TableOrderDashboardEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final PosRepeatQuantityModalResponseModel data;
  TableOrderDashboardRepeatFoodOrderResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}

final class TableOrderDashboardFoodVariationModalRepeatResponseEvent extends TableOrderDashboardEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final PosFoodVariationModalResponseDataModel data;
  TableOrderDashboardFoodVariationModalRepeatResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}
