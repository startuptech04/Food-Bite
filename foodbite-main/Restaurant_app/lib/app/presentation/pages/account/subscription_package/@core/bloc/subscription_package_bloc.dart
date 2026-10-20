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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/renew_subscription_payment_response_model.dart';
import 'package:vendor/app/core/models/request/renew_subscription_package_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/subscription_package_info_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'subscription_package_event.dart';
part 'subscription_package_state.dart';

class SubscriptionPackageBloc extends Bloc<SubscriptionPackageEvent, SubscriptionPackageState> {
  final AccountRepository _accountRepository = AccountRepository();
  SubscriptionPackageBloc() : super(SubscriptionPackageState(model: SubscriptionPackageInfoModel(locale: ''))) {
    on<SubscriptionPackageInitialEvent>(_onSubscriptionPackageInitialEvent);
    on<SubscriptionPackagePaymentChangedEvent>(_onSubscriptionPackagePaymentChangedEvent);
    on<SubscriptionPackageMakePaymentEvent>(_onSubscriptionPackageMakePaymentEvent);
  }

  FutureOr<void> _onSubscriptionPackageInitialEvent(SubscriptionPackageInitialEvent event, Emitter<SubscriptionPackageState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "subscription_packages"}, 'subscription_packages_screen', 'subscription_packages_screen');
      emit(state.copyWith(status: SubscriptionPackageStatus.loading));
      DioApiResponse response = await _accountRepository.getSubscriptionInfo();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          SubscriptionPackageInfoModel data = SubscriptionPackageInfoModel.fromJson(myMap, locale.toString());
          String paymentId = '';
          String paymentName = '';
          String paymentImageUrl = '';

          if (data.primary != null && data.primary!.name!.isNotEmpty) {
            paymentId = data.primary!.id!;
            paymentName = data.primary!.name!;
            paymentImageUrl = data.primary!.image!;
          } else if (data.payments!.isNotEmpty) {
            paymentId = data.payments![0].id!;
            paymentName = data.payments![0].name!;
            paymentImageUrl = data.payments![0].image!;
          }

          emit(state.copyWith(status: SubscriptionPackageStatus.success, model: data, payment: paymentId, paymentName: paymentName, paymentImageURL: paymentImageUrl));
        } else {
          emit(state.copyWith(status: SubscriptionPackageStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SubscriptionPackageStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SubscriptionPackageStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSubscriptionPackagePaymentChangedEvent(SubscriptionPackagePaymentChangedEvent event, Emitter<SubscriptionPackageState> emit) async {
    final int index = state.model.payments!.indexWhere((element) => element.id == event.id);
    if (index != -1) {
      String paymentId = state.model.payments![index].id!;
      String paymentName = state.model.payments![index].name!;
      String paymentImageUrl = state.model.payments![index].image!;
      emit(state.copyWith(payment: paymentId, paymentName: paymentName, paymentImageURL: paymentImageUrl, status: SubscriptionPackageStatus.success));
    }
  }

  FutureOr<void> _onSubscriptionPackageMakePaymentEvent(SubscriptionPackageMakePaymentEvent event, Emitter<SubscriptionPackageState> emit) async {
    try {
      emit(state.copyWith(status: SubscriptionPackageStatus.fetchingPaymentLink));
      final String userId = await _accountRepository.userId();
      RenewSubscriptionPackageRequestModel param = RenewSubscriptionPackageRequestModel(user: userId, payment: state.payment, subscriber: state.model.info!.id!, packageId: state.model.info!.subscriptionInfo!.id!);
      DioApiResponse response = await _accountRepository.renewSubscriptionPackage(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        RenewSubscriptionPaymentResponseModel paymentResponse = RenewSubscriptionPaymentResponseModel.fromJson(myMap);
        emit(state.copyWith(status: SubscriptionPackageStatus.paymentLinkFetched, paymentLinkId: paymentResponse.payLink!));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SubscriptionPackageStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SubscriptionPackageStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
