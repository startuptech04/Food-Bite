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

enum ReportEmergencyFormEmailFieldValidationError { invalid }

enum ReportEmergencyFormNameFieldValidationError { empty }

enum ReportEmergencyFormCountryCodeFieldValidationError { empty }

enum ReportEmergencyFormNumberFieldValidationError { empty }

enum ReportEmergencyFormShortDescriptionFieldValidationError { empty }

class ReportEmergencyFormEmailField extends FormzInput<String, ReportEmergencyFormEmailFieldValidationError> {
  const ReportEmergencyFormEmailField.pure([super.value = '']) : super.pure();

  const ReportEmergencyFormEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  ReportEmergencyFormEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : ReportEmergencyFormEmailFieldValidationError.invalid;
  }
}

class ReportEmergencyFormNameField extends FormzInput<String, ReportEmergencyFormNameFieldValidationError> {
  const ReportEmergencyFormNameField.pure([super.value = '']) : super.pure();
  const ReportEmergencyFormNameField.dirty([super.value = '']) : super.dirty();

  @override
  ReportEmergencyFormNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return ReportEmergencyFormNameFieldValidationError.empty;
    return null;
  }
}

class ReportEmergencyFormCountryCodeField extends FormzInput<String, ReportEmergencyFormCountryCodeFieldValidationError> {
  const ReportEmergencyFormCountryCodeField.pure([super.value = '']) : super.pure();
  const ReportEmergencyFormCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  ReportEmergencyFormCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return ReportEmergencyFormCountryCodeFieldValidationError.empty;
    return null;
  }
}

class ReportEmergencyFormNumberField extends FormzInput<String, ReportEmergencyFormNumberFieldValidationError> {
  const ReportEmergencyFormNumberField.pure([super.value = '']) : super.pure();
  const ReportEmergencyFormNumberField.dirty([super.value = '']) : super.dirty();

  @override
  ReportEmergencyFormNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return ReportEmergencyFormNumberFieldValidationError.empty;
    return null;
  }
}

class ReportEmergencyFormShortDescriptionField extends FormzInput<String, ReportEmergencyFormShortDescriptionFieldValidationError> {
  const ReportEmergencyFormShortDescriptionField.pure([super.value = '']) : super.pure();
  const ReportEmergencyFormShortDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  ReportEmergencyFormShortDescriptionFieldValidationError? validator(String value) {
    if (value.isEmpty) return ReportEmergencyFormShortDescriptionFieldValidationError.empty;
    return null;
  }
}
