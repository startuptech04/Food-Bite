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

part of 'add_expense_modal_bloc.dart';

sealed class AddExpenseModalEvent {}

final class AddExpenseModalInitialEvent extends AddExpenseModalEvent {}

final class AddExpenseModalAmountChangedEvent extends AddExpenseModalEvent {
  final String amount;
  AddExpenseModalAmountChangedEvent({required this.amount});
}

final class AddExpenseModalAmountUnfocusedEvent extends AddExpenseModalEvent {}

final class AddExpenseModalSubmitEvent extends AddExpenseModalEvent {}
