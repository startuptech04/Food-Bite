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

sealed class MainCategoriesModalEvent {}

final class MainCategoriesModalInitialEvent extends MainCategoriesModalEvent {
  final String selectedCategories;
  MainCategoriesModalInitialEvent({required this.selectedCategories});
}

final class MainCategoriesSelectEvent extends MainCategoriesModalEvent {
  final MainCategoryListModel selectedCategories;
  MainCategoriesSelectEvent({required this.selectedCategories});
}

final class MainCategoriesOnSaveEvent extends MainCategoriesModalEvent {}
