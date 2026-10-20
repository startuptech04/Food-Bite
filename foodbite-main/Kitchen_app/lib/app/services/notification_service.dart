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

import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:kitchen/app/core/config/assets_url.dart';
import 'package:kitchen/app/core/config/shared_pref_keys.dart';
import 'package:kitchen/app/core/models/notification_response_data_model.dart';
import 'package:kitchen/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (message.data.isNotEmpty) {
      Map<String, dynamic>? notificationMap = jsonDecode(jsonEncode(message.data)) as Map<String, dynamic>;
      NotificationResponseDataModel notificationData = NotificationResponseDataModel.fromJson(notificationMap);
      if (notificationData.type!.isNotEmpty && notificationData.type == 'order') {
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String notificationSound = '';
        final String? sound = sharedPreferences.getString(SharedPreferencesKey.publicKeys.notificationBell);
        if (sound != null && sound.isNotEmpty && sound.toString() != '') {
          notificationSound = sound;
        } else {
          notificationSound = AssetsUrl.notificationAssetSound.sound1;
        }

        final AudioPlayer player = AudioPlayer();
        await player.setAsset(notificationSound);
        await player.setVolume(1.0);
        await player.play();
      }
    }
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e, stacktrace) {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
    }
  }
}
