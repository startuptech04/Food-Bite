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

enum CustomDateInsightStartDateFieldValidationError { empty }

enum CustomDateInsightEndDateFieldValidationError { empty }

class CustomDateInsightStartDateField extends FormzInput<String, CustomDateInsightStartDateFieldValidationError> {
  const CustomDateInsightStartDateField.pure([super.value = '']) : super.pure();
  const CustomDateInsightStartDateField.dirty([super.value = '']) : super.dirty();

  @override
  CustomDateInsightStartDateFieldValidationError? validator(String value) {
    if (value.isEmpty) return CustomDateInsightStartDateFieldValidationError.empty;
    return null;
  }
}

class CustomDateInsightEndDateField extends FormzInput<String, CustomDateInsightEndDateFieldValidationError> {
  const CustomDateInsightEndDateField.pure([super.value = '']) : super.pure();
  const CustomDateInsightEndDateField.dirty([super.value = '']) : super.dirty();

  @override
  CustomDateInsightEndDateFieldValidationError? validator(String value) {
    if (value.isEmpty) return CustomDateInsightEndDateFieldValidationError.empty;
    return null;
  }
}
