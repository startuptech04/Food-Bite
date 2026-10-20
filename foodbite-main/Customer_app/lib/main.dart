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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:user/app/presentation/pages/account/@core/bloc/account_bloc.dart';
import 'package:user/app/presentation/pages/account/edit_user_profile/bloc/edit_user_profile_bloc.dart';
import 'package:user/app/presentation/pages/account/wallet/add_wallet_money/make_wallet_payments/bloc/make_wallet_payments_bloc.dart';
import 'package:user/app/presentation/pages/cart/@core/bloc/cart_bloc.dart';
import 'package:user/app/presentation/pages/cart/checkout/bloc/checkout_bloc.dart';
import 'package:user/app/presentation/pages/cart/make_payments/bloc/make_payments_bloc.dart';
import 'package:user/app/presentation/pages/dining/@core/bloc/dining_bloc.dart';
import 'package:user/app/presentation/pages/dining/dining_campaigns/bloc/dining_campaign_bloc.dart';
import 'package:user/app/presentation/pages/dining/filter_dining_with_category/bloc/filter_dining_with_category_bloc.dart';
import 'package:user/app/presentation/pages/dining/restaurant_pre_booking_table/make_dining_booking_payments/bloc/make_dining_booking_payment_bloc.dart';
import 'package:user/app/presentation/pages/favourite/foods/bloc/favourite_foods_bloc.dart';
import 'package:user/app/presentation/pages/favourite/orders/bloc/favourite_orders_bloc.dart';
import 'package:user/app/presentation/pages/favourite/restaurants/bloc/favourite_restaurants_bloc.dart';
import 'package:user/app/presentation/pages/history/@core/bloc/history_bloc.dart';
import 'package:user/app/presentation/pages/history/history_detail/bloc/history_detail_bloc.dart';
import 'package:user/app/presentation/pages/home/@core/bloc/home_bloc.dart';
import 'package:user/app/presentation/pages/home/campaign/food_campaign/bloc/food_campaign_bloc.dart';
import 'package:user/app/presentation/pages/home/campaign/restaurant_campaign/bloc/restaurant_campaign_bloc.dart';
import 'package:user/app/presentation/pages/home/food_subcriptions_info/make_payments_subscription_package/bloc/make_payments_subscription_package_bloc.dart';
import 'package:user/app/presentation/pages/home/restaurant/@core/bloc/restaurant_bloc.dart';
import 'package:user/app/presentation/pages/home/restaurant/food_search/bloc/food_search_bloc.dart';
import 'package:user/app/presentation/pages/home/restaurant/restaurant_detail_info/bloc/restaurant_detail_info_bloc.dart';
import 'package:user/app/presentation/pages/home/sort/brands/bloc/restaurants_by_brands_bloc.dart';
import 'package:user/app/presentation/pages/home/sort/categories/filter_foods/bloc/filter_foods_by_category_bloc.dart';
import 'package:user/app/presentation/pages/home/sort/categories/filter_restaurants/bloc/filter_restaurants_by_categories_bloc.dart';
import 'package:user/app/presentation/pages/home/sort/cuisine/bloc/restaurants_by_cuisine_bloc.dart';
import 'package:user/app/presentation/pages/modals/cart_summary_modal/bloc/cart_summary_modal_bloc.dart';
import 'package:user/app/presentation/pages/modals/restaurants_by_localities_modal/bloc/restaurants_by_localities_bloc.dart';
import 'package:user/app/presentation/pages/modals/single_food_from_banner_modal/bloc/single_food_from_banner_modal_bloc.dart';
import 'package:user/app/presentation/pages/modals/web_otp_modal/bloc/web_otp_modal_bloc.dart';
import 'package:user/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:user/app/presentation/pages/tabs/bloc/bottom_tab_navigation_bloc.dart';
import 'package:user/app/services/local_notification_service.dart';
import 'package:user/gen/l10n/app_localizations.dart';
import 'app/presentation/styles/app_localization/app_localization_bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'app/presentation/styles/theme.dart';
import 'app/presentation/styles/theme_bloc/theme_bloc.dart';
import 'app/router/app_route_config.dart';
import 'app/core/observer.dart';
import 'app/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void setupTimeagoLocales() {
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('hi', timeago.HiMessages());
  timeago.setLocaleMessages('es', timeago.EsMessages());
  timeago.setLocaleMessages('ar', timeago.ArMessages());
}

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Bloc.observer = const AppBlocObserver();
      if (!kIsWeb) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        FirebaseAnalytics analytics = FirebaseAnalytics.instance;
        await analytics.setAnalyticsCollectionEnabled(true);
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        await LocalNotificationService.initialize();
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          LocalNotificationService.showNotification(message);
        });
      }
      setupTimeagoLocales();
      runApp(MyApp());
    },
    (error, stack) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } else {
        debugPrint('Unhandled application error: $error\n$stack');
      }
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
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => BottomTabNavigationBloc()),
        BlocProvider(create: (_) => CartSummaryModalBloc()),
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => DiningBloc()),
        BlocProvider(create: (_) => DiningCampaignBloc()),
        BlocProvider(create: (_) => FilterDiningWithCategoryBloc()),
        BlocProvider(create: (_) => HistoryBloc()),
        BlocProvider(create: (_) => FavouriteFoodsBloc()),
        BlocProvider(create: (_) => AccountBloc()),
        BlocProvider(create: (_) => EditUserProfileBloc()),
        BlocProvider(create: (_) => RestaurantBloc()),
        BlocProvider(create: (_) => RestaurantDetailInfoBloc()),
        BlocProvider(create: (_) => FoodCampaignBloc()),
        BlocProvider(create: (_) => FilterFoodsByCategoryBloc()),
        BlocProvider(create: (_) => FavouriteRestaurantsBloc()),
        BlocProvider(create: (_) => RestaurantCampaignBloc()),
        BlocProvider(create: (_) => FilterRestaurantsByCategoriesBloc()),
        BlocProvider(create: (_) => RestaurantsByCuisineBloc()),
        BlocProvider(create: (_) => RestaurantsByBrandsBloc()),
        BlocProvider(create: (_) => RestaurantsByLocalitiesBloc()),
        BlocProvider(create: (_) => CheckoutBloc()),
        BlocProvider(create: (_) => MakePaymentsBloc()),
        BlocProvider(create: (_) => MakeWalletPaymentsBloc()),
        BlocProvider(create: (_) => MakeDiningBookingPaymentBloc()),
        BlocProvider(create: (_) => WebOtpModalBloc()),
        BlocProvider(create: (_) => FoodSearchBloc()),
        BlocProvider(create: (_) => FavouriteOrdersBloc()),
        BlocProvider(create: (_) => HistoryDetailBloc()),
        BlocProvider(create: (_) => SingleFoodFromBannerModalBloc()),
        BlocProvider(create: (_) => MakePaymentsSubscriptionPackageBloc()),
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
