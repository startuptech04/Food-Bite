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

part of 'manage_outlet_bloc.dart';

sealed class ManageOutletEvent {}

final class ManageOutletInitialEvent extends ManageOutletEvent {
  final bool isNew;
  final String outletId;
  ManageOutletInitialEvent({required this.isNew, required this.outletId});
}

final class ManageOutletNameChangedEvent extends ManageOutletEvent {
  final String name;
  ManageOutletNameChangedEvent({required this.name});
}

final class ManageOutletNameUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletShortDescriptionChangedEvent extends ManageOutletEvent {
  final String shortDescription;
  ManageOutletShortDescriptionChangedEvent({required this.shortDescription});
}

final class ManageOutletShortDescriptionUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletAddressChangedEvent extends ManageOutletEvent {
  final String address;
  ManageOutletAddressChangedEvent({required this.address});
}

final class ManageOutletAddressUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletMinOrderAmountChangedEvent extends ManageOutletEvent {
  final String minOrderAmount;
  ManageOutletMinOrderAmountChangedEvent({required this.minOrderAmount});
}

final class ManageOutletMinOrderAmountUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletDishForTwoChangedEvent extends ManageOutletEvent {
  final String dishForTwo;
  ManageOutletDishForTwoChangedEvent({required this.dishForTwo});
}

final class ManageOutletDishForTwoUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletFoodLicenseChangedEvent extends ManageOutletEvent {
  final String license;
  ManageOutletFoodLicenseChangedEvent({required this.license});
}

final class ManageOutletFoodLicenseUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletEmailChangedEvent extends ManageOutletEvent {
  final String email;
  ManageOutletEmailChangedEvent({required this.email});
}

final class ManageOutletEmailUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletPasswordChangedEvent extends ManageOutletEvent {
  final String password;
  ManageOutletPasswordChangedEvent({required this.password});
}

final class ManageOutletPasswordUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletFirstNameChangedEvent extends ManageOutletEvent {
  final String firstName;
  ManageOutletFirstNameChangedEvent({required this.firstName});
}

final class ManageOutletFirstNameUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletLastNameChangedEvent extends ManageOutletEvent {
  final String lastName;
  ManageOutletLastNameChangedEvent({required this.lastName});
}

final class ManageOutletLastNameUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletCountryCodeChangedEvent extends ManageOutletEvent {
  final String countryCode;
  ManageOutletCountryCodeChangedEvent({required this.countryCode});
}

final class ManageOutletCountryCodeUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletMobileNumberChangedEvent extends ManageOutletEvent {
  final String mobileNumber;
  ManageOutletMobileNumberChangedEvent({required this.mobileNumber});
}

final class ManageOutletMobileNumberUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletLogoChangeEvent extends ManageOutletEvent {
  final String logo;
  ManageOutletLogoChangeEvent({required this.logo});
}

final class ManageOutletCoverChangeEvent extends ManageOutletEvent {
  final String cover;
  ManageOutletCoverChangeEvent({required this.cover});
}

final class ManageOutletHomeDeliveryChangeEvent extends ManageOutletEvent {
  final HomeDeliverySupportModel option;
  ManageOutletHomeDeliveryChangeEvent({required this.option});
}

final class ManageOutletTakeAwayChangeEvent extends ManageOutletEvent {
  final TakeAwaySupportModel option;
  ManageOutletTakeAwayChangeEvent({required this.option});
}

final class ManageOutletScheduleOrderChangeEvent extends ManageOutletEvent {
  final ScheduleOrderSupportModel option;
  ManageOutletScheduleOrderChangeEvent({required this.option});
}

final class ManageOutletCuisineChangeEvent extends ManageOutletEvent {
  final ModalNavigationBackResponseModel param;
  ManageOutletCuisineChangeEvent({required this.param});
}

final class ManageOutletCusineUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletTypeChangeEvent extends ManageOutletEvent {
  final ModalNavigationBackResponseModel param;
  ManageOutletTypeChangeEvent({required this.param});
}

final class ManageOutletTypeUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletFacilitiesChangeEvent extends ManageOutletEvent {
  final ModalNavigationBackResponseModel param;
  ManageOutletFacilitiesChangeEvent({required this.param});
}

final class ManageOutletFacilityUnfocusedEvent extends ManageOutletEvent {}

final class ManageOutletDeliveryTimeChangeEvent extends ManageOutletEvent {
  final String time;
  ManageOutletDeliveryTimeChangeEvent({required this.time});
}

final class ManageOutletLicenseChangeEvent extends ManageOutletEvent {
  final OutletLicenseResponseModel option;
  ManageOutletLicenseChangeEvent({required this.option});
}

final class ManageOutletCityChangeEvent extends ManageOutletEvent {
  final OutletCitiesResponseModel city;
  ManageOutletCityChangeEvent({required this.city});
}

final class ManageOutletLocalityChangeEvent extends ManageOutletEvent {
  final OutletLocalitiesResponseModel locality;
  ManageOutletLocalityChangeEvent({required this.locality});
}

final class ManageOutletLocationChangeEvent extends ManageOutletEvent {
  final double latitude;
  final double longitude;
  ManageOutletLocationChangeEvent({required this.latitude, required this.longitude});
}

final class ManageOutletSocialLinkChangeEvent extends ManageOutletEvent {
  final String type;
  final String value;
  ManageOutletSocialLinkChangeEvent({required this.type, required this.value});
}

final class ManageOutletSubmitEvent extends ManageOutletEvent {
  final List<OutletFormTranslations> translations;
  ManageOutletSubmitEvent({required this.translations});
}
