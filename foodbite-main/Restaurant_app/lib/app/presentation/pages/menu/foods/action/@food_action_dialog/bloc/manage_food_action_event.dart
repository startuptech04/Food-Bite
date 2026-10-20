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

part of 'manage_food_action_bloc.dart';

sealed class ManageFoodActionEvent {}

final class ManageFoodActionInitialEvent extends ManageFoodActionEvent {
  final String id;
  final bool isNew;
  final bool customCategory;
  ManageFoodActionInitialEvent({required this.id, required this.isNew, required this.customCategory});
}

final class ManageFoodActionFoodNameChangedEvent extends ManageFoodActionEvent {
  final String name;
  ManageFoodActionFoodNameChangedEvent({required this.name});
}

final class ManageFoodActionFoodNameUnfocusedEvent extends ManageFoodActionEvent {}

final class ManageFoodActionFoodShortDescriptionChangedEvent extends ManageFoodActionEvent {
  final String description;
  ManageFoodActionFoodShortDescriptionChangedEvent({required this.description});
}

final class ManageFoodActionFoodShortDescriptionUnfocusedEvent extends ManageFoodActionEvent {}

final class ManageFoodActionFoodImageChangedEvent extends ManageFoodActionEvent {
  final String image;
  ManageFoodActionFoodImageChangedEvent({required this.image});
}

final class ManageFoodActionFoodPriceChangedEvent extends ManageFoodActionEvent {
  final String price;
  ManageFoodActionFoodPriceChangedEvent({required this.price});
}

final class ManageFoodActionFoodPriceUnfocusedEvent extends ManageFoodActionEvent {}

final class ManageFoodActionFoodDiscountChangedEvent extends ManageFoodActionEvent {
  final String discount;
  ManageFoodActionFoodDiscountChangedEvent({required this.discount});
}

final class ManageFoodActionFoodDiscountTypeChangedEvent extends ManageFoodActionEvent {
  final String value;
  ManageFoodActionFoodDiscountTypeChangedEvent({required this.value});
}

final class ManageFoodActionFoodTaxationToggleEvent extends ManageFoodActionEvent {}

final class ManageFoodActionFoodOwnCategoryChangedEvent extends ManageFoodActionEvent {
  final bool value;
  ManageFoodActionFoodOwnCategoryChangedEvent({required this.value});
}

final class ManageFoodActionFoodCategoryModalResponseEvent extends ManageFoodActionEvent {
  final String id;
  final String name;
  ManageFoodActionFoodCategoryModalResponseEvent({required this.id, required this.name});
}

final class ManageFoodActionFoodSubCategoryModalResponseEvent extends ManageFoodActionEvent {
  final String id;
  final String name;
  ManageFoodActionFoodSubCategoryModalResponseEvent({required this.id, required this.name});
}

final class ManageFoodActionFoodPreferencesChangeEvent extends ManageFoodActionEvent {
  final String value;
  ManageFoodActionFoodPreferencesChangeEvent({required this.value});
}

final class ManageFoodActionFoodPurchaseLimitChangedEvent extends ManageFoodActionEvent {
  final String limit;
  ManageFoodActionFoodPurchaseLimitChangedEvent({required this.limit});
}

final class ManageFoodActionFoodTaxationModalResponseEvent extends ManageFoodActionEvent {
  final String ids;
  final String names;
  ManageFoodActionFoodTaxationModalResponseEvent({required this.ids, required this.names});
}

final class ManageFoodActionFoodAddonsModalResponseEvent extends ManageFoodActionEvent {
  final String ids;
  final String names;
  ManageFoodActionFoodAddonsModalResponseEvent({required this.ids, required this.names});
}

final class ManageFoodActionFoodAvailabilityStartTimeChangedEvent extends ManageFoodActionEvent {
  final String value;
  ManageFoodActionFoodAvailabilityStartTimeChangedEvent({required this.value});
}

final class ManageFoodActionFoodAvailabilityEndTimeChangedEvent extends ManageFoodActionEvent {
  final String value;
  ManageFoodActionFoodAvailabilityEndTimeChangedEvent({required this.value});
}

final class ManageFoodActionFoodVariationChangedEvent extends ManageFoodActionEvent {
  final bool isNew;
  final int index;
  final FoodVariationModel model;
  ManageFoodActionFoodVariationChangedEvent({required this.isNew, required this.index, required this.model});
}

final class ManageFoodActionFoodVariationDeleteEvent extends ManageFoodActionEvent {
  final int index;
  ManageFoodActionFoodVariationDeleteEvent({required this.index});
}

final class ManageFoodActionFoodCategoryUnfocusedEvent extends ManageFoodActionEvent {}

final class ManageFoodActionFoodSubCategoryUnfocusedEvent extends ManageFoodActionEvent {}

final class ManageFoodActionFoodStockChangeEvent extends ManageFoodActionEvent {
  final String type;
  ManageFoodActionFoodStockChangeEvent({required this.type});
}

final class ManageFoodActionFoodStockNumberChangedEvent extends ManageFoodActionEvent {
  final String value;
  ManageFoodActionFoodStockNumberChangedEvent({required this.value});
}

final class ManageFoodActionFoodStockNumberUnfocusedEvent extends ManageFoodActionEvent {}

final class ManageFoodActionFoodTaxationUnfocusedEvent extends ManageFoodActionEvent {}

final class ManageFoodActionFoodCreateFormEvent extends ManageFoodActionEvent {
  final List<FoodFormTranslations> translations;
  final List<String> tags;
  ManageFoodActionFoodCreateFormEvent({required this.translations, required this.tags});
}

final class ManageFoodActionFoodUpdateFormEvent extends ManageFoodActionEvent {
  final List<FoodFormTranslations> translations;
  final List<String> tags;
  ManageFoodActionFoodUpdateFormEvent({required this.translations, required this.tags});
}
