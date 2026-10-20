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

part of 'dining_guest_count_bloc.dart';

sealed class DiningGuestCountEvent {}

final class DiningGuestCountInitialEvent extends DiningGuestCountEvent {}

final class DiningGuestCountSelectEvent extends DiningGuestCountEvent {
  final int selectedNumber;
  DiningGuestCountSelectEvent({required this.selectedNumber});
}

final class DiningGuestCountSaveEvent extends DiningGuestCountEvent {}
