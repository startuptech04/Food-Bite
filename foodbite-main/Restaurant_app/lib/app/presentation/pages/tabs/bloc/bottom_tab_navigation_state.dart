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

part of 'bottom_tab_navigation_bloc.dart';

final class BottomTabNavigationState {
  final int tabIndex;
  final bool canActivate;
  final bool isSubscriptionExpired;
  final String subscriptionExpiredDate;
  final String subscriptionName;
  const BottomTabNavigationState({
    this.tabIndex = 0,
    this.canActivate = true,
    this.isSubscriptionExpired = false,
    this.subscriptionExpiredDate = '',
    this.subscriptionName = '',
  });

  BottomTabNavigationState copyWith({
    int? tabIndex,
    bool? canActivate,
    bool? isSubscriptionExpired,
    String? subscriptionExpiredDate,
    String? subscriptionName,
  }) {
    return BottomTabNavigationState(
      tabIndex: tabIndex ?? this.tabIndex,
      canActivate: canActivate ?? this.canActivate,
      isSubscriptionExpired: isSubscriptionExpired ?? this.isSubscriptionExpired,
      subscriptionExpiredDate: subscriptionExpiredDate ?? this.subscriptionExpiredDate,
      subscriptionName: subscriptionName ?? this.subscriptionName,
    );
  }
}
