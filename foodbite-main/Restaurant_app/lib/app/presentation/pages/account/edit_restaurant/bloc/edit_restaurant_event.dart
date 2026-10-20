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

part of 'edit_restaurant_bloc.dart';

sealed class EditRestaurantEvent {}

final class EditRestaurantInitialEvent extends EditRestaurantEvent {}

final class EditRestaurantNameChangedEvent extends EditRestaurantEvent {
  final String name;
  EditRestaurantNameChangedEvent({required this.name});
}

final class EditRestaurantNameUnfocusedEvent extends EditRestaurantEvent {}

final class EditRestaurantShortDescriptionChangedEvent extends EditRestaurantEvent {
  final String shortDescription;
  EditRestaurantShortDescriptionChangedEvent({required this.shortDescription});
}

final class EditRestaurantShortDescriptionUnfocusedEvent extends EditRestaurantEvent {}

final class EditRestaurantAddressChangedEvent extends EditRestaurantEvent {
  final String address;
  EditRestaurantAddressChangedEvent({required this.address});
}

final class EditRestaurantAddressUnfocusedEvent extends EditRestaurantEvent {}

final class EditRestaurantMinOrderAmountChangedEvent extends EditRestaurantEvent {
  final String minOrderAmount;
  EditRestaurantMinOrderAmountChangedEvent({required this.minOrderAmount});
}

final class EditRestaurantMinOrderAmountUnfocusedEvent extends EditRestaurantEvent {}

final class EditRestaurantDishForTwoChangedEvent extends EditRestaurantEvent {
  final String dishForTwo;
  EditRestaurantDishForTwoChangedEvent({required this.dishForTwo});
}

final class EditRestaurantDishForTwoUnfocusedEvent extends EditRestaurantEvent {}

final class EditRestaurantFoodLicenseChangedEvent extends EditRestaurantEvent {
  final String license;
  EditRestaurantFoodLicenseChangedEvent({required this.license});
}

final class EditRestaurantFoodLicenseUnfocusedEvent extends EditRestaurantEvent {}

final class EditRestaurantLogoChangeEvent extends EditRestaurantEvent {
  final String logo;
  EditRestaurantLogoChangeEvent({required this.logo});
}

final class EditRestaurantCoverChangeEvent extends EditRestaurantEvent {
  final String cover;
  EditRestaurantCoverChangeEvent({required this.cover});
}

final class EditRestaurantHomeDeliveryChangeEvent extends EditRestaurantEvent {
  final HomeDeliverySupportModel option;
  EditRestaurantHomeDeliveryChangeEvent({required this.option});
}

final class EditRestaurantTakeAwayChangeEvent extends EditRestaurantEvent {
  final TakeAwaySupportModel option;
  EditRestaurantTakeAwayChangeEvent({required this.option});
}

final class EditRestaurantScheduleOrderChangeEvent extends EditRestaurantEvent {
  final ScheduleOrderSupportModel option;
  EditRestaurantScheduleOrderChangeEvent({required this.option});
}

final class EditRestaurantLicenseChangeEvent extends EditRestaurantEvent {
  final RestaurantFoodLicenseConfigModel option;
  EditRestaurantLicenseChangeEvent({required this.option});
}

final class EditRestaurantCuisineChangeEvent extends EditRestaurantEvent {
  final ModalNavigationBackResponseModel param;
  EditRestaurantCuisineChangeEvent({required this.param});
}

final class EditRestaurantTypeChangeEvent extends EditRestaurantEvent {
  final ModalNavigationBackResponseModel param;
  EditRestaurantTypeChangeEvent({required this.param});
}

final class EditRestaurantFacilitiesChangeEvent extends EditRestaurantEvent {
  final ModalNavigationBackResponseModel param;
  EditRestaurantFacilitiesChangeEvent({required this.param});
}

final class EditRestaurantDeliveryTimeChangeEvent extends EditRestaurantEvent {
  final String time;
  EditRestaurantDeliveryTimeChangeEvent({required this.time});
}

final class EditRestaurantSocialLinkChangeEvent extends EditRestaurantEvent {
  final String type;
  final String value;
  EditRestaurantSocialLinkChangeEvent({required this.type, required this.value});
}

final class EditRestaurantSubmitEvent extends EditRestaurantEvent {
  final List<EditRestaurantFormTranslations> translations;
  EditRestaurantSubmitEvent({required this.translations});
}
