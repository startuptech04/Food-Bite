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

part of 'dining_booking_refund_reason_list_modal_bloc.dart';

sealed class DiningBookingRefundReasonListModalEvent {}

final class DiningBookingRefundReasonListModalInitialEvent extends DiningBookingRefundReasonListModalEvent {}

final class DiningBookingRefundReasonListModalReasonSelectEvent extends DiningBookingRefundReasonListModalEvent {
  final String id;
  DiningBookingRefundReasonListModalReasonSelectEvent({required this.id});
}
