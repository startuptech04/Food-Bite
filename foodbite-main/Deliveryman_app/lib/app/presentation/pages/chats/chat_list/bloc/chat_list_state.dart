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

part of 'chat_list_bloc.dart';

enum ChatListStatus { loading, empty, success, failure, unAuthorized }

extension ChatListStatusX on ChatListStatus {
  bool get isLoading => this == ChatListStatus.loading;
  bool get isSuccess => this == ChatListStatus.success;
  bool get isFailure => this == ChatListStatus.failure;
  bool get isEmpty => this == ChatListStatus.empty;
  bool get isUnAuthorized => this == ChatListStatus.unAuthorized;
}

final class ChatListState {
  final MyChatListResponseModel model;
  final String userId;
  final ChatListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const ChatListState({required this.model, this.userId = '', this.status = ChatListStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  ChatListState copyWith({MyChatListResponseModel? model, String? userId, ChatListStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return ChatListState(
      model: model ?? this.model,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
