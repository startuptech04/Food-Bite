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

enum CustomSubCategoryNameFieldValidationError { empty }

enum CustomSubCategoryCateIdFieldValidationError { empty }

class CustomSubCategoryNameField extends FormzInput<String, CustomSubCategoryNameFieldValidationError> {
  const CustomSubCategoryNameField.pure([super.value = '']) : super.pure();
  const CustomSubCategoryNameField.dirty([super.value = '']) : super.dirty();

  @override
  CustomSubCategoryNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return CustomSubCategoryNameFieldValidationError.empty;
    return null;
  }
}

class CustomSubCategoryCateIdField extends FormzInput<String, CustomSubCategoryCateIdFieldValidationError> {
  const CustomSubCategoryCateIdField.pure([super.value = '']) : super.pure();
  const CustomSubCategoryCateIdField.dirty([super.value = '']) : super.dirty();

  @override
  CustomSubCategoryCateIdFieldValidationError? validator(String value) {
    if (value.isEmpty) return CustomSubCategoryCateIdFieldValidationError.empty;
    return null;
  }
}
