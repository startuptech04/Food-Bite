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

part of 'schedular_time_picker_modal_bloc.dart';

sealed class SchedularTimePickerModalEvent {}

final class SchedularTimePickerInitialEvent extends SchedularTimePickerModalEvent {
  final bool isNew;
  final String startTime;
  final String endTime;
  SchedularTimePickerInitialEvent({required this.isNew, required this.startTime, required this.endTime});
}

final class StartTimePickerChanged extends SchedularTimePickerModalEvent {
  final String time;
  StartTimePickerChanged({required this.time});
}

final class StartTimePickerUnfocused extends SchedularTimePickerModalEvent {}

final class EndTimePickerChanged extends SchedularTimePickerModalEvent {
  final String time;
  EndTimePickerChanged({required this.time});
}

final class EndTimePickerUnfocused extends SchedularTimePickerModalEvent {}

final class ScheduleFormSubmitted extends SchedularTimePickerModalEvent {}
