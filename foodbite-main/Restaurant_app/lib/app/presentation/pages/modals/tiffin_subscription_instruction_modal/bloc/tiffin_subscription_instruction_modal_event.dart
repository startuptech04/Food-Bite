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

part of 'tiffin_subscription_instruction_modal_bloc.dart';

sealed class TiffinSubscriptionInstructionModalEvent {}

final class TiffinSubscriptionInstructionInitialEvent extends TiffinSubscriptionInstructionModalEvent {
  final bool isNew;
  final String title;
  TiffinSubscriptionInstructionInitialEvent({required this.isNew, required this.title});
}

final class TiffinSubscriptionInstructionModalNameChangeEvent extends TiffinSubscriptionInstructionModalEvent {
  final String name;
  TiffinSubscriptionInstructionModalNameChangeEvent({required this.name});
}

final class TiffinSubscriptionInstructionNameModalUnfocusedEvent extends TiffinSubscriptionInstructionModalEvent {}
