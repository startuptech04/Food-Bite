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

part of 'delivery_instructions_modal_bloc.dart';

sealed class DeliveryInstructionsModalEvent {}

final class DeliveryInstructionsModalInitialEvent extends DeliveryInstructionsModalEvent {
  final String deliveryInstructionId;
  final String deliveryInstructionList;
  final String addressTitle;
  final String addressSubtitle;
  DeliveryInstructionsModalInitialEvent({required this.deliveryInstructionId, required this.deliveryInstructionList, required this.addressTitle, required this.addressSubtitle});
}

final class DeliveryInstructionSaveEvent extends DeliveryInstructionsModalEvent {
  final String id;
  final String name;
  final String image;
  DeliveryInstructionSaveEvent({required this.id, required this.name, required this.image});
}
