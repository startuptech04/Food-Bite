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

enum ResetWithOptionTwoCountryCodeFieldValidationError { empty }

enum ResetWithOptionTwoMobileNumberFieldValidationError { empty }

enum ResetWithOptionTwoPasswordFieldValidationError { empty }

enum ResetWithOptionTwoConfirmPasswordFieldValidationError { empty, mismatch }

class ResetWithOptionTwoCountryCodeField extends FormzInput<String, ResetWithOptionTwoCountryCodeFieldValidationError> {
  const ResetWithOptionTwoCountryCodeField.pure([super.value = '']) : super.pure();
  const ResetWithOptionTwoCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  ResetWithOptionTwoCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return ResetWithOptionTwoCountryCodeFieldValidationError.empty;
    return null;
  }
}

class ResetWithOptionTwoMobileNumberField extends FormzInput<String, ResetWithOptionTwoMobileNumberFieldValidationError> {
  const ResetWithOptionTwoMobileNumberField.pure([super.value = '']) : super.pure();
  const ResetWithOptionTwoMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  ResetWithOptionTwoMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return ResetWithOptionTwoMobileNumberFieldValidationError.empty;
    return null;
  }
}

class ResetWithOptionTwoPasswordField extends FormzInput<String, ResetWithOptionTwoPasswordFieldValidationError> {
  const ResetWithOptionTwoPasswordField.pure([super.value = '']) : super.pure();
  const ResetWithOptionTwoPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  ResetWithOptionTwoPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return ResetWithOptionTwoPasswordFieldValidationError.empty;
    return null;
  }
}

class ResetWithOptionTwoConfirmedPasswordField extends FormzInput<String, ResetWithOptionTwoConfirmPasswordFieldValidationError> {
  final String password;

  const ResetWithOptionTwoConfirmedPasswordField.pure({this.password = ''}) : super.pure('');

  const ResetWithOptionTwoConfirmedPasswordField.dirty({required this.password, String value = ''}) : super.dirty(value);

  @override
  ResetWithOptionTwoConfirmPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) {
      return ResetWithOptionTwoConfirmPasswordFieldValidationError.empty;
    }
    return password == value ? null : ResetWithOptionTwoConfirmPasswordFieldValidationError.mismatch;
  }
}
