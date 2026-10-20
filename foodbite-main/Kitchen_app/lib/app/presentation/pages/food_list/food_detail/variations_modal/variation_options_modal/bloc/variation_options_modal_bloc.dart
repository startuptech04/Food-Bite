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
import 'package:kitchen/app/core/models/food_variation_options_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/core/validations/food_variations_form.dart';

part 'variation_options_modal_event.dart';
part 'variation_options_modal_state.dart';

class VariationOptionsModalBloc extends Bloc<VariationOptionsModalEvent, VariationOptionsModalState> {
  final AuthRepository _authRepository = AuthRepository();
  VariationOptionsModalBloc() : super(const VariationOptionsModalState()) {
    on<VariationOptionsModalInitialEvent>(_onVariationOptionsModalInitialEvent);
    on<VariationOptionNameChanged>(_onVariationOptionNameChanged);
    on<VariationOptionNameUnfocused>(_onVariationOptionNameUnfocused);
    on<VariationOptionPriceChanged>(_onVariationOptionPriceChanged);
    on<VariationOptionPriceUnfocused>(_onVariationOptionPriceUnfocused);
    on<VariationOptionStockChanged>(_onVariationOptionStockChanged);
    on<VariationOptionStockUnfocused>(_onVariationOptionStockUnfocused);
    on<VariationOptionFormSubmit>(_onVariationOptionFormSubmit);
  }

  FutureOr<void> _onVariationOptionsModalInitialEvent(VariationOptionsModalInitialEvent event, Emitter<VariationOptionsModalState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "food_variation_options"}, 'food_variation_options_screen', 'food_variation_options_screen');
    if (!event.isNew) {
      emit(
        state.copyWith(
          name: VariationOptionNameField.pure(event.model.name!),
          price: VariationOptionPriceField.pure(event.model.price.toString()),
          stock: VariationOptionStockField.pure(event.stockType == 'unlimited' ? '-1' : event.model.stock.toString()),
          stockType: event.stockType,
          isValid: Formz.validate([state.name, state.price, state.stock]),
        ),
      );
    }
    emit(state.copyWith(stockType: event.stockType));
  }

  FutureOr<void> _onVariationOptionNameChanged(VariationOptionNameChanged event, Emitter<VariationOptionsModalState> emit) async {
    final name = VariationOptionNameField.dirty(event.name);
    emit(state.copyWith(name: name.isValid ? name : VariationOptionNameField.pure(event.name), status: VariationOptionsModalStatus.initial, isValid: Formz.validate([name, state.price, state.stock])));
  }

  FutureOr<void> _onVariationOptionNameUnfocused(VariationOptionNameUnfocused event, Emitter<VariationOptionsModalState> emit) async {
    final name = VariationOptionNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, status: VariationOptionsModalStatus.initial, isValid: Formz.validate([name, state.price, state.stock])));
  }

  FutureOr<void> _onVariationOptionPriceChanged(VariationOptionPriceChanged event, Emitter<VariationOptionsModalState> emit) async {
    final price = VariationOptionPriceField.dirty(event.price);
    emit(state.copyWith(price: price.isValid ? price : VariationOptionPriceField.pure(event.price), status: VariationOptionsModalStatus.initial, isValid: Formz.validate([price, state.name, state.stock])));
  }

  FutureOr<void> _onVariationOptionPriceUnfocused(VariationOptionPriceUnfocused event, Emitter<VariationOptionsModalState> emit) async {
    final price = VariationOptionPriceField.dirty(state.price.value);
    emit(state.copyWith(price: price, status: VariationOptionsModalStatus.initial, isValid: Formz.validate([price, state.name, state.stock])));
  }

  FutureOr<void> _onVariationOptionStockChanged(VariationOptionStockChanged event, Emitter<VariationOptionsModalState> emit) async {
    final stock = VariationOptionStockField.dirty(event.stock);
    emit(state.copyWith(stock: stock.isValid ? stock : VariationOptionStockField.pure(event.stock), status: VariationOptionsModalStatus.initial, isValid: Formz.validate([stock, state.name, state.price])));
  }

  FutureOr<void> _onVariationOptionStockUnfocused(VariationOptionStockUnfocused event, Emitter<VariationOptionsModalState> emit) async {
    final stock = VariationOptionStockField.dirty(state.stock.value);
    emit(state.copyWith(stock: stock, status: VariationOptionsModalStatus.initial, isValid: Formz.validate([stock, state.name, state.price])));
  }

  FutureOr<void> _onVariationOptionFormSubmit(VariationOptionFormSubmit event, Emitter<VariationOptionsModalState> emit) async {
    final name = VariationOptionNameField.dirty(state.name.value);
    final price = VariationOptionPriceField.dirty(state.price.value);
    final stock = VariationOptionStockField.dirty(state.stockType == 'unlimited' ? '-1' : state.stock.value);
    emit(state.copyWith(name: name, price: price, stock: stock, status: VariationOptionsModalStatus.initial, isValid: Formz.validate([name, price, stock])));
    if (state.isValid && state.name.value.isNotEmpty && state.price.value.isNotEmpty && state.stock.value.isNotEmpty) {
      emit(state.copyWith(status: VariationOptionsModalStatus.selected));
    }
  }
}
