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

enum WaiterProfileEmailFieldValidationError { invalid }

enum WaiterProfileFirstNameFieldValidationError { empty }

enum WaiterProfileLastNameFieldValidationError { empty }

enum WaiterProfileCountryCodeFieldValidationError { empty }

enum WaiterProfileMobileNumberFieldValidationError { empty }

class WaiterProfileEmailField extends FormzInput<String, WaiterProfileEmailFieldValidationError> {
  const WaiterProfileEmailField.pure([super.value = '']) : super.pure();

  const WaiterProfileEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  WaiterProfileEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : WaiterProfileEmailFieldValidationError.invalid;
  }
}

class WaiterProfileFirstNameField extends FormzInput<String, WaiterProfileFirstNameFieldValidationError> {
  const WaiterProfileFirstNameField.pure([super.value = '']) : super.pure();
  const WaiterProfileFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterProfileFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterProfileFirstNameFieldValidationError.empty;
    return null;
  }
}

class WaiterProfileLastNameField extends FormzInput<String, WaiterProfileLastNameFieldValidationError> {
  const WaiterProfileLastNameField.pure([super.value = '']) : super.pure();
  const WaiterProfileLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterProfileLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterProfileLastNameFieldValidationError.empty;
    return null;
  }
}

class WaiterProfileCountryCodeField extends FormzInput<String, WaiterProfileCountryCodeFieldValidationError> {
  const WaiterProfileCountryCodeField.pure([super.value = '']) : super.pure();
  const WaiterProfileCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterProfileCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterProfileCountryCodeFieldValidationError.empty;
    return null;
  }
}

class WaiterProfileMobileNumberField extends FormzInput<String, WaiterProfileMobileNumberFieldValidationError> {
  const WaiterProfileMobileNumberField.pure([super.value = '']) : super.pure();
  const WaiterProfileMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  WaiterProfileMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return WaiterProfileMobileNumberFieldValidationError.empty;
    return null;
  }
}
