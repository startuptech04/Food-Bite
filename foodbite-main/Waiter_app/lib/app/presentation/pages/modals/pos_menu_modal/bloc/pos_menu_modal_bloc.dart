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
import 'package:waiter/app/core/repositories/auth_repository.dart';

part 'pos_menu_modal_event.dart';
part 'pos_menu_modal_state.dart';

class PosMenuModalBloc extends Bloc<PosMenuModalEvent, PosMenuModalState> {
  final AuthRepository _authRepository = AuthRepository();
  PosMenuModalBloc() : super(const PosMenuModalState()) {
    on<PosMenuModalInitialEvent>(_onPosMenuModalInitialEvent);
  }

  FutureOr<void> _onPosMenuModalInitialEvent(PosMenuModalInitialEvent event, Emitter<PosMenuModalState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "pos_menu"}, 'pos_menu_screen', 'pos_menu_screen');
    emit(state.copyWith(currentInView: event.currentInView, isDarkTheme: event.isDarkTheme, status: PosMenuModalStatus.success));
  }
}
