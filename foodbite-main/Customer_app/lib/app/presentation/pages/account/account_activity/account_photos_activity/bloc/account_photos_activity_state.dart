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

part of 'account_photos_activity_bloc.dart';

enum AccountPhotosActivityStatus { loading, empty, success, failure }

extension AccountPhotosActivityStatusX on AccountPhotosActivityStatus {
  bool get isLoading => this == AccountPhotosActivityStatus.loading;
  bool get isSuccess => this == AccountPhotosActivityStatus.success;
  bool get isFailure => this == AccountPhotosActivityStatus.failure;
  bool get isEmpty => this == AccountPhotosActivityStatus.empty;
}

final class AccountPhotosActivityState {
  final MyMediaFilesResponseModel model;
  final AccountPhotosActivityStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountPhotosActivityState({required this.model, this.status = AccountPhotosActivityStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  AccountPhotosActivityState copyWith({MyMediaFilesResponseModel? model, AccountPhotosActivityStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return AccountPhotosActivityState(
      model: model ?? this.model,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
