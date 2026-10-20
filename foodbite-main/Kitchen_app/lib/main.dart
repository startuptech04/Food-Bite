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

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kitchen/app/core/observer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kitchen/app/env.dart';
import 'package:kitchen/app/presentation/pages/account/@core/bloc/account_bloc.dart';
import 'package:kitchen/app/presentation/pages/account/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:kitchen/app/presentation/pages/food_list/@core/bloc/food_list_bloc.dart';
import 'package:kitchen/app/presentation/pages/orders/@core/bloc/order_list_bloc.dart';
import 'package:kitchen/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_localization/app_localization_bloc.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/app/presentation/styles/theme_bloc/theme_bloc.dart';
import 'package:kitchen/app/router/app_route_config.dart';
import 'package:kitchen/app/services/local_notification_service.dart';
import 'package:kitchen/app/services/notification_service.dart';
import 'package:kitchen/firebase_options.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Bloc.observer = const AppBlocObserver();
      if (!kIsWeb) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        FirebaseAnalytics analytics = FirebaseAnalytics.instance;
        await analytics.setAnalyticsCollectionEnabled(true);
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        await LocalNotificationService.initialize();
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          LocalNotificationService.showNotification(message);
        });
      }
      runApp(MyApp());
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()..add(ThemeInitialEvent())),
        BlocProvider(create: (_) => AppLocalizationBloc()..add(AppLocalizationInitialEvent())),
        BlocProvider(create: (_) => SplashBloc()),
        BlocProvider(create: (_) => FoodListBloc()),
        BlocProvider(create: (_) => OrderListBloc()),
        BlocProvider(create: (_) => AccountBloc()),
        BlocProvider(create: (_) => EditProfileBloc()),
      ],
      child: Builder(
        builder: (context) {
          final isDarkTheme = context.watch<ThemeBloc>().state.isDarkTheme;
          final currentLanguage = context.watch<AppLocalizationBloc>().state.appLanguage;
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: TextScaler.linear(mediaQuery.textScaler.scale(1).clamp(0.9, 1.1))),
            child: MaterialApp(
              title: Environments.appName,
              initialRoute: AppRouter.initialRoute,
              onGenerateRoute: AppRouter.onGenerateRouted,
              localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
              supportedLocales: Environments.supportedLanguages,
              locale: Locale(currentLanguage),
              debugShowCheckedModeBanner: false,
              theme: isDarkTheme ? appThemeData[AppTheme.dark] : appThemeData[AppTheme.light],
            ),
          );
        },
      ),
    );
  }
}
