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

enum AddonNameFieldValidationError { empty }

enum AddonPriceFieldValidationError { empty }

enum AddonStockFieldValidationError { empty }

class AddonNameField extends FormzInput<String, AddonNameFieldValidationError> {
  const AddonNameField.pure([super.value = '']) : super.pure();
  const AddonNameField.dirty([super.value = '']) : super.dirty();

  @override
  AddonNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return AddonNameFieldValidationError.empty;
    return null;
  }
}

class AddonPriceField extends FormzInput<String, AddonPriceFieldValidationError> {
  const AddonPriceField.pure([super.value = '']) : super.pure();
  const AddonPriceField.dirty([super.value = '']) : super.dirty();

  @override
  AddonPriceFieldValidationError? validator(String value) {
    if (value.isEmpty) return AddonPriceFieldValidationError.empty;
    return null;
  }
}

class AddonStockField extends FormzInput<String, AddonStockFieldValidationError> {
  const AddonStockField.pure([super.value = '']) : super.pure();
  const AddonStockField.dirty([super.value = '']) : super.dirty();

  @override
  AddonStockFieldValidationError? validator(String value) {
    if (value.isEmpty) return AddonStockFieldValidationError.empty;
    return null;
  }
}
