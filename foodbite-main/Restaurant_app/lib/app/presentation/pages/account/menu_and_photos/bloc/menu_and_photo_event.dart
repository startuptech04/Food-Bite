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

part of 'menu_and_photo_bloc.dart';

sealed class MenuAndPhotoEvent {}

final class MenuAndPhotoInitialEvent extends MenuAndPhotoEvent {}

final class MenuAndPhotoMenuModalResponseEvent extends MenuAndPhotoEvent {
  final DiningMenuModalResponseModel response;
  MenuAndPhotoMenuModalResponseEvent({required this.response});
}

final class MenuAndPhotoMenuModalEditResponseEvent extends MenuAndPhotoEvent {
  final String oldName;
  final DiningMenuModalResponseModel response;
  MenuAndPhotoMenuModalEditResponseEvent({required this.oldName, required this.response});
}

final class MenuAndPhotoRemoveMenuEvent extends MenuAndPhotoEvent {
  final String name;
  MenuAndPhotoRemoveMenuEvent({required this.name});
}

final class MenuAndPhotoMenuAddPhotoEvent extends MenuAndPhotoEvent {
  final String image;
  MenuAndPhotoMenuAddPhotoEvent({required this.image});
}

final class MenuAndPhotoMenuPhotoRemoveEvent extends MenuAndPhotoEvent {
  final String photo;
  MenuAndPhotoMenuPhotoRemoveEvent({required this.photo});
}

final class MenuAndPhotoSaveEvent extends MenuAndPhotoEvent {}
