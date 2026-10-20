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

part of 'intro_bloc.dart';

sealed class IntroEvent {}

final class IntroInitialEvent extends IntroEvent {}

final class IntroNotificationPermissionEvent extends IntroEvent {}

final class IntroCameraPermissionEvent extends IntroEvent {}

final class IntroLocationPermisionEvent extends IntroEvent {}

final class IntroLocationOpenSettingEvent extends IntroEvent {}

final class IntroLanguageChangeEvent extends IntroEvent {
  final String locale;
  IntroLanguageChangeEvent({required this.locale});
}
