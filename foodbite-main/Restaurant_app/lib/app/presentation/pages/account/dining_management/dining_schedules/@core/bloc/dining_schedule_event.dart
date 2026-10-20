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

part of 'dining_schedule_bloc.dart';

sealed class DiningScheduleEvent {}

final class DiningScheduleInitialEvent extends DiningScheduleEvent {}

final class DiningScheduleAddTimeSlotEvent extends DiningScheduleEvent {
  final int dayIndex;
  final String type;
  final String time;
  DiningScheduleAddTimeSlotEvent({required this.dayIndex, required this.type, required this.time});
}

final class DiningScheduleDeleteTimeSlotEvent extends DiningScheduleEvent {
  final int slotIndex;
  final int mealIndex;
  DiningScheduleDeleteTimeSlotEvent({required this.slotIndex, required this.mealIndex});
}

final class DiningScheduleEditTimeSlotEvent extends DiningScheduleEvent {
  final int slotIndex;
  final int mealIndex;
  final String type;
  final String time;
  DiningScheduleEditTimeSlotEvent({required this.slotIndex, required this.mealIndex, required this.type, required this.time});
}

final class DiningScheduleSaveEvent extends DiningScheduleEvent {}
