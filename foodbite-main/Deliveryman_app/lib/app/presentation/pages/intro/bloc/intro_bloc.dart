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
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:driver/app/core/models/request/push_notification_token_request_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/intro_repository.dart';
import 'package:driver/app/core/repositories/splash_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'intro_event.dart';
part 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  final IntroRepository _introRepository = IntroRepository();
  final SplashRepositry _splashRepositry = SplashRepositry();
  final AuthRepository _authRepository = AuthRepository();
  IntroBloc() : super(const IntroState()) {
    on<IntroInitialEvent>(_onIntroInitialEvent);
    on<IntroNotificationPermissionEvent>(_onIntroNotificationPermissionEvent);
    on<IntroCameraPermissionEvent>(_onIntroCameraPermissionEvent);
    on<IntroLocationPermisionEvent>(_onIntroLocationPermisionEvent);
    on<IntroLocationOpenSettingEvent>(_onIntroLocationOpenSettingEvent);
    on<IntroLanguageChangeEvent>(_onIntroLanguageChangeEvent);
  }

  FutureOr<void> _onIntroInitialEvent(IntroInitialEvent event, Emitter<IntroState> emit) async {
    final String locale = await _authRepository.getLocale();
    emit(state.copyWith(locale: locale));
  }

  FutureOr<void> _onIntroNotificationPermissionEvent(IntroNotificationPermissionEvent event, Emitter<IntroState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "intro"}, 'intro_screen', 'intro_screen');
    emit(state.copyWith(status: IntroStatus.loading));
    if (await Permission.notification.request().isGranted) {
      if (!kIsWeb) {
        final String user = await _splashRepositry.userId();
        String? pushToken = '';
        String deviceType = '';
        String deviceId = '';
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        await FirebaseMessaging.instance.getToken().then((value) async {
          pushToken = value;
        });
        if (pushToken != null && pushToken!.isNotEmpty) {
          if (Platform.isAndroid) {
            deviceType = 'android';
            var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
            deviceId = '${androidDeviceInfo.host}:${androidDeviceInfo.device}:${androidDeviceInfo.id}:${androidDeviceInfo.model}:${androidDeviceInfo.brand}';
          } else if (Platform.isIOS) {
            deviceType = 'ios';
            var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
            deviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.model}:${iosDeviceInfo.identifierForVendor}';
          }
          if (Platform.isAndroid || Platform.isIOS) {
            PushNotificationTokenRequestModel tokenParam = PushNotificationTokenRequestModel(user: user, deviceId: deviceId, deviceType: deviceType, token: pushToken!);
            await _splashRepositry.savePushNotificationToken(tokenParam);
          }
        }
      }

      emit(state.copyWith(status: IntroStatus.notificationGranted, currentPageIndex: state.currentPageIndex + 1));
    } else {
      emit(state.copyWith(status: IntroStatus.notificationDicline, currentPageIndex: state.currentPageIndex + 1));
    }
  }

  FutureOr<void> _onIntroCameraPermissionEvent(IntroCameraPermissionEvent event, Emitter<IntroState> emit) async {
    emit(state.copyWith(status: IntroStatus.loading));
    if (await Permission.camera.request().isGranted) {
      emit(state.copyWith(status: IntroStatus.cameraGranted, currentPageIndex: state.currentPageIndex + 1));
    } else {
      emit(state.copyWith(status: IntroStatus.cameraDicline, currentPageIndex: state.currentPageIndex + 1));
    }
  }

  FutureOr<void> _onIntroLocationPermisionEvent(IntroLocationPermisionEvent event, Emitter<IntroState> emit) async {
    /// Test ///
    // await _introRepository.saveIntro();
    // await _introRepository.saveLocation(23.0301, 72.5178);
    // emit(state.copyWith(status: IntroStatus.locationGranted));

    /// Test ///

    //// Live ////
    emit(state.copyWith(status: IntroStatus.loading));
    await Permission.location.status.then((value) async {
      if (value.isPermanentlyDenied) {
        emit(state.copyWith(status: IntroStatus.deniedForever));
      } else {
        try {
          await _determinePosition()
              .then((value) async {
                await _introRepository.saveIntro();
                await _introRepository.saveLocation(value.latitude, value.longitude);
                emit(state.copyWith(status: IntroStatus.locationGranted));
              })
              .catchError((error, stacktrace) {
                emit(state.copyWith(status: IntroStatus.failure, statusCode: 0, alertMessage: error.toString(), extraMessage: ''));
                if (!kIsWeb) {
                  FirebaseCrashlytics.instance.recordError(error, stacktrace);
                }
              });
        } catch (e, stacktrace) {
          emit(state.copyWith(status: IntroStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    });
    //// Live ////
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  FutureOr<void> _onIntroLocationOpenSettingEvent(IntroLocationOpenSettingEvent event, Emitter<IntroState> emit) async {
    await Geolocator.openLocationSettings();
  }

  FutureOr<void> _onIntroLanguageChangeEvent(IntroLanguageChangeEvent event, Emitter<IntroState> emit) async {
    emit(state.copyWith(locale: event.locale));
  }
}
