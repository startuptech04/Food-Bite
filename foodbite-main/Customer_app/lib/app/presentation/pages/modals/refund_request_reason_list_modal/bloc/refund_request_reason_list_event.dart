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

part of 'refund_request_reason_list_bloc.dart';

sealed class RefundRequestReasonListEvent {}

final class RefundRequestReasonListInitialEvent extends RefundRequestReasonListEvent {}

final class RefundRequestReasonSelectEvent extends RefundRequestReasonListEvent {
  final String id;
  RefundRequestReasonSelectEvent({required this.id});
}
