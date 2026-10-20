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

part of 'user_avatar_list_modal_bloc.dart';

enum UserAvatarListModalStatus { loading, success, failure, empty }

extension UserAvatarListModalStatusX on UserAvatarListModalStatus {
  bool get isLoading => this == UserAvatarListModalStatus.loading;
  bool get isSuccess => this == UserAvatarListModalStatus.success;
  bool get isFailure => this == UserAvatarListModalStatus.failure;
  bool get isEmpty => this == UserAvatarListModalStatus.empty;
}

final class UserAvatarListModalState {
  final UserAvatarListResponseModel model;
  final String selected;
  final UserAvatarListModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const UserAvatarListModalState({required this.model, this.selected = '', this.status = UserAvatarListModalStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  UserAvatarListModalState copyWith({UserAvatarListResponseModel? model, String? selected, UserAvatarListModalStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return UserAvatarListModalState(
      model: model ?? this.model,
      selected: selected ?? this.selected,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
