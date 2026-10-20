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

part of 'addons_check_list_bloc.dart';

sealed class AddonsCheckListEvent {}

final class AddonsCheckListInitialEvent extends AddonsCheckListEvent {
  final String vendorId;
  final List<String> savedAddons;
  AddonsCheckListInitialEvent({required this.vendorId, required this.savedAddons});
}

final class AddonsCheckListOnTapEvent extends AddonsCheckListEvent {
  final String id;
  final String name;
  AddonsCheckListOnTapEvent({required this.id, required this.name});
}

final class AddonsCheckListOnSaveEvent extends AddonsCheckListEvent {}
