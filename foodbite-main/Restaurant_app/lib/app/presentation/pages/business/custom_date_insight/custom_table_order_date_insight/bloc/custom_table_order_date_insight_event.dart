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

part of 'custom_table_order_date_insight_bloc.dart';

sealed class CustomTableOrderDateInsightEvent {}

final class CustomTableOrderDateInsightInitialEvent extends CustomTableOrderDateInsightEvent {}

final class CustomTableOrderDateInsightStartDateChangedEvent extends CustomTableOrderDateInsightEvent {
  final String date;
  CustomTableOrderDateInsightStartDateChangedEvent({required this.date});
}

final class CustomTableOrderDateInsightStartDateUnfocusedEvent extends CustomTableOrderDateInsightEvent {}

final class CustomTableOrderDateInsightEndDateChangedEvent extends CustomTableOrderDateInsightEvent {
  final String date;
  CustomTableOrderDateInsightEndDateChangedEvent({required this.date});
}

final class CustomTableOrderDateInsightEndDateUnfocusedEvent extends CustomTableOrderDateInsightEvent {}

final class CustomTableOrderDateInsightDateSubmitEvent extends CustomTableOrderDateInsightEvent {}
