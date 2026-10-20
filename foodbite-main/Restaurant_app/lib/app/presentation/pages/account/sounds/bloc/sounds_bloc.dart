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
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/notification_alert_list_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/splash_respository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'sounds_event.dart';
part 'sounds_state.dart';

class SoundsBloc extends Bloc<SoundsEvent, SoundsState> {
  final SplashRepositry _splashRepositry = SplashRepositry();
  final AccountRepository _accountRepository = AccountRepository();
  SoundsBloc() : super(const SoundsState()) {
    on<SoundsInitialEvent>(_onSoundsInitialEvent);
    on<SoundsSelectEvent>(_onSoundsSelectEvent);
    on<SoundsPlayingEvent>(_onSoundsPlayingEvent);
  }

  FutureOr<void> _onSoundsInitialEvent(SoundsInitialEvent event, Emitter<SoundsState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "sound_setting"}, 'sound_setting_screen', 'sound_setting_screen');
      emit(state.copyWith(status: SoundsStatus.loading));
      String savedNotificationBell = '';
      await _splashRepositry.getNotificationBell().then((sound) async {
        if (sound.isEmpty || sound == '') {
          savedNotificationBell = AssetsUrl.notificationAssetSound.sound1;
        } else {
          savedNotificationBell = sound;
        }
      });
      List<NotificationAlertListModel> soundsList = <NotificationAlertListModel>[];
      for (var i = 1; i <= 16; i++) {
        NotificationAlertListModel sounds = NotificationAlertListModel(name: 'Alert $i', sound: 'assets/sounds/alert$i.mp3');
        soundsList.add(sounds);
      }
      emit(state.copyWith(status: SoundsStatus.success, sounds: soundsList, savedBell: savedNotificationBell));
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SoundsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSoundsSelectEvent(SoundsSelectEvent event, Emitter<SoundsState> emit) async {
    await _splashRepositry.saveNotificationBell(event.sound);
    emit(state.copyWith(savedBell: event.sound, status: SoundsStatus.success));
  }

  FutureOr<void> _onSoundsPlayingEvent(SoundsPlayingEvent event, Emitter<SoundsState> emit) async {
    emit(state.copyWith(playingSound: event.sound, status: SoundsStatus.success));
  }
}
