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

part of 'tiffin_subscription_request_off_days_modal_bloc.dart';

sealed class TiffinSubscriptionRequestOffDaysModalEvent {}

final class TiffinSubscriptionRequestOffDaysModalInitialEvent extends TiffinSubscriptionRequestOffDaysModalEvent {
  final String purchaseId;
  final List<String> requestedOffDates;
  final List<String> offDays;
  final int totalOrders;
  TiffinSubscriptionRequestOffDaysModalInitialEvent({required this.purchaseId, required this.requestedOffDates, required this.offDays, required this.totalOrders});
}

final class TiffinSubscriptionRequestOffDaysModalSelectedDateEvent extends TiffinSubscriptionRequestOffDaysModalEvent {
  final DateTime date;
  TiffinSubscriptionRequestOffDaysModalSelectedDateEvent({required this.date});
}

final class TiffinSubscriptionRequestOffDaySubmitEvent extends TiffinSubscriptionRequestOffDaysModalEvent {}
