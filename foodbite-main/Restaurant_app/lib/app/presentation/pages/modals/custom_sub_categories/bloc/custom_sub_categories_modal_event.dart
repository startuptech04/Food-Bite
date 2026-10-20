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

sealed class CustomSubCategoriesModalEvent {}

final class CustomSubCategoriesModalInitialEvent extends CustomSubCategoriesModalEvent {
  final String cateId;
  final String selectedCategories;
  final String vendorId;
  CustomSubCategoriesModalInitialEvent({required this.cateId, required this.selectedCategories, required this.vendorId});
}

final class CustomSubCategoriesSelectEvent extends CustomSubCategoriesModalEvent {
  final VendorSubCategoriesListModel selectedCategories;
  CustomSubCategoriesSelectEvent({required this.selectedCategories});
}

final class CustomSubCategoriesOnSaveEvent extends CustomSubCategoriesModalEvent {}
