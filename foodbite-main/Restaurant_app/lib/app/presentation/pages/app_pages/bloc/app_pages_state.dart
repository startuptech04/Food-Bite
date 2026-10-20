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

part of 'app_pages_bloc.dart';

enum AppPagesStatus { loading, loaded, failure }

extension AppPagesStatusX on AppPagesStatus {
  bool get isLoading => this == AppPagesStatus.loading;
  bool get isLoaded => this == AppPagesStatus.loaded;
  bool get isFailure => this == AppPagesStatus.failure;
}

final class AppPagesState {
  final String title;
  final String description;
  final AppPagesStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const AppPagesState({this.title = '', this.description = '', this.status = AppPagesStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  AppPagesState copyWith({String? title, String? description, AppPagesStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return AppPagesState(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
