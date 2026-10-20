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

enum ResetWithOptionOneEmailFieldValidationError { invalid }

enum ResetWithOptionOnePasswordFieldValidationError { empty }

enum ResetWithOptionOneConfirmPasswordFieldValidationError { empty, mismatch }

class ResetWithOptionOneEmailField extends FormzInput<String, ResetWithOptionOneEmailFieldValidationError> {
  const ResetWithOptionOneEmailField.pure([super.value = '']) : super.pure();

  const ResetWithOptionOneEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  ResetWithOptionOneEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : ResetWithOptionOneEmailFieldValidationError.invalid;
  }
}

class ResetWithOptionOnePasswordField extends FormzInput<String, ResetWithOptionOnePasswordFieldValidationError> {
  const ResetWithOptionOnePasswordField.pure([super.value = '']) : super.pure();
  const ResetWithOptionOnePasswordField.dirty([super.value = '']) : super.dirty();

  @override
  ResetWithOptionOnePasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return ResetWithOptionOnePasswordFieldValidationError.empty;
    return null;
  }
}

class ResetWithOptionOneConfirmedPasswordField extends FormzInput<String, ResetWithOptionOneConfirmPasswordFieldValidationError> {
  final String password;

  const ResetWithOptionOneConfirmedPasswordField.pure({this.password = ''}) : super.pure('');

  const ResetWithOptionOneConfirmedPasswordField.dirty({required this.password, String value = ''}) : super.dirty(value);

  @override
  ResetWithOptionOneConfirmPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) {
      return ResetWithOptionOneConfirmPasswordFieldValidationError.empty;
    }
    return password == value ? null : ResetWithOptionOneConfirmPasswordFieldValidationError.mismatch;
  }
}
