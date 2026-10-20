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

enum VariationNameFieldValidationError { empty }

enum VariationMinQuantityFieldValidationError { empty }

enum VariationMaxQuantityFieldValidationError { empty }

enum VariationOptionNameFieldValidationError { empty }

enum VariationOptionPriceFieldValidationError { empty }

enum VariationOptionStockFieldValidationError { empty }

class VariationNameField extends FormzInput<String, VariationNameFieldValidationError> {
  const VariationNameField.pure([super.value = '']) : super.pure();
  const VariationNameField.dirty([super.value = '']) : super.dirty();

  @override
  VariationNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return VariationNameFieldValidationError.empty;
    return null;
  }
}

class VariationMinQuantityField extends FormzInput<String, VariationMinQuantityFieldValidationError> {
  const VariationMinQuantityField.pure([super.value = '']) : super.pure();
  const VariationMinQuantityField.dirty([super.value = '']) : super.dirty();

  @override
  VariationMinQuantityFieldValidationError? validator(String value) {
    if (value.isEmpty) return VariationMinQuantityFieldValidationError.empty;
    return null;
  }
}

class VariationMaxQuantityField extends FormzInput<String, VariationMaxQuantityFieldValidationError> {
  const VariationMaxQuantityField.pure([super.value = '']) : super.pure();
  const VariationMaxQuantityField.dirty([super.value = '']) : super.dirty();

  @override
  VariationMaxQuantityFieldValidationError? validator(String value) {
    if (value.isEmpty) return VariationMaxQuantityFieldValidationError.empty;
    return null;
  }
}

////////////
class VariationOptionNameField extends FormzInput<String, VariationOptionNameFieldValidationError> {
  const VariationOptionNameField.pure([super.value = '']) : super.pure();
  const VariationOptionNameField.dirty([super.value = '']) : super.dirty();

  @override
  VariationOptionNameFieldValidationError? validator(String value) {
    if (value.isEmpty) {
      return VariationOptionNameFieldValidationError.empty;
    }
    return null;
  }
}

class VariationOptionPriceField extends FormzInput<String, VariationOptionPriceFieldValidationError> {
  const VariationOptionPriceField.pure([super.value = '']) : super.pure();
  const VariationOptionPriceField.dirty([super.value = '']) : super.dirty();

  @override
  VariationOptionPriceFieldValidationError? validator(String value) {
    if (value.isEmpty) {
      return VariationOptionPriceFieldValidationError.empty;
    }
    return null;
  }
}

class VariationOptionStockField extends FormzInput<String, VariationOptionStockFieldValidationError> {
  const VariationOptionStockField.pure([super.value = '']) : super.pure();
  const VariationOptionStockField.dirty([super.value = '']) : super.dirty();

  @override
  VariationOptionStockFieldValidationError? validator(String value) {
    if (value.isEmpty) {
      return VariationOptionStockFieldValidationError.empty;
    }
    return null;
  }
}

///////////