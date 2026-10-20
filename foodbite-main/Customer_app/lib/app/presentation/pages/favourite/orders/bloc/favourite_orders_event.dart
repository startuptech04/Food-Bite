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

part of 'favourite_orders_bloc.dart';

sealed class FavouriteOrdersEvent {}

final class FavouriteOrdersInitialEvent extends FavouriteOrdersEvent {}

final class FavouriteOrdersPullRefreshEvent extends FavouriteOrdersEvent {}

final class FavouriteOrdersLoadMoreOrderEvent extends FavouriteOrdersEvent {}

final class FavouriteOrdersSilenceEvent extends FavouriteOrdersEvent {}
