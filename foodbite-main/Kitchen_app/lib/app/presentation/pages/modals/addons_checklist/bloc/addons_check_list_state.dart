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

part of 'addons_check_list_bloc.dart';

enum AddonsCheckListStatus { loading, success, failure, empty, selected }

extension AddonsCheckListStatusX on AddonsCheckListStatus {
  bool get isLoading => this == AddonsCheckListStatus.loading;
  bool get isSuccess => this == AddonsCheckListStatus.success;
  bool get isFailure => this == AddonsCheckListStatus.failure;
  bool get isEmpty => this == AddonsCheckListStatus.empty;
  bool get isSelected => this == AddonsCheckListStatus.selected;
}

final class AddonsCheckListState {
  final List<AddonsCheckListModel> addons;
  final List<String> savedAddonsId;
  final List<String> savedAddonsName;
  final AddonsCheckListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const AddonsCheckListState({
    this.addons = const [],
    required this.savedAddonsId,
    this.savedAddonsName = const [],
    this.status = AddonsCheckListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  AddonsCheckListState copyWith({List<AddonsCheckListModel>? addons, List<String>? savedAddonsId, List<String>? savedAddonsName, AddonsCheckListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return AddonsCheckListState(
      addons: addons ?? this.addons,
      savedAddonsId: savedAddonsId ?? this.savedAddonsId,
      savedAddonsName: savedAddonsName ?? this.savedAddonsName,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
