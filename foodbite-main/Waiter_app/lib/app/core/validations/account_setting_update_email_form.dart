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

enum AccountSettingChangeEmailFieldValidationError { invalid }

class AccountSettingChangeEmailField extends FormzInput<String, AccountSettingChangeEmailFieldValidationError> {
  const AccountSettingChangeEmailField.pure([super.value = '']) : super.pure();

  const AccountSettingChangeEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  AccountSettingChangeEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : AccountSettingChangeEmailFieldValidationError.invalid;
  }
}
