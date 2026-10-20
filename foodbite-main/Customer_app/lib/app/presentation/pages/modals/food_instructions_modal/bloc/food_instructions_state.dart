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

enum FoodInstructionsStatus { success, failure }

extension FoodInstructionsStatusX on FoodInstructionsStatus {
  bool get isSuccess => this == FoodInstructionsStatus.success;
  bool get isFailure => this == FoodInstructionsStatus.failure;
}

final class FoodInstructionsState {
  final String instructions;
  final FoodInstructionsStatus status;
  final String alertMessage;
  final String extraMessage;
  const FoodInstructionsState({this.status = FoodInstructionsStatus.success, this.instructions = '', this.alertMessage = '', this.extraMessage = ''});

  FoodInstructionsState copyWith({String? instructions, FoodInstructionsStatus? status, String? alertMessage, String? extraMessage}) {
    return FoodInstructionsState(instructions: instructions ?? this.instructions, status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
