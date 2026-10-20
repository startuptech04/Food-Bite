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
import 'package:user/app/core/repositories/auth_repository.dart';

part 'make_payments_subscription_package_event.dart';
part 'make_payments_subscription_package_state.dart';

class MakePaymentsSubscriptionPackageBloc extends Bloc<MakePaymentsSubscriptionPackageEvent, MakePaymentsSubscriptionPackageState> {
  final AuthRepository _authRepository = AuthRepository();
  MakePaymentsSubscriptionPackageBloc() : super(const MakePaymentsSubscriptionPackageState()) {
    on<MakePaymentsSubscriptionPackageInitialEvent>(_onMakePaymentsSubscriptionPackageInitialEvent);
    on<MakePaymentsSubscriptionPackageResponseEvent>(_onMakePaymentsSubscriptionPackageResponseEvent);
  }

  FutureOr<void> _onMakePaymentsSubscriptionPackageInitialEvent(MakePaymentsSubscriptionPackageInitialEvent event, Emitter<MakePaymentsSubscriptionPackageState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "make_payment_tiffin_subscription_package"}, 'make_payment_tiffin_subscription_package_screen', 'make_payment_tiffin_subscription_package_screen');
    emit(state.copyWith(status: MakePaymentsSubscriptionPackageStatus.initial));
  }

  FutureOr<void> _onMakePaymentsSubscriptionPackageResponseEvent(MakePaymentsSubscriptionPackageResponseEvent event, Emitter<MakePaymentsSubscriptionPackageState> emit) async {
    emit(state.copyWith(status: MakePaymentsSubscriptionPackageStatus.success));
  }
}
