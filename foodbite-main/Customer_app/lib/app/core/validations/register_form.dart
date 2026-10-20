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

enum RegisterEmailFieldValidationError { invalid }

enum RegisterPasswordFieldValidationError { empty }

enum RegisterFirstNameFieldValidationError { empty }

enum RegisterLastNameFieldValidationError { empty }

enum RegisterCountryCodeFieldValidationError { empty }

enum RegisterMobileNumberFieldValidationError { empty }

class RegisterEmailField extends FormzInput<String, RegisterEmailFieldValidationError> {
  const RegisterEmailField.pure([super.value = '']) : super.pure();

  const RegisterEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  RegisterEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : RegisterEmailFieldValidationError.invalid;
  }
}

class RegisterPasswordField extends FormzInput<String, RegisterPasswordFieldValidationError> {
  const RegisterPasswordField.pure([super.value = '']) : super.pure();
  const RegisterPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterPasswordFieldValidationError.empty;
    return null;
  }
}

class RegisterFirstNameField extends FormzInput<String, RegisterFirstNameFieldValidationError> {
  const RegisterFirstNameField.pure([super.value = '']) : super.pure();
  const RegisterFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterFirstNameFieldValidationError.empty;
    return null;
  }
}

class RegisterLastNameField extends FormzInput<String, RegisterLastNameFieldValidationError> {
  const RegisterLastNameField.pure([super.value = '']) : super.pure();
  const RegisterLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterLastNameFieldValidationError.empty;
    return null;
  }
}

class RegisterCountryCodeField extends FormzInput<String, RegisterCountryCodeFieldValidationError> {
  const RegisterCountryCodeField.pure([super.value = '']) : super.pure();
  const RegisterCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterCountryCodeFieldValidationError.empty;
    return null;
  }
}

class RegisterMobileNumberField extends FormzInput<String, RegisterMobileNumberFieldValidationError> {
  const RegisterMobileNumberField.pure([super.value = '']) : super.pure();
  const RegisterMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterMobileNumberFieldValidationError.empty;
    return null;
  }
}
