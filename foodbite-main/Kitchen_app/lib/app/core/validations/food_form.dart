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

enum FoodNameFieldValidationError { empty }

enum FoodShortDescriptionFieldValidationError { empty }

enum FoodImageFieldValidationError { empty }

enum FoodStockFieldValidationError { empty }

class FoodNameField extends FormzInput<String, FoodNameFieldValidationError> {
  const FoodNameField.pure([super.value = '']) : super.pure();
  const FoodNameField.dirty([super.value = '']) : super.dirty();

  @override
  FoodNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return FoodNameFieldValidationError.empty;
    return null;
  }
}

class FoodShortDescriptionField extends FormzInput<String, FoodShortDescriptionFieldValidationError> {
  const FoodShortDescriptionField.pure([super.value = '']) : super.pure();
  const FoodShortDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  FoodShortDescriptionFieldValidationError? validator(String value) {
    if (value.isEmpty) return FoodShortDescriptionFieldValidationError.empty;
    return null;
  }
}

class FoodImageField extends FormzInput<String, FoodImageFieldValidationError> {
  const FoodImageField.pure([super.value = '']) : super.pure();
  const FoodImageField.dirty([super.value = '']) : super.dirty();

  @override
  FoodImageFieldValidationError? validator(String value) {
    if (value.isEmpty) return FoodImageFieldValidationError.empty;
    return null;
  }
}

class FoodStockField extends FormzInput<String, FoodStockFieldValidationError> {
  const FoodStockField.pure([super.value = '']) : super.pure();
  const FoodStockField.dirty([super.value = '']) : super.dirty();

  @override
  FoodStockFieldValidationError? validator(String value) {
    if (value.isEmpty) return FoodStockFieldValidationError.empty;
    return null;
  }
}
