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

enum RegisterRequestNameFieldValidationError { empty }

enum RegisterRequestShortDescriptionFieldValidationError { empty }

enum RegisterRequestAddressFieldValidationError { empty }

enum RegisterRequestCuisineFieldValidationError { empty }

enum RegisterRequestTypeFieldValidationError { empty }

enum RegisterRequestFacilitiesFieldValidationError { empty }

enum RegisterRequestMinOrderAmountFieldValidationError { empty }

enum RegisterRequestDishPriceForTwoFieldValidationError { empty }

enum RegisterRequestFoodLicenseFieldValidationError { empty }

enum RegisterRequestDeliveryTimeFieldValidationError { empty }

enum RegisterRequestEmailFieldValidationError { invalid }

enum RegisterRequestPasswordFieldValidationError { empty }

enum RegisterRequestFirstNameFieldValidationError { empty }

enum RegisterRequestLastNameFieldValidationError { empty }

enum RegisterRequestCountryCodeFieldValidationError { empty }

enum RegisterRequestMobileNumberFieldValidationError { empty }

enum RegisterRequestLatitudeFieldValidationError { empty }

enum RegisterRequestLongitudeFieldValidationError { empty }

enum RegisterRequestCoverFieldValidationError { empty }

enum RegisterRequestLogoFieldValidationError { empty }

class RegisterRequestNameField extends FormzInput<String, RegisterRequestNameFieldValidationError> {
  const RegisterRequestNameField.pure([super.value = '']) : super.pure();
  const RegisterRequestNameField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestNameFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestShortDescriptionField extends FormzInput<String, RegisterRequestShortDescriptionFieldValidationError> {
  const RegisterRequestShortDescriptionField.pure([super.value = '']) : super.pure();
  const RegisterRequestShortDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestShortDescriptionFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestShortDescriptionFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestAddressField extends FormzInput<String, RegisterRequestAddressFieldValidationError> {
  const RegisterRequestAddressField.pure([super.value = '']) : super.pure();
  const RegisterRequestAddressField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestAddressFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestAddressFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestCuisineField extends FormzInput<String, RegisterRequestCuisineFieldValidationError> {
  const RegisterRequestCuisineField.pure([super.value = '']) : super.pure();
  const RegisterRequestCuisineField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestCuisineFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestCuisineFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestTypeField extends FormzInput<String, RegisterRequestTypeFieldValidationError> {
  const RegisterRequestTypeField.pure([super.value = '']) : super.pure();
  const RegisterRequestTypeField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestTypeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestTypeFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestFacilitiesField extends FormzInput<String, RegisterRequestFacilitiesFieldValidationError> {
  const RegisterRequestFacilitiesField.pure([super.value = '']) : super.pure();
  const RegisterRequestFacilitiesField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestFacilitiesFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestFacilitiesFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestMinOrderAmountField extends FormzInput<String, RegisterRequestMinOrderAmountFieldValidationError> {
  const RegisterRequestMinOrderAmountField.pure([super.value = '']) : super.pure();
  const RegisterRequestMinOrderAmountField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestMinOrderAmountFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestMinOrderAmountFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestDishPriceForTwoField extends FormzInput<String, RegisterRequestDishPriceForTwoFieldValidationError> {
  const RegisterRequestDishPriceForTwoField.pure([super.value = '']) : super.pure();
  const RegisterRequestDishPriceForTwoField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestDishPriceForTwoFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestDishPriceForTwoFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestFoodLicenseField extends FormzInput<String, RegisterRequestFoodLicenseFieldValidationError> {
  const RegisterRequestFoodLicenseField.pure([super.value = '']) : super.pure();
  const RegisterRequestFoodLicenseField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestFoodLicenseFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestFoodLicenseFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestDeliveryTimeField extends FormzInput<String, RegisterRequestDeliveryTimeFieldValidationError> {
  const RegisterRequestDeliveryTimeField.pure([super.value = '']) : super.pure();
  const RegisterRequestDeliveryTimeField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestDeliveryTimeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestDeliveryTimeFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestEmailField extends FormzInput<String, RegisterRequestEmailFieldValidationError> {
  const RegisterRequestEmailField.pure([super.value = '']) : super.pure();

  const RegisterRequestEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

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

class RegisterRequestCoverField extends FormzInput<String, RegisterRequestCoverFieldValidationError> {
  const RegisterRequestCoverField.pure([super.value = '']) : super.pure();
  const RegisterRequestCoverField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestCoverFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestCoverFieldValidationError.empty;
    return null;
  }
}

class RegisterRequestLogoField extends FormzInput<String, RegisterRequestLogoFieldValidationError> {
  const RegisterRequestLogoField.pure([super.value = '']) : super.pure();
  const RegisterRequestLogoField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterRequestLogoFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterRequestLogoFieldValidationError.empty;
    return null;
  }
}
