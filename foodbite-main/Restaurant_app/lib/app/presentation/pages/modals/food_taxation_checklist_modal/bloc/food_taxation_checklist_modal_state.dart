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

part of 'food_taxation_checklist_modal_bloc.dart';

enum FoodTaxationChecklistModalStatus { loading, success, failure, empty, selected }

extension FoodTaxationChecklistModalStatusX on FoodTaxationChecklistModalStatus {
  bool get isLoading => this == FoodTaxationChecklistModalStatus.loading;
  bool get isSuccess => this == FoodTaxationChecklistModalStatus.success;
  bool get isFailure => this == FoodTaxationChecklistModalStatus.failure;
  bool get isEmpty => this == FoodTaxationChecklistModalStatus.empty;
  bool get isSelected => this == FoodTaxationChecklistModalStatus.selected;
}

final class FoodTaxationChecklistModalState {
  final List<String> savedTaxId;
  final List<String> savedTaxName;
  final List<FoodTaxationCheckListModel> taxations;
  final FoodTaxationChecklistModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodTaxationChecklistModalState({
    required this.savedTaxId,
    this.savedTaxName = const [],
    this.taxations = const [],
    this.status = FoodTaxationChecklistModalStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  FoodTaxationChecklistModalState copyWith({
    List<String>? savedTaxId,
    List<String>? savedTaxName,
    List<FoodTaxationCheckListModel>? taxations,
    FoodTaxationChecklistModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return FoodTaxationChecklistModalState(
      savedTaxId: savedTaxId ?? this.savedTaxId,
      savedTaxName: savedTaxName ?? this.savedTaxName,
      taxations: taxations ?? this.taxations,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
