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
  const BottomTabNavigationState({this.tabIndex = 0, this.canActivate = true});

  BottomTabNavigationState copyWith({int? tabIndex, bool? canActivate}) {
    return BottomTabNavigationState(tabIndex: tabIndex ?? this.tabIndex, canActivate: canActivate ?? this.canActivate);
  }
}
