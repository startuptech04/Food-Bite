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

enum LoginWithTypeThreeEmailFieldValidationError { invalid }

enum LoginWithTypeThreeRememberMeFieldValidationError { valid }

class LoginWithTypeThreeEmailField extends FormzInput<String, LoginWithTypeThreeEmailFieldValidationError> {
  const LoginWithTypeThreeEmailField.pure([super.value = '']) : super.pure();

  const LoginWithTypeThreeEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  LoginWithTypeThreeEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : LoginWithTypeThreeEmailFieldValidationError.invalid;
  }
}

class LoginWithTypeThreeRememberMeField extends FormzInput<bool, LoginWithTypeThreeRememberMeFieldValidationError> {
  const LoginWithTypeThreeRememberMeField.pure([super.value = false]) : super.pure();
  const LoginWithTypeThreeRememberMeField.dirty([super.value = false]) : super.dirty();

  @override
  LoginWithTypeThreeRememberMeFieldValidationError? validator(bool value) {
    if (value) return LoginWithTypeThreeRememberMeFieldValidationError.valid;
    return null;
  }
}
