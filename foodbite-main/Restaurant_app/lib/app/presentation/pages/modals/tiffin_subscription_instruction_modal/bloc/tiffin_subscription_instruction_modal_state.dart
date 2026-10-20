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

enum TiffinSubscriptionInstructionModalStatus { loading, success, failure, changeDetail }

extension TiffinSubscriptionInstructionModalStatusX on TiffinSubscriptionInstructionModalStatus {
  bool get isLoading => this == TiffinSubscriptionInstructionModalStatus.loading;
  bool get isSuccess => this == TiffinSubscriptionInstructionModalStatus.success;
  bool get isFailure => this == TiffinSubscriptionInstructionModalStatus.failure;
  bool get isChangeDetail => this == TiffinSubscriptionInstructionModalStatus.changeDetail;
}

final class TiffinSubscriptionInstructionModalState {
  final bool isValid;
  final TiffinSubscriptionInstructionNameField instructionName;
  final TiffinSubscriptionInstructionModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TiffinSubscriptionInstructionModalState({
    this.isValid = false,
    this.instructionName = const TiffinSubscriptionInstructionNameField.pure(),
    this.status = TiffinSubscriptionInstructionModalStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  TiffinSubscriptionInstructionModalState copyWith({
    bool? isNew,
    TiffinSubscriptionInstructionNameField? instructionName,
    bool? isValid,
    TiffinSubscriptionInstructionModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return TiffinSubscriptionInstructionModalState(
      isValid: isValid ?? this.isValid,
      instructionName: instructionName ?? this.instructionName,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
