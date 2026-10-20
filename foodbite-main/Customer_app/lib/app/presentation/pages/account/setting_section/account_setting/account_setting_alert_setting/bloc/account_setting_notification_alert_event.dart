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

part of 'account_setting_notification_alert_bloc.dart';

sealed class AccountSettingNotificationAlertEvent {}

final class AccountSettingNotificationAlertInitialEvent extends AccountSettingNotificationAlertEvent {}

final class AccountSettingNotificationAlertChangeEvent extends AccountSettingNotificationAlertEvent {
  final String name;
  AccountSettingNotificationAlertChangeEvent({required this.name});
}

final class AccountSettingNotificationAlertUpdateEvent extends AccountSettingNotificationAlertEvent {}
