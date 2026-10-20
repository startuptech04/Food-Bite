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

part of 'checkout_bloc.dart';

sealed class CheckoutEvent {}

final class CheckoutInitialEvent extends CheckoutEvent {
  final String name;
  final String restaurant;
  CheckoutInitialEvent({required this.name, required this.restaurant});
}

final class CheckoutQuantityEvent extends CheckoutEvent {
  final String id;
  final String uuid;
  final String action;
  CheckoutQuantityEvent({required this.id, required this.uuid, required this.action});
}

final class CheckoutPaymentChangedEvent extends CheckoutEvent {
  final String id;
  CheckoutPaymentChangedEvent({required this.id});
}

final class CheckoutInstructionsEvent extends CheckoutEvent {
  final String instructions;
  CheckoutInstructionsEvent({required this.instructions});
}

final class CheckoutDeliveryAddressChangeEvent extends CheckoutEvent {
  final DeliveryAddressModalResponseModel selected;
  CheckoutDeliveryAddressChangeEvent({required this.selected});
}

final class CheckoutDeliveryInstructionChangeEvent extends CheckoutEvent {
  final DeliveryInstructionModalResponseModel data;
  CheckoutDeliveryInstructionChangeEvent({required this.data});
}

final class CheckoutDeliveryInstructionClearEvent extends CheckoutEvent {}

final class CheckoutReceiverChangeEvent extends CheckoutEvent {
  final String name;
  final String countryCode;
  final String phoneNumber;
  CheckoutReceiverChangeEvent({required this.name, required this.countryCode, required this.phoneNumber});
}

final class CheckoutBillingInfoExtraChargeEvent extends CheckoutEvent {
  double deliveryTip;
  CheckoutBillingInfoExtraChargeEvent({required this.deliveryTip});
}

final class CheckoutCouponCodeResponseEvent extends CheckoutEvent {
  final CouponConfigModel coupon;
  CheckoutCouponCodeResponseEvent({required this.coupon});
}

final class CheckoutRemoveCouponEvent extends CheckoutEvent {}

final class CheckoutWalletUseEvent extends CheckoutEvent {}

final class CheckoutCouponValidationErrorEvent extends CheckoutEvent {}

final class CheckoutChangeOrderToEvent extends CheckoutEvent {
  final String orderTo;
  CheckoutChangeOrderToEvent({required this.orderTo});
}

final class CheckoutScheduleDateEvent extends CheckoutEvent {
  final DateTime date;
  CheckoutScheduleDateEvent({required this.date});
}

final class CheckoutScheduleTimeEvent extends CheckoutEvent {
  final String time;
  CheckoutScheduleTimeEvent({required this.time});
}

final class CheckoutCreateOrderEvent extends CheckoutEvent {}
