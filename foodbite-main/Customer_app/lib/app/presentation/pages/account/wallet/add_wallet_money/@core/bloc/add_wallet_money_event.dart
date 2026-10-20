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

part of 'add_wallet_money_bloc.dart';

sealed class AddWalletMoneyEvent {}

final class AddWalletMoneyInitialEvent extends AddWalletMoneyEvent {}

final class AddWalletMoneyAmountChanged extends AddWalletMoneyEvent {
  final String amount;
  AddWalletMoneyAmountChanged({required this.amount});
}

final class AddWalletMoneyAmountUnfocused extends AddWalletMoneyEvent {}

final class AddWalletMoneyPaymentChangedEvent extends AddWalletMoneyEvent {
  final String id;
  AddWalletMoneyPaymentChangedEvent({required this.id});
}

final class AddWalletMoneyIncrementEvent extends AddWalletMoneyEvent {
  final String amount;
  AddWalletMoneyIncrementEvent({required this.amount});
}

final class AddWalletMoneySubmitEvent extends AddWalletMoneyEvent {}
