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

part of 'sub_categories_action_bloc.dart';

final class SubCategoriesActionState {
  final CustomSubCategoryNameField name;
  final CustomSubCategoryCateIdField category;
  final String categoryName;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SubCategoriesActionState({
    this.name = const CustomSubCategoryNameField.pure(),
    this.category = const CustomSubCategoryCateIdField.pure(),
    this.categoryName = '',
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  SubCategoriesActionState copyWith({
    CustomSubCategoryNameField? name,
    CustomSubCategoryCateIdField? category,
    String? categoryName,
    bool? isValid,
    FormzSubmissionStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return SubCategoriesActionState(
      name: name ?? this.name,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
