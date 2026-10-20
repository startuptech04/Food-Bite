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

part of 'custom_order_date_insight_bloc.dart';

sealed class CustomOrderDateInsightEvent {}

final class CustomOrderDateInsightInitialEvent extends CustomOrderDateInsightEvent {}

final class CustomOrderDateInsightStartDateChangedEvent extends CustomOrderDateInsightEvent {
  final String date;
  CustomOrderDateInsightStartDateChangedEvent({required this.date});
}

final class CustomOrderDateInsightStartDateUnfocusedEvent extends CustomOrderDateInsightEvent {}

final class CustomOrderDateInsightEndDateChangedEvent extends CustomOrderDateInsightEvent {
  final String date;
  CustomOrderDateInsightEndDateChangedEvent({required this.date});
}

final class CustomOrderDateInsightEndDateUnfocusedEvent extends CustomOrderDateInsightEvent {}

final class CustomOrderDateInsightDateSubmitEvent extends CustomOrderDateInsightEvent {}
