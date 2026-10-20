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

enum DeliverymanFirstNameFieldValidationError { empty }

enum DeliverymanLastNameFieldValidationError { empty }

enum DeliverymanEmailFieldValidationError { invalid }

enum DeliverymanPasswordFieldValidationError { empty }

enum DeliverymanCountryCodeFieldValidationError { empty }

enum DeliverymanMobileNumberFieldValidationError { empty }

enum DeliverymanAgeFieldValidationError { empty }

enum DeliverymanIdentityNumberFieldValidationError { empty }

enum DeliverymanDOBFieldValidationError { empty }

enum DeliverymanCoverFieldValidationError { empty }

enum DeliverymanIdentityProofFieldValidationError { empty }

enum DeliverymanDrivingLicenseieldValidationError { empty }

class DeliverymanFirstNameField extends FormzInput<String, DeliverymanFirstNameFieldValidationError> {
  const DeliverymanFirstNameField.pure([super.value = '']) : super.pure();
  const DeliverymanFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanFirstNameFieldValidationError.empty;
    return null;
  }
}

class DeliverymanLastNameField extends FormzInput<String, DeliverymanLastNameFieldValidationError> {
  const DeliverymanLastNameField.pure([super.value = '']) : super.pure();
  const DeliverymanLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanLastNameFieldValidationError.empty;
    return null;
  }
}

class DeliverymanEmailField extends FormzInput<String, DeliverymanEmailFieldValidationError> {
  const DeliverymanEmailField.pure([super.value = '']) : super.pure();

  const DeliverymanEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  DeliverymanEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : DeliverymanEmailFieldValidationError.invalid;
  }
}

class DeliverymanPasswordField extends FormzInput<String, DeliverymanPasswordFieldValidationError> {
  const DeliverymanPasswordField.pure([super.value = '']) : super.pure();
  const DeliverymanPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanPasswordFieldValidationError.empty;
    return null;
  }
}

class DeliverymanCountryCodeField extends FormzInput<String, DeliverymanCountryCodeFieldValidationError> {
  const DeliverymanCountryCodeField.pure([super.value = '']) : super.pure();
  const DeliverymanCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanCountryCodeFieldValidationError.empty;
    return null;
  }
}

class DeliverymanMobileNumberField extends FormzInput<String, DeliverymanMobileNumberFieldValidationError> {
  const DeliverymanMobileNumberField.pure([super.value = '']) : super.pure();
  const DeliverymanMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanMobileNumberFieldValidationError.empty;
    return null;
  }
}

class DeliverymanAgeField extends FormzInput<String, DeliverymanAgeFieldValidationError> {
  const DeliverymanAgeField.pure([super.value = '']) : super.pure();
  const DeliverymanAgeField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanAgeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanAgeFieldValidationError.empty;
    return null;
  }
}

class DeliverymanIdentityNumberField extends FormzInput<String, DeliverymanIdentityNumberFieldValidationError> {
  const DeliverymanIdentityNumberField.pure([super.value = '']) : super.pure();
  const DeliverymanIdentityNumberField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanIdentityNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanIdentityNumberFieldValidationError.empty;
    return null;
  }
}

class DeliverymanDOBField extends FormzInput<String, DeliverymanDOBFieldValidationError> {
  const DeliverymanDOBField.pure([super.value = '']) : super.pure();
  const DeliverymanDOBField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanDOBFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanDOBFieldValidationError.empty;
    return null;
  }
}

class DeliverymanCoverField extends FormzInput<String, DeliverymanCoverFieldValidationError> {
  const DeliverymanCoverField.pure([super.value = '']) : super.pure();
  const DeliverymanCoverField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanCoverFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanCoverFieldValidationError.empty;
    return null;
  }
}

class DeliverymanIdentityProofField extends FormzInput<String, DeliverymanIdentityProofFieldValidationError> {
  const DeliverymanIdentityProofField.pure([super.value = '']) : super.pure();
  const DeliverymanIdentityProofField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanIdentityProofFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanIdentityProofFieldValidationError.empty;
    return null;
  }
}

class DeliverymanDrivingLicenseField extends FormzInput<String, DeliverymanDrivingLicenseieldValidationError> {
  const DeliverymanDrivingLicenseField.pure([super.value = '']) : super.pure();
  const DeliverymanDrivingLicenseField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanDrivingLicenseieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanDrivingLicenseieldValidationError.empty;
    return null;
  }
}
