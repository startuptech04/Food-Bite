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

enum DeliveryTimeFromFieldValidationError { empty }

enum DeliveryTimeToFieldValidationError { empty }

class DeliveryTimeFromField extends FormzInput<String, DeliveryTimeFromFieldValidationError> {
  const DeliveryTimeFromField.pure([super.value = '']) : super.pure();
  const DeliveryTimeFromField.dirty([super.value = '']) : super.dirty();

  @override
  DeliveryTimeFromFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliveryTimeFromFieldValidationError.empty;
    return null;
  }
}

class DeliveryTimeToField extends FormzInput<String, DeliveryTimeToFieldValidationError> {
  const DeliveryTimeToField.pure([super.value = '']) : super.pure();
  const DeliveryTimeToField.dirty([super.value = '']) : super.dirty();

  @override
  DeliveryTimeToFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliveryTimeToFieldValidationError.empty;
    return null;
  }
}
