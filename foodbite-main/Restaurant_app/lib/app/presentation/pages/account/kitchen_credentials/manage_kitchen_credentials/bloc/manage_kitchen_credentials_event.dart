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

part of 'manage_kitchen_credentials_bloc.dart';

sealed class ManageKitchenCredentialsEvent {}

final class ManageKitchenCredentialsInitialEvent extends ManageKitchenCredentialsEvent {
  final bool isNew;
  final String kitchenId;
  ManageKitchenCredentialsInitialEvent({required this.isNew, required this.kitchenId});
}

final class ManageKitchenOwnerCoverChangeEvent extends ManageKitchenCredentialsEvent {
  final String image;
  ManageKitchenOwnerCoverChangeEvent({required this.image});
}

final class ManageKitchenOwnerFirstNameChangedEvent extends ManageKitchenCredentialsEvent {
  final String firstName;
  ManageKitchenOwnerFirstNameChangedEvent({required this.firstName});
}

final class ManageKitchenOwnerFirstNameUnfocusedEvent extends ManageKitchenCredentialsEvent {}

final class ManageKitchenOwnerLastNameChangedEvent extends ManageKitchenCredentialsEvent {
  final String lastName;
  ManageKitchenOwnerLastNameChangedEvent({required this.lastName});
}

final class ManageKitchenOwnerLastNameUnfocusedEvent extends ManageKitchenCredentialsEvent {}

final class ManageKitchenOwnerEmailChangedEvent extends ManageKitchenCredentialsEvent {
  final String email;
  ManageKitchenOwnerEmailChangedEvent({required this.email});
}

final class ManageKitchenOwnerEmailUnfocusedEvent extends ManageKitchenCredentialsEvent {}

final class ManageKitchenOwnerPasswordChangedEvent extends ManageKitchenCredentialsEvent {
  final String password;
  ManageKitchenOwnerPasswordChangedEvent({required this.password});
}

final class ManageKitchenOwnerPasswordUnfocusedEvent extends ManageKitchenCredentialsEvent {}

final class ManageKitchenOwnerCountryCodeChangedEvent extends ManageKitchenCredentialsEvent {
  final String countryCode;
  ManageKitchenOwnerCountryCodeChangedEvent({required this.countryCode});
}

final class ManageKitchenOwnerCountryCodeUnfocusedEvent extends ManageKitchenCredentialsEvent {}

final class ManageKitchenOwnerMobileNumberChangedEvent extends ManageKitchenCredentialsEvent {
  final String mobileNumber;
  ManageKitchenOwnerMobileNumberChangedEvent({required this.mobileNumber});
}

final class ManageKitchenOwnerMobileNumberUnfocusedEvent extends ManageKitchenCredentialsEvent {}

final class ManageKitchenOwnerGenderChangeEvent extends ManageKitchenCredentialsEvent {
  final KitchenOwnerGenderModel gender;
  ManageKitchenOwnerGenderChangeEvent({required this.gender});
}

final class ManageKitchenOwnerSubmitEvent extends ManageKitchenCredentialsEvent {}
