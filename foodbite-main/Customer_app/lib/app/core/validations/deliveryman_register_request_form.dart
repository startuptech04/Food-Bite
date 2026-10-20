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

enum DeliverymanRegisterRequestEmailFieldValidationError { invalid }

enum DeliverymanRegisterRequestPasswordFieldValidationError { empty }

enum DeliverymanRegisterRequestFirstNameFieldValidationError { empty }

enum DeliverymanRegisterRequestLastNameFieldValidationError { empty }

enum DeliverymanRegisterRequestCountryCodeFieldValidationError { empty }

enum DeliverymanRegisterRequestMobileNumberFieldValidationError { empty }

enum DeliverymanRegisterRequestCoverFieldValidationError { empty }

enum DeliverymanRegisterRequestIndentityProofFieldValidationError { empty }

enum DeliverymanRegisterRequestAgeFieldValidationError { empty }

enum DeliverymanRegisterRequestDOBFieldValidationError { empty }

enum DeliverymanRegisterRequestIdentityNumberFieldValidationError { empty }

enum DeliverymanRegisterRequestDrivingLicenseFieldValidationError { empty }

enum DeliverymanRegisterRequestLatitudeFieldValidationError { empty }

enum DeliverymanRegisterRequestLongitudeFieldValidationError { empty }

class DeliverymanRegisterRequestEmailField extends FormzInput<String, DeliverymanRegisterRequestEmailFieldValidationError> {
  const DeliverymanRegisterRequestEmailField.pure([super.value = '']) : super.pure();

  const DeliverymanRegisterRequestEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$');

  @override
  DeliverymanRegisterRequestEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : DeliverymanRegisterRequestEmailFieldValidationError.invalid;
  }
}

class DeliverymanRegisterRequestPasswordField extends FormzInput<String, DeliverymanRegisterRequestPasswordFieldValidationError> {
  const DeliverymanRegisterRequestPasswordField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestPasswordFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestFirstNameField extends FormzInput<String, DeliverymanRegisterRequestFirstNameFieldValidationError> {
  const DeliverymanRegisterRequestFirstNameField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestFirstNameFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestLastNameField extends FormzInput<String, DeliverymanRegisterRequestLastNameFieldValidationError> {
  const DeliverymanRegisterRequestLastNameField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestLastNameFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestCountryCodeField extends FormzInput<String, DeliverymanRegisterRequestCountryCodeFieldValidationError> {
  const DeliverymanRegisterRequestCountryCodeField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestCountryCodeFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestMobileNumberField extends FormzInput<String, DeliverymanRegisterRequestMobileNumberFieldValidationError> {
  const DeliverymanRegisterRequestMobileNumberField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestMobileNumberFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestCoverField extends FormzInput<String, DeliverymanRegisterRequestCoverFieldValidationError> {
  const DeliverymanRegisterRequestCoverField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestCoverField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestCoverFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestCoverFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestIndentityProofField extends FormzInput<String, DeliverymanRegisterRequestIndentityProofFieldValidationError> {
  const DeliverymanRegisterRequestIndentityProofField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestIndentityProofField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestIndentityProofFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestIndentityProofFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestAgeField extends FormzInput<String, DeliverymanRegisterRequestAgeFieldValidationError> {
  const DeliverymanRegisterRequestAgeField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestAgeField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestAgeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestAgeFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestDOBField extends FormzInput<String, DeliverymanRegisterRequestDOBFieldValidationError> {
  const DeliverymanRegisterRequestDOBField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestDOBField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestDOBFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestDOBFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestIdentityNumberField extends FormzInput<String, DeliverymanRegisterRequestIdentityNumberFieldValidationError> {
  const DeliverymanRegisterRequestIdentityNumberField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestIdentityNumberField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestIdentityNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestIdentityNumberFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestDrivingLicenseField extends FormzInput<String, DeliverymanRegisterRequestDrivingLicenseFieldValidationError> {
  const DeliverymanRegisterRequestDrivingLicenseField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestDrivingLicenseField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestDrivingLicenseFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestDrivingLicenseFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestLatitudeField extends FormzInput<String, DeliverymanRegisterRequestLatitudeFieldValidationError> {
  const DeliverymanRegisterRequestLatitudeField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestLatitudeField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestLatitudeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestLatitudeFieldValidationError.empty;
    return null;
  }
}

class DeliverymanRegisterRequestLongitudeField extends FormzInput<String, DeliverymanRegisterRequestLongitudeFieldValidationError> {
  const DeliverymanRegisterRequestLongitudeField.pure([super.value = '']) : super.pure();
  const DeliverymanRegisterRequestLongitudeField.dirty([super.value = '']) : super.dirty();

  @override
  DeliverymanRegisterRequestLongitudeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DeliverymanRegisterRequestLongitudeFieldValidationError.empty;
    return null;
  }
}
