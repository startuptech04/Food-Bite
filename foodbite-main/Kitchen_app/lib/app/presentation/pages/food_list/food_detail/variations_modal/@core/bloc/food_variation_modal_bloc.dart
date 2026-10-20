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
import 'package:kitchen/app/core/models/food_variation_model.dart';
import 'package:kitchen/app/core/models/food_variation_options_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/core/validations/food_variations_form.dart';

part 'food_variation_modal_event.dart';
part 'food_variation_modal_state.dart';

class FoodVariationModalBloc extends Bloc<FoodVariationModalEvent, FoodVariationModalState> {
  final AuthRepository _authRepository = AuthRepository();
  FoodVariationModalBloc() : super(FoodVariationModalState(savedData: FoodVariationModel())) {
    on<FoodVariationModalInitialEvent>(_onFoodVariationModalInitialEvent);
    on<FoodVariationNameChanged>(_onFoodVariationNameChanged);
    on<FoodVariationNameUnfocused>(_onFoodVariationNameUnfocused);
    on<FoodVariationMinChanged>(_onFoodVariationMinChanged);
    on<FoodVariationMinUnfocused>(_onFoodVariationMinUnfocused);
    on<FoodVariationMaxChanged>(_onFoodVariationMaxChanged);
    on<FoodVariationMaxUnfocused>(_onFoodVariationMaxUnfocused);
    on<FoodVariationRequiredChanged>(_onFoodVariationRequiredChanged);
    on<FoodVariationTypeChanged>(_onFoodVariationTypeChanged);
    on<FoodVariationOptionChanged>(_onFoodVariationOptionChanged);
    on<FoodVariationRemoveEvent>(_onFoodVariationRemoveEvent);
    on<FoodVaritionFormSubmit>(_onFoodVaritionFormSubmit);
  }

