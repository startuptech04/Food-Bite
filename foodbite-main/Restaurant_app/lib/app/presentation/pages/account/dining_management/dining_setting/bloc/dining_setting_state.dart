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

enum DiningSettingStatus { loading, success, failure, customError, updateStart, updateSuccess, updateFailed }

extension DiningSettingStatusX on DiningSettingStatus {
  bool get isLoading => this == DiningSettingStatus.loading;
  bool get isSuccess => this == DiningSettingStatus.success;
  bool get isFailure => this == DiningSettingStatus.failure;
  bool get isCustomError => this == DiningSettingStatus.customError;
  bool get isUpdateStart => this == DiningSettingStatus.updateStart;
  bool get isUpdateSuccess => this == DiningSettingStatus.updateSuccess;
  bool get isUpdateFailed => this == DiningSettingStatus.updateFailed;
}

final class DiningSettingState {
  final String appLocale;
  final DiningDetailResponseModel model;
  final String category;
  final String categoryName;
  final DiningSettingStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningSettingState({this.appLocale = '', required this.model, this.category = '', this.categoryName = '', this.status = DiningSettingStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  DiningSettingState copyWith({String? appLocale, DiningDetailResponseModel? model, String? category, String? categoryName, DiningSettingStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return DiningSettingState(
      appLocale: appLocale ?? this.appLocale,
      model: model ?? this.model,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
