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

enum FoodTaxationNameFieldValidationError { empty }

enum FoodAmountTaxationFieldValidationError { empty }

class FoodTaxationNameField extends FormzInput<String, FoodTaxationNameFieldValidationError> {
  const FoodTaxationNameField.pure([super.value = '']) : super.pure();
  const FoodTaxationNameField.dirty([super.value = '']) : super.dirty();

  @override
  FoodTaxationNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return FoodTaxationNameFieldValidationError.empty;
    return null;
  }
}

class FoodTaxationAmountField extends FormzInput<String, FoodAmountTaxationFieldValidationError> {
  const FoodTaxationAmountField.pure([super.value = '']) : super.pure();
  const FoodTaxationAmountField.dirty([super.value = '']) : super.dirty();

  @override
  FoodAmountTaxationFieldValidationError? validator(String value) {
    if (value.isEmpty) return FoodAmountTaxationFieldValidationError.empty;
    return null;
  }
}
