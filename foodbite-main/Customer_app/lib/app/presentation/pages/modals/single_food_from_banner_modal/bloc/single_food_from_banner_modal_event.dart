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

part of 'single_food_from_banner_modal_bloc.dart';

sealed class SingleFoodFromBannerModalEvent {}

final class SingleFoodFromBannerModalInitialEvent extends SingleFoodFromBannerModalEvent {
  final String id;
  final String name;
  SingleFoodFromBannerModalInitialEvent({required this.id, required this.name});
}

final class SingleFoodFromBannerModalQuantityEvent extends SingleFoodFromBannerModalEvent {
  final String action;
  SingleFoodFromBannerModalQuantityEvent({required this.action});
}

final class SingleFoodFromBannerModalSaveEvent extends SingleFoodFromBannerModalEvent {}

final class SingleFoodFromBannerModalFavouriteEvent extends SingleFoodFromBannerModalEvent {}

final class SingleFoodFromBannerModalAddonsEvent extends SingleFoodFromBannerModalEvent {
  final int index;
  SingleFoodFromBannerModalAddonsEvent({required this.index});
}

final class SingleFoodFromBannerModalVariationOptionEvent extends SingleFoodFromBannerModalEvent {
  final int vIndex;
  final int oIndex;
  final String type;
  SingleFoodFromBannerModalVariationOptionEvent({required this.vIndex, required this.oIndex, required this.type});
}

final class SingleFoodFromBannerModalRepeatIncreaseEvent extends SingleFoodFromBannerModalEvent {
  final int index;
  final String uuid;
  SingleFoodFromBannerModalRepeatIncreaseEvent({required this.index, required this.uuid});
}

final class SingleFoodFromBannerModalRepeatDecreaseEvent extends SingleFoodFromBannerModalEvent {
  final int index;
  final String uuid;
  SingleFoodFromBannerModalRepeatDecreaseEvent({required this.index, required this.uuid});
}

final class SingleFoodFromBannerModalNewItemEvent extends SingleFoodFromBannerModalEvent {}

final class SingleFoodFromBannerModalNewItemSaveEvent extends SingleFoodFromBannerModalEvent {}

final class SingleFoodInstructionChangeEvent extends SingleFoodFromBannerModalEvent {
  final String instruction;
  SingleFoodInstructionChangeEvent({required this.instruction});
}

final class SingleFoodShareEvent extends SingleFoodFromBannerModalEvent {}
