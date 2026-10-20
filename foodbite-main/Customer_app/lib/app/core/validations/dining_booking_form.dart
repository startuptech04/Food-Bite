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

enum DiningBookingEmailFieldValidationError { invalid }

enum DiningBookingNameFieldValidationError { empty }

enum DiningBookingCountryCodeFieldValidationError { empty }

enum DiningBookingNumberFieldValidationError { empty }

class DiningBookingEmailField extends FormzInput<String, DiningBookingEmailFieldValidationError> {
  const DiningBookingEmailField.pure([super.value = '']) : super.pure();

  const DiningBookingEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  DiningBookingEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : DiningBookingEmailFieldValidationError.invalid;
  }
}

class DiningBookingNameField extends FormzInput<String, DiningBookingNameFieldValidationError> {
  const DiningBookingNameField.pure([super.value = '']) : super.pure();
  const DiningBookingNameField.dirty([super.value = '']) : super.dirty();

  @override
  DiningBookingNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningBookingNameFieldValidationError.empty;
    return null;
  }
}

class DiningBookingCountryCodeField extends FormzInput<String, DiningBookingCountryCodeFieldValidationError> {
  const DiningBookingCountryCodeField.pure([super.value = '']) : super.pure();
  const DiningBookingCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  DiningBookingCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningBookingCountryCodeFieldValidationError.empty;
    return null;
  }
}

class DiningBookingNumberField extends FormzInput<String, DiningBookingNumberFieldValidationError> {
  const DiningBookingNumberField.pure([super.value = '']) : super.pure();
  const DiningBookingNumberField.dirty([super.value = '']) : super.dirty();

  @override
  DiningBookingNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningBookingNumberFieldValidationError.empty;
    return null;
  }
}
