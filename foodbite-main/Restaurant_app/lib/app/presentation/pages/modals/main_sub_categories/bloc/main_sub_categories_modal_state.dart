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

part of 'main_sub_categories_modal_bloc.dart';

enum MainSubCategoriesModalStatus { loading, success, failure, selected }

extension MainSubCategoriesModalStatusX on MainSubCategoriesModalStatus {
  bool get isLoading => this == MainSubCategoriesModalStatus.loading;
  bool get isSuccess => this == MainSubCategoriesModalStatus.success;
  bool get isFailure => this == MainSubCategoriesModalStatus.failure;
  bool get isSelected => this == MainSubCategoriesModalStatus.selected;
}

final class MainSubCategoriesModalState {
  final List<MainSubCategoriesListModel> categories;
  final String selectedCategories;
  final MainSubCategoriesListModel info;
  final MainSubCategoriesModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const MainSubCategoriesModalState({
    this.categories = const [],
    this.selectedCategories = '',
    required this.info,
    this.status = MainSubCategoriesModalStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  MainSubCategoriesModalState copyWith({
    List<MainSubCategoriesListModel>? categories,
    String? selectedCategories,
    MainSubCategoriesListModel? info,
    MainSubCategoriesModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return MainSubCategoriesModalState(
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      info: info ?? this.info,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
