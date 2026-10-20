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

enum KitchenOwnerFirstNameFieldValidationError { empty }

enum KitchenOwnerLastNameFieldValidationError { empty }

enum KitchenOwnerEmailFieldValidationError { invalid }

enum KitchenOwnerPasswordFieldValidationError { empty }

enum KitchenOwnerCountryCodeFieldValidationError { empty }

enum KitchenOwnerMobileNumberFieldValidationError { empty }

enum KitchenOwnerCoverFieldValidationError { empty }

class KitchenOwnerFirstNameField extends FormzInput<String, KitchenOwnerFirstNameFieldValidationError> {
  const KitchenOwnerFirstNameField.pure([super.value = '']) : super.pure();
  const KitchenOwnerFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  KitchenOwnerFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return KitchenOwnerFirstNameFieldValidationError.empty;
    return null;
  }
}

class KitchenOwnerLastNameField extends FormzInput<String, KitchenOwnerLastNameFieldValidationError> {
  const KitchenOwnerLastNameField.pure([super.value = '']) : super.pure();
  const KitchenOwnerLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  KitchenOwnerLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return KitchenOwnerLastNameFieldValidationError.empty;
    return null;
  }
}

class KitchenOwnerEmailField extends FormzInput<String, KitchenOwnerEmailFieldValidationError> {
  const KitchenOwnerEmailField.pure([super.value = '']) : super.pure();

  const KitchenOwnerEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  KitchenOwnerEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : KitchenOwnerEmailFieldValidationError.invalid;
  }
}

class KitchenOwnerPasswordField extends FormzInput<String, KitchenOwnerPasswordFieldValidationError> {
  const KitchenOwnerPasswordField.pure([super.value = '']) : super.pure();
  const KitchenOwnerPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  KitchenOwnerPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return KitchenOwnerPasswordFieldValidationError.empty;
    return null;
  }
}

class KitchenOwnerCountryCodeField extends FormzInput<String, KitchenOwnerCountryCodeFieldValidationError> {
  const KitchenOwnerCountryCodeField.pure([super.value = '']) : super.pure();
  const KitchenOwnerCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  KitchenOwnerCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return KitchenOwnerCountryCodeFieldValidationError.empty;
    return null;
  }
}

class KitchenOwnerMobileNumberField extends FormzInput<String, KitchenOwnerMobileNumberFieldValidationError> {
  const KitchenOwnerMobileNumberField.pure([super.value = '']) : super.pure();
  const KitchenOwnerMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  KitchenOwnerMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return KitchenOwnerMobileNumberFieldValidationError.empty;
    return null;
  }
}

class KitchenOwnerCoverField extends FormzInput<String, KitchenOwnerCoverFieldValidationError> {
  const KitchenOwnerCoverField.pure([super.value = '']) : super.pure();
  const KitchenOwnerCoverField.dirty([super.value = '']) : super.dirty();

  @override
  KitchenOwnerCoverFieldValidationError? validator(String value) {
    if (value.isEmpty) return KitchenOwnerCoverFieldValidationError.empty;
    return null;
  }
}
