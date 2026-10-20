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

part of 'dialog_tiffin_subscription_bloc.dart';

sealed class DialogTiffinSubscriptionEvent {}

final class DialogTiffinSubscriptionInitialEvent extends DialogTiffinSubscriptionEvent {
  final bool isNew;
  final TiffinSubcriptionPackageConfigModel model;
  DialogTiffinSubscriptionInitialEvent({required this.isNew, required this.model});
}

final class DialogTiffinSubscriptionCoverChangeEvent extends DialogTiffinSubscriptionEvent {
  final String image;
  DialogTiffinSubscriptionCoverChangeEvent({required this.image});
}

final class DialogTiffinSubscriptionNameChangeEvent extends DialogTiffinSubscriptionEvent {
  final String name;
  DialogTiffinSubscriptionNameChangeEvent({required this.name});
}

final class DialogTiffinSubscriptionNameUnfocusedEvent extends DialogTiffinSubscriptionEvent {}

final class DialogTiffinSubscriptionShortDescriptionChangeEvent extends DialogTiffinSubscriptionEvent {
  final String shortDescription;
  DialogTiffinSubscriptionShortDescriptionChangeEvent({required this.shortDescription});
}

final class DialogTiffinSubscriptionShortDescriptionUnfocusedEvent extends DialogTiffinSubscriptionEvent {}

final class DialogTiffinSubscriptionFoodsChangeEvent extends DialogTiffinSubscriptionEvent {
  final TiffinSubscriptionFoodModalResponseModel foods;
  DialogTiffinSubscriptionFoodsChangeEvent({required this.foods});
}

final class DialogTiffinSubscriptionFoodsUnfocusedEvent extends DialogTiffinSubscriptionEvent {}

final class DialogTiffinSubscriptionDeliveryAreaChangeEvent extends DialogTiffinSubscriptionEvent {
  final String deliveryArea;
  DialogTiffinSubscriptionDeliveryAreaChangeEvent({required this.deliveryArea});
}

final class DialogTiffinSubscriptionDeliveryAreaUnfocusedEvent extends DialogTiffinSubscriptionEvent {}

final class DialogTiffinSubscriptionPriceChangeEvent extends DialogTiffinSubscriptionEvent {
  final String price;
  DialogTiffinSubscriptionPriceChangeEvent({required this.price});
}

final class DialogTiffinSubscriptionPriceUnfocusedEvent extends DialogTiffinSubscriptionEvent {}

final class DialogTiffinSubscriptionDiscountChangeEvent extends DialogTiffinSubscriptionEvent {
  final String discount;
  DialogTiffinSubscriptionDiscountChangeEvent({required this.discount});
}

final class DialogTiffinSubscriptionDiscountUnfocusedEvent extends DialogTiffinSubscriptionEvent {}

final class DialogTiffinSubscriptionDiscountTypeChangeEvent extends DialogTiffinSubscriptionEvent {
  final DiscountModel type;
  DialogTiffinSubscriptionDiscountTypeChangeEvent({required this.type});
}

final class DialogTiffinSubscriptionAvailabilityChangeEvent extends DialogTiffinSubscriptionEvent {
  final AvailabilityValidationModel availability;
  DialogTiffinSubscriptionAvailabilityChangeEvent({required this.availability});
}

final class DialogTiffinSubscriptionOrderNumberEvent extends DialogTiffinSubscriptionEvent {
  final OrderValidationModel orderNumber;
  DialogTiffinSubscriptionOrderNumberEvent({required this.orderNumber});
}

final class DialogTiffinSubscriptionAddonSelectEvent extends DialogTiffinSubscriptionEvent {
  final AddonValidationModel addon;
  DialogTiffinSubscriptionAddonSelectEvent({required this.addon});
}

final class DialogTiffinSubscriptionVariationSelectEvent extends DialogTiffinSubscriptionEvent {
  final VariationValidationModel variation;
  DialogTiffinSubscriptionVariationSelectEvent({required this.variation});
}

final class DialogTiffinSubscriptionDeliveryChangeEvent extends DialogTiffinSubscriptionEvent {
  final DeliveryValidationModel delivery;
  DialogTiffinSubscriptionDeliveryChangeEvent({required this.delivery});
}

final class DialogTiffinSubscriptionTimeSlotEvent extends DialogTiffinSubscriptionEvent {
  final TiffinSubscriptionTimeSlotModalResponseModel timeslot;
  DialogTiffinSubscriptionTimeSlotEvent({required this.timeslot});
}

final class DialogTiffinSubscriptionEditSlotEvent extends DialogTiffinSubscriptionEvent {
  final int index;
  final TiffinSubscriptionTimeSlotModalResponseModel timeslot;
  DialogTiffinSubscriptionEditSlotEvent({required this.index, required this.timeslot});
}

final class DialogTiffinSubscriptionDeleteSlotEvent extends DialogTiffinSubscriptionEvent {
  final int index;
  DialogTiffinSubscriptionDeleteSlotEvent({required this.index});
}

final class DialogTiffinSubscriptionInstructionAddEvent extends DialogTiffinSubscriptionEvent {
  final TiffinSubscriptionInstructionModel instruction;
  DialogTiffinSubscriptionInstructionAddEvent({required this.instruction});
}

final class DialogTiffinSubscriptionDeleteInstructionEvent extends DialogTiffinSubscriptionEvent {
  final int index;
  DialogTiffinSubscriptionDeleteInstructionEvent({required this.index});
}

final class DialogTiffinSubscriptionEditInstructionEvent extends DialogTiffinSubscriptionEvent {
  final int index;
  final TiffinSubscriptionInstructionModel instruction;
  DialogTiffinSubscriptionEditInstructionEvent({required this.index, required this.instruction});
}

final class DialogTiffinSubscriptionOffDayEvent extends DialogTiffinSubscriptionEvent {
  final TiffinSubscriptionOffDayModalResponseModel offdays;
  DialogTiffinSubscriptionOffDayEvent({required this.offdays});
}

final class DialogTiffinSubscriptionSubmitEvent extends DialogTiffinSubscriptionEvent {
  List<TiffinSubscriptionFormTransation> translations;
  DialogTiffinSubscriptionSubmitEvent({required this.translations});
}
