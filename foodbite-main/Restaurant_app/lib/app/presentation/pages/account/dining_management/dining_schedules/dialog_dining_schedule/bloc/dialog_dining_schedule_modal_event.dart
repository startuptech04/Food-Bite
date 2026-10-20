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

part of 'dialog_dining_schedule_modal_bloc.dart';

sealed class DialogDiningScheduleModalEvent {}

final class DialogDiningScheduleModalInitialEvent extends DialogDiningScheduleModalEvent {
  final bool isNew;
  final String dayName;
  final String type;
  final String time;
  DialogDiningScheduleModalInitialEvent(this.isNew, this.dayName, this.type, this.time);
}

final class DialogDiningScheduleTypeChangeEvent extends DialogDiningScheduleModalEvent {
  final DiningScheduleMealTypeModel type;
  DialogDiningScheduleTypeChangeEvent({required this.type});
}

final class DialogDiningScheduleTimePickerChanged extends DialogDiningScheduleModalEvent {
  final String time;
  DialogDiningScheduleTimePickerChanged({required this.time});
}

final class DialogDiningScheduleTimePickerUnfocused extends DialogDiningScheduleModalEvent {}

final class DialogDiningScheduleModalSubmitEvent extends DialogDiningScheduleModalEvent {}
