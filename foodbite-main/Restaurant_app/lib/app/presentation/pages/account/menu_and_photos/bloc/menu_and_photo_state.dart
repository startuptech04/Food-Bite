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

enum MenuAndPhotoStatus { loading, success, failure, customError, updateStart, updateSuccess, updateFailed }

extension MenuAndPhotoStatusX on MenuAndPhotoStatus {
  bool get isLoading => this == MenuAndPhotoStatus.loading;
  bool get isSuccess => this == MenuAndPhotoStatus.success;
  bool get isFailure => this == MenuAndPhotoStatus.failure;
  bool get isCustomError => this == MenuAndPhotoStatus.customError;
  bool get isUpdateStart => this == MenuAndPhotoStatus.updateStart;
  bool get isUpdateSuccess => this == MenuAndPhotoStatus.updateSuccess;
  bool get isUpdateFailed => this == MenuAndPhotoStatus.updateFailed;
}

final class MenuAndPhotoState {
  final String appLocale;
  final MenuAndPhotoResponseModel model;
  final MenuAndPhotoStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const MenuAndPhotoState({this.appLocale = '', required this.model, this.status = MenuAndPhotoStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  MenuAndPhotoState copyWith({String? appLocale, MenuAndPhotoResponseModel? model, MenuAndPhotoStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return MenuAndPhotoState(
      appLocale: appLocale ?? this.appLocale,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
