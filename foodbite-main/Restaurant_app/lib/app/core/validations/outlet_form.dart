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

enum OutletNameFieldValidationError { empty }

enum OutletShortDescriptionFieldValidationError { empty }

enum OutletAddressFieldValidationError { empty }

enum OutletCuisineFieldValidationError { empty }

enum OutletTypeFieldValidationError { empty }

enum OutletFacilitiesFieldValidationError { empty }

enum OutletMinOrderAmountFieldValidationError { empty }

enum OutletDishPriceForTwoFieldValidationError { empty }

enum OutletFoodLicenseFieldValidationError { empty }

enum OutletDeliveryTimeFieldValidationError { empty }

enum OutletEmailFieldValidationError { invalid }

enum OutletPasswordFieldValidationError { empty }

enum OutletFirstNameFieldValidationError { empty }

enum OutletLastNameFieldValidationError { empty }

enum OutletCountryCodeFieldValidationError { empty }

enum OutletMobileNumberFieldValidationError { empty }

enum OutletLatitudeFieldValidationError { empty }

enum OutletLongitudeFieldValidationError { empty }

enum OutletCoverFieldValidationError { empty }

enum OutletLogoFieldValidationError { empty }

class OutletNameField extends FormzInput<String, OutletNameFieldValidationError> {
  const OutletNameField.pure([super.value = '']) : super.pure();
  const OutletNameField.dirty([super.value = '']) : super.dirty();

  @override
  OutletNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletNameFieldValidationError.empty;
    return null;
  }
}

class OutletShortDescriptionField extends FormzInput<String, OutletShortDescriptionFieldValidationError> {
  const OutletShortDescriptionField.pure([super.value = '']) : super.pure();
  const OutletShortDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  OutletShortDescriptionFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletShortDescriptionFieldValidationError.empty;
    return null;
  }
}

class OutletAddressField extends FormzInput<String, OutletAddressFieldValidationError> {
  const OutletAddressField.pure([super.value = '']) : super.pure();
  const OutletAddressField.dirty([super.value = '']) : super.dirty();

  @override
  OutletAddressFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletAddressFieldValidationError.empty;
    return null;
  }
}

class OutletCuisineField extends FormzInput<String, OutletCuisineFieldValidationError> {
  const OutletCuisineField.pure([super.value = '']) : super.pure();
  const OutletCuisineField.dirty([super.value = '']) : super.dirty();

  @override
  OutletCuisineFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletCuisineFieldValidationError.empty;
    return null;
  }
}

class OutletTypeField extends FormzInput<String, OutletTypeFieldValidationError> {
  const OutletTypeField.pure([super.value = '']) : super.pure();
  const OutletTypeField.dirty([super.value = '']) : super.dirty();

  @override
  OutletTypeFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletTypeFieldValidationError.empty;
    return null;
  }
}

class OutletFacilitiesField extends FormzInput<String, OutletFacilitiesFieldValidationError> {
  const OutletFacilitiesField.pure([super.value = '']) : super.pure();
  const OutletFacilitiesField.dirty([super.value = '']) : super.dirty();

  @override
  OutletFacilitiesFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletFacilitiesFieldValidationError.empty;
    return null;
  }
}

class OutletMinOrderAmountField extends FormzInput<String, OutletMinOrderAmountFieldValidationError> {
  const OutletMinOrderAmountField.pure([super.value = '']) : super.pure();
  const OutletMinOrderAmountField.dirty([super.value = '']) : super.dirty();

  @override
  OutletMinOrderAmountFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletMinOrderAmountFieldValidationError.empty;
    return null;
  }
}

class OutletDishPriceForTwoField extends FormzInput<String, OutletDishPriceForTwoFieldValidationError> {
  const OutletDishPriceForTwoField.pure([super.value = '']) : super.pure();
  const OutletDishPriceForTwoField.dirty([super.value = '']) : super.dirty();

  @override
  OutletDishPriceForTwoFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletDishPriceForTwoFieldValidationError.empty;
    return null;
  }
}

