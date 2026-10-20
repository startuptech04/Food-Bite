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

part of 'deposite_bloc.dart';

sealed class DepositeEvent {}

final class DepositeInitialEvent extends DepositeEvent {}

final class DepositeToggleEvent extends DepositeEvent {
  final String toggle;
  DepositeToggleEvent({required this.toggle});
}

final class DepositeHistoryLoadMoreEvent extends DepositeEvent {}

final class DepositeCollectedCashLoadMoreEvent extends DepositeEvent {}
