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

part of 'social_account_verification_modal_bloc.dart';

sealed class SocialAccountVerificationModalEvent {}

final class SocialAccountVerificationModalInitialEvent extends SocialAccountVerificationModalEvent {
  final String firstName;
  final String lastName;
  SocialAccountVerificationModalInitialEvent({required this.firstName, required this.lastName});
}

final class SocialAccountVerificationModalFirstNameChangedEvent extends SocialAccountVerificationModalEvent {
  final String firstName;
  SocialAccountVerificationModalFirstNameChangedEvent({required this.firstName});
}

final class SocialAccountVerificationModalFirstNameUnfocusedEvent extends SocialAccountVerificationModalEvent {}

final class SocialAccountVerificationModalLastNameChangedEvent extends SocialAccountVerificationModalEvent {
  final String lastName;
  SocialAccountVerificationModalLastNameChangedEvent({required this.lastName});
}

final class SocialAccountVerificationModalLastNameUnfocusedEvent extends SocialAccountVerificationModalEvent {}

final class SocialAccountVerificationModalCountryCodeChangedEvent extends SocialAccountVerificationModalEvent {
  final String countryCode;
  SocialAccountVerificationModalCountryCodeChangedEvent({required this.countryCode});
}

final class SocialAccountVerificationModalCountryCodeUnfocusedEvent extends SocialAccountVerificationModalEvent {}

final class SocialAccountVerificationModalMobileNumberChangedEvent extends SocialAccountVerificationModalEvent {
  final String mobileNumber;
  SocialAccountVerificationModalMobileNumberChangedEvent({required this.mobileNumber});
}

final class SocialAccountVerificationModalMobileNumberUnfocusedEvent extends SocialAccountVerificationModalEvent {}

final class SocialAccountVerificationModalSubmitEvent extends SocialAccountVerificationModalEvent {}
