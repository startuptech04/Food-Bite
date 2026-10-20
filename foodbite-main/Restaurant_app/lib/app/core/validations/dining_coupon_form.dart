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

enum DiningCouponNameFieldValidationError { empty }

enum DiningCouponCodeFieldValidationError { empty }

enum DiningCouponLimitFieldValidationError { empty }

enum DiningCouponStartDateFieldValidationError { empty }

enum DiningCouponExpireDateFieldValidationError { empty }

enum DiningCouponMinDiscountFieldValidationError { empty }

enum DiningCouponMaxDiscountFieldValidationError { empty }

enum DiningCouponPreBookingChargeFieldValidationError { empty }

class DiningCouponNameField extends FormzInput<String, DiningCouponNameFieldValidationError> {
  const DiningCouponNameField.pure([super.value = '']) : super.pure();
  const DiningCouponNameField.dirty([super.value = '']) : super.dirty();

  @override
  DiningCouponNameFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningCouponNameFieldValidationError.empty;
    return null;
  }
}

class DiningCouponCodeField extends FormzInput<String, DiningCouponCodeFieldValidationError> {
  const DiningCouponCodeField.pure([super.value = '']) : super.pure();
  const DiningCouponCodeField.dirty([super.value = '']) : super.dirty();

  @override
  DiningCouponCodeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningCouponCodeFieldValidationError.empty;
    return null;
  }
}

class DiningCouponLimitField extends FormzInput<String, DiningCouponLimitFieldValidationError> {
  const DiningCouponLimitField.pure([super.value = '']) : super.pure();
  const DiningCouponLimitField.dirty([super.value = '']) : super.dirty();

  @override
  DiningCouponLimitFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningCouponLimitFieldValidationError.empty;
    return null;
  }
}

class DiningCouponStartDateField extends FormzInput<String, DiningCouponStartDateFieldValidationError> {
  const DiningCouponStartDateField.pure([super.value = '']) : super.pure();
  const DiningCouponStartDateField.dirty([super.value = '']) : super.dirty();

  @override
  DiningCouponStartDateFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningCouponStartDateFieldValidationError.empty;
    return null;
  }
}

class DiningCouponExpireDateField extends FormzInput<String, DiningCouponExpireDateFieldValidationError> {
  const DiningCouponExpireDateField.pure([super.value = '']) : super.pure();
  const DiningCouponExpireDateField.dirty([super.value = '']) : super.dirty();

  @override
  DiningCouponExpireDateFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningCouponExpireDateFieldValidationError.empty;
    return null;
  }
}

class DiningCouponMinDiscountField extends FormzInput<String, DiningCouponMinDiscountFieldValidationError> {
  const DiningCouponMinDiscountField.pure([super.value = '']) : super.pure();
  const DiningCouponMinDiscountField.dirty([super.value = '']) : super.dirty();

  @override
  DiningCouponMinDiscountFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningCouponMinDiscountFieldValidationError.empty;
    return null;
  }
}

class DiningCouponMaxDiscountField extends FormzInput<String, DiningCouponMaxDiscountFieldValidationError> {
  const DiningCouponMaxDiscountField.pure([super.value = '']) : super.pure();
  const DiningCouponMaxDiscountField.dirty([super.value = '']) : super.dirty();

  @override
  DiningCouponMaxDiscountFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningCouponMaxDiscountFieldValidationError.empty;
    return null;
  }
}

class DiningCouponPreBookingChargeField extends FormzInput<String, DiningCouponPreBookingChargeFieldValidationError> {
  const DiningCouponPreBookingChargeField.pure([super.value = '']) : super.pure();
  const DiningCouponPreBookingChargeField.dirty([super.value = '']) : super.dirty();

  @override
  DiningCouponPreBookingChargeFieldValidationError? validator(String value) {
    if (value.isEmpty) return DiningCouponPreBookingChargeFieldValidationError.empty;
    return null;
  }
}
