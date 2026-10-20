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

part of 'manage_waiter_bloc.dart';

sealed class ManageWaiterEvent {}

final class ManageWaiterInitialEvent extends ManageWaiterEvent {
  final bool isNew;
  final String waiterId;
  ManageWaiterInitialEvent({required this.isNew, required this.waiterId});
}

final class ManageWaiterCoverChangeEvent extends ManageWaiterEvent {
  final String image;
  ManageWaiterCoverChangeEvent({required this.image});
}

final class ManageWaiterFirstNameChangedEvent extends ManageWaiterEvent {
  final String firstName;
  ManageWaiterFirstNameChangedEvent({required this.firstName});
}

final class ManageWaiterFirstNameUnfocusedEvent extends ManageWaiterEvent {}

final class ManageWaiterLastNameChangedEvent extends ManageWaiterEvent {
  final String lastName;
  ManageWaiterLastNameChangedEvent({required this.lastName});
}

final class ManageWaiterLastNameUnfocusedEvent extends ManageWaiterEvent {}

final class ManageWaiterEmailChangedEvent extends ManageWaiterEvent {
  final String email;
  ManageWaiterEmailChangedEvent({required this.email});
}

final class ManageWaiterEmailUnfocusedEvent extends ManageWaiterEvent {}

final class ManageWaiterPasswordChangedEvent extends ManageWaiterEvent {
  final String password;
  ManageWaiterPasswordChangedEvent({required this.password});
}

final class ManageWaiterPasswordUnfocusedEvent extends ManageWaiterEvent {}

final class ManageWaiterCountryCodeChangedEvent extends ManageWaiterEvent {
  final String countryCode;
  ManageWaiterCountryCodeChangedEvent({required this.countryCode});
}

final class ManageWaiterCountryCodeUnfocusedEvent extends ManageWaiterEvent {}

final class ManageWaiterMobileNumberChangedEvent extends ManageWaiterEvent {
  final String mobileNumber;
  ManageWaiterMobileNumberChangedEvent({required this.mobileNumber});
}

final class ManageWaiterMobileNumberUnfocusedEvent extends ManageWaiterEvent {}

final class ManageWaiterGenderChangeEvent extends ManageWaiterEvent {
  final WaiterGenderModel gender;
  ManageWaiterGenderChangeEvent({required this.gender});
}

final class ManageWaiterSubmitEvent extends ManageWaiterEvent {}
