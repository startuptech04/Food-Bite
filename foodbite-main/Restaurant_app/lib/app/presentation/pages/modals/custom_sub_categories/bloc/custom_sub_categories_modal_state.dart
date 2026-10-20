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

part of 'custom_sub_categories_modal_bloc.dart';

enum CustomSubCategoriesModalStatus { loading, success, failure, selected }

extension CustomSubCategoriesModalStatusX on CustomSubCategoriesModalStatus {
  bool get isLoading => this == CustomSubCategoriesModalStatus.loading;
  bool get isSuccess => this == CustomSubCategoriesModalStatus.success;
  bool get isFailure => this == CustomSubCategoriesModalStatus.failure;
  bool get isSelected => this == CustomSubCategoriesModalStatus.selected;
}

final class CustomSubCategoriesModalState {
  final List<VendorSubCategoriesListModel> categories;
  final String selectedCategories;
  final VendorSubCategoriesListModel info;
  final CustomSubCategoriesModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CustomSubCategoriesModalState({
    this.categories = const [],
    this.selectedCategories = '',
    required this.info,
    this.status = CustomSubCategoriesModalStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  CustomSubCategoriesModalState copyWith({
    List<VendorSubCategoriesListModel>? categories,
    String? selectedCategories,
    VendorSubCategoriesListModel? info,
    CustomSubCategoriesModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return CustomSubCategoriesModalState(
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
