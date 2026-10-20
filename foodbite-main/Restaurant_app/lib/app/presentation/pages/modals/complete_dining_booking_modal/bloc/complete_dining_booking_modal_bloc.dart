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
import 'package:vendor/app/core/models/request/complete_dining_booking_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/dining_booking_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'complete_dining_booking_modal_event.dart';
part 'complete_dining_booking_modal_state.dart';

class CompleteDiningBookingModalBloc extends Bloc<CompleteDiningBookingModalEvent, CompleteDiningBookingModalState> {
  final DiningBookingRepository _diningBookingRepository = DiningBookingRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CompleteDiningBookingModalBloc() : super(const CompleteDiningBookingModalState()) {
    on<CompleteDiningBookingModalInitialEvent>(_onCompleteDiningBookingModalInitialEvent);
    on<CompleteDiningBookingModalBillingTotalChangedEvent>(_onCompleteDiningBookingModalBillingTotalChangedEvent);
    on<CompleteDiningBookingModalDiscountChangedEvent>(_onCompleteDiningBookingModalDiscountChangedEvent);
    on<CompleteDiningBookingModalDiscountTypeChangedEvent>(_onCompleteDiningBookingModalDiscountTypeChangedEvent);
    on<CompleteDiningBookingModalCouponPercentageChangeEvent>(_onCompleteDiningBookingModalCouponPercentageChangeEvent);
    on<CompleteDiningBookingModalCalculateBillingEvent>(_onCompleteDiningBookingModalCalculateBillingEvent);
    on<CompleteDiningBookingModalSubmitEvent>(_onCompleteDiningBookingModalSubmitEvent);
  }

