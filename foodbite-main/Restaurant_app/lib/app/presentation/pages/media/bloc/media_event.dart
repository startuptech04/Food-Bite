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

part of 'media_bloc.dart';

sealed class MediaEvent {}

final class MediaInitialEvent extends MediaEvent {
  final String file;
  MediaInitialEvent({required this.file});
}

final class MediaLoadMoreEvent extends MediaEvent {}

final class MediaSelectEvent extends MediaEvent {
  final String file;
  MediaSelectEvent({required this.file});
}

final class MediaTabChangeEvent extends MediaEvent {
  final int tabIndex;
  MediaTabChangeEvent({required this.tabIndex});
}

final class MediaUploadImageEvent extends MediaEvent {
  final XFile newImage;
  MediaUploadImageEvent({required this.newImage});
}
