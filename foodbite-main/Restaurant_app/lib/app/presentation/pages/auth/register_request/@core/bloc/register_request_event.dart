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

part of 'register_request_bloc.dart';

sealed class RegisterRequestEvent {}

final class RegisterRequestInitialEvent extends RegisterRequestEvent {}

final class RegisterRequestNameChangedEvent extends RegisterRequestEvent {
  final String name;
  RegisterRequestNameChangedEvent({required this.name});
}

final class RegisterRequestNameUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestShortDescriptionChangedEvent extends RegisterRequestEvent {
  final String shortDescription;
  RegisterRequestShortDescriptionChangedEvent({required this.shortDescription});
}

final class RegisterRequestShortDescriptionUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestAddressChangedEvent extends RegisterRequestEvent {
  final String address;
  RegisterRequestAddressChangedEvent({required this.address});
}

final class RegisterRequestAddressUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestMinOrderAmountChangedEvent extends RegisterRequestEvent {
  final String minOrderAmount;
  RegisterRequestMinOrderAmountChangedEvent({required this.minOrderAmount});
}

final class RegisterRequestMinOrderAmountUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestDishForTwoChangedEvent extends RegisterRequestEvent {
  final String dishForTwo;
  RegisterRequestDishForTwoChangedEvent({required this.dishForTwo});
}

final class RegisterRequestDishForTwoUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestFoodLicenseChangedEvent extends RegisterRequestEvent {
  final String license;
  RegisterRequestFoodLicenseChangedEvent({required this.license});
}

final class RegisterRequestFoodLicenseUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestEmailChangedEvent extends RegisterRequestEvent {
  final String email;
  RegisterRequestEmailChangedEvent({required this.email});
}

final class RegisterRequestEmailUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestPasswordChangedEvent extends RegisterRequestEvent {
  final String password;
  RegisterRequestPasswordChangedEvent({required this.password});
}

final class RegisterRequestPasswordUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestFirstNameChangedEvent extends RegisterRequestEvent {
  final String firstName;
  RegisterRequestFirstNameChangedEvent({required this.firstName});
}

final class RegisterRequestFirstNameUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestLastNameChangedEvent extends RegisterRequestEvent {
  final String lastName;
  RegisterRequestLastNameChangedEvent({required this.lastName});
}

final class RegisterRequestLastNameUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestCountryCodeChangedEvent extends RegisterRequestEvent {
  final String countryCode;
  RegisterRequestCountryCodeChangedEvent({required this.countryCode});
}

final class RegisterRequestCountryCodeUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestMobileNumberChangedEvent extends RegisterRequestEvent {
  final String mobileNumber;
  RegisterRequestMobileNumberChangedEvent({required this.mobileNumber});
}

final class RegisterRequestMobileNumberUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestHomeDeliveryChangeEvent extends RegisterRequestEvent {
  final HomeDeliverySupportModel option;
  RegisterRequestHomeDeliveryChangeEvent({required this.option});
}

final class RegisterRequestTakeAwayChangeEvent extends RegisterRequestEvent {
  final TakeAwaySupportModel option;
  RegisterRequestTakeAwayChangeEvent({required this.option});
}

final class RegisterRequestScheduleOrderChangeEvent extends RegisterRequestEvent {
  final ScheduleOrderSupportModel option;
  RegisterRequestScheduleOrderChangeEvent({required this.option});
}

final class RegisterRequestCuisineChangeEvent extends RegisterRequestEvent {
  final ModalNavigationBackResponseModel param;
  RegisterRequestCuisineChangeEvent({required this.param});
}

final class RegisterRequestCusineUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestTypeChangeEvent extends RegisterRequestEvent {
  final ModalNavigationBackResponseModel param;
  RegisterRequestTypeChangeEvent({required this.param});
}

final class RegisterRequestTypeUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestFacilitiesChangeEvent extends RegisterRequestEvent {
  final ModalNavigationBackResponseModel param;
  RegisterRequestFacilitiesChangeEvent({required this.param});
}

final class RegisterRequestFacilityUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestDeliveryTimeChangeEvent extends RegisterRequestEvent {
  final String time;
  RegisterRequestDeliveryTimeChangeEvent({required this.time});
}

final class RegisterRequestLicenseChangeEvent extends RegisterRequestEvent {
  final RegisterRequestLicenseModel option;
  RegisterRequestLicenseChangeEvent({required this.option});
}

final class RegisterRequestCityChangeEvent extends RegisterRequestEvent {
  final RegisterRequestCitiesModel city;
  RegisterRequestCityChangeEvent({required this.city});
}

final class RegisterRequestLocalityChangeEvent extends RegisterRequestEvent {
  final LocalitiesFromCityModel locality;
  RegisterRequestLocalityChangeEvent({required this.locality});
}

final class RegisterRequestLocationChangeEvent extends RegisterRequestEvent {
  final double latitude;
  final double longitude;
  RegisterRequestLocationChangeEvent({required this.latitude, required this.longitude});
}

final class RegisterRequestFormTextInputChangeEvent extends RegisterRequestEvent {
  final int formIndex;
  final String value;
  RegisterRequestFormTextInputChangeEvent({required this.formIndex, required this.value});
}

final class RegisterRequestFormCountryCodeChangeEvent extends RegisterRequestEvent {
  final int formIndex;
  final String value;
  RegisterRequestFormCountryCodeChangeEvent({required this.formIndex, required this.value});
}

final class RegisterRequestFormCheckboxChangeEvent extends RegisterRequestEvent {
  final int formIndex;
  final int checkboxIndex;
  RegisterRequestFormCheckboxChangeEvent({required this.formIndex, required this.checkboxIndex});
}

final class RegisterRequestUploadImageEvent extends RegisterRequestEvent {
  final XFile newImage;
  final String uploadImageTag;
  final int formIndex;
  final String formUploadingImageUUID;
  RegisterRequestUploadImageEvent({required this.newImage, required this.uploadImageTag, required this.formIndex, required this.formUploadingImageUUID});
}

final class RegisterRequestOnBackPageEvent extends RegisterRequestEvent {}

final class RegisterRequestSubmitEvent extends RegisterRequestEvent {
  final List<RegisterRequestFormTranslations> translations;
  RegisterRequestSubmitEvent({required this.translations});
}

final class RegisterRequestBusinessModelChangeEvent extends RegisterRequestEvent {
  final String businessModel;
  RegisterRequestBusinessModelChangeEvent({required this.businessModel});
}

final class RegisterRequestChangeSubscriptionPackageEvent extends RegisterRequestEvent {
  final String subscriptionPackage;
  RegisterRequestChangeSubscriptionPackageEvent({required this.subscriptionPackage});
}

final class RegisterRequestBusinessPlanSelectEvent extends RegisterRequestEvent {}

final class RegisterRequestChangePaymentMethodEvent extends RegisterRequestEvent {
  final String paymentId;
  RegisterRequestChangePaymentMethodEvent({required this.paymentId});
}

final class RegisterRequestSocialLinkChangeEvent extends RegisterRequestEvent {
  final String type;
  final String value;
  RegisterRequestSocialLinkChangeEvent({required this.type, required this.value});
}

final class RegisterRequestCreateProfileRequestEvent extends RegisterRequestEvent {}
