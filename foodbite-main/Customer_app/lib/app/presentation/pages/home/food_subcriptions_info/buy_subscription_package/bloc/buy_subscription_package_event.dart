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

part of 'buy_subscription_package_bloc.dart';

sealed class BuySubscriptionPackageEvent {}

final class BuySubscriptionPackageInitialEvent extends BuySubscriptionPackageEvent {
  final String id;
  BuySubscriptionPackageInitialEvent({required this.id});
}

final class BuySubscriptionPackageSlotSelectEvent extends BuySubscriptionPackageEvent {
  final String slot;
  BuySubscriptionPackageSlotSelectEvent({required this.slot});
}

final class BuySubscriptionPackagePaymentChangeEvent extends BuySubscriptionPackageEvent {
  final String id;
  BuySubscriptionPackagePaymentChangeEvent({required this.id});
}

final class BuySubscriptionPackageDeliveryAddressChangeEvent extends BuySubscriptionPackageEvent {
  final DeliveryAddressModalResponseModel selected;
  BuySubscriptionPackageDeliveryAddressChangeEvent({required this.selected});
}

final class BuySubscriptionPackageInstructionsEvent extends BuySubscriptionPackageEvent {
  final String instructions;
  BuySubscriptionPackageInstructionsEvent({required this.instructions});
}

final class BuySubscriptionPackageDeliveryInstructionClearEvent extends BuySubscriptionPackageEvent {}

final class BuySubscriptionPackageDeliveryInstructionChangeEvent extends BuySubscriptionPackageEvent {
  final DeliveryInstructionModalResponseModel data;
  BuySubscriptionPackageDeliveryInstructionChangeEvent({required this.data});
}

final class BuySubscriptionPackageReceiverChangeEvent extends BuySubscriptionPackageEvent {
  final String name;
  final String countryCode;
  final String phoneNumber;
  BuySubscriptionPackageReceiverChangeEvent({required this.name, required this.countryCode, required this.phoneNumber});
}

final class BuySubscriptionPackageFoodModalResponseEvent extends BuySubscriptionPackageEvent {
  final String id;
  final FoodInfoModalResponseModel response;
  BuySubscriptionPackageFoodModalResponseEvent({required this.id, required this.response});
}

final class BuySubscriptionPackageCreateOrderEvent extends BuySubscriptionPackageEvent {}
