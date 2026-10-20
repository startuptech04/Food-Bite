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

part of 'register_bloc.dart';

sealed class RegisterEvent {}

final class RegisterInitialEvent extends RegisterEvent {}

final class RegisterEmailChangedEvent extends RegisterEvent {
  final String email;
  RegisterEmailChangedEvent({required this.email});
}

final class RegisterEmailUnfocusedEvent extends RegisterEvent {}

final class RegisterPasswordChangedEvent extends RegisterEvent {
  final String password;
  RegisterPasswordChangedEvent({required this.password});
}

final class RegisterPasswordUnfocusedEvent extends RegisterEvent {}

final class RegisterFirstNameChangedEvent extends RegisterEvent {
  final String firstName;
  RegisterFirstNameChangedEvent({required this.firstName});
}

final class RegisterFirstNameUnfocusedEvent extends RegisterEvent {}

final class RegisterLastNameChangedEvent extends RegisterEvent {
  final String lastName;
  RegisterLastNameChangedEvent({required this.lastName});
}

final class RegisterLastNameUnfocusedEvent extends RegisterEvent {}

final class RegisterCountryCodeChangedEvent extends RegisterEvent {
  final String countryCode;
  RegisterCountryCodeChangedEvent({required this.countryCode});
}

final class RegisterCountryCodeUnfocusedEvent extends RegisterEvent {}

final class RegisterMobileNumberChangedEvent extends RegisterEvent {
  final String mobileNumber;
  RegisterMobileNumberChangedEvent({required this.mobileNumber});
}

final class RegisterMobileNumberUnfocusedEvent extends RegisterEvent {}

final class RegisterReferralCodeChangedEvent extends RegisterEvent {
  final String referralCode;
  RegisterReferralCodeChangedEvent({required this.referralCode});
}

final class RegisterFormVerificationSubmitEvent extends RegisterEvent {}

final class RegisterFormSubmitEvent extends RegisterEvent {
  final bool isEmailVerified;
  final bool isMobileVerified;
  final String otp;
  RegisterFormSubmitEvent({required this.isEmailVerified, required this.isMobileVerified, required this.otp});
}

final class RegisterFormFirebaseVerificationSubmitEvent extends RegisterEvent {
  final String accessToken;
  RegisterFormFirebaseVerificationSubmitEvent({required this.accessToken});
}
