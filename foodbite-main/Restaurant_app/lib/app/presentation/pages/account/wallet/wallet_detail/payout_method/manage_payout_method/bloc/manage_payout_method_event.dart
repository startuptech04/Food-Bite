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

part of 'manage_payout_method_bloc.dart';

sealed class ManagePayoutMethodEvent {}

final class ManagePayoutMethodInitialEvent extends ManagePayoutMethodEvent {
  final bool isNew;
  final String id;
  ManagePayoutMethodInitialEvent({required this.isNew, required this.id});
}

final class ManagePayoutMethodChangeEvent extends ManagePayoutMethodEvent {
  final String methodId;
  ManagePayoutMethodChangeEvent({required this.methodId});
}

final class ManagePayoutMethodTextInputChangeEvent extends ManagePayoutMethodEvent {
  final int formIndex;
  final String value;
  ManagePayoutMethodTextInputChangeEvent({required this.formIndex, required this.value});
}

final class ManagePayoutMethodCountryCodeChangeEvent extends ManagePayoutMethodEvent {
  final int formIndex;
  final String value;
  ManagePayoutMethodCountryCodeChangeEvent({required this.formIndex, required this.value});
}

final class ManagePayoutMethodSubmitEvent extends ManagePayoutMethodEvent {}
