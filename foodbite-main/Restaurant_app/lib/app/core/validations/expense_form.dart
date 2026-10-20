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

enum ExpenseAmountFieldValidationError { empty }

class ExpenseAmountField extends FormzInput<String, ExpenseAmountFieldValidationError> {
  const ExpenseAmountField.pure([super.value = '']) : super.pure();
  const ExpenseAmountField.dirty([super.value = '']) : super.dirty();

  @override
  ExpenseAmountFieldValidationError? validator(String value) {
    if (value.isEmpty) return ExpenseAmountFieldValidationError.empty;
    return null;
  }
}
