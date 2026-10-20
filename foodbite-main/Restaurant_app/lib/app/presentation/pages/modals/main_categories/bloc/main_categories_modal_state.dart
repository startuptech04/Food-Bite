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

part of 'main_categories_modal_bloc.dart';

enum MainCategoriesModalStatus { loading, success, failure, selected }

extension MainCategoriesModalStatusX on MainCategoriesModalStatus {
  bool get isLoading => this == MainCategoriesModalStatus.loading;
  bool get isSuccess => this == MainCategoriesModalStatus.success;
  bool get isFailure => this == MainCategoriesModalStatus.failure;
  bool get isSelected => this == MainCategoriesModalStatus.selected;
}

final class MainCategoriesModalState {
  final List<MainCategoryListModel> categories;
  final String selectedCategories;
  final MainCategoryListModel info;
  final MainCategoriesModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const MainCategoriesModalState({
    this.categories = const [],
    this.selectedCategories = '',
    required this.info,
    this.status = MainCategoriesModalStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  MainCategoriesModalState copyWith({
    List<MainCategoryListModel>? categories,
    String? selectedCategories,
    MainCategoryListModel? info,
    MainCategoriesModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return MainCategoriesModalState(
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
