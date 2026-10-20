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

part of 'food_instructions_bloc.dart';

sealed class FoodInstructionsEvent {}

final class FoodInstructionsInitialEvent extends FoodInstructionsEvent {
  final String instructions;
  FoodInstructionsInitialEvent({required this.instructions});
}

final class FoodInstructionsChangeEvent extends FoodInstructionsEvent {
  final String instructions;
  FoodInstructionsChangeEvent({required this.instructions});
}
