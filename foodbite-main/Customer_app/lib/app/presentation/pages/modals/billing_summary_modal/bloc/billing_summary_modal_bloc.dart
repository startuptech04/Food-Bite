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
import 'package:user/app/core/models/order_settings_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:user/app/core/repositories/auth_repository.dart';

part 'billing_summary_modal_event.dart';
part 'billing_summary_modal_state.dart';

class BillingSummaryModalBloc extends Bloc<BillingSummaryModalEvent, BillingSummaryModalState> {
  final AuthRepository _authRepository = AuthRepository();
  BillingSummaryModalBloc() : super(const BillingSummaryModalState()) {
    on<BillingSummaryModalInitialEvent>(_onBillingSummaryModalInitialEvent);
    on<BillingSummaryModalDeliveryGratitudeEvent>(_onBillingSummaryModalDeliveryGratitudeEvent);
  }

  FutureOr<void> _onBillingSummaryModalInitialEvent(BillingSummaryModalInitialEvent event, Emitter<BillingSummaryModalState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "billing_summary"}, 'billing_summary_screen', 'billing_summary_screen');
      List<dynamic> jsonList = jsonDecode(event.deliveryGratitude);
      List<GratitudesConfigModel> modelList = jsonList.map((json) => GratitudesConfigModel.fromJson(json)).toList();
      emit(
        state.copyWith(
          orderTo: event.orderTo,
          realTotal: event.realTotal,
          itemDiscount: event.itemDiscount,
          itemTotal: event.itemTotal,
          couponDiscount: event.couponDiscount,
          couponCode: event.couponCode,
          walletAmount: event.walletAmount,
          serviceCharge: event.serviceCharge,
          serviceChargeName: event.serviceChargeName,
          foodServiceCharge: event.foodServiceCharge,
          foodServiceChargeName: event.foodServiceChargeName,
          gratitudeList: modelList,
          deliveryTip: event.deliveryTip,
          extraCharge: event.extraCharge,
          deliveryCharge: event.deliveryCharge,
          packagingCharges: event.packagingCharges,
          packagingChargesTax: event.packagingChargesTax,
          grandTotal: event.grandTotal,
          status: BillingSummaryModalStatus.success,
        ),
      );
    } catch (e, stacktrace) {
      emit(state.copyWith(status: BillingSummaryModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onBillingSummaryModalDeliveryGratitudeEvent(BillingSummaryModalDeliveryGratitudeEvent event, Emitter<BillingSummaryModalState> emit) async {
    if (state.deliveryTip <= 0) {
      emit(state.copyWith(deliveryTip: event.tip));
    } else if (state.deliveryTip == event.tip) {
      emit(state.copyWith(deliveryTip: 0));
    } else {
      emit(state.copyWith(deliveryTip: event.tip));
    }
    emit(state.copyWith(status: BillingSummaryModalStatus.success, grandTotal: calculateGrandTotal()));
  }

  double calculateGrandTotal() {
    double grandTotal = 0.0;
    final double itemTotal = double.parse(state.itemTotal.toString());
    final double deliveryCharge = double.parse(state.deliveryCharge.toString());
    final double taxCharge = double.parse(state.foodServiceCharge.toString());
    final double serviceCharge = double.parse(state.serviceCharge.toString());
    final double packagingCharges = double.parse(state.packagingCharges.toString());
    final double packagingChargesTax = double.parse(state.packagingChargesTax.toString());
    final double deliveryTipCharge = double.parse(state.deliveryTip.toString());
    final double couponDiscount = double.parse(state.couponDiscount.toString());
    final double walletAmount = double.parse(state.walletAmount.toString());
    String total = (itemTotal + deliveryCharge + taxCharge + serviceCharge + packagingCharges + packagingChargesTax + deliveryTipCharge).toStringAsFixed(2);
    double subTotal = double.parse(total);
    String grandCount = (subTotal - couponDiscount - walletAmount).toStringAsFixed(2);
    grandTotal = double.parse(grandCount);
    return grandTotal;
  }
}
