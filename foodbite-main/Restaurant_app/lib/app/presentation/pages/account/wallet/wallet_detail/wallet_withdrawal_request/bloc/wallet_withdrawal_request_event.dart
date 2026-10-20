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

part of 'wallet_withdrawal_request_bloc.dart';

sealed class WalletWithdrawalRequestEvent {}

final class WalletWithdrawalRequestInitialEvent extends WalletWithdrawalRequestEvent {}

final class WalletWithdrawalDetailMethodChangeEvent extends WalletWithdrawalRequestEvent {
  final WalletPayoutMethodConfigModel method;
  WalletWithdrawalDetailMethodChangeEvent({required this.method});
}

final class WalletWithdrawalDetailAmountChangeEvent extends WalletWithdrawalRequestEvent {
  final String amount;
  WalletWithdrawalDetailAmountChangeEvent({required this.amount});
}

final class WalletWithdrawalDetailSubmitEvent extends WalletWithdrawalRequestEvent {}
