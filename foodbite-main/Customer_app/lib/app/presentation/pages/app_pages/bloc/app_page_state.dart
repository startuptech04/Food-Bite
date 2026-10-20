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

part of 'app_page_bloc.dart';

enum AppPageStatus { loading, loaded, failure }

extension AppPageStatusX on AppPageStatus {
  bool get isLoading => this == AppPageStatus.loading;
  bool get isLoaded => this == AppPageStatus.loaded;
  bool get isFailure => this == AppPageStatus.failure;
}

final class AppPageState {
  final String title;
  final String description;
  final AppPageStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AppPageState({this.title = '', this.description = '', this.status = AppPageStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  AppPageState copyWith({String? title, String? description, AppPageStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return AppPageState(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
