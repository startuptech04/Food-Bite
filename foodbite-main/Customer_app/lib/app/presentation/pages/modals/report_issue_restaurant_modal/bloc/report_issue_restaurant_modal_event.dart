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

part of 'report_issue_restaurant_modal_bloc.dart';

sealed class ReportIssueRestaurantModalEvent {}

final class ReportIssueRestaurantModalInitialEvent extends ReportIssueRestaurantModalEvent {
  final String id;
  ReportIssueRestaurantModalInitialEvent({required this.id});
}

final class ReportIssueRestaurantModalSelectReasonEvent extends ReportIssueRestaurantModalEvent {
  final String id;
  final String name;
  ReportIssueRestaurantModalSelectReasonEvent({required this.id, required this.name});
}

final class ReportIssueRestaurantReSelectEvent extends ReportIssueRestaurantModalEvent {}

final class ReportIssueRestaurantMessageChangedEvent extends ReportIssueRestaurantModalEvent {
  final String message;
  ReportIssueRestaurantMessageChangedEvent({required this.message});
}

final class ReportIssueRestaurantMessageUnfocusedEvent extends ReportIssueRestaurantModalEvent {}

final class ReportIssueRestaurantSubmitEvent extends ReportIssueRestaurantModalEvent {}
