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

part of 'addons_bloc.dart';

sealed class AddonsEvent {}

final class AddonsInitialEvent extends AddonsEvent {}

final class AddonsLoadMoreEvent extends AddonsEvent {}

final class AddonsDeleteEvent extends AddonsEvent {
  final String id;
  AddonsDeleteEvent({required this.id});
}

final class AddonsChangeStatusEvent extends AddonsEvent {
  final String id;
  final bool status;
  final AddonResultModel model;
  AddonsChangeStatusEvent({required this.id, required this.status, required this.model});
}

final class AddonsChangeStockEvent extends AddonsEvent {
  final String id;
  final bool inStock;
  final AddonResultModel model;
  AddonsChangeStockEvent({required this.id, required this.inStock, required this.model});
}
