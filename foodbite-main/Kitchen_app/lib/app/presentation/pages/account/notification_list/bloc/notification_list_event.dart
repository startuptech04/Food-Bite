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

part of 'notification_list_bloc.dart';

sealed class NotificationListEvent {}

final class NotificationListInitialEvent extends NotificationListEvent {}

final class NotificationListReadAllEvent extends NotificationListEvent {}

final class NotificationListLoadMoreEvent extends NotificationListEvent {}

final class NotificationListPullRefreshEvent extends NotificationListEvent {}
