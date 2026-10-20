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

part of 'dialog_dining_coupon_bloc.dart';

sealed class DialogDiningCouponEvent {}

final class DialogDiningCouponInitialEvent extends DialogDiningCouponEvent {
  final bool isNew;
  final DiningCouponInfoConfigModel model;
  DialogDiningCouponInitialEvent({required this.isNew, required this.model});
}

final class DialogDiningCouponNameChangedEvent extends DialogDiningCouponEvent {
  final String name;
  DialogDiningCouponNameChangedEvent({required this.name});
}

final class DialogDiningCouponNameUnfocusedEvent extends DialogDiningCouponEvent {}

final class DialogDiningCouponCodeChangedEvent extends DialogDiningCouponEvent {
  final String code;
  DialogDiningCouponCodeChangedEvent({required this.code});
}

final class DialogDiningCouponCodeUnfocusedEvent extends DialogDiningCouponEvent {}

final class DialogDiningCouponLimitChangedEvent extends DialogDiningCouponEvent {
  final String limit;
  DialogDiningCouponLimitChangedEvent({required this.limit});
}

final class DialogDiningCouponLimitUnfocusedEvent extends DialogDiningCouponEvent {}

final class DialogDiningCouponStartDateChangedEvent extends DialogDiningCouponEvent {
  final String startDate;
  DialogDiningCouponStartDateChangedEvent({required this.startDate});
}

final class DialogDiningCouponStartDateUnfocusedEvent extends DialogDiningCouponEvent {}

final class DialogDiningCouponExpireDateChangedEvent extends DialogDiningCouponEvent {
  final String expireDate;
  DialogDiningCouponExpireDateChangedEvent({required this.expireDate});
}

final class DialogDiningCouponExpireDateUnfocusedEvent extends DialogDiningCouponEvent {}

final class DialogDiningTypeChangeEvent extends DialogDiningCouponEvent {
  final DiningCouponTypeModel type;
  DialogDiningTypeChangeEvent({required this.type});
}

final class DialogDiningCouponMinDiscountChangedEvent extends DialogDiningCouponEvent {
  final String minDiscount;
  DialogDiningCouponMinDiscountChangedEvent({required this.minDiscount});
}

final class DialogDiningCouponMinDiscountUnfocusedEvent extends DialogDiningCouponEvent {}

final class DialogDiningCouponMaxDiscountChangedEvent extends DialogDiningCouponEvent {
  final String maxDiscount;
  DialogDiningCouponMaxDiscountChangedEvent({required this.maxDiscount});
}

final class DialogDiningCouponMaxDiscountUnfocusedEvent extends DialogDiningCouponEvent {}

final class DialogDiningCouponAvailabilityChangeEvent extends DialogDiningCouponEvent {
  final DiningCouponAvailabilityModel availability;
  DialogDiningCouponAvailabilityChangeEvent({required this.availability});
}

final class DialogDiningCouponPreBookingChargeChangedEvent extends DialogDiningCouponEvent {
  final String preBookingCharge;
  DialogDiningCouponPreBookingChargeChangedEvent({required this.preBookingCharge});
}

final class DialogDiningCouponPreBookingChargeChangeEvent extends DialogDiningCouponEvent {
  final DiningCouponPreBookingModel preBooking;
  DialogDiningCouponPreBookingChargeChangeEvent({required this.preBooking});
}

final class DialogDiningCouponPreBookingChargeUnfocusedEvent extends DialogDiningCouponEvent {}

final class DialogDiningCouponSubmitEvent extends DialogDiningCouponEvent {
  List<DiningCouponFormTranslations> translations;
  DialogDiningCouponSubmitEvent({required this.translations});
}
