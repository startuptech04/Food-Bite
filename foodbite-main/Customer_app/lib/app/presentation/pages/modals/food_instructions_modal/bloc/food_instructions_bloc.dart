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
import 'package:user/app/core/repositories/auth_repository.dart';

part 'food_instructions_event.dart';
part 'food_instructions_state.dart';

class FoodInstructionsBloc extends Bloc<FoodInstructionsEvent, FoodInstructionsState> {
  final AuthRepository _authRepository = AuthRepository();
  FoodInstructionsBloc() : super(const FoodInstructionsState()) {
    on<FoodInstructionsInitialEvent>(_onFoodInstructionsInitialEvent);
    on<FoodInstructionsChangeEvent>(_onFoodInstructionsChangeEvent);
  }

  FutureOr<void> _onFoodInstructionsInitialEvent(FoodInstructionsInitialEvent event, Emitter<FoodInstructionsState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "food_instructions"}, 'food_instructions_screen', 'food_instructions_screen');
    emit(state.copyWith(status: FoodInstructionsStatus.success, instructions: event.instructions));
  }

  FutureOr<void> _onFoodInstructionsChangeEvent(FoodInstructionsChangeEvent event, Emitter<FoodInstructionsState> emit) async {
    emit(state.copyWith(instructions: event.instructions));
  }
}
