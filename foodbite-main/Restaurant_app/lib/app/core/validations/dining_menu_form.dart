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

enum MenuNameFieldValidationError { empty }

class MenuNameField extends FormzInput<String, MenuNameFieldValidationError> {
  const MenuNameField.pure([super.value = '']) : super.pure();
  const MenuNameField.dirty([super.value = '']) : super.dirty();

  @override
  MenuNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return MenuNameFieldValidationError.empty;
    return null;
  }
}
