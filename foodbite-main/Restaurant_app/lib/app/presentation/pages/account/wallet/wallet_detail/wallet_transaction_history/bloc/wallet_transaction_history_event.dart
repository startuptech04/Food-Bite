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

part of 'wallet_transaction_history_bloc.dart';

sealed class WalletTransactionHistoryEvent {}

final class WalletTransactionHistoryInitialEvent extends WalletTransactionHistoryEvent {}

final class WalletTransactionHistoryToggleTransactionEvent extends WalletTransactionHistoryEvent {
  final String transaction;
  WalletTransactionHistoryToggleTransactionEvent({required this.transaction});
}

final class WalletTransactionHistoryScrollMoreTransactionEvent extends WalletTransactionHistoryEvent {}
