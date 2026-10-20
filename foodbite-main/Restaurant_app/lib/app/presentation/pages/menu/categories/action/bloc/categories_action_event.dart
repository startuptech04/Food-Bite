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

sealed class CategoriesActionEvent {}

final class CategoriesActionInitialEvent extends CategoriesActionEvent {
  final bool isNew;
  final VendorCategoryResultModel model;
  CategoriesActionInitialEvent({required this.isNew, required this.model});
}

final class CustomCategoryActionNameChanged extends CategoriesActionEvent {
  final String name;
  CustomCategoryActionNameChanged({required this.name});
}

final class CustomCategoryActionNameUnfocused extends CategoriesActionEvent {}

final class CustomCategoryActionImageChanged extends CategoriesActionEvent {
  final String image;
  CustomCategoryActionImageChanged({required this.image});
}

final class CustomCategoryActionFormCreateSubmitted extends CategoriesActionEvent {
  final List<CustomCategoryFormTranslations> translations;
  CustomCategoryActionFormCreateSubmitted({required this.translations});
}

final class CustomCategoryActionFormUpdateSubmitted extends CategoriesActionEvent {
  final String id;
  final VendorCategoryResultModel model;
  final List<CustomCategoryFormTranslations> translations;
  CustomCategoryActionFormUpdateSubmitted({required this.id, required this.model, required this.translations});
}
