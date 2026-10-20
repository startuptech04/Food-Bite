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

part of 'feeds_bloc.dart';

sealed class FeedsEvent {}

final class FeedsInitialEvent extends FeedsEvent {}

final class FeedsGoOfflineEvent extends FeedsEvent {
  final String messageId;
  FeedsGoOfflineEvent({required this.messageId});
}

final class FeedsGoOnlineEvent extends FeedsEvent {}

final class FeedsRefreshLocationEvent extends FeedsEvent {}

final class FeedsLocationOpenSettingEvent extends FeedsEvent {}

final class FeedsChangeMapZoomLevelEvent extends FeedsEvent {
  final String action;
  FeedsChangeMapZoomLevelEvent({required this.action});
}

final class FeedsNewOrderNotificationEvent extends FeedsEvent {}

final class FeedsCheckNotificationEvent extends FeedsEvent {}

final class FeedsFetchActiveOrderEvent extends FeedsEvent {}

final class FeedsRestaurantDirectionEvent extends FeedsEvent {
  final int restaurantIndex;
  FeedsRestaurantDirectionEvent({required this.restaurantIndex});
}
