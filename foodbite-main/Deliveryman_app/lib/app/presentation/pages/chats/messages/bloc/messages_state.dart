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

part of 'messages_bloc.dart';

enum MessagesStatus { loading, chatInitialize, failure, customError, loadMoreStart, loadMoreEnd, scrollDown }

extension MessagesStatusX on MessagesStatus {
  bool get isLoading => this == MessagesStatus.loading;
  bool get isChatInitialize => this == MessagesStatus.chatInitialize;
  bool get isFailure => this == MessagesStatus.failure;
  bool get isCustomError => this == MessagesStatus.customError;
  bool get isLoadMoreStart => this == MessagesStatus.loadMoreStart;
  bool get isLoadMoreEnd => this == MessagesStatus.loadMoreEnd;
  bool get isScrollDown => this == MessagesStatus.scrollDown;
}

final class MessagesState {
  final ChatMessagesResponseModel model;
  final String chatRoomId;
  final String userId;
  final String authRole;
  final String name;
  final String senderFirstName;
  final String senderLastName;
  final String senderCover;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final MessagesStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const MessagesState({
    required this.model,
    this.chatRoomId = '',
    this.userId = '',
    this.authRole = '',
    this.name = '',
    this.senderFirstName = '',
    this.senderLastName = '',
    this.senderCover = '',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = MessagesStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  MessagesState copyWith({
    ChatMessagesResponseModel? model,
    String? chatRoomId,
    String? userId,
    String? authRole,
    String? name,
    String? senderFirstName,
    String? senderLastName,
    String? senderCover,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    MessagesStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return MessagesState(
      model: model ?? this.model,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      userId: userId ?? this.userId,
      authRole: authRole ?? this.authRole,
      name: name ?? this.name,
      senderFirstName: senderFirstName ?? this.senderFirstName,
      senderLastName: senderLastName ?? this.senderLastName,
      senderCover: senderCover ?? this.senderCover,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
