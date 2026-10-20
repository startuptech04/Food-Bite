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
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'setting_section_event.dart';
part 'setting_section_state.dart';

class SettingSectionBloc extends Bloc<SettingSectionEvent, SettingSectionState> {
  final AuthRepository _authRepository = AuthRepository();
  SettingSectionBloc() : super(const SettingSectionState()) {
    on<SettingSectionInitialEvent>(_onSettingSectionInitialEvent);
  }

  FutureOr<void> _onSettingSectionInitialEvent(SettingSectionInitialEvent event, Emitter<SettingSectionState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "settings"}, 'setting_screen', 'setting_screen');
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      emit(state.copyWith(currentVersion: currentVersion, status: SettingSectionStatus.initial));
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SettingSectionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
