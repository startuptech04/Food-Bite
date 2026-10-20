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

final class RegisterRequestAgeChangedEvent extends RegisterRequestEvent {
  final String age;
  RegisterRequestAgeChangedEvent({required this.age});
}

final class RegisterRequestAgeUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestDOBChangedEvent extends RegisterRequestEvent {
  final String dob;
  RegisterRequestDOBChangedEvent({required this.dob});
}

final class RegisterRequestDOBUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestIdentityNumberChangedEvent extends RegisterRequestEvent {
  final String identity;
  RegisterRequestIdentityNumberChangedEvent({required this.identity});
}

final class RegisterRequestIdentityNumberUnfocusedEvent extends RegisterRequestEvent {}

final class RegisterRequestIdentityTypeChangeEvent extends RegisterRequestEvent {
  final RegisterRequestIdentityTypeModel identity;
  RegisterRequestIdentityTypeChangeEvent({required this.identity});
}

final class RegisterRequestJobTypeChangeEvent extends RegisterRequestEvent {
  final RegisterRequestJobTypeModel jobType;
  RegisterRequestJobTypeChangeEvent({required this.jobType});
}

final class RegisterRequestCityChangeEvent extends RegisterRequestEvent {
  final RegisterRequestCitiesModel city;
  RegisterRequestCityChangeEvent({required this.city});
}

final class RegisterRequestLocalityChangeEvent extends RegisterRequestEvent {
  final LocalitiesFromCityModel locality;
  RegisterRequestLocalityChangeEvent({required this.locality});
}

final class RegisterRequestVehicleChangeEvent extends RegisterRequestEvent {
  final RegisterRequestVehicleModel vehicle;
  RegisterRequestVehicleChangeEvent({required this.vehicle});
}

final class RegisterRequestUploadImageEvent extends RegisterRequestEvent {
  final XFile newImage;
  final String uploadImageTag;
  final int formIndex;
  final String formUploadingImageUUID;
  RegisterRequestUploadImageEvent({required this.newImage, required this.uploadImageTag, required this.formIndex, required this.formUploadingImageUUID});
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

final class RegisterRequestSubmitEvent extends RegisterRequestEvent {}
