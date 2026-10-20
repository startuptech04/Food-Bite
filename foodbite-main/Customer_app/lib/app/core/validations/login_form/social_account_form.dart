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

import 'package:formz/formz.dart';

enum SocialAccountVerificationFirstNameFieldValidationError { empty }

enum SocialAccountVerificationLastNameFieldValidationError { empty }

enum SocialAccountVerificationCountryCodeFieldValidationError { empty }

enum SocialAccountVerificationMobileNumberFieldValidationError { empty }

class SocialAccountVerificationFirstNameField extends FormzInput<String, SocialAccountVerificationFirstNameFieldValidationError> {
  const SocialAccountVerificationFirstNameField.pure([super.value = '']) : super.pure();
  const SocialAccountVerificationFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  SocialAccountVerificationFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return SocialAccountVerificationFirstNameFieldValidationError.empty;
    return null;
  }
}

class SocialAccountVerificationLastNameField extends FormzInput<String, SocialAccountVerificationLastNameFieldValidationError> {
  const SocialAccountVerificationLastNameField.pure([super.value = '']) : super.pure();
  const SocialAccountVerificationLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  SocialAccountVerificationLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return SocialAccountVerificationLastNameFieldValidationError.empty;
    return null;
  }
}

class SocialAccountVerificationCountryCodeField extends FormzInput<String, SocialAccountVerificationCountryCodeFieldValidationError> {
  const SocialAccountVerificationCountryCodeField.pure([super.value = '']) : super.pure();
  const SocialAccountVerificationCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  SocialAccountVerificationCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return SocialAccountVerificationCountryCodeFieldValidationError.empty;
    return null;
  }
}

class SocialAccountVerificationMobileNumberField extends FormzInput<String, SocialAccountVerificationMobileNumberFieldValidationError> {
  const SocialAccountVerificationMobileNumberField.pure([super.value = '']) : super.pure();
  const SocialAccountVerificationMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  SocialAccountVerificationMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return SocialAccountVerificationMobileNumberFieldValidationError.empty;
    return null;
  }
}
