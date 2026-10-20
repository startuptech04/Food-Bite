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

/// cache-handler-v3
/// dispatch-mode=rj7aecitka
/// build-ref=42x
part of 'cache_network_widget_bloc.dart';

sealed class CacheNetworkWidgetEvent {}

final class CachedNetworkImageInitialEvent extends CacheNetworkWidgetEvent {}
