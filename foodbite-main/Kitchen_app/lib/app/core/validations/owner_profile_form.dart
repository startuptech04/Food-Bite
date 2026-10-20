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

enum OwnerProfileEmailFieldValidationError { invalid }

enum OwnerProfileFirstNameFieldValidationError { empty }

enum OwnerProfileLastNameFieldValidationError { empty }

enum OwnerProfileCountryCodeFieldValidationError { empty }

enum OwnerProfileMobileNumberFieldValidationError { empty }

class OwnerProfileEmailField extends FormzInput<String, OwnerProfileEmailFieldValidationError> {
  const OwnerProfileEmailField.pure([super.value = '']) : super.pure();

  const OwnerProfileEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  OwnerProfileEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : OwnerProfileEmailFieldValidationError.invalid;
  }
}

class OwnerProfileFirstNameField extends FormzInput<String, OwnerProfileFirstNameFieldValidationError> {
  const OwnerProfileFirstNameField.pure([super.value = '']) : super.pure();
  const OwnerProfileFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  OwnerProfileFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return OwnerProfileFirstNameFieldValidationError.empty;
    return null;
  }
}

class OwnerProfileLastNameField extends FormzInput<String, OwnerProfileLastNameFieldValidationError> {
  const OwnerProfileLastNameField.pure([super.value = '']) : super.pure();
  const OwnerProfileLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  OwnerProfileLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return OwnerProfileLastNameFieldValidationError.empty;
    return null;
  }
}

class OwnerProfileCountryCodeField extends FormzInput<String, OwnerProfileCountryCodeFieldValidationError> {
  const OwnerProfileCountryCodeField.pure([super.value = '']) : super.pure();
  const OwnerProfileCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  OwnerProfileCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return OwnerProfileCountryCodeFieldValidationError.empty;
    return null;
  }
}

class OwnerProfileMobileNumberField extends FormzInput<String, OwnerProfileMobileNumberFieldValidationError> {
  const OwnerProfileMobileNumberField.pure([super.value = '']) : super.pure();
  const OwnerProfileMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  OwnerProfileMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return OwnerProfileMobileNumberFieldValidationError.empty;
    return null;
  }
}