class OutletFoodLicenseField extends FormzInput<String, OutletFoodLicenseFieldValidationError> {
  const OutletFoodLicenseField.pure([super.value = '']) : super.pure();
  const OutletFoodLicenseField.dirty([super.value = '']) : super.dirty();

  @override
  OutletFoodLicenseFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletFoodLicenseFieldValidationError.empty;
    return null;
  }
}

class OutletDeliveryTimeField extends FormzInput<String, OutletDeliveryTimeFieldValidationError> {
  const OutletDeliveryTimeField.pure([super.value = '']) : super.pure();
  const OutletDeliveryTimeField.dirty([super.value = '']) : super.dirty();

  @override
  OutletDeliveryTimeFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletDeliveryTimeFieldValidationError.empty;
    return null;
  }
}

class OutletEmailField extends FormzInput<String, OutletEmailFieldValidationError> {
  const OutletEmailField.pure([super.value = '']) : super.pure();

  const OutletEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  OutletEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : OutletEmailFieldValidationError.invalid;
  }
}

class OutletPasswordField extends FormzInput<String, OutletPasswordFieldValidationError> {
  const OutletPasswordField.pure([super.value = '']) : super.pure();
  const OutletPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  OutletPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletPasswordFieldValidationError.empty;
    return null;
  }
}

class OutletFirstNameField extends FormzInput<String, OutletFirstNameFieldValidationError> {
  const OutletFirstNameField.pure([super.value = '']) : super.pure();
  const OutletFirstNameField.dirty([super.value = '']) : super.dirty();

  @override
  OutletFirstNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletFirstNameFieldValidationError.empty;
    return null;
  }
}

class OutletLastNameField extends FormzInput<String, OutletLastNameFieldValidationError> {
  const OutletLastNameField.pure([super.value = '']) : super.pure();
  const OutletLastNameField.dirty([super.value = '']) : super.dirty();

  @override
  OutletLastNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletLastNameFieldValidationError.empty;
    return null;
  }
}

class OutletCountryCodeField extends FormzInput<String, OutletCountryCodeFieldValidationError> {
  const OutletCountryCodeField.pure([super.value = '']) : super.pure();
  const OutletCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  OutletCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletCountryCodeFieldValidationError.empty;
    return null;
  }
}

class OutletMobileNumberField extends FormzInput<String, OutletMobileNumberFieldValidationError> {
  const OutletMobileNumberField.pure([super.value = '']) : super.pure();
  const OutletMobileNumberField.dirty([super.value = '']) : super.dirty();

  @override
  OutletMobileNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletMobileNumberFieldValidationError.empty;
    return null;
  }
}

class OutletLatitudeField extends FormzInput<String, OutletLatitudeFieldValidationError> {
  const OutletLatitudeField.pure([super.value = '']) : super.pure();
  const OutletLatitudeField.dirty([super.value = '']) : super.dirty();

  @override
  OutletLatitudeFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletLatitudeFieldValidationError.empty;
    return null;
  }
}

class OutletLongitudeField extends FormzInput<String, OutletLongitudeFieldValidationError> {
  const OutletLongitudeField.pure([super.value = '']) : super.pure();
  const OutletLongitudeField.dirty([super.value = '']) : super.dirty();

  @override
  OutletLongitudeFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletLongitudeFieldValidationError.empty;
    return null;
  }
}

class OutletCoverField extends FormzInput<String, OutletCoverFieldValidationError> {
  const OutletCoverField.pure([super.value = '']) : super.pure();
  const OutletCoverField.dirty([super.value = '']) : super.dirty();

  @override
  OutletCoverFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletCoverFieldValidationError.empty;
    return null;
  }
}

class OutletLogoField extends FormzInput<String, OutletLogoFieldValidationError> {
  const OutletLogoField.pure([super.value = '']) : super.pure();
  const OutletLogoField.dirty([super.value = '']) : super.dirty();

  @override
  OutletLogoFieldValidationError? validator(String value) {
    if (value.isEmpty) return OutletLogoFieldValidationError.empty;
    return null;
  }
}
