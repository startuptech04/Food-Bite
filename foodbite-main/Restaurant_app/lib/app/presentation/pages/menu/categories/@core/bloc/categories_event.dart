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

part of 'categories_bloc.dart';

sealed class CategoriesEvent {}

final class CategoriesInitialEvent extends CategoriesEvent {}

final class CategoriesChangeStatusEvent extends CategoriesEvent {
  final String id;
  final bool status;
  final VendorCategoryResultModel model;
  CategoriesChangeStatusEvent({required this.id, required this.status, required this.model});
}

final class CategoriesDeleteEvent extends CategoriesEvent {
  final String id;
  CategoriesDeleteEvent({required this.id});
}

final class MainCategoriesLoadMoreEvent extends CategoriesEvent {}

final class CustomCategoriesLoadMoreEvent extends CategoriesEvent {}