  FutureOr<void> _onCompleteDiningBookingModalInitialEvent(CompleteDiningBookingModalInitialEvent event, Emitter<CompleteDiningBookingModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "complete_dining_booking"}, 'complete_dining_booking_screen', 'complete_dining_booking_screen');
    List<CompleteDiningBookingModalDiscountTypeModel> discountTypeList = <CompleteDiningBookingModalDiscountTypeModel>[];
    discountTypeList.clear();
    CompleteDiningBookingModalDiscountTypeModel percent = CompleteDiningBookingModalDiscountTypeModel(label: 'dd_percent_price', value: 'per');
    CompleteDiningBookingModalDiscountTypeModel amount = CompleteDiningBookingModalDiscountTypeModel(label: 'dd_amount_price', value: 'amount');
    discountTypeList.add(percent);
    discountTypeList.add(amount);
    emit(
      state.copyWith(
        bookingId: event.bookingId,
        userName: event.userName,
        bookingDate: event.bookingDate,
        contactNumber: event.contactNumber,
        couponCoverCharge: event.couponCoverCharge,
        grandTotal: event.grandTotal,
        couponId: event.couponId,
        couponCode: event.couponCode,
        couponDiscountType: event.couponDiscountType,
        couponMinDiscount: event.couponMinDiscount,
        couponMaxDiscount: event.couponMaxDiscount,
        couponSelectedPercentageDiscount: event.couponMinDiscount,
        discountTypeList: discountTypeList,
        discountType: 'per',
        status: CompleteDiningBookingModalStatus.initial,
      ),
    );
  }

  FutureOr<void> _onCompleteDiningBookingModalBillingTotalChangedEvent(CompleteDiningBookingModalBillingTotalChangedEvent event, Emitter<CompleteDiningBookingModalState> emit) async {
    if (event.total.isNotEmpty) {
      emit(state.copyWith(diningItemTotalAmount: double.parse(event.total), status: CompleteDiningBookingModalStatus.initial));
    } else {
      emit(state.copyWith(diningItemTotalAmount: 0, status: CompleteDiningBookingModalStatus.initial));
    }
    add(CompleteDiningBookingModalCalculateBillingEvent());
  }

  FutureOr<void> _onCompleteDiningBookingModalDiscountChangedEvent(CompleteDiningBookingModalDiscountChangedEvent event, Emitter<CompleteDiningBookingModalState> emit) async {
    if (event.discount.isNotEmpty) {
      emit(state.copyWith(diningItemDiscountValue: double.parse(event.discount), status: CompleteDiningBookingModalStatus.initial));
    } else {
      emit(state.copyWith(diningItemDiscountValue: 0, status: CompleteDiningBookingModalStatus.initial));
    }
    add(CompleteDiningBookingModalCalculateBillingEvent());
  }

  FutureOr<void> _onCompleteDiningBookingModalDiscountTypeChangedEvent(CompleteDiningBookingModalDiscountTypeChangedEvent event, Emitter<CompleteDiningBookingModalState> emit) async {
    emit(state.copyWith(discountType: event.value, status: CompleteDiningBookingModalStatus.initial));
    add(CompleteDiningBookingModalCalculateBillingEvent());
  }

  FutureOr<void> _onCompleteDiningBookingModalCouponPercentageChangeEvent(CompleteDiningBookingModalCouponPercentageChangeEvent event, Emitter<CompleteDiningBookingModalState> emit) async {
    emit(state.copyWith(couponSelectedPercentageDiscount: event.couponDiscountPercentage, status: CompleteDiningBookingModalStatus.initial));
    add(CompleteDiningBookingModalCalculateBillingEvent());
  }

  FutureOr<void> _onCompleteDiningBookingModalCalculateBillingEvent(CompleteDiningBookingModalCalculateBillingEvent event, Emitter<CompleteDiningBookingModalState> emit) async {
    if (state.diningItemTotalAmount > 0) {
      double discountAmount = 0;
      if (state.discountType == 'amount') {
        discountAmount = state.diningItemDiscountValue;
      } else {
        double percentage(numFirst, per) {
          return (numFirst / 100) * per;
        }

        String discountString = (double.parse(percentage(state.diningItemTotalAmount, state.diningItemDiscountValue).toString())).toStringAsFixed(2);
        discountAmount = double.parse(discountString);
      }
      double couponDiscountAmount = 0;
      if (state.couponId.isNotEmpty) {
        if (state.couponDiscountType == 'amount') {
          couponDiscountAmount = state.couponMinDiscount;
        } else {
          double percentage(numFirst, per) {
            return (numFirst / 100) * per;
          }

          String discountString = (double.parse(percentage(state.diningItemTotalAmount, state.couponSelectedPercentageDiscount).toString())).toStringAsFixed(2);
          couponDiscountAmount = double.parse(discountString);
        }
      }
      double totalDiscount = (discountAmount + couponDiscountAmount);
      String billingTotalString = (state.diningItemTotalAmount - totalDiscount).toStringAsFixed(2);
      double billingTotal = double.parse(billingTotalString);
      emit(state.copyWith(diningGrandTotalBillAmount: billingTotal, diningItemDiscountAmount: discountAmount, diningCouponDiscountAmount: couponDiscountAmount, status: CompleteDiningBookingModalStatus.initial));
    } else {
      emit(state.copyWith(diningGrandTotalBillAmount: 0, diningItemDiscountAmount: 0, diningCouponDiscountAmount: 0, status: CompleteDiningBookingModalStatus.initial));
    }
  }

  FutureOr<void> _onCompleteDiningBookingModalSubmitEvent(CompleteDiningBookingModalSubmitEvent event, Emitter<CompleteDiningBookingModalState> emit) async {
    try {
      emit(state.copyWith(status: CompleteDiningBookingModalStatus.complete));
      final String vendorId = await _diningBookingRepository.getVendorId();
      final String bookingId = state.bookingId;
      CompleteDiningBookingRequestModel param = CompleteDiningBookingRequestModel(
        vendorId: vendorId,
        bookingId: bookingId,
        itemTotal: state.diningItemTotalAmount,
        itemDiscount: state.diningItemDiscountAmount,
        couponDiscount: state.diningCouponDiscountAmount,
        billTotal: state.diningGrandTotalBillAmount,
      );
      DioApiResponse response = await _diningBookingRepository.completeDiningBooking(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: CompleteDiningBookingModalStatus.completeSuccess));
        } else {
          emit(state.copyWith(status: CompleteDiningBookingModalStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CompleteDiningBookingModalStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CompleteDiningBookingModalStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
