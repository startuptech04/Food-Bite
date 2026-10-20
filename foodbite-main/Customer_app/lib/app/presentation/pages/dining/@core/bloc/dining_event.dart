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

part of 'dining_bloc.dart';

sealed class DiningEvent {}

final class DiningInitialEvent extends DiningEvent {}

final class DiningLoadMoreEvent extends DiningEvent {}

final class DiningFavouriteEvent extends DiningEvent {
  final String id;
  final bool isFavourite;
  DiningFavouriteEvent({required this.id, required this.isFavourite});
}

final class DiningHideEvent extends DiningEvent {
  final String id;
  DiningHideEvent({required this.id});
}

final class DiningRemoveRestaurantFromListEvent extends DiningEvent {
  final String id;
  DiningRemoveRestaurantFromListEvent({required this.id});
}

final class DiningUndoHideActionEvent extends DiningEvent {
  final String id;
  DiningUndoHideActionEvent({required this.id});
}

final class DiningSilentHideEvent extends DiningEvent {
  final String id;
  DiningSilentHideEvent({required this.id});
}

final class DiningSilentUnHideEvent extends DiningEvent {
  final String id;
  DiningSilentUnHideEvent({required this.id});
}

final class DiningRefreshFavouriteEvent extends DiningEvent {
  final List<String> inFavList;
  DiningRefreshFavouriteEvent({required this.inFavList});
}

final class DiningPullRefreshEvent extends DiningEvent {}
