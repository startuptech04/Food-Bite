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
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/config/global_settings.dart';
import 'package:driver/app/core/models/driver_settings_model.dart';
import 'package:driver/app/core/models/notification_response_data_model.dart';
import 'package:driver/app/core/models/request/push_notification_token_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/splash_repository.dart';
import 'package:driver/app/env.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashRepositry _splashRepositry = SplashRepositry();
  final AuthRepository _authRepository = AuthRepository();
  SplashBloc() : super(const SplashState()) {
    on<SplashInitialEvent>(_onSplashInitialEvent);
    on<SplashOrderNotificationEvent>(_onSplashOrderNotificationEvent);
    on<SplashNavigateScreenRouteEvent>(_onSplashNavigateScreenRouteEvent);
  }

  FutureOr<void> _onSplashInitialEvent(SplashInitialEvent event, Emitter<SplashState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "splash"}, 'splash_screen', 'splash_screen');
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    final hasInternet = (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi));
    if (!hasInternet) {
      emit(state.copyWith(status: SplashStatus.connectionError));
    } else {
      try {
        // /// Notification Bell //
        await _splashRepositry.getNotificationBell().then((sound) async {
          if (sound.isEmpty || sound == '') {
            await _splashRepositry.saveNotificationBell(AssetsUrl.notificationAssetSound.sound1);
          }
        });
        // /// Notification Bell //

        String userAgent = 'unknown';
        if (kIsWeb) {
          userAgent = 'browser';
        } else if (Platform.isAndroid) {
          userAgent = 'android';
        } else if (Platform.isIOS) {
          userAgent = 'ios';
        }

        DioApiResponse response = await _splashRepositry.getDefaultSetting();
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          DriverSettingsModel data = DriverSettingsModel.fromJson(myMap);
          final bool haveSavedLocale = await _splashRepositry.haveSavedLocale();
          if (haveSavedLocale) {
            final String locale = await _splashRepositry.getLocale();
            emit(state.copyWith(appLocale: locale.isNotEmpty ? locale : Environments.defaultLanguage, status: SplashStatus.appLocale));
          } else {
            emit(state.copyWith(appLocale: data.defaultLocale!.code.toString(), status: SplashStatus.appLocale));
          }
          await _splashRepositry.saveSettings(data);
          if (data.versions!.success!) {
            final PackageInfo packageInfo = await PackageInfo.fromPlatform();
            final String currentVersion = packageInfo.version;
            debugPrint('currentVersion ------------->> $currentVersion');
            final String latestVersion = userAgent == 'android' ? data.versions!.androidVersion! : data.versions!.iosVersion!;
            final String forceUpdateUrl = userAgent == 'android' ? data.versions!.androidUrl! : data.versions!.iosUrl!;
            if (_isVersionLower(currentVersion, latestVersion) && userAgent != 'browser') {
              emit(state.copyWith(status: SplashStatus.forceUpdate, newUpdateVersion: latestVersion, versionUpdateUrl: forceUpdateUrl, currentVersion: currentVersion));
            } else {
              add(SplashNavigateScreenRouteEvent(data: data));
            }
          } else {
            add(SplashNavigateScreenRouteEvent(data: data));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: SplashStatus.failure, statusCode: 0, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: SplashStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onSplashOrderNotificationEvent(SplashOrderNotificationEvent event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.newNotification));
  }

  bool _isVersionLower(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || currentParts[i] < latestParts[i]) {
        return true;
      } else if (currentParts[i] > latestParts[i]) {
        return false;
      }
    }
    return false;
  }

  FutureOr<void> _onSplashNavigateScreenRouteEvent(SplashNavigateScreenRouteEvent event, Emitter<SplashState> emit) async {
    if (event.data.settings!.maintenance!) {
      emit(state.copyWith(status: SplashStatus.maintenance, businessEmail: event.data.settings!.email, businessMobile: event.data.settings!.mobile));
    } else {
      if (!kIsWeb) {
        var notificationStatus = await Permission.notification.status;
        if (notificationStatus.isGranted || notificationStatus.isLimited || notificationStatus.isProvisional) {
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
      }
      FirebaseMessaging.onMessage.handleError((error) {}).listen((RemoteMessage event) async {
        if (event.data.isNotEmpty) {
          Map<String, dynamic>? notificationMap = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;
          NotificationResponseDataModel notificationData = NotificationResponseDataModel.fromJson(notificationMap);
          if (notificationData.type!.isNotEmpty && notificationData.type == 'order') {
            add(SplashOrderNotificationEvent(notificationData: notificationData));
          }
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) async {});

      GlobalSettings().init();
      await _splashRepositry.haveIntro().then((value) async {
        if (value == false) {
          emit(state.copyWith(status: SplashStatus.intro, defaultLanguage: event.data.defaultLocale!.code ?? Environments.defaultLanguage));
        } else {
          await _splashRepositry.haveAuthToken().then((value) {
            if (value == true) {
              emit(state.copyWith(status: SplashStatus.authorized, defaultLanguage: event.data.defaultLocale!.code ?? Environments.defaultLanguage));
            } else {
              emit(state.copyWith(status: SplashStatus.unAuthorized, defaultLanguage: event.data.defaultLocale!.code ?? Environments.defaultLanguage));
            }
          });
        }
      });
    }
  }
}
