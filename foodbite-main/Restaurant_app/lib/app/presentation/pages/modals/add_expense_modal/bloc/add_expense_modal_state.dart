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

enum AddExpenseModalStatus { initial, submit, submitFailed, submitSuccess }

extension AddExpenseModalStatusX on AddExpenseModalStatus {
  bool get isInitial => this == AddExpenseModalStatus.initial;
  bool get isSubmit => this == AddExpenseModalStatus.submit;
  bool get isSubmitFailed => this == AddExpenseModalStatus.submitFailed;
  bool get isSubmitSuccess => this == AddExpenseModalStatus.submitSuccess;
}

final class AddExpenseModalState {
  final ExpenseAmountField amount;
  final bool isValid;
  final AddExpenseModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AddExpenseModalState({this.amount = const ExpenseAmountField.pure(), this.isValid = false, this.status = AddExpenseModalStatus.initial, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  AddExpenseModalState copyWith({ExpenseAmountField? amount, bool? isValid, AddExpenseModalStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return AddExpenseModalState(
      amount: amount ?? this.amount,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
