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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:formz/formz.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/request/add_expense_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/validations/expense_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'add_expense_modal_event.dart';
part 'add_expense_modal_state.dart';

class AddExpenseModalBloc extends Bloc<AddExpenseModalEvent, AddExpenseModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  AddExpenseModalBloc() : super(AddExpenseModalState()) {
    on<AddExpenseModalInitialEvent>(_onAddExpenseModalInitialEvent);
    on<AddExpenseModalAmountChangedEvent>(_onAddExpenseModalAmountChangedEvent);
    on<AddExpenseModalAmountUnfocusedEvent>(_onAddExpenseModalAmountUnfocusedEvent);
    on<AddExpenseModalSubmitEvent>(_onAddExpenseModalSubmitEvent);
  }

  FutureOr<void> _onAddExpenseModalInitialEvent(AddExpenseModalInitialEvent event, Emitter<AddExpenseModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_expense"}, 'add_expense_screen', 'add_expense_screen');
  }

  FutureOr<void> _onAddExpenseModalAmountChangedEvent(AddExpenseModalAmountChangedEvent event, Emitter<AddExpenseModalState> emit) async {
    final amount = ExpenseAmountField.dirty(event.amount);
    emit(state.copyWith(amount: amount.isValid ? amount : ExpenseAmountField.pure(event.amount), isValid: Formz.validate([amount]), status: AddExpenseModalStatus.initial));
  }

  FutureOr<void> _onAddExpenseModalAmountUnfocusedEvent(AddExpenseModalAmountUnfocusedEvent event, Emitter<AddExpenseModalState> emit) async {
    final amount = ExpenseAmountField.dirty(state.amount.value);
    emit(state.copyWith(amount: amount, isValid: Formz.validate([amount]), status: AddExpenseModalStatus.initial));
  }

  FutureOr<void> _onAddExpenseModalSubmitEvent(AddExpenseModalSubmitEvent event, Emitter<AddExpenseModalState> emit) async {
    final amount = ExpenseAmountField.dirty(state.amount.value);
    emit(state.copyWith(amount: amount, isValid: Formz.validate([amount]), status: AddExpenseModalStatus.initial));
    if (state.isValid && state.amount.value.isNotEmpty) {
      try {
        final String vendorId = await _accountRepository.getVendorId();
        AddExpenseRequestModel param = AddExpenseRequestModel(amount: state.amount.value, restaurant: vendorId, expenseType: 'other');
        emit(state.copyWith(status: AddExpenseModalStatus.submit));
        DioApiResponse response = await _accountRepository.addExpense(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (!initialResponse.success!) {
            emit(state.copyWith(status: AddExpenseModalStatus.submitFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          } else {
            emit(state.copyWith(status: AddExpenseModalStatus.submitSuccess));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: AddExpenseModalStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: AddExpenseModalStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
