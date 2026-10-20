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

import 'package:bloc/bloc.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';

part 'subscription_package_payment_event.dart';
part 'subscription_package_payment_state.dart';

class SubscriptionPackagePaymentBloc extends Bloc<SubscriptionPackagePaymentEvent, SubscriptionPackagePaymentState> {
  final AccountRepository _accountRepository = AccountRepository();
  SubscriptionPackagePaymentBloc() : super(const SubscriptionPackagePaymentState()) {
    on<SubscriptionPackagePaymentInitialEvent>(_onSubscriptionPackagePaymentInitialEvent);
    on<SubscriptionPackagePaymentResponseEvent>(_onSubscriptionPackagePaymentResponseEvent);
  }

  FutureOr<void> _onSubscriptionPackagePaymentInitialEvent(SubscriptionPackagePaymentInitialEvent event, Emitter<SubscriptionPackagePaymentState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "make_payment_subscription_packages"}, 'make_payment_subscription_packages_screen', 'make_payment_subscription_packages_screen');
    emit(state.copyWith(status: SubscriptionPackagePaymentStatus.initial));
  }

  FutureOr<void> _onSubscriptionPackagePaymentResponseEvent(SubscriptionPackagePaymentResponseEvent event, Emitter<SubscriptionPackagePaymentState> emit) async {
    emit(state.copyWith(status: SubscriptionPackagePaymentStatus.success));
  }
}
