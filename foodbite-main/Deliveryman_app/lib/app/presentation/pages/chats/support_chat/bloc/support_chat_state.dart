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

part of 'support_chat_bloc.dart';

enum SupportChatStatus { loading, chatInitialize, failure, customError, loadMoreStart, loadMoreEnd, scrollDown }

extension SupportChatStatusX on SupportChatStatus {
  bool get isLoading => this == SupportChatStatus.loading;
  bool get isChatInitialize => this == SupportChatStatus.chatInitialize;
  bool get isFailure => this == SupportChatStatus.failure;
  bool get isCustomError => this == SupportChatStatus.customError;
  bool get isLoadMoreStart => this == SupportChatStatus.loadMoreStart;
  bool get isLoadMoreEnd => this == SupportChatStatus.loadMoreEnd;
  bool get isScrollDown => this == SupportChatStatus.scrollDown;
}

final class SupportChatState {
  final String chatRoomId;
  final String userId;
  final String authRole;
  final String name;
  final String senderFirstName;
  final String senderLastName;
  final String senderCover;
  final int pageSize;
  final int currentPage;
  final SupportChatMessageResponseModel model;
  final bool loadMore;
  final SupportChatStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SupportChatState({
    this.chatRoomId = '',
    this.userId = '',
    this.authRole = '',
    this.name = '',
    this.senderFirstName = '',
    this.senderLastName = '',
    this.senderCover = '',
    required this.pageSize,
    this.currentPage = 0,
    required this.model,
    this.loadMore = false,
    this.status = SupportChatStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  SupportChatState copyWith({
    String? chatRoomId,
    String? userId,
    String? authRole,
    String? name,
    String? senderFirstName,
    String? senderLastName,
    String? senderCover,
    int? pageSize,
    int? currentPage,
    SupportChatMessageResponseModel? model,
    bool? loadMore,
    SupportChatStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return SupportChatState(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      userId: userId ?? this.userId,
      authRole: authRole ?? this.authRole,
      name: name ?? this.name,
      senderFirstName: senderFirstName ?? this.senderFirstName,
      senderLastName: senderLastName ?? this.senderLastName,
      senderCover: senderCover ?? this.senderCover,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      model: model ?? this.model,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
