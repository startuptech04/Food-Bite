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

enum CustomCategoryNameFieldValidationError { empty }

enum CustomCategoryImageFieldValidationError { empty }

class CustomCategoryNameField extends FormzInput<String, CustomCategoryNameFieldValidationError> {
  const CustomCategoryNameField.pure([super.value = '']) : super.pure();
  const CustomCategoryNameField.dirty([super.value = '']) : super.dirty();

  @override
  CustomCategoryNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return CustomCategoryNameFieldValidationError.empty;
    return null;
  }
}

class CustomCategoryImageField extends FormzInput<String, CustomCategoryImageFieldValidationError> {
  const CustomCategoryImageField.pure([super.value = '']) : super.pure();
  const CustomCategoryImageField.dirty([super.value = '']) : super.dirty();

  @override
  CustomCategoryImageFieldValidationError? validator(String value) {
    if (value.isEmpty) return CustomCategoryImageFieldValidationError.empty;
    return null;
  }
}
