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

part of 'dining_category_checklist_bloc.dart';

enum DiningCategoryChecklistStatus { loading, success, failure, empty, selected }

extension DiningCategoryChecklistStatusX on DiningCategoryChecklistStatus {
  bool get isLoading => this == DiningCategoryChecklistStatus.loading;
  bool get isSuccess => this == DiningCategoryChecklistStatus.success;
  bool get isFailure => this == DiningCategoryChecklistStatus.failure;
  bool get isEmpty => this == DiningCategoryChecklistStatus.empty;
  bool get isSelected => this == DiningCategoryChecklistStatus.selected;
}

final class DiningCategoryChecklistState {
  final List<DiningCategoryListModel> categories;
  final List<String> savedDiningCategoryId;
  final List<String> savedDiningCategoryName;
  final DiningCategoryChecklistStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningCategoryChecklistState({
    this.categories = const [],
    this.savedDiningCategoryId = const [],
    this.savedDiningCategoryName = const [],
    this.status = DiningCategoryChecklistStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DiningCategoryChecklistState copyWith({
    List<DiningCategoryListModel>? categories,
    List<String>? savedDiningCategoryId,
    List<String>? savedDiningCategoryName,
    DiningCategoryChecklistStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return DiningCategoryChecklistState(
      categories: categories ?? this.categories,
      savedDiningCategoryId: savedDiningCategoryId ?? this.savedDiningCategoryId,
      savedDiningCategoryName: savedDiningCategoryName ?? this.savedDiningCategoryName,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
