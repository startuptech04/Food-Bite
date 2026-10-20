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

enum TiffinSubscriptionCoverFieldValidationError { empty }

enum TiffinSubscriptionNameFieldValidationError { empty }

enum TiffinSubscriptionShortDescriptionFieldValidationError { empty }

enum TiffinSubscriptionFoodsFieldValidationError { empty }

enum TiffinSubscriptionDeliveryAreaFieldValidationError { empty }

enum TiffinSubscriptionPriceFieldValidationError { empty }

enum TiffinSubscriptionDiscountFieldValidationError { empty }

enum TiffinSubscriptionTotalOrdersFieldValidationError { empty }

class TiffinSubscriptionCoverField extends FormzInput<String, TiffinSubscriptionCoverFieldValidationError> {
  const TiffinSubscriptionCoverField.pure([super.value = '']) : super.pure();
  const TiffinSubscriptionCoverField.dirty([super.value = '']) : super.dirty();

  @override
  TiffinSubscriptionCoverFieldValidationError? validator(String value) {
    if (value.isEmpty) return TiffinSubscriptionCoverFieldValidationError.empty;
    return null;
  }
}

class TiffinSubscriptionNameField extends FormzInput<String, TiffinSubscriptionNameFieldValidationError> {
  const TiffinSubscriptionNameField.pure([super.value = '']) : super.pure();
  const TiffinSubscriptionNameField.dirty([super.value = '']) : super.dirty();

  @override
  TiffinSubscriptionNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return TiffinSubscriptionNameFieldValidationError.empty;
    return null;
  }
}

class TiffinSubscriptionFoodsField extends FormzInput<String, TiffinSubscriptionFoodsFieldValidationError> {
  const TiffinSubscriptionFoodsField.pure([super.value = '']) : super.pure();
  const TiffinSubscriptionFoodsField.dirty([super.value = '']) : super.dirty();

  @override
  TiffinSubscriptionFoodsFieldValidationError? validator(String value) {
    if (value.isEmpty) return TiffinSubscriptionFoodsFieldValidationError.empty;
    return null;
  }
}

class TiffinSubscriptionShortDescriptionField extends FormzInput<String, TiffinSubscriptionShortDescriptionFieldValidationError> {
  const TiffinSubscriptionShortDescriptionField.pure([super.value = '']) : super.pure();
  const TiffinSubscriptionShortDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  TiffinSubscriptionShortDescriptionFieldValidationError? validator(String value) {
    if (value.isEmpty) return TiffinSubscriptionShortDescriptionFieldValidationError.empty;
    return null;
  }
}

class TiffinSubscriptionDeliveryAreaField extends FormzInput<String, TiffinSubscriptionDeliveryAreaFieldValidationError> {
  const TiffinSubscriptionDeliveryAreaField.pure([super.value = '']) : super.pure();
  const TiffinSubscriptionDeliveryAreaField.dirty([super.value = '']) : super.dirty();

  @override
  TiffinSubscriptionDeliveryAreaFieldValidationError? validator(String value) {
    if (value.isEmpty) return TiffinSubscriptionDeliveryAreaFieldValidationError.empty;
    return null;
  }
}

class TiffinSubscriptionPriceField extends FormzInput<String, TiffinSubscriptionPriceFieldValidationError> {
  const TiffinSubscriptionPriceField.pure([super.value = '']) : super.pure();
  const TiffinSubscriptionPriceField.dirty([super.value = '']) : super.dirty();

  @override
  TiffinSubscriptionPriceFieldValidationError? validator(String value) {
    if (value.isEmpty) return TiffinSubscriptionPriceFieldValidationError.empty;
    return null;
  }
}

class TiffinSubscriptionDiscountField extends FormzInput<String, TiffinSubscriptionDiscountFieldValidationError> {
  const TiffinSubscriptionDiscountField.pure([super.value = '']) : super.pure();
  const TiffinSubscriptionDiscountField.dirty([super.value = '']) : super.dirty();

  @override
  TiffinSubscriptionDiscountFieldValidationError? validator(String value) {
    if (value.isEmpty) return TiffinSubscriptionDiscountFieldValidationError.empty;
    return null;
  }
}

class TiffinSubscriptionTotalOrdersField extends FormzInput<String, TiffinSubscriptionTotalOrdersFieldValidationError> {
  const TiffinSubscriptionTotalOrdersField.pure([super.value = '']) : super.pure();
  const TiffinSubscriptionTotalOrdersField.dirty([super.value = '']) : super.dirty();

  @override
  TiffinSubscriptionTotalOrdersFieldValidationError? validator(String value) {
    if (value.isEmpty) return TiffinSubscriptionTotalOrdersFieldValidationError.empty;
    return null;
  }
}
