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

enum RestaurantTableNumberFieldValidationError { empty }

enum RestaurantTableCapacityFieldValidationError { empty }

class RestaurantTableNumberField extends FormzInput<String, RestaurantTableNumberFieldValidationError> {
  const RestaurantTableNumberField.pure([super.value = '']) : super.pure();
  const RestaurantTableNumberField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantTableNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantTableNumberFieldValidationError.empty;
    return null;
  }
}

class RestaurantTableCapacityField extends FormzInput<String, RestaurantTableCapacityFieldValidationError> {
  const RestaurantTableCapacityField.pure([super.value = '']) : super.pure();
  const RestaurantTableCapacityField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantTableCapacityFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantTableCapacityFieldValidationError.empty;
    return null;
  }
}
