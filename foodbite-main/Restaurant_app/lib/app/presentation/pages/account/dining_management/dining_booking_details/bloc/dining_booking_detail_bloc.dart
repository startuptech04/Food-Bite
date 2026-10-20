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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/dining_booking_call_customer_response_model.dart';
import 'package:vendor/app/core/models/dining_booking_information_response_model.dart';
import 'package:vendor/app/core/models/request/accept_dining_booking_request_model.dart';
import 'package:vendor/app/core/models/request/reject_dining_booking_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/dining_booking_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_booking_detail_event.dart';
part 'dining_booking_detail_state.dart';

class DiningBookingDetailBloc extends Bloc<DiningBookingDetailEvent, DiningBookingDetailState> {
  final DiningBookingRepository _diningBookingRepository = DiningBookingRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningBookingDetailBloc() : super(DiningBookingDetailState(model: DiningBookingInformationResponseModel(locale: ''))) {
    on<DiningBookingDetailInitialEvent>(_onDiningBookingDetailInitialEvent);
    on<DiningBookingDetailRejectEvent>(_onDiningBookingDetailRejectEvent);
    on<DiningBookingDetailAcceptEvent>(_onDiningBookingDetailAcceptEvent);
    on<DiningBookingDetailCallCustomerEvent>(_onDiningBookingDetailCallCustomerEvent);
  }

  FutureOr<void> _onDiningBookingDetailInitialEvent(DiningBookingDetailInitialEvent event, Emitter<DiningBookingDetailState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_booking_detail"}, 'dining_booking_detail_screen', 'dining_booking_detail_screen');
      emit(state.copyWith(status: DiningBookingDetailStatus.loading, bookingId: event.bookingId));
      final String vendorId = await _diningBookingRepository.getVendorId();
      DioApiResponse response = await _diningBookingRepository.getDiningBookingInformation(event.bookingId, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningBookingInformationResponseModel data = DiningBookingInformationResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: DiningBookingDetailStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningBookingDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningBookingDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningBookingDetailRejectEvent(DiningBookingDetailRejectEvent event, Emitter<DiningBookingDetailState> emit) async {
    try {
      emit(state.copyWith(status: DiningBookingDetailStatus.reject));
      final String vendorId = await _diningBookingRepository.getVendorId();
      final String bookingId = state.bookingId;
      RejectDiningBookingRequestModel param = RejectDiningBookingRequestModel(vendorId: vendorId, bookingId: bookingId, reasonId: event.reasonId);
      DioApiResponse response = await _diningBookingRepository.rejectDiningBooking(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: DiningBookingDetailStatus.rejectSuccess));
        } else {
          emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningBookingDetailAcceptEvent(DiningBookingDetailAcceptEvent event, Emitter<DiningBookingDetailState> emit) async {
    try {
      emit(state.copyWith(status: DiningBookingDetailStatus.accept));
      final String vendorId = await _diningBookingRepository.getVendorId();
      final String bookingId = state.bookingId;
      AcceptDiningBookingRequestModel param = AcceptDiningBookingRequestModel(bookingId: bookingId, vendorId: vendorId);
      DioApiResponse response = await _diningBookingRepository.acceptDiningBooking(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: DiningBookingDetailStatus.acceptSuccess));
        } else {
          emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningBookingDetailCallCustomerEvent(DiningBookingDetailCallCustomerEvent event, Emitter<DiningBookingDetailState> emit) async {
    try {
      emit(state.copyWith(status: DiningBookingDetailStatus.callCustomer));
      final String vendorId = await _diningBookingRepository.getVendorId();
      final String bookingId = state.bookingId;
      DioApiResponse response = await _diningBookingRepository.diningBookingCallCustomer(bookingId, vendorId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          DiningBookingCallCustomerResponseModel callNumber = DiningBookingCallCustomerResponseModel.fromJson(myMap);
          if (callNumber.details!.userCountryCode!.isNotEmpty && callNumber.details!.userContact!.isNotEmpty) {
            emit(state.copyWith(status: DiningBookingDetailStatus.callCustomerSuccess));
            final Uri numberLaunchUri = Uri(scheme: 'tel', path: '${callNumber.details!.userCountryCode!}${callNumber.details!.userContact!}');
            launchUrl(numberLaunchUri);
          }
        } else {
          emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningBookingDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
