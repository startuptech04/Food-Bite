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

enum TableOrderCustomerFormNameFieldValidationError { empty }

enum TableOrderCustomerFormCountryCodeFieldValidationError { empty }

enum TableOrderCustomerFormNumberFieldValidationError { empty }

class TableOrderCustomerFormNameField extends FormzInput<String, TableOrderCustomerFormNameFieldValidationError> {
  const TableOrderCustomerFormNameField.pure([super.value = '']) : super.pure();
  const TableOrderCustomerFormNameField.dirty([super.value = '']) : super.dirty();

  @override
  TableOrderCustomerFormNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return TableOrderCustomerFormNameFieldValidationError.empty;
    return null;
  }
}

class TableOrderCustomerFormCountryCodeField extends FormzInput<String, TableOrderCustomerFormCountryCodeFieldValidationError> {
  const TableOrderCustomerFormCountryCodeField.pure([super.value = '']) : super.pure();
  const TableOrderCustomerFormCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  TableOrderCustomerFormCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return TableOrderCustomerFormCountryCodeFieldValidationError.empty;
    return null;
  }
}

class TableOrderCustomerFormNumberField extends FormzInput<String, TableOrderCustomerFormNumberFieldValidationError> {
  const TableOrderCustomerFormNumberField.pure([super.value = '']) : super.pure();
  const TableOrderCustomerFormNumberField.dirty([super.value = '']) : super.dirty();

  @override
  TableOrderCustomerFormNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return TableOrderCustomerFormNumberFieldValidationError.empty;
    return null;
  }
}
