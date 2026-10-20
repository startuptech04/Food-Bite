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

part of 'report_emergency_bloc.dart';

sealed class ReportEmergencyEvent {}

final class ReportEmergencyInitialEvent extends ReportEmergencyEvent {}

final class ReportEmergencyFormNameChangedEvent extends ReportEmergencyEvent {
  final String name;
  ReportEmergencyFormNameChangedEvent({required this.name});
}

final class ReportEmergencyFormNameUnfocusedEvent extends ReportEmergencyEvent {}

final class ReportEmergencyFormCountryCodeChangedEvent extends ReportEmergencyEvent {
  final String flag;
  final String countryCode;
  ReportEmergencyFormCountryCodeChangedEvent({required this.flag, required this.countryCode});
}

final class ReportEmergencyFormNumberChangedEvent extends ReportEmergencyEvent {
  final String number;
  ReportEmergencyFormNumberChangedEvent({required this.number});
}

final class ReportEmergencyFormNumberUnfocusedEvent extends ReportEmergencyEvent {}

final class ReportEmergencyFormEmailChangedEvent extends ReportEmergencyEvent {
  final String email;
  ReportEmergencyFormEmailChangedEvent({required this.email});
}

final class ReportEmergencyFormEmailUnfocusedEvent extends ReportEmergencyEvent {}

final class ReportEmergencyFormDescriptionChangedEvent extends ReportEmergencyEvent {
  final String text;
  ReportEmergencyFormDescriptionChangedEvent({required this.text});
}

final class ReportEmergencyFormDescriptionUnfocusedEvent extends ReportEmergencyEvent {}

final class ReportEmergecyFormSelectQueryEvent extends ReportEmergencyEvent {
  final String report;
  ReportEmergecyFormSelectQueryEvent({required this.report});
}

final class ReportEmergencyFormSubmitEvent extends ReportEmergencyEvent {}
