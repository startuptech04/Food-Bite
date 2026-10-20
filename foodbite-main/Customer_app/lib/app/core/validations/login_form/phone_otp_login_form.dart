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

enum LoginWithTypeFourCountryCodeFieldValidationError { empty }

enum LoginWithTypeFourMobileNumberFieldValidationError { empty }

enum LoginWithTypeFourRememberMeFieldValidationError { valid }

class LoginWithTypeFourCountryCodeField extends FormzInput<String, LoginWithTypeFourCountryCodeFieldValidationError> {
  const LoginWithTypeFourCountryCodeField.pure([super.value = '']) : super.pure();
  const LoginWithTypeFourCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  LoginWithTypeFourCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return LoginWithTypeFourCountryCodeFieldValidationError.empty;
    return null;
  }
}

class LoginWithTypeFourMobileNumberField extends FormzInput<String, LoginWithTypeFourMobileNumberFieldValidationError> {
  const LoginWithTypeFourMobileNumberField.pure([super.value = '']) : super.pure();
  const LoginWithTypeFourMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  LoginWithTypeFourMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return LoginWithTypeFourMobileNumberFieldValidationError.empty;
    return null;
  }
}

class LoginWithTypeFourRememberMeField extends FormzInput<bool, LoginWithTypeFourRememberMeFieldValidationError> {
  const LoginWithTypeFourRememberMeField.pure([super.value = false]) : super.pure();
  const LoginWithTypeFourRememberMeField.dirty([super.value = false]) : super.dirty();

  @override
  LoginWithTypeFourRememberMeFieldValidationError? validator(bool value) {
    if (value) return LoginWithTypeFourRememberMeFieldValidationError.valid;
    return null;
  }
}
