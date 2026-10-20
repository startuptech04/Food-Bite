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

part of 'search_menu_bloc.dart';

sealed class SearchMenuEvent {}

final class SearchMenuInitialEvent extends SearchMenuEvent {}

final class SearchMenuSearchEvent extends SearchMenuEvent {
  final String searchQuery;
  SearchMenuSearchEvent({required this.searchQuery});
}

final class SearchMenuExecuteQueryEvent extends SearchMenuEvent {
  final String query;
  SearchMenuExecuteQueryEvent({required this.query});
}
