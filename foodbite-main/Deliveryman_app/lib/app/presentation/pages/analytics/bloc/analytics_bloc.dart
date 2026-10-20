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
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/models/deliveryman_insight_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/feeds_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final FeedsRepository _feedsRepository = FeedsRepository();
  final AuthRepository _authRepository = AuthRepository();
  AnalyticsBloc() : super(AnalyticsState(model: DeliverymanInsightModel(locale: ''))) {
    on<AnalyticsInitialEvent>(_onAnalyticsInitialEvent);
  }

  FutureOr<void> _onAnalyticsInitialEvent(AnalyticsInitialEvent event, Emitter<AnalyticsState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "business_analytics"}, 'business_analytics_screen', 'business_analytics_screen');
      DioApiResponse response = await _feedsRepository.deliverymanInsight();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DeliverymanInsightModel data = DeliverymanInsightModel.fromJson(myMap, locale.toString());
        for (var element in data.recentOrders!) {
          if (element.restaurant!.location!.coordinates!.isNotEmpty && element.deliveryAddressRaw!.location!.coordinates!.isNotEmpty) {
            double restaurantLatitude = element.restaurant!.location!.coordinates![1];
            double restaurantLongitude = element.restaurant!.location!.coordinates![0];
            double deliveryLatitude = element.deliveryAddressRaw!.location!.coordinates![1];
            double deliveryLongitude = element.deliveryAddressRaw!.location!.coordinates![0];
            double distanceInMeters = Geolocator.distanceBetween(restaurantLatitude, restaurantLongitude, deliveryLatitude, deliveryLongitude);
            if (data.findMode! == 'km') {
              double distanceInKilometers = distanceInMeters / 1000;
              String distanceInString = double.parse(distanceInKilometers.toString()).toStringAsFixed(2);
              element.distance = double.parse(distanceInString.toString());
            } else {
              double distanceInMiles = distanceInMeters / 1609.34;
              String distanceInString = double.parse(distanceInMiles.toString()).toStringAsFixed(2);
              element.distance = double.parse(distanceInString.toString());
            }
          }
          element.deliveryFullAddress = '${element.deliveryAddressRaw!.flatHouse!} ${element.deliveryAddressRaw!.locality!} ${element.deliveryAddressRaw!.landmark!}';
        }
        List<PieChartModel> earningChartData = <PieChartModel>[];
        PieChartModel bonuseEarning = PieChartModel(name: 'bonuses', amount: data.earningChartData!.totalBonuses!);
        PieChartModel tipsEarning = PieChartModel(name: 'tips', amount: data.earningChartData!.totalTips!);
        PieChartModel extraShiftEarning = PieChartModel(name: 'dd_extra_shift', amount: data.earningChartData!.totalExtraShiftEarning!);
        PieChartModel totalEarning = PieChartModel(name: 'total_earning', amount: data.earningChartData!.totalEarnings!);
        earningChartData.add(bonuseEarning);
        earningChartData.add(tipsEarning);
        earningChartData.add(extraShiftEarning);
        earningChartData.add(totalEarning);

        emit(state.copyWith(model: data, earningPieChart: earningChartData, status: AnalyticsStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AnalyticsStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AnalyticsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
