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

enum WaiterFirstNameFieldValidationError { empty }

enum WaiterLastNameFieldValidationError { empty }

enum WaiterEmailFieldValidationError { invalid }

enum WaiterPasswordFieldValidationError { empty }

enum WaiterCountryCodeFieldValidationError { empty }

enum WaiterMobileNumberFieldValidationError { empty }

enum WaiterCoverFieldValidationError { empty }

class WaiterFirstNameField extends FormzInput<String, WaiterFirstNameFieldValidationError> {
  const WaiterFirstNameField.pure([super.value = '']) : super.pure();
  const WaiterFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterFirstNameFieldValidationError.empty;
    return null;
  }
}

class WaiterLastNameField extends FormzInput<String, WaiterLastNameFieldValidationError> {
  const WaiterLastNameField.pure([super.value = '']) : super.pure();
  const WaiterLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterLastNameFieldValidationError.empty;
    return null;
  }
}

class WaiterEmailField extends FormzInput<String, WaiterEmailFieldValidationError> {
  const WaiterEmailField.pure([super.value = '']) : super.pure();

  const WaiterEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  WaiterEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : WaiterEmailFieldValidationError.invalid;
  }
}

class WaiterPasswordField extends FormzInput<String, WaiterPasswordFieldValidationError> {
  const WaiterPasswordField.pure([super.value = '']) : super.pure();
  const WaiterPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterPasswordFieldValidationError.empty;
    return null;
  }
}

class WaiterCountryCodeField extends FormzInput<String, WaiterCountryCodeFieldValidationError> {
  const WaiterCountryCodeField.pure([super.value = '']) : super.pure();
  const WaiterCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterCountryCodeFieldValidationError.empty;
    return null;
  }
}

class WaiterMobileNumberField extends FormzInput<String, WaiterMobileNumberFieldValidationError> {
  const WaiterMobileNumberField.pure([super.value = '']) : super.pure();
  const WaiterMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterMobileNumberFieldValidationError.empty;
    return null;
  }
}

class WaiterCoverField extends FormzInput<String, WaiterCoverFieldValidationError> {
  const WaiterCoverField.pure([super.value = '']) : super.pure();
  const WaiterCoverField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterCoverFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterCoverFieldValidationError.empty;
    return null;
  }
}
