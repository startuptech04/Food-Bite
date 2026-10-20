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

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/vendor_subscription_status_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'bottom_tab_navigation_event.dart';
part 'bottom_tab_navigation_state.dart';

class BottomTabNavigationBloc extends Bloc<BottomTabNavigationEvent, BottomTabNavigationState> {
  final AccountRepository _accountRepository = AccountRepository();
  BottomTabNavigationBloc() : super(const BottomTabNavigationState(tabIndex: 2, canActivate: true)) {
    on<BottomNavigationTabInitialEvent>(_onBottomNavigationTabInitialEvent);
    on<BottomNavigationTabChange>(_onBottomNavigationTabChange);
  }

  FutureOr<void> _onBottomNavigationTabInitialEvent(BottomNavigationTabInitialEvent event, Emitter<BottomTabNavigationState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "tabs"}, 'tabs_screen', 'tabs_screen');
    emit(state.copyWith(tabIndex: event.tabIndex, canActivate: true));
    final String role = await _accountRepository.getAuthRole();
    if (role == 'vendor') {
      try {
        DioApiResponse response = await _accountRepository.getVendorSubscriptionStatus();
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          AccountSubscriptionPackageInfoConfigModel data = AccountSubscriptionPackageInfoConfigModel.fromJson(myMap, locale.toString());
          final bool isSubscriptionPlanExpired = data.expiring!;
          final String subscriptionExpiredDate = data.date!;
          final String subscriptionPackageName = data.name!;
          emit(state.copyWith(isSubscriptionExpired: isSubscriptionPlanExpired, subscriptionExpiredDate: subscriptionExpiredDate, subscriptionName: subscriptionPackageName));
        }
      } catch (e, stacktrace) {
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onBottomNavigationTabChange(BottomNavigationTabChange event, Emitter<BottomTabNavigationState> emit) async {
    emit(state.copyWith(tabIndex: event.tabIndex, canActivate: true));
  }
}
