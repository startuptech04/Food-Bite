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

enum StartTimeFieldValidationError { empty }

enum EndTimeFieldValidationError { empty }

class StartTimeField extends FormzInput<String, StartTimeFieldValidationError> {
  const StartTimeField.pure([super.value = '']) : super.pure();
  const StartTimeField.dirty([super.value = '']) : super.dirty();

  @override
  StartTimeFieldValidationError? validator(String value) {
    if (value.isEmpty) return StartTimeFieldValidationError.empty;
    return null;
  }
}

class EndTimeField extends FormzInput<String, EndTimeFieldValidationError> {
  const EndTimeField.pure([super.value = '']) : super.pure();
  const EndTimeField.dirty([super.value = '']) : super.dirty();

  @override
  EndTimeFieldValidationError? validator(String value) {
    if (value.isEmpty) return EndTimeFieldValidationError.empty;
    return null;
  }
}
