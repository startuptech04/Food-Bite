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

part of 'make_payments_subscription_package_bloc.dart';

sealed class MakePaymentsSubscriptionPackageEvent {}

final class MakePaymentsSubscriptionPackageInitialEvent extends MakePaymentsSubscriptionPackageEvent {
  final String paymentId;
  MakePaymentsSubscriptionPackageInitialEvent({required this.paymentId});
}

final class MakePaymentsSubscriptionPackageResponseEvent extends MakePaymentsSubscriptionPackageEvent {}
