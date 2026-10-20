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

part of 'dining_category_checklist_bloc.dart';

sealed class DiningCategoryChecklistEvent {}

final class DiningCategoryChecklistInitialEvent extends DiningCategoryChecklistEvent {
  final List<String> savedCategory;
  DiningCategoryChecklistInitialEvent({required this.savedCategory});
}

final class DiningCategoryChecklistSelectEvent extends DiningCategoryChecklistEvent {
  final String id;
  final String name;
  DiningCategoryChecklistSelectEvent({required this.id, required this.name});
}

final class DiningCategoryChecklistSaveEvent extends DiningCategoryChecklistEvent {}
