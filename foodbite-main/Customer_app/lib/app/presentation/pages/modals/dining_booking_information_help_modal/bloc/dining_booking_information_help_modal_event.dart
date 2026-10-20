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

part of 'dining_booking_information_help_modal_bloc.dart';

sealed class DiningBookingInformationHelpModalEvent {}

final class DiningBookingInformationHelpModalInitialEvent extends DiningBookingInformationHelpModalEvent {
  final String bookingId;
  final String bookingStatus;
  final String paymentMode;
  final bool refundRequestEnable;
  final String restaurant;
  final String payment;
  DiningBookingInformationHelpModalInitialEvent({required this.bookingId, required this.bookingStatus, required this.paymentMode, required this.refundRequestEnable, required this.restaurant, required this.payment});
}

final class DiningBookingInformationHelpModalRefundRequestEvent extends DiningBookingInformationHelpModalEvent {
  final String reasonId;
  DiningBookingInformationHelpModalRefundRequestEvent({required this.reasonId});
}

final class DiningBookingInformationHelpModalSummaryEvent extends DiningBookingInformationHelpModalEvent {}

final class DiningBookingInformationHelpModalInvoiceEvent extends DiningBookingInformationHelpModalEvent {}
