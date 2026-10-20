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

part of 'search_restaurant_activity_section_bloc.dart';

sealed class SearchRestaurantActivitySectionEvent {}

final class SearchRestaurantActivitySectionInitialEvent extends SearchRestaurantActivitySectionEvent {}

final class SearchRestaurantActivitySectionFindResultEvent extends SearchRestaurantActivitySectionEvent {
  final String searchQuery;
  SearchRestaurantActivitySectionFindResultEvent({required this.searchQuery});
}

final class SearchRestaurantActivitySectionExecuteEvent extends SearchRestaurantActivitySectionEvent {
  final String query;
  SearchRestaurantActivitySectionExecuteEvent({required this.query});
}
