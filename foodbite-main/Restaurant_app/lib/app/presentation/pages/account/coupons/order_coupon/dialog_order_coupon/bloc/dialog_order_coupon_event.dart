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

part of 'dialog_order_coupon_bloc.dart';

sealed class DialogOrderCouponEvent {}

final class DialogOrderCouponInitialEvent extends DialogOrderCouponEvent {
  final bool isNew;
  final CouponsConfigModel model;
  DialogOrderCouponInitialEvent({required this.isNew, required this.model});
}

final class DialogOrderCouponNameChangedEvent extends DialogOrderCouponEvent {
  final String name;
  DialogOrderCouponNameChangedEvent({required this.name});
}

final class DialogOrderCouponNameUnfocusedEvent extends DialogOrderCouponEvent {}

final class DialogOrderCouponCodeChangedEvent extends DialogOrderCouponEvent {
  final String code;
  DialogOrderCouponCodeChangedEvent({required this.code});
}

final class DialogOrderCouponCodeUnfocusedEvent extends DialogOrderCouponEvent {}

final class DialogOrderCouponLimitChangedEvent extends DialogOrderCouponEvent {
  final String limit;
  DialogOrderCouponLimitChangedEvent({required this.limit});
}

final class DialogOrderCouponLimitUnfocusedEvent extends DialogOrderCouponEvent {}

final class DialogOrderCouponStartDateChangedEvent extends DialogOrderCouponEvent {
  final String startDate;
  DialogOrderCouponStartDateChangedEvent({required this.startDate});
}

final class DialogOrderCouponStartDateUnfocusedEvent extends DialogOrderCouponEvent {}

final class DialogOrderCouponExpireDateChangedEvent extends DialogOrderCouponEvent {
  final String expireDate;
  DialogOrderCouponExpireDateChangedEvent({required this.expireDate});
}

final class DialogOrderCouponExpireDateUnfocusedEvent extends DialogOrderCouponEvent {}

final class DialogOrderCouponMinDiscountChangedEvent extends DialogOrderCouponEvent {
  final String minDiscount;
  DialogOrderCouponMinDiscountChangedEvent({required this.minDiscount});
}

final class DialogOrderCouponMinDiscountUnfocusedEvent extends DialogOrderCouponEvent {}

final class DialogOrderCouponMaxDiscountChangedEvent extends DialogOrderCouponEvent {
  final String maxDiscount;
  DialogOrderCouponMaxDiscountChangedEvent({required this.maxDiscount});
}

final class DialogOrderCouponMaxDiscountUnfocusedEvent extends DialogOrderCouponEvent {}

final class DialogOrderCouponMinCartChangedEvent extends DialogOrderCouponEvent {
  final String minCart;
  DialogOrderCouponMinCartChangedEvent({required this.minCart});
}

final class DialogOrderCouponMinCartUnfocusedEvent extends DialogOrderCouponEvent {}

final class DialogOrderCouponTypeEvent extends DialogOrderCouponEvent {
  final OrderCouponTypeModel type;
  DialogOrderCouponTypeEvent({required this.type});
}

final class DialogOrderCouponSubmitEvent extends DialogOrderCouponEvent {
  final List<OrderCouponFormTranslations> translations;
  DialogOrderCouponSubmitEvent({required this.translations});
}
