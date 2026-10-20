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

part of 'search_bloc.dart';

sealed class SearchEvent {}

final class SearchInitialEvent extends SearchEvent {}

final class SearchFindResultEvent extends SearchEvent {
  final String searchQuery;
  SearchFindResultEvent({required this.searchQuery});
}

final class SearchSaveHistoryEvent extends SearchEvent {
  final String type;
  final int index;
  SearchSaveHistoryEvent({required this.type, required this.index});
}

final class SearchOnLocalSearchHistoryTapEvent extends SearchEvent {
  final int index;
  SearchOnLocalSearchHistoryTapEvent({required this.index});
}

final class SearchOnLocalSearchHistoryDeleteEvent extends SearchEvent {
  final int index;
  SearchOnLocalSearchHistoryDeleteEvent({required this.index});
}

final class SearchExecuteQueryEvent extends SearchEvent {
  final String query;
  SearchExecuteQueryEvent({required this.query});
}
