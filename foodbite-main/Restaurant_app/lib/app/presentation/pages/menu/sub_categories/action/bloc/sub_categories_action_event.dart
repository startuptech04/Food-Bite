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

sealed class SubCategoriesActionEvent {}

final class SubCategoriesActionInitialEvent extends SubCategoriesActionEvent {
  final bool isNew;
  final CustomSubCategoryResultModel model;
  SubCategoriesActionInitialEvent({required this.isNew, required this.model});
}

final class CustomSubCategoryActionNameChanged extends SubCategoriesActionEvent {
  final String name;

  CustomSubCategoryActionNameChanged({required this.name});
}

final class CustomSubCategoryCateIdUnfocused extends SubCategoriesActionEvent {}

final class CustomSubCategoryActionNameUnfocused extends SubCategoriesActionEvent {}

final class CustomSubCategoryActionFormCreateSubmitted extends SubCategoriesActionEvent {
  final List<CustomSubCategoryFormTranslations> translations;
  CustomSubCategoryActionFormCreateSubmitted({required this.translations});
}

final class CustomSubCategoryActionFormUpdateSubmitted extends SubCategoriesActionEvent {
  final String id;
  final CustomSubCategoryResultModel model;
  final List<CustomSubCategoryFormTranslations> translations;
  CustomSubCategoryActionFormUpdateSubmitted({required this.id, required this.model, required this.translations});
}

final class CustomSubCategoryActionCategoryModalResponseEvent extends SubCategoriesActionEvent {
  final String name;
  final String id;
  CustomSubCategoryActionCategoryModalResponseEvent({required this.name, required this.id});
}
