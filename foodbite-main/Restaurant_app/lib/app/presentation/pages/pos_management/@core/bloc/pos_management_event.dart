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

part of 'pos_management_bloc.dart';

sealed class PosManagementEvent {}

final class PosManagementInitialEvent extends PosManagementEvent {}

final class PosManagementScrollToCategoryEvent extends PosManagementEvent {
  final String categoryId;
  PosManagementScrollToCategoryEvent({required this.categoryId});
}

final class PosManagementToggleCustomCategoryViewEvent extends PosManagementEvent {
  final int categoryIndex;
  PosManagementToggleCustomCategoryViewEvent({required this.categoryIndex});
}

final class PosManagementToggleMainCategoryViewEvent extends PosManagementEvent {
  final int categoryIndex;
  PosManagementToggleMainCategoryViewEvent({required this.categoryIndex});
}

final class PosManagementFoodModalResponseEvent extends PosManagementEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final PosFoodInfoModalResponseModel response;
  PosManagementFoodModalResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.response});
}

final class PosManagementVariationModalResponseEvent extends PosManagementEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final PosFoodVariationModalResponseDataModel data;
  PosManagementVariationModalResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}

final class PosManagementAddCartEvent extends PosManagementEvent {
  final String id;
  final String from;
  final int categoryIndex;
  PosManagementAddCartEvent({required this.id, required this.from, required this.categoryIndex});
}

final class PosManagementRefreshCartDataEvent extends PosManagementEvent {}

final class PosManagementFoodQuantityDecreaseEvent extends PosManagementEvent {
  final String id;
  final String from;
  final int categoryIndex;
  PosManagementFoodQuantityDecreaseEvent({required this.id, required this.from, required this.categoryIndex});
}

final class PosManagementFoodQuantityIncreaseEvent extends PosManagementEvent {
  final String id;
  final String from;
  final int categoryIndex;
  PosManagementFoodQuantityIncreaseEvent({required this.id, required this.from, required this.categoryIndex});
}

final class PosManagementRepeatFoodOrderResponseEvent extends PosManagementEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final PosRepeatQuantityModalResponseModel data;
  PosManagementRepeatFoodOrderResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}

final class PosManagementFoodVariationModalRepeatResponseEvent extends PosManagementEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final PosFoodVariationModalResponseDataModel data;
  PosManagementFoodVariationModalRepeatResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}
