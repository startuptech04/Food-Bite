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

enum AccountSettingChangePasswordPasswordFieldValidationError { empty }

enum AccountSettingChangePasswordConfirmPasswordFieldValidationError { empty, mismatch }

class AccountSettingChangePasswordPasswordField extends FormzInput<String, AccountSettingChangePasswordPasswordFieldValidationError> {
  const AccountSettingChangePasswordPasswordField.pure([super.value = '']) : super.pure();
  const AccountSettingChangePasswordPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  AccountSettingChangePasswordPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return AccountSettingChangePasswordPasswordFieldValidationError.empty;
    return null;
  }
}

class AccountSettingChangePasswordConfirmedPasswordField extends FormzInput<String, AccountSettingChangePasswordConfirmPasswordFieldValidationError> {
  final String password;

  const AccountSettingChangePasswordConfirmedPasswordField.pure({this.password = ''}) : super.pure('');

  const AccountSettingChangePasswordConfirmedPasswordField.dirty({required this.password, String value = ''}) : super.dirty(value);

  @override
  AccountSettingChangePasswordConfirmPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) {
      return AccountSettingChangePasswordConfirmPasswordFieldValidationError.empty;
    }
    return password == value ? null : AccountSettingChangePasswordConfirmPasswordFieldValidationError.mismatch;
  }
}
