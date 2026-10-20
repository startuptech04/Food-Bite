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

enum OrderCouponNameFieldValidationError { empty }

enum OrderCouponCodeFieldValidationError { empty }

enum OrderCouponLimitFieldValidationError { empty }

enum OrderCouponStartDateFieldValidationError { empty }

enum OrderCouponExpireDateFieldValidationError { empty }

enum OrderCouponMinDiscountFieldValidationError { empty }

enum OrderCouponMaxDiscountFieldValidationError { empty }

enum OrderCouponMinCartFieldValidationError { empty }

class OrderCouponNameField extends FormzInput<String, OrderCouponNameFieldValidationError> {
  const OrderCouponNameField.pure([super.value = '']) : super.pure();
  const OrderCouponNameField.dirty([super.value = '']) : super.dirty();

  @override
  OrderCouponNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return OrderCouponNameFieldValidationError.empty;
    return null;
  }
}

class OrderCouponCodeField extends FormzInput<String, OrderCouponCodeFieldValidationError> {
  const OrderCouponCodeField.pure([super.value = '']) : super.pure();
  const OrderCouponCodeField.dirty([super.value = '']) : super.dirty();

  @override
  OrderCouponCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return OrderCouponCodeFieldValidationError.empty;
    return null;
  }
}

class OrderCouponLimitField extends FormzInput<String, OrderCouponLimitFieldValidationError> {
  const OrderCouponLimitField.pure([super.value = '']) : super.pure();
  const OrderCouponLimitField.dirty([super.value = '']) : super.dirty();

  @override
  OrderCouponLimitFieldValidationError? validator(String value) {
    if (value.isEmpty) return OrderCouponLimitFieldValidationError.empty;
    return null;
  }
}

class OrderCouponStartDateField extends FormzInput<String, OrderCouponStartDateFieldValidationError> {
  const OrderCouponStartDateField.pure([super.value = '']) : super.pure();
  const OrderCouponStartDateField.dirty([super.value = '']) : super.dirty();

  @override
  OrderCouponStartDateFieldValidationError? validator(String value) {
    if (value.isEmpty) return OrderCouponStartDateFieldValidationError.empty;
    return null;
  }
}

class OrderCouponExpireDateField extends FormzInput<String, OrderCouponExpireDateFieldValidationError> {
  const OrderCouponExpireDateField.pure([super.value = '']) : super.pure();
  const OrderCouponExpireDateField.dirty([super.value = '']) : super.dirty();

  @override
  OrderCouponExpireDateFieldValidationError? validator(String value) {
    if (value.isEmpty) return OrderCouponExpireDateFieldValidationError.empty;
    return null;
  }
}

class OrderCouponMinDiscountField extends FormzInput<String, OrderCouponMinDiscountFieldValidationError> {
  const OrderCouponMinDiscountField.pure([super.value = '']) : super.pure();
  const OrderCouponMinDiscountField.dirty([super.value = '']) : super.dirty();

  @override
  OrderCouponMinDiscountFieldValidationError? validator(String value) {
    if (value.isEmpty) return OrderCouponMinDiscountFieldValidationError.empty;
    return null;
  }
}

class OrderCouponMaxDiscountField extends FormzInput<String, OrderCouponMaxDiscountFieldValidationError> {
  const OrderCouponMaxDiscountField.pure([super.value = '']) : super.pure();
  const OrderCouponMaxDiscountField.dirty([super.value = '']) : super.dirty();

  @override
  OrderCouponMaxDiscountFieldValidationError? validator(String value) {
    if (value.isEmpty) return OrderCouponMaxDiscountFieldValidationError.empty;
    return null;
  }
}

class OrderCouponMinCartField extends FormzInput<String, OrderCouponMinCartFieldValidationError> {
  const OrderCouponMinCartField.pure([super.value = '']) : super.pure();
  const OrderCouponMinCartField.dirty([super.value = '']) : super.dirty();

  @override
  OrderCouponMinCartFieldValidationError? validator(String value) {
    if (value.isEmpty) return OrderCouponMinCartFieldValidationError.empty;
    return null;
  }
}
