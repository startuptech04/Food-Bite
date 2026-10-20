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

part of 'manage_deliveryman_bloc.dart';

sealed class ManageDeliverymanEvent {}

final class ManageDeliverymanInitialEvent extends ManageDeliverymanEvent {
  final bool isNew;
  final String deliverymanId;
  ManageDeliverymanInitialEvent({required this.isNew, required this.deliverymanId});
}

final class ManageDeliverymanCoverChangeEvent extends ManageDeliverymanEvent {
  final String image;
  ManageDeliverymanCoverChangeEvent({required this.image});
}

final class ManageDeliverymanFirstNameChangedEvent extends ManageDeliverymanEvent {
  final String firstName;
  ManageDeliverymanFirstNameChangedEvent({required this.firstName});
}

final class ManageDeliverymanFirstNameUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanLastNameChangedEvent extends ManageDeliverymanEvent {
  final String lastName;
  ManageDeliverymanLastNameChangedEvent({required this.lastName});
}

final class ManageDeliverymanLastNameUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanEmailChangedEvent extends ManageDeliverymanEvent {
  final String email;
  ManageDeliverymanEmailChangedEvent({required this.email});
}

final class ManageDeliverymanEmailUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanPasswordChangedEvent extends ManageDeliverymanEvent {
  final String password;
  ManageDeliverymanPasswordChangedEvent({required this.password});
}

final class ManageDeliverymanPasswordUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanCountryCodeChangedEvent extends ManageDeliverymanEvent {
  final String countryCode;
  ManageDeliverymanCountryCodeChangedEvent({required this.countryCode});
}

final class ManageDeliverymanCountryCodeUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanMobileNumberChangedEvent extends ManageDeliverymanEvent {
  final String mobileNumber;
  ManageDeliverymanMobileNumberChangedEvent({required this.mobileNumber});
}

final class ManageDeliverymanMobileNumberUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanAgeChangedEvent extends ManageDeliverymanEvent {
  final String age;
  ManageDeliverymanAgeChangedEvent({required this.age});
}

final class ManageDeliverymanAgeUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanIdentityNumberChangedEvent extends ManageDeliverymanEvent {
  final String identity;
  ManageDeliverymanIdentityNumberChangedEvent({required this.identity});
}

final class ManageDeliverymanIdentityNumberUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanDOBChangedEvent extends ManageDeliverymanEvent {
  final String dob;
  ManageDeliverymanDOBChangedEvent({required this.dob});
}

final class ManageDeliverymanDOBUnfocusedEvent extends ManageDeliverymanEvent {}

final class ManageDeliverymanIdentityProofChangeEvent extends ManageDeliverymanEvent {
  final String image;
  ManageDeliverymanIdentityProofChangeEvent({required this.image});
}

final class ManageDeliverymanDrivingLicenseChangeEvent extends ManageDeliverymanEvent {
  final String image;
  ManageDeliverymanDrivingLicenseChangeEvent({required this.image});
}

final class ManageDeliverymanChangeIdentityTypeEvent extends ManageDeliverymanEvent {
  final IdentityProofModel type;
  ManageDeliverymanChangeIdentityTypeEvent({required this.type});
}

final class ManageDeliverymanChangeVehicleEvent extends ManageDeliverymanEvent {
  final DeliverymanVehicleConfigModel vehicle;
  ManageDeliverymanChangeVehicleEvent({required this.vehicle});
}

final class ManageDeliverymanSubmitEvent extends ManageDeliverymanEvent {}
