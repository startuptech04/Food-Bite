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

enum AddressReceiverNameFieldValidationError { empty }

enum AddressReceiveCountryCodeFieldValidationError { empty }

enum AddressReceiverNumberFieldValidationError { empty }

enum AddressHouseFieldValidationError { empty }

enum AddressLocalityFieldValidationError { empty }

class AddressReceiverNameField extends FormzInput<String, AddressReceiverNameFieldValidationError> {
  const AddressReceiverNameField.pure([super.value = '']) : super.pure();
  const AddressReceiverNameField.dirty([super.value = '']) : super.dirty();

  @override
  AddressReceiverNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return AddressReceiverNameFieldValidationError.empty;
    return null;
  }
}

class AddressReceiveCountryCodeField extends FormzInput<String, AddressReceiveCountryCodeFieldValidationError> {
  const AddressReceiveCountryCodeField.pure([super.value = '']) : super.pure();
  const AddressReceiveCountryCodeField.dirty([super.value = '']) : super.dirty();

  @override
  AddressReceiveCountryCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return AddressReceiveCountryCodeFieldValidationError.empty;
    return null;
  }
}

class AddressReceiverNumberField extends FormzInput<String, AddressReceiverNumberFieldValidationError> {
  const AddressReceiverNumberField.pure([super.value = '']) : super.pure();
  const AddressReceiverNumberField.dirty([super.value = '']) : super.dirty();

  @override
  AddressReceiverNumberFieldValidationError? validator(String value) {
    if (value.isEmpty) return AddressReceiverNumberFieldValidationError.empty;
    return null;
  }
}

class AddressHouseField extends FormzInput<String, AddressHouseFieldValidationError> {
  const AddressHouseField.pure([super.value = '']) : super.pure();
  const AddressHouseField.dirty([super.value = '']) : super.dirty();

  @override
  AddressHouseFieldValidationError? validator(String value) {
    if (value.isEmpty) return AddressHouseFieldValidationError.empty;
    return null;
  }
}

class AddressLocalityField extends FormzInput<String, AddressLocalityFieldValidationError> {
  const AddressLocalityField.pure([super.value = '']) : super.pure();
  const AddressLocalityField.dirty([super.value = '']) : super.dirty();

  @override
  AddressLocalityFieldValidationError? validator(String value) {
    if (value.isEmpty) return AddressLocalityFieldValidationError.empty;
    return null;
  }
}
