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

part of 'custom_pos_date_insight_bloc.dart';

sealed class CustomPosDateInsightEvent {}

final class CustomPosDateInsightInitialEvent extends CustomPosDateInsightEvent {}

final class CustomPosDateInsightStartDateChangedEvent extends CustomPosDateInsightEvent {
  final String date;
  CustomPosDateInsightStartDateChangedEvent({required this.date});
}

final class CustomPosDateInsightStartDateUnfocusedEvent extends CustomPosDateInsightEvent {}

final class CustomPosDateInsightEndDateChangedEvent extends CustomPosDateInsightEvent {
  final String date;
  CustomPosDateInsightEndDateChangedEvent({required this.date});
}

final class CustomPosDateInsightEndDateUnfocusedEvent extends CustomPosDateInsightEvent {}

final class CustomPosDateInsightDateSubmitEvent extends CustomPosDateInsightEvent {}
