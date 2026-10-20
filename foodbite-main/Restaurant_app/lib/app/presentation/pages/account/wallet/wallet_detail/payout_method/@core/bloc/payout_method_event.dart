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

part of 'payout_method_bloc.dart';

sealed class PayoutMethodEvent {}

final class PayoutMethodInitialEvent extends PayoutMethodEvent {}

final class PayoutMethodLoadMoreEvent extends PayoutMethodEvent {}

final class PayoutMethodDeleteEvent extends PayoutMethodEvent {
  final int index;
  PayoutMethodDeleteEvent({required this.index});
}

final class PayoutMethodChangeDefaultMethodEvent extends PayoutMethodEvent {
  final int index;
  PayoutMethodChangeDefaultMethodEvent({required this.index});
}
