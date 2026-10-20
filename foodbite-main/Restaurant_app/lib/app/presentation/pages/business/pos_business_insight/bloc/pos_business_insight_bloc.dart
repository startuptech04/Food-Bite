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
import 'package:vendor/app/core/models/pos_business_insight_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'pos_business_insight_event.dart';
part 'pos_business_insight_state.dart';

class PosBusinessInsightBloc extends Bloc<PosBusinessInsightEvent, PosBusinessInsightState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PosBusinessInsightBloc() : super(PosBusinessInsightState(model: PosBusinessInsightModel(locale: ''))) {
    on<PosBusinessInsightInitialEvent>(_onPosBusinessInsightInitialEvent);
    on<PosBusinessInsightUnitChangeEvent>(_onPosBusinessInsightUnitChangeEvent);
  }

  FutureOr<void> _onPosBusinessInsightInitialEvent(PosBusinessInsightInitialEvent event, Emitter<PosBusinessInsightState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "pos_order_business_insight"}, 'pos_order_business_insight_screen', 'pos_order_business_insight_screen');
      emit(state.copyWith(status: PosBusinessInsightStatus.loading, unit: 'month'));
      DioApiResponse response = await _orderRepository.posBusinessInsight();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PosBusinessInsightModel data = PosBusinessInsightModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: PosBusinessInsightStatus.success, model: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PosBusinessInsightStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PosBusinessInsightStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPosBusinessInsightUnitChangeEvent(PosBusinessInsightUnitChangeEvent event, Emitter<PosBusinessInsightState> emit) async {
    emit(state.copyWith(unit: event.unit, status: PosBusinessInsightStatus.success));
  }
}
