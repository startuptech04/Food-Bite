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

part of 'custom_categories_modal_bloc.dart';

enum CustomCategoriesModalStatus { loading, success, failure, selected }

extension CustomCategoriesModalStatusX on CustomCategoriesModalStatus {
  bool get isLoading => this == CustomCategoriesModalStatus.loading;
  bool get isSuccess => this == CustomCategoriesModalStatus.success;
  bool get isFailure => this == CustomCategoriesModalStatus.failure;
  bool get isSelected => this == CustomCategoriesModalStatus.selected;
}

final class CustomCategoriesModalState {
  final List<VendorCategoriesLimitedInfoModel> categories;
  final String selectedCategories;
  final VendorCategoriesLimitedInfoModel info;
  final CustomCategoriesModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CustomCategoriesModalState({
    this.categories = const [],
    this.selectedCategories = '',
    required this.info,
    this.status = CustomCategoriesModalStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  CustomCategoriesModalState copyWith({
    List<VendorCategoriesLimitedInfoModel>? categories,
    String? selectedCategories,
    VendorCategoriesLimitedInfoModel? info,
    CustomCategoriesModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return CustomCategoriesModalState(
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
