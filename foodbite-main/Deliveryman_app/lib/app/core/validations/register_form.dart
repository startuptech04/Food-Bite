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

enum RegisterRequestEmailFieldValidationError { invalid }

enum RegisterRequestPasswordFieldValidationError { empty }

enum RegisterRequestFirstNameFieldValidationError { empty }

enum RegisterRequestLastNameFieldValidationError { empty }

enum RegisterRequestCountryCodeFieldValidationError { empty }

enum RegisterRequestMobileNumberFieldValidationError { empty }

enum RegisterRequestCoverFieldValidationError { empty }

enum RegisterRequestIndentityProofFieldValidationError { empty }

enum RegisterRequestAgeFieldValidationError { empty }

enum RegisterRequestDOBFieldValidationError { empty }

enum RegisterRequestIdentityNumberFieldValidationError { empty }

enum RegisterRequestDrivingLicenseFieldValidationError { empty }

enum RegisterRequestLatitudeFieldValidationError { empty }

enum RegisterRequestLongitudeFieldValidationError { empty }

class RegisterRequestEmailField extends FormzInput<String, RegisterRequestEmailFieldValidationError> {
  const RegisterRequestEmailField.pure([super.value = '']) : super.pure();

  const RegisterRequestEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  RegisterRequestEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : RegisterRequestEmailFieldValidationError.invalid;
  }
}

class RegisterRequestPasswordField extends FormzInput<String, RegisterRequestPasswordFieldValidationError> {
  const RegisterRequestPasswordField.pure([super.value = '']) : super.pure();
  const RegisterRequestPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestPasswordFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestFirstNameField extends FormzInput<String, RegisterRequestFirstNameFieldValidationError> {
  const RegisterRequestFirstNameField.pure([super.value = '']) : super.pure();
  const RegisterRequestFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestFirstNameFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestLastNameField extends FormzInput<String, RegisterRequestLastNameFieldValidationError> {
  const RegisterRequestLastNameField.pure([super.value = '']) : super.pure();
  const RegisterRequestLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestLastNameFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestCountryCodeField extends FormzInput<String, RegisterRequestCountryCodeFieldValidationError> {
  const RegisterRequestCountryCodeField.pure([super.value = '']) : super.pure();
  const RegisterRequestCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestCountryCodeFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestMobileNumberField extends FormzInput<String, RegisterRequestMobileNumberFieldValidationError> {
  const RegisterRequestMobileNumberField.pure([super.value = '']) : super.pure();
  const RegisterRequestMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestMobileNumberFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestCoverField extends FormzInput<String, RegisterRequestCoverFieldValidationError> {
  const RegisterRequestCoverField.pure([super.value = '']) : super.pure();
  const RegisterRequestCoverField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestCoverFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestCoverFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestIndentityProofField extends FormzInput<String, RegisterRequestIndentityProofFieldValidationError> {
  const RegisterRequestIndentityProofField.pure([super.value = '']) : super.pure();
  const RegisterRequestIndentityProofField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestIndentityProofFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestIndentityProofFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestAgeField extends FormzInput<String, RegisterRequestAgeFieldValidationError> {
  const RegisterRequestAgeField.pure([super.value = '']) : super.pure();
  const RegisterRequestAgeField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestAgeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestAgeFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestDOBField extends FormzInput<String, RegisterRequestDOBFieldValidationError> {
  const RegisterRequestDOBField.pure([super.value = '']) : super.pure();
  const RegisterRequestDOBField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestDOBFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestDOBFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestIdentityNumberField extends FormzInput<String, RegisterRequestIdentityNumberFieldValidationError> {
  const RegisterRequestIdentityNumberField.pure([super.value = '']) : super.pure();
  const RegisterRequestIdentityNumberField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestIdentityNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestIdentityNumberFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestDrivingLicenseField extends FormzInput<String, RegisterRequestDrivingLicenseFieldValidationError> {
  const RegisterRequestDrivingLicenseField.pure([super.value = '']) : super.pure();
  const RegisterRequestDrivingLicenseField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestDrivingLicenseFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestDrivingLicenseFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestLatitudeField extends FormzInput<String, RegisterRequestLatitudeFieldValidationError> {
  const RegisterRequestLatitudeField.pure([super.value = '']) : super.pure();
  const RegisterRequestLatitudeField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestLatitudeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestLatitudeFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestLongitudeField extends FormzInput<String, RegisterRequestLongitudeFieldValidationError> {
  const RegisterRequestLongitudeField.pure([super.value = '']) : super.pure();
  const RegisterRequestLongitudeField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestLongitudeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestLongitudeFieldValidationError.empty;
    return null;
  }
}
