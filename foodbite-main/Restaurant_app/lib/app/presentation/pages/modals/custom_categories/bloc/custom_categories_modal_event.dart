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

sealed class CustomCategoriesModalEvent {}

final class CustomCategoriesModalInitialEvent extends CustomCategoriesModalEvent {
  final String selectedCategories;
  CustomCategoriesModalInitialEvent({required this.selectedCategories});
}

final class CustomCategoriesSelectEvent extends CustomCategoriesModalEvent {
  final VendorCategoriesLimitedInfoModel selectedCategories;
  CustomCategoriesSelectEvent({required this.selectedCategories});
}

final class CustomCategoriesOnSaveEvent extends CustomCategoriesModalEvent {}
