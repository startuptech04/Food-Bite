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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/chat_messages_response_model.dart';
import 'package:vendor/app/core/models/chat_socket_incoming_message_model.dart';
import 'package:vendor/app/core/models/request/chat_conversion_request_model.dart';
import 'package:vendor/app/core/models/request/load_more_chat_conversion_request_model.dart';
import 'package:vendor/app/core/models/request/send_chat_message_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/chat_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'chat_messages_event.dart';
part 'chat_messages_state.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  final ChatRepository _chatRepository = ChatRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ChatMessagesBloc()
    : super(
        ChatMessagesState(
          pageSize: ApiRequestService.pageSize,
          model: ChatMessagesResponseModel(chats: []),
        ),
      ) {
    on<ChatMessagesInitialEvent>(_onChatMessagesInitialEvent);
    on<ChatMessagesSendNewMessageEvent>(_onChatMessagesSendNewMessageEvent);
    on<ChatMessagesReceiveNewMessageEvent>(_onChatMessagesReceiveNewMessageEvent);
    on<ChatMessagesReceiveLoadMoreEvent>(_onChatMessagesReceiveLoadMoreEvent);
  }

  FutureOr<void> _onChatMessagesInitialEvent(ChatMessagesInitialEvent event, Emitter<ChatMessagesState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "regular_chat_messages"}, 'regular_chat_messages_screen', 'regular_chat_messages_screen');
      final String userId = await _chatRepository.userId();
      final String authRole = await _chatRepository.authRole();
      final String firstName = await _chatRepository.firstName();
      final String lastName = await _chatRepository.lastName();
      final String userCover = await _chatRepository.userCover();
      emit(state.copyWith(status: ChatMessagesStatus.loading, userId: userId.toString(), authRole: authRole.toString(), name: event.name, senderFirstName: firstName, senderLastName: lastName, senderCover: userCover));
      ChatConversionRequestModel param = ChatConversionRequestModel(senderId: userId.toString(), receiverId: event.receiverId, page: state.currentPage, limit: state.pageSize);
      DioApiResponse response = await _chatRepository.fetchChatMessages(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ChatMessagesResponseModel chatResponse = ChatMessagesResponseModel.fromJson(myMap);
        String roomId = '';
        if (chatResponse.roomID!.isNotEmpty) {
          roomId = chatResponse.roomID!;
        }
        chatResponse.chats!.sort((a, b) {
          DateTime dateA = DateTime.parse(a.createdAt!);
          DateTime dateB = DateTime.parse(b.createdAt!);
          return dateA.compareTo(dateB);
        });
        emit(state.copyWith(status: ChatMessagesStatus.chatInitialize, model: chatResponse, chatRoomId: roomId));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: ChatMessagesStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ChatMessagesStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onChatMessagesSendNewMessageEvent(ChatMessagesSendNewMessageEvent event, Emitter<ChatMessagesState> emit) async {
    final String userId = await _chatRepository.userId();
    DateTime now = DateTime.now().toUtc();
    String formattedDate = now.toIso8601String();
    final int indexOfNewMessage = state.model.chats!.indexWhere((element) => element.createdAt == formattedDate && element.message == event.msg);
    try {
      SendChatMessageRequestModel param = SendChatMessageRequestModel(room: state.model.roomID!, sender: userId, msg: event.msg, msgType: 'text');
      DioApiResponse response = await _chatRepository.sendChatMessage(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          state.model.chats!.removeAt(indexOfNewMessage);
          emit(state.copyWith(status: ChatMessagesStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', model: state.model, extraMessage: ''));
        }
      } else {
        state.model.chats!.removeAt(indexOfNewMessage);
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: ChatMessagesStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString(), model: state.model));
      }
    } catch (e, stacktrace) {
      state.model.chats!.removeAt(indexOfNewMessage);
      emit(state.copyWith(status: ChatMessagesStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', model: state.model));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onChatMessagesReceiveNewMessageEvent(ChatMessagesReceiveNewMessageEvent event, Emitter<ChatMessagesState> emit) async {
    ChatMessageConfigModel receivedMsg = ChatMessageConfigModel(
      createdAt: event.msg.currentDate!,
      roomId: state.chatRoomId,
      senderId: event.msg.senderId!,
      message: event.msg.message!,
      messageType: event.msg.messageType!,
      randomId: event.msg.randomId!,
    );
    state.model.chats!.add(receivedMsg);
    state.model.chats!.toSet();
    emit(state.copyWith(status: ChatMessagesStatus.scrollDown, model: state.model));
  }

  FutureOr<void> _onChatMessagesReceiveLoadMoreEvent(ChatMessagesReceiveLoadMoreEvent event, Emitter<ChatMessagesState> emit) async {
    try {
      emit(state.copyWith(loadMore: true, status: ChatMessagesStatus.loadMoreStart));
      LoadMoreChatConversionRequestModel param = LoadMoreChatConversionRequestModel(roomId: state.chatRoomId, limit: state.pageSize * 2, page: state.currentPage);
      DioApiResponse response = await _chatRepository.getChatConversion(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ChatMessagesResponseModel chatResponse = ChatMessagesResponseModel.fromJson(myMap);
        String roomId = '';
        if (chatResponse.roomID!.isNotEmpty) {
          roomId = chatResponse.roomID!;
        }
        chatResponse.chats!.sort((a, b) {
          DateTime dateA = DateTime.parse(a.createdAt!);
          DateTime dateB = DateTime.parse(b.createdAt!);
          return dateA.compareTo(dateB);
        });
        emit(state.copyWith(status: ChatMessagesStatus.loadMoreEnd, loadMore: false, model: chatResponse, chatRoomId: roomId));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: ChatMessagesStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ChatMessagesStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
