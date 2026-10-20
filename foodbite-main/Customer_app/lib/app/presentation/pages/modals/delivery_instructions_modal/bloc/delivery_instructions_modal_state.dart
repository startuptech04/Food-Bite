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

enum DeliveryInstructionsModalStatus { loading, success, failure, selected }

extension DeliveryInstructionsModalStatusX on DeliveryInstructionsModalStatus {
  bool get isLoading => this == DeliveryInstructionsModalStatus.loading;
  bool get isSuccess => this == DeliveryInstructionsModalStatus.success;
  bool get isFailure => this == DeliveryInstructionsModalStatus.failure;
  bool get isSelected => this == DeliveryInstructionsModalStatus.selected;
}

final class DeliveryInstructionsModalState {
  final String deliveryInstructionId;
  final String deliveryInstructionName;
  final String deliveryInstructionImage;
  final List<InstructionConfigModel> instructions;
  final String addressTitle;
  final String addressSubtitle;
  final DeliveryInstructionsModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DeliveryInstructionsModalState({
    this.deliveryInstructionId = '',
    this.deliveryInstructionName = '',
    this.deliveryInstructionImage = '',
    this.instructions = const [],
    this.addressTitle = '',
    this.addressSubtitle = '',
    this.status = DeliveryInstructionsModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DeliveryInstructionsModalState copyWith({
    String? deliveryInstructionId,
    String? deliveryInstructionName,
    String? deliveryInstructionImage,
    List<InstructionConfigModel>? instructions,
    String? addressTitle,
    String? addressSubtitle,
    DeliveryInstructionsModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DeliveryInstructionsModalState(
      deliveryInstructionId: deliveryInstructionId ?? this.deliveryInstructionId,
      deliveryInstructionName: deliveryInstructionName ?? this.deliveryInstructionName,
      deliveryInstructionImage: deliveryInstructionImage ?? this.deliveryInstructionImage,
      instructions: instructions ?? this.instructions,
      addressTitle: addressTitle ?? this.addressTitle,
      addressSubtitle: addressSubtitle ?? this.addressSubtitle,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
