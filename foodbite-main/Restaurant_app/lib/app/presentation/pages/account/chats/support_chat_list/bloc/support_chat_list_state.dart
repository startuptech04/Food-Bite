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

part of 'support_chat_list_bloc.dart';

enum SupportChatListStatus { loading, empty, success, failure }

extension SupportChatListStatusX on SupportChatListStatus {
  bool get isLoading => this == SupportChatListStatus.loading;
  bool get isSuccess => this == SupportChatListStatus.success;
  bool get isFailure => this == SupportChatListStatus.failure;
  bool get isEmpty => this == SupportChatListStatus.empty;
}

final class SupportChatListState {
  final String userId;
  final MySupportChatListResponseModel model;
  final SupportChatListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SupportChatListState({this.userId = '', required this.model, this.status = SupportChatListStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  SupportChatListState copyWith({String? userId, MySupportChatListResponseModel? model, SupportChatListStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return SupportChatListState(
      userId: userId ?? this.userId,
      model: model ?? this.model,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
