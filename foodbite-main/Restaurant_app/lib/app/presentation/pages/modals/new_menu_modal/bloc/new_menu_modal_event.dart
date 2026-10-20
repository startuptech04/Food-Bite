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

part of 'new_menu_modal_bloc.dart';

sealed class NewMenuModalEvent {}

final class NewMenuModalInitialEvent extends NewMenuModalEvent {
  final bool isNew;
  final String name;
  final List<MenuTranslations> translations;
  final List<String> photos;
  NewMenuModalInitialEvent({required this.isNew, required this.name, required this.translations, required this.photos});
}

final class NewMenuNameUnfocusedEvent extends NewMenuModalEvent {}

final class NewMenuNameChangedEvent extends NewMenuModalEvent {
  final String name;
  NewMenuNameChangedEvent({required this.name});
}

final class NewMenuSavePhotoEvent extends NewMenuModalEvent {
  final String image;
  NewMenuSavePhotoEvent({required this.image});
}

final class NewMenuRemovePhotoEvent extends NewMenuModalEvent {
  final String image;
  NewMenuRemovePhotoEvent({required this.image});
}

final class NewMenuSaveEvent extends NewMenuModalEvent {
  final List<MenuFormTranslations> translations;
  NewMenuSaveEvent({required this.translations});
}
