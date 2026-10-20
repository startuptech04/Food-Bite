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

part of 'categories_action_bloc.dart';

final class CategoriesActionState {
  final CustomCategoryNameField name;
  final CustomCategoryImageField image;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CategoriesActionState({
    this.name = const CustomCategoryNameField.pure(),
    this.image = const CustomCategoryImageField.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  CategoriesActionState copyWith({CustomCategoryNameField? name, CustomCategoryImageField? image, bool? isValid, FormzSubmissionStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return CategoriesActionState(
      name: name ?? this.name,
      image: image ?? this.image,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
