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

part of 'sub_categories_bloc.dart';

sealed class SubCategoriesEvent {}

final class SubCategoriesInitialEvent extends SubCategoriesEvent {}

final class SubCategoriesChangeStatusEvent extends SubCategoriesEvent {
  final bool status;
  final CustomSubCategoryResultModel model;
  SubCategoriesChangeStatusEvent({required this.status, required this.model});
}

final class SubCategoriesDeleteEvent extends SubCategoriesEvent {
  final String id;
  SubCategoriesDeleteEvent({required this.id});
}

final class MainSubCategoriesLoadMoreEvent extends SubCategoriesEvent {}

final class CustomSubCategoriesLoadMoreEvent extends SubCategoriesEvent {}
