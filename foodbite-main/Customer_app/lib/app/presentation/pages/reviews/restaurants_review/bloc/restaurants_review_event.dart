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

part of 'restaurants_review_bloc.dart';

sealed class RestaurantsReviewEvent {}

final class RestaurantsReviewInitialEvent extends RestaurantsReviewEvent {
  final String id;
  final String name;
  final String ratings;
  RestaurantsReviewInitialEvent({required this.id, required this.name, required this.ratings});
}

final class RestaurantsReviewLoadMoreEvent extends RestaurantsReviewEvent {}
