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

part of 'dining_setting_bloc.dart';

sealed class DiningSettingEvent {}

final class DiningSettingInitialEvent extends DiningSettingEvent {}

final class DiningCategoryModalResponseEvent extends DiningSettingEvent {
  final String ids;
  final String names;
  DiningCategoryModalResponseEvent({required this.ids, required this.names});
}

final class DiningMenuModalResponseEvent extends DiningSettingEvent {
  final DiningMenuModalResponseModel response;
  DiningMenuModalResponseEvent({required this.response});
}

final class DiningMenuModalEditResponseEvent extends DiningSettingEvent {
  final String oldName;
  final DiningMenuModalResponseModel response;
  DiningMenuModalEditResponseEvent({required this.oldName, required this.response});
}

final class DiningSettingRemoveMenuEvent extends DiningSettingEvent {
  final String name;
  DiningSettingRemoveMenuEvent({required this.name});
}

final class DiningMenuAddPhotoEvent extends DiningSettingEvent {
  final String image;
  DiningMenuAddPhotoEvent({required this.image});
}

final class DiningMenuPhotoRemoveEvent extends DiningSettingEvent {
  final String photo;
  DiningMenuPhotoRemoveEvent({required this.photo});
}

final class DiningSettingSaveEvent extends DiningSettingEvent {}
