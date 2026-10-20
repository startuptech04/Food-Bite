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

part of 'chat_messages_bloc.dart';

enum ChatMessagesStatus { loading, chatInitialize, failure, customError, loadMoreStart, loadMoreEnd, scrollDown }

extension ChatMessagesStatusX on ChatMessagesStatus {
  bool get isLoading => this == ChatMessagesStatus.loading;
  bool get isChatInitialize => this == ChatMessagesStatus.chatInitialize;
  bool get isFailure => this == ChatMessagesStatus.failure;
  bool get isCustomError => this == ChatMessagesStatus.customError;
  bool get isLoadMoreStart => this == ChatMessagesStatus.loadMoreStart;
  bool get isLoadMoreEnd => this == ChatMessagesStatus.loadMoreEnd;
  bool get isScrollDown => this == ChatMessagesStatus.scrollDown;
}

final class ChatMessagesState {
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
  final ChatMessagesStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ChatMessagesState({
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
    this.status = ChatMessagesStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ChatMessagesState copyWith({
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
    ChatMessagesStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ChatMessagesState(
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
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
