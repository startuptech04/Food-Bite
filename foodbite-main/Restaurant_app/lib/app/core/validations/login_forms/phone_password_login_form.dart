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

enum LoginWithTypeTwoCountryCodeFieldValidationError { empty }

enum LoginWithTypeTwoMobileNumberFieldValidationError { empty }

enum LoginWithTypeTwoPasswordFieldValidationError { empty }

enum LoginWithTypeTwoRememberMeFieldValidationError { valid }

class LoginWithTypeTwoCountryCodeField extends FormzInput<String, LoginWithTypeTwoCountryCodeFieldValidationError> {
  const LoginWithTypeTwoCountryCodeField.pure([super.value = '']) : super.pure();
  const LoginWithTypeTwoCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  LoginWithTypeTwoCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return LoginWithTypeTwoCountryCodeFieldValidationError.empty;
    return null;
  }
}

class LoginWithTypeTwoMobileNumberField extends FormzInput<String, LoginWithTypeTwoMobileNumberFieldValidationError> {
  const LoginWithTypeTwoMobileNumberField.pure([super.value = '']) : super.pure();
  const LoginWithTypeTwoMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  LoginWithTypeTwoMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return LoginWithTypeTwoMobileNumberFieldValidationError.empty;
    return null;
  }
}

class LoginWithTypeTwoPasswordField extends FormzInput<String, LoginWithTypeTwoPasswordFieldValidationError> {
  const LoginWithTypeTwoPasswordField.pure([super.value = '']) : super.pure();
  const LoginWithTypeTwoPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  LoginWithTypeTwoPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return LoginWithTypeTwoPasswordFieldValidationError.empty;
    return null;
  }
}

class LoginWithTypeTwoRememberMeField extends FormzInput<bool, LoginWithTypeTwoRememberMeFieldValidationError> {
  const LoginWithTypeTwoRememberMeField.pure([super.value = false]) : super.pure();
  const LoginWithTypeTwoRememberMeField.dirty([super.value = false]) : super.dirty();

  @override
  LoginWithTypeTwoRememberMeFieldValidationError? validator(bool value) {
    if (value) return LoginWithTypeTwoRememberMeFieldValidationError.valid;
    return null;
  }
}
