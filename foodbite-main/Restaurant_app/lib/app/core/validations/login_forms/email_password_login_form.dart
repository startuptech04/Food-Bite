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

enum LoginWithTypeOneEmailFieldValidationError { invalid }

enum LoginWithTypeOnePasswordFieldValidationError { empty }

enum LoginWithTypeOneRememberMeFieldValidationError { valid }

class LoginWithTypeOneEmailField extends FormzInput<String, LoginWithTypeOneEmailFieldValidationError> {
  const LoginWithTypeOneEmailField.pure([super.value = '']) : super.pure();

  const LoginWithTypeOneEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  LoginWithTypeOneEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : LoginWithTypeOneEmailFieldValidationError.invalid;
  }
}

class LoginWithTypeOnePasswordField extends FormzInput<String, LoginWithTypeOnePasswordFieldValidationError> {
  const LoginWithTypeOnePasswordField.pure([super.value = '']) : super.pure();
  const LoginWithTypeOnePasswordField.dirty([super.value = '']) : super.dirty();

  @override
  LoginWithTypeOnePasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return LoginWithTypeOnePasswordFieldValidationError.empty;
    return null;
  }
}

class LoginWithTypeOneRememberMeField extends FormzInput<bool, LoginWithTypeOneRememberMeFieldValidationError> {
  const LoginWithTypeOneRememberMeField.pure([super.value = false]) : super.pure();
  const LoginWithTypeOneRememberMeField.dirty([super.value = false]) : super.dirty();

  @override
  LoginWithTypeOneRememberMeFieldValidationError? validator(bool value) {
    if (value) return LoginWithTypeOneRememberMeFieldValidationError.valid;
    return null;
  }
}
