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

sealed class MainSubCategoriesModalEvent {}

final class MainSubCategoriesModalInitialEvent extends MainSubCategoriesModalEvent {
  final String cateId;
  final String selectedCategories;
  MainSubCategoriesModalInitialEvent({required this.cateId, required this.selectedCategories});
}

final class MainSubCategoriesSelectEvent extends MainSubCategoriesModalEvent {
  final MainSubCategoriesListModel selectedCategories;
  MainSubCategoriesSelectEvent({required this.selectedCategories});
}

final class MainSubCategoriesOnSaveEvent extends MainSubCategoriesModalEvent {}
