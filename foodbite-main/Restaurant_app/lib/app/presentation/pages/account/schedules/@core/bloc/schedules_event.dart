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

part of 'schedules_bloc.dart';

sealed class SchedulesEvent {}

final class SchedulesInitialEvent extends SchedulesEvent {}

final class ScheduleAddTimeSlotEvent extends SchedulesEvent {
  final int dayIndex;
  final String startTime;
  final String endTime;
  ScheduleAddTimeSlotEvent({required this.dayIndex, required this.startTime, required this.endTime});
}

final class ScheduleDeleteTimeSlotEvent extends SchedulesEvent {
  final int dayIndex;
  final int slotIndex;
  ScheduleDeleteTimeSlotEvent({required this.dayIndex, required this.slotIndex});
}

final class ScheduleEditTimeSlotEvent extends SchedulesEvent {
  final int dayIndex;
  final int slotIndex;
  final String startTime;
  final String endTime;
  ScheduleEditTimeSlotEvent({required this.dayIndex, required this.slotIndex, required this.startTime, required this.endTime});
}

final class ScheduleSubmitEvent extends SchedulesEvent {}
