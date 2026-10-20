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
import 'package:user/app/core/models/payment_list_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:user/app/core/repositories/auth_repository.dart';

part 'payment_modal_event.dart';
part 'payment_modal_state.dart';

class PaymentModalBloc extends Bloc<PaymentModalEvent, PaymentModalState> {
  final AuthRepository _authRepository = AuthRepository();
  PaymentModalBloc() : super(const PaymentModalState()) {
    on<PaymentModalInitialEvent>(_onPaymentModalInitialEvent);
  }

  FutureOr<void> _onPaymentModalInitialEvent(PaymentModalInitialEvent event, Emitter<PaymentModalState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "payment_list"}, 'payment_list_screen', 'payment_list_screen');
      List<dynamic> jsonList = jsonDecode(event.paymentList);
      final String locale = await _authRepository.getLocale();
      List<PaymentListModel> modelList = jsonList.map((json) => PaymentListModel.fromJson(json, locale.toString())).toList();
      emit(state.copyWith(paymentList: modelList, status: PaymentModalStatus.success));
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PaymentModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
