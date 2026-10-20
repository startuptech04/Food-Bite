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

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/validations/tiffin_subscription_instruction_form.dart';

part 'tiffin_subscription_instruction_modal_event.dart';
part 'tiffin_subscription_instruction_modal_state.dart';

class TiffinSubscriptionInstructionModalBloc extends Bloc<TiffinSubscriptionInstructionModalEvent, TiffinSubscriptionInstructionModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  TiffinSubscriptionInstructionModalBloc() : super(const TiffinSubscriptionInstructionModalState()) {
    on<TiffinSubscriptionInstructionInitialEvent>(_onTiffinSubscriptionInstructionInitialEvent);
    on<TiffinSubscriptionInstructionModalNameChangeEvent>(_onTiffinSubscriptionInstructionModalNameChangeEvent);
    on<TiffinSubscriptionInstructionNameModalUnfocusedEvent>(_onTiffinSubscriptionInstructionNameModalUnfocusedEvent);
  }

  FutureOr<void> _onTiffinSubscriptionInstructionInitialEvent(TiffinSubscriptionInstructionInitialEvent event, Emitter<TiffinSubscriptionInstructionModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "tiffin_subscription_instructions"}, 'tiffin_subscription_instructions_screen', 'tiffin_subscription_instructions_screen');
    if (event.isNew) {
      emit(state.copyWith(status: TiffinSubscriptionInstructionModalStatus.success));
    } else {
      final instructionName = TiffinSubscriptionInstructionNameField.dirty(event.title);
      emit(state.copyWith(instructionName: instructionName, status: TiffinSubscriptionInstructionModalStatus.success, isValid: Formz.validate([instructionName])));
    }
  }

  FutureOr<void> _onTiffinSubscriptionInstructionModalNameChangeEvent(TiffinSubscriptionInstructionModalNameChangeEvent event, Emitter<TiffinSubscriptionInstructionModalState> emit) async {
    final instructionName = TiffinSubscriptionInstructionNameField.dirty(event.name);
    emit(
      state.copyWith(
        instructionName: instructionName.isValid ? instructionName : TiffinSubscriptionInstructionNameField.pure(event.name),
        status: TiffinSubscriptionInstructionModalStatus.changeDetail,
        isValid: Formz.validate([instructionName]),
      ),
    );
  }

  FutureOr<void> _onTiffinSubscriptionInstructionNameModalUnfocusedEvent(TiffinSubscriptionInstructionNameModalUnfocusedEvent event, Emitter<TiffinSubscriptionInstructionModalState> emit) async {
    final instructionName = TiffinSubscriptionInstructionNameField.dirty(state.instructionName.value);
    emit(state.copyWith(instructionName: instructionName, status: TiffinSubscriptionInstructionModalStatus.changeDetail, isValid: Formz.validate([instructionName])));
  }
}
