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

part of 'sounds_bloc.dart';

sealed class SoundsEvent {}

final class SoundsInitialEvent extends SoundsEvent {}

final class SoundsSelectEvent extends SoundsEvent {
  final String sound;
  SoundsSelectEvent({required this.sound});
}

final class SoundsPlayingEvent extends SoundsEvent {
  final String sound;
  SoundsPlayingEvent({required this.sound});
}
