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

enum FeedbackFormEmailFieldValidationError { invalid }

enum FeedbackFormNameFieldValidationError { empty }

enum FeedbackFormCountryCodeFieldValidationError { empty }

enum FeedbackFormNumberFieldValidationError { empty }

enum FeedbackFormShortDescriptionFieldValidationError { empty }

class FeedbackFormEmailField extends FormzInput<String, FeedbackFormEmailFieldValidationError> {
  const FeedbackFormEmailField.pure([super.value = '']) : super.pure();

  const FeedbackFormEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  FeedbackFormEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : FeedbackFormEmailFieldValidationError.invalid;
  }
}

class FeedbackFormNameField extends FormzInput<String, FeedbackFormNameFieldValidationError> {
  const FeedbackFormNameField.pure([super.value = '']) : super.pure();
  const FeedbackFormNameField.dirty([super.value = '']) : super.dirty();

  @override
  FeedbackFormNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return FeedbackFormNameFieldValidationError.empty;
    return null;
  }
}

class FeedbackFormCountryCodeField extends FormzInput<String, FeedbackFormCountryCodeFieldValidationError> {
  const FeedbackFormCountryCodeField.pure([super.value = '']) : super.pure();
  const FeedbackFormCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  FeedbackFormCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return FeedbackFormCountryCodeFieldValidationError.empty;
    return null;
  }
}

class FeedbackFormNumberField extends FormzInput<String, FeedbackFormNumberFieldValidationError> {
  const FeedbackFormNumberField.pure([super.value = '']) : super.pure();
  const FeedbackFormNumberField.dirty([super.value = '']) : super.dirty();

  @override
  FeedbackFormNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return FeedbackFormNumberFieldValidationError.empty;
    return null;
  }
}

class FeedbackFormShortDescriptionField extends FormzInput<String, FeedbackFormShortDescriptionFieldValidationError> {
  const FeedbackFormShortDescriptionField.pure([super.value = '']) : super.pure();
  const FeedbackFormShortDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  FeedbackFormShortDescriptionFieldValidationError? validator(String value) {
    if (value.isEmpty) return FeedbackFormShortDescriptionFieldValidationError.empty;
    return null;
  }
}
