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

part of 'kitchen_credentials_list_bloc.dart';

sealed class KitchenCredentialsListEvent {}

final class KitchenCredentialsListInitialEvent extends KitchenCredentialsListEvent {}

final class KitchenCredentialsListLoadMoreEvent extends KitchenCredentialsListEvent {}

final class KitchenCredentialsListStatusChangeEvent extends KitchenCredentialsListEvent {
  final int index;
  KitchenCredentialsListStatusChangeEvent({required this.index});
}
