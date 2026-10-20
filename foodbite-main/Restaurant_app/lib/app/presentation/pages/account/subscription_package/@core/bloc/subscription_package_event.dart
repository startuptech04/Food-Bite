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

part of 'subscription_package_bloc.dart';

sealed class SubscriptionPackageEvent {}

final class SubscriptionPackageInitialEvent extends SubscriptionPackageEvent {}

final class SubscriptionPackagePaymentChangedEvent extends SubscriptionPackageEvent {
  final String id;
  SubscriptionPackagePaymentChangedEvent({required this.id});
}

final class SubscriptionPackageMakePaymentEvent extends SubscriptionPackageEvent {}
