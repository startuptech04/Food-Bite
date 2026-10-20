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

part of 'history_detail_bloc.dart';

sealed class HistoryDetailEvent {}

final class HistoryDetailInitialEvent extends HistoryDetailEvent {
  final String id;
  HistoryDetailInitialEvent({required this.id});
}

final class HistoryDetailRepayOrderEvent extends HistoryDetailEvent {}

final class HistoryDetailCancelMyOrderEvent extends HistoryDetailEvent {
  final String reasonId;
  HistoryDetailCancelMyOrderEvent({required this.reasonId});
}

final class HistoryDetailOpenSettingEvent extends HistoryDetailEvent {}

final class HistoryDetailDirectionEvent extends HistoryDetailEvent {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;
  HistoryDetailDirectionEvent({required this.startLatitude, required this.startLongitude, required this.endLatitude, required this.endLongitude});
}

final class HistoryDetailFavouriteEvent extends HistoryDetailEvent {}

final class HistoryDetailReviewSavedEvent extends HistoryDetailEvent {}

final class HistoryDetailPaymentChangedEvent extends HistoryDetailEvent {
  final String id;
  HistoryDetailPaymentChangedEvent({required this.id});
}

final class HistoryDetailCallRestaurantEvent extends HistoryDetailEvent {}

final class HistoryDetailCallDriverEvent extends HistoryDetailEvent {}

final class HistoryDetailNewDeliverymanLocation extends HistoryDetailEvent {
  final double latitude;
  final double longitude;
  HistoryDetailNewDeliverymanLocation({required this.latitude, required this.longitude});
}
