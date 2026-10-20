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
import 'package:kitchen/app/core/repositories/auth_repository.dart';

part 'bottom_tab_navigation_event.dart';
part 'bottom_tab_navigation_state.dart';

class BottomTabNavigationBloc extends Bloc<BottomTabNavigationEvent, BottomTabNavigationState> {
  final AuthRepository _authRepository = AuthRepository();
  BottomTabNavigationBloc() : super(const BottomTabNavigationState(tabIndex: 0, canActivate: true)) {
    on<BottomNavigationTabInitialEvent>(_onBottomNavigationTabInitialEvent);
    on<BottomNavigationTabChange>(_onBottomNavigationTabChange);
  }

  FutureOr<void> _onBottomNavigationTabInitialEvent(BottomNavigationTabInitialEvent event, Emitter<BottomTabNavigationState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "tabs"}, 'tab_screen', 'tab_screen');
    final bool isAuthorized = await _authRepository.isAuthorized();
    if (!isAuthorized) {
      emit(state.copyWith(tabIndex: event.tabIndex, canActivate: false));
    } else {
      emit(state.copyWith(tabIndex: event.tabIndex, canActivate: true));
    }
  }

  FutureOr<void> _onBottomNavigationTabChange(BottomNavigationTabChange event, Emitter<BottomTabNavigationState> emit) async {
    emit(state.copyWith(tabIndex: event.tabIndex, canActivate: true));
  }
}
