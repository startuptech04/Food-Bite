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

enum PosOrderCustomerFormNameFieldValidationError { empty }

enum PosOrderCustomerFormCountryCodeFieldValidationError { empty }

enum PosOrderCustomerFormNumberFieldValidationError { empty }

class PosOrderCustomerFormNameField extends FormzInput<String, PosOrderCustomerFormNameFieldValidationError> {
  const PosOrderCustomerFormNameField.pure([super.value = '']) : super.pure();
  const PosOrderCustomerFormNameField.dirty([super.value = '']) : super.dirty();

  @override
  PosOrderCustomerFormNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return PosOrderCustomerFormNameFieldValidationError.empty;
    return null;
  }
}

class PosOrderCustomerFormCountryCodeField extends FormzInput<String, PosOrderCustomerFormCountryCodeFieldValidationError> {
  const PosOrderCustomerFormCountryCodeField.pure([super.value = '']) : super.pure();
  const PosOrderCustomerFormCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  PosOrderCustomerFormCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return PosOrderCustomerFormCountryCodeFieldValidationError.empty;
    return null;
  }
}

class PosOrderCustomerFormNumberField extends FormzInput<String, PosOrderCustomerFormNumberFieldValidationError> {
  const PosOrderCustomerFormNumberField.pure([super.value = '']) : super.pure();
  const PosOrderCustomerFormNumberField.dirty([super.value = '']) : super.dirty();

  @override
  PosOrderCustomerFormNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return PosOrderCustomerFormNumberFieldValidationError.empty;
    return null;
  }
}
