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

enum RestaurantEditNameFieldValidationError { empty }

enum RestaurantEditShortDescriptionFieldValidationError { empty }

enum RestaurantEditAddressFieldValidationError { empty }

enum RestaurantEditCuisineFieldValidationError { empty }

enum RestaurantEditTypeFieldValidationError { empty }

enum RestaurantEditFacilitiesFieldValidationError { empty }

enum RestaurantEditMinOrderAmountFieldValidationError { empty }

enum RestaurantEditDishPriceForTwoFieldValidationError { empty }

enum RestaurantEditFoodLicenseFieldValidationError { empty }

enum RestaurantEditDeliveryTimeFieldValidationError { empty }

class RestaurantEditNameField extends FormzInput<String, RestaurantEditNameFieldValidationError> {
  const RestaurantEditNameField.pure([super.value = '']) : super.pure();
  const RestaurantEditNameField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditNameFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditShortDescriptionField extends FormzInput<String, RestaurantEditShortDescriptionFieldValidationError> {
  const RestaurantEditShortDescriptionField.pure([super.value = '']) : super.pure();
  const RestaurantEditShortDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditShortDescriptionFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditShortDescriptionFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditAddressField extends FormzInput<String, RestaurantEditAddressFieldValidationError> {
  const RestaurantEditAddressField.pure([super.value = '']) : super.pure();
  const RestaurantEditAddressField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditAddressFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditAddressFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditCuisineField extends FormzInput<String, RestaurantEditCuisineFieldValidationError> {
  const RestaurantEditCuisineField.pure([super.value = '']) : super.pure();
  const RestaurantEditCuisineField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditCuisineFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditCuisineFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditTypeField extends FormzInput<String, RestaurantEditTypeFieldValidationError> {
  const RestaurantEditTypeField.pure([super.value = '']) : super.pure();
  const RestaurantEditTypeField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditTypeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditTypeFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditFacilitiesField extends FormzInput<String, RestaurantEditFacilitiesFieldValidationError> {
  const RestaurantEditFacilitiesField.pure([super.value = '']) : super.pure();
  const RestaurantEditFacilitiesField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditFacilitiesFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditFacilitiesFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditMinOrderAmountField extends FormzInput<String, RestaurantEditMinOrderAmountFieldValidationError> {
  const RestaurantEditMinOrderAmountField.pure([super.value = '']) : super.pure();
  const RestaurantEditMinOrderAmountField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditMinOrderAmountFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditMinOrderAmountFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditDishPriceForTwoField extends FormzInput<String, RestaurantEditDishPriceForTwoFieldValidationError> {
  const RestaurantEditDishPriceForTwoField.pure([super.value = '']) : super.pure();
  const RestaurantEditDishPriceForTwoField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditDishPriceForTwoFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditDishPriceForTwoFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditFoodLicenseField extends FormzInput<String, RestaurantEditFoodLicenseFieldValidationError> {
  const RestaurantEditFoodLicenseField.pure([super.value = '']) : super.pure();
  const RestaurantEditFoodLicenseField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditFoodLicenseFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditFoodLicenseFieldValidationError.empty;
    return null;
  }
}

class RestaurantEditDeliveryTimeField extends FormzInput<String, RestaurantEditDeliveryTimeFieldValidationError> {
  const RestaurantEditDeliveryTimeField.pure([super.value = '']) : super.pure();
  const RestaurantEditDeliveryTimeField.dirty([super.value = '']) : super.dirty();

  @override
  RestaurantEditDeliveryTimeFieldValidationError? validator(String value) {
    if (value.isEmpty) return RestaurantEditDeliveryTimeFieldValidationError.empty;
    return null;
  }
}