  FutureOr<void> _onFoodVariationModalInitialEvent(FoodVariationModalInitialEvent event, Emitter<FoodVariationModalState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "food_variation"}, 'food_variation_screen', 'food_variation_screen');
    if (!event.isNew) {
      emit(
        state.copyWith(
          name: VariationNameField.dirty(event.model.title!),
          min: VariationMinQuantityField.dirty(event.model.type! == 'multi' ? event.model.min! : '1'),
          max: VariationMaxQuantityField.dirty(event.model.type! == 'multi' ? event.model.max! : '1'),
          isRequired: event.model.isRequired! == 'true' ? true : false,
          type: event.model.type,
          options: [...event.model.options!],
          status: FoodVariationModalStatus.initial,
          isValid: Formz.validate([state.name, state.min, state.max]),
        ),
      );
    }
  }

  FutureOr<void> _onFoodVariationNameChanged(FoodVariationNameChanged event, Emitter<FoodVariationModalState> emit) async {
    final name = VariationNameField.dirty(event.name);
    emit(state.copyWith(name: name.isValid ? name : VariationNameField.pure(event.name), status: FoodVariationModalStatus.initial, isValid: Formz.validate([name, state.min, state.max])));
  }

  FutureOr<void> _onFoodVariationNameUnfocused(FoodVariationNameUnfocused event, Emitter<FoodVariationModalState> emit) async {
    final name = VariationNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, status: FoodVariationModalStatus.initial, isValid: Formz.validate([name, state.min, state.max])));
  }

  FutureOr<void> _onFoodVariationMinChanged(FoodVariationMinChanged event, Emitter<FoodVariationModalState> emit) async {
    final min = VariationMinQuantityField.dirty(event.min);
    emit(state.copyWith(min: min.isValid ? min : VariationMinQuantityField.pure(event.min), status: FoodVariationModalStatus.initial, isValid: Formz.validate([min, state.name, state.max])));
  }

  FutureOr<void> _onFoodVariationMinUnfocused(FoodVariationMinUnfocused event, Emitter<FoodVariationModalState> emit) async {
    final min = VariationMinQuantityField.dirty(state.min.value);
    emit(state.copyWith(min: min, status: FoodVariationModalStatus.initial, isValid: Formz.validate([min, state.name, state.max])));
  }

  FutureOr<void> _onFoodVariationMaxChanged(FoodVariationMaxChanged event, Emitter<FoodVariationModalState> emit) async {
    final max = VariationMaxQuantityField.dirty(event.max);
    emit(state.copyWith(max: max.isValid ? max : VariationMaxQuantityField.pure(event.max), status: FoodVariationModalStatus.initial, isValid: Formz.validate([max, state.name, state.min])));
  }

  FutureOr<void> _onFoodVariationMaxUnfocused(FoodVariationMaxUnfocused event, Emitter<FoodVariationModalState> emit) async {
    final max = VariationMaxQuantityField.dirty(state.max.value);
    emit(state.copyWith(max: max, status: FoodVariationModalStatus.initial, isValid: Formz.validate([max, state.name, state.min])));
  }

  FutureOr<void> _onFoodVariationRequiredChanged(FoodVariationRequiredChanged event, Emitter<FoodVariationModalState> emit) async {
    emit(state.copyWith(isRequired: event.checked, status: FoodVariationModalStatus.initial));
  }

  FutureOr<void> _onFoodVariationTypeChanged(FoodVariationTypeChanged event, Emitter<FoodVariationModalState> emit) async {
    if (event.value == 'single') {
      const min = VariationMinQuantityField.dirty('0');
      const max = VariationMaxQuantityField.dirty('0');
      emit(state.copyWith(type: event.value, min: min, max: max, status: FoodVariationModalStatus.initial, isValid: Formz.validate([min, max, state.name])));
    } else {
      const min = VariationMinQuantityField.dirty('');
      const max = VariationMaxQuantityField.dirty('');
      emit(state.copyWith(type: event.value, min: min, max: max, status: FoodVariationModalStatus.initial, isValid: Formz.validate([min, max, state.name])));
    }
  }

  FutureOr<void> _onFoodVariationOptionChanged(FoodVariationOptionChanged event, Emitter<FoodVariationModalState> emit) async {
    if (state.options.isEmpty) {
      List<FoodVariationOptionModel> newOptionList = <FoodVariationOptionModel>[];
      emit(state.copyWith(options: [...newOptionList], status: FoodVariationModalStatus.initial));
    }
    if (event.isNew) {
      FoodVariationOptionModel option = FoodVariationOptionModel(name: event.name, price: event.price, stock: event.stock);
      state.options.add(option);
      emit(state.copyWith(options: [...state.options], status: FoodVariationModalStatus.initial));
    } else {
      state.options[event.index].name = event.name;
      state.options[event.index].price = event.price;
      state.options[event.index].stock = event.stock;
      emit(state.copyWith(options: [...state.options], status: FoodVariationModalStatus.initial));
    }
  }

  FutureOr<void> _onFoodVariationRemoveEvent(FoodVariationRemoveEvent event, Emitter<FoodVariationModalState> emit) async {
    state.options.removeAt(event.index);
    emit(state.copyWith(options: [...state.options], status: FoodVariationModalStatus.initial));
  }

  FutureOr<void> _onFoodVaritionFormSubmit(FoodVaritionFormSubmit event, Emitter<FoodVariationModalState> emit) async {
    final name = VariationNameField.dirty(state.name.value);
    final min = VariationMinQuantityField.dirty(state.min.value);
    final max = VariationMaxQuantityField.dirty(state.max.value);
    emit(state.copyWith(name: name, min: min, max: max, status: FoodVariationModalStatus.initial, isValid: Formz.validate([name, min, max])));
    if (state.isValid && state.name.value.isNotEmpty && state.min.value.isNotEmpty && state.max.value.isNotEmpty) {
      if (state.options.isNotEmpty) {
        FoodVariationModel data = FoodVariationModel(isRequired: '${state.isRequired}', title: state.name.value, type: state.type, min: state.min.value, max: state.max.value, options: state.options);
        emit(state.copyWith(savedData: data, status: FoodVariationModalStatus.success));
      } else {
        emit(state.copyWith(status: FoodVariationModalStatus.failure, statusCode: 0, alertMessage: 'Please add options', extraMessage: ''));
      }
    }
  }
}
