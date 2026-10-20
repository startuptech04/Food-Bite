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

part of 'wallet_bloc.dart';

sealed class WalletEvent {}

final class WalletInitalEvent extends WalletEvent {}

final class WalletToggleTransactionEvent extends WalletEvent {
  final String transaction;
  WalletToggleTransactionEvent({required this.transaction});
}

final class WalletScrollMoreTransactionEvent extends WalletEvent {}
