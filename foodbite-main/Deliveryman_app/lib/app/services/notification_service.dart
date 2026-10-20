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

import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/config/shared_pref_keys.dart';
import 'package:driver/app/core/models/notification_response_data_model.dart';
import 'package:driver/app/core/models/order_notification_local_list_model.dart';
import 'package:driver/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (message.data.isNotEmpty) {
      Map<String, dynamic>? notificationMap = jsonDecode(jsonEncode(message.data)) as Map<String, dynamic>;
      NotificationResponseDataModel notificationData = NotificationResponseDataModel.fromJson(notificationMap);
      if (notificationData.type!.isNotEmpty && notificationData.type == 'order') {
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        ///////// Save to Local Storage /////////
        DateTime currentTime = DateTime.now();
        OrderNotificationLocalListModel newNotification = OrderNotificationLocalListModel(
          notificationId: notificationData.value,
          createdAt: "${currentTime.year}-${currentTime.month}-${currentTime.day}",
          extra: notificationData.extra.toString(),
          status: 'new',
        );
        await saveOrderNotitication(newNotification);
        ///////// Save to Local Storage /////////
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

Future<Database> getDdInstance() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'foodbite_driver_notification.db');
  return openDatabase(path, version: 1);
}

Future<void> saveOrderNotitication(OrderNotificationLocalListModel param) async {
  try {
    Database db = await getDdInstance();
    await db.execute('''
  CREATE TABLE IF NOT EXISTS notification (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    notification_id TEXT,
    extra TEXT,
    status TEXT,
    createdAt TEXT
  )   
  ''');
    await db.insert('notification', param.toJson());
  } catch (e, stacktrace) {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
    }
  }
}
