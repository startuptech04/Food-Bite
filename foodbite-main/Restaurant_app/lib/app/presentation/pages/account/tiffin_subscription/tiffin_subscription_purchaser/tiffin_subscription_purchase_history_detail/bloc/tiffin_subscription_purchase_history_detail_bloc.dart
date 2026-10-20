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
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/customer_call_number_response_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_purchase_history_detail_response_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/tiffin_subscription_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'tiffin_subscription_purchase_history_detail_event.dart';
part 'tiffin_subscription_purchase_history_detail_state.dart';

class TiffinSubscriptionPurchaseHistoryDetailBloc extends Bloc<TiffinSubscriptionPurchaseHistoryDetailEvent, TiffinSubscriptionPurchaseHistoryDetailState> {
  final TiffinSubscriptionRepository _tiffinSubscriptionRepository = TiffinSubscriptionRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TiffinSubscriptionPurchaseHistoryDetailBloc() : super(TiffinSubscriptionPurchaseHistoryDetailState(model: TiffinSubscriptionPurchaseHistoryDetailResponseModel(locale: ''))) {
    on<TiffinSubscriptionPurchaseHistoryDetailInitialEvent>(_onTiffinSubscriptionPurchaseHistoryDetailInitialEvent);
    on<TiffinSubscriptionPurchaseHistoryDetailCallEvent>(_onTiffinSubscriptionPurchaseHistoryDetailCallEvent);
  }

  FutureOr<void> _onTiffinSubscriptionPurchaseHistoryDetailInitialEvent(TiffinSubscriptionPurchaseHistoryDetailInitialEvent event, Emitter<TiffinSubscriptionPurchaseHistoryDetailState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "tiffin_purchase_detail"}, 'tiffin_purchase_detail_screen', 'tiffin_purchase_detail_screen');
      emit(state.copyWith(status: TiffinSubscriptionPurchaseHistoryDetailStatus.loading, purchaseId: event.purchaseId));
      DioApiResponse response = await _tiffinSubscriptionRepository.getPurchaseHistoryDetail(event.purchaseId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        TiffinSubscriptionPurchaseHistoryDetailResponseModel data = TiffinSubscriptionPurchaseHistoryDetailResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: TiffinSubscriptionPurchaseHistoryDetailStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionPurchaseHistoryDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TiffinSubscriptionPurchaseHistoryDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTiffinSubscriptionPurchaseHistoryDetailCallEvent(TiffinSubscriptionPurchaseHistoryDetailCallEvent event, Emitter<TiffinSubscriptionPurchaseHistoryDetailState> emit) async {
    try {
      emit(state.copyWith(status: TiffinSubscriptionPurchaseHistoryDetailStatus.callCustomer));
      DioApiResponse response = await _tiffinSubscriptionRepository.callCustomer(state.model.details!.userInfo!.id!);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        CustomerCallNumberResponseModel data = CustomerCallNumberResponseModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionPurchaseHistoryDetailStatus.callSuccess));
        if (data.countryCode!.isNotEmpty && data.mobile!.isNotEmpty) {
          final Uri numberLaunchUri = Uri(scheme: 'tel', path: '${data.countryCode!}${data.mobile!}');
          launchUrl(numberLaunchUri);
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionPurchaseHistoryDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TiffinSubscriptionPurchaseHistoryDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
