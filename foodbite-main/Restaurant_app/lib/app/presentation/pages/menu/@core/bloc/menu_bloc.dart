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
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  MenuBloc() : super(const MenuState()) {
    on<MenuInitialEvent>(_onMenuInitialEvent);
  }

  Future<void> _onMenuInitialEvent(MenuInitialEvent event, Emitter<MenuState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "menu"}, 'menu_screen', 'menu_screen');
      final bool haveCustomCategory = await _menuRepository.haveCustomCategory();
      emit(state.copyWith(customCategory: haveCustomCategory));
    } catch (e, stacktrace) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
