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
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/core/models/api_status_response_model.dart';
import 'package:user/app/core/models/chat_socket_incoming_message_model.dart';
import 'package:user/app/core/models/request/load_more_chat_conversion_request_model.dart';
import 'package:user/app/core/models/request/send_chat_message_request_model.dart';
import 'package:user/app/core/models/request/support_chat_convertion_request_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/models/support_chat_message_response_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:user/app/core/repositories/chat_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'support_chat_event.dart';
part 'support_chat_state.dart';

class SupportChatBloc extends Bloc<SupportChatEvent, SupportChatState> {
  final ChatRepository _chatRepository = ChatRepository();
  final AuthRepository _authRepository = AuthRepository();
  SupportChatBloc()
    : super(
        SupportChatState(
          pageSize: ApiRequestService.pageSize,
          model: SupportChatMessageResponseModel(chats: []),
        ),
      ) {
    on<SupportChatInitialEvent>(_onSupportChatInitialEvent);
    on<SupportChatSendNewMessageEvent>(_onSupportChatSendNewMessageEvent);
    on<SupportChatReceiveNewMessageEvent>(_onSupportChatReceiveNewMessageEvent);
    on<SupportChatReceiveLoadMoreEvent>(_onSupportChatReceiveLoadMoreEvent);
  }

  FutureOr<void> _onSupportChatInitialEvent(SupportChatInitialEvent event, Emitter<SupportChatState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "support_chat_messages"}, 'support_chat_message_screen', 'support_chat_message_screen');
      final String userId = await _chatRepository.userId();
      final String authRole = await _chatRepository.authRole();
      final String firstName = await _chatRepository.firstName();
      final String lastName = await _chatRepository.lastName();
      final String userCover = await _chatRepository.userCover();
      emit(state.copyWith(status: SupportChatStatus.loading, userId: userId.toString(), authRole: authRole.toString(), senderFirstName: firstName, senderLastName: lastName, senderCover: userCover));
      SupportChatConvertionRequestModel param = SupportChatConvertionRequestModel(user: userId.toString(), type: event.type, typeId: event.typeId, page: state.currentPage, limit: state.pageSize);
      DioApiResponse response = await _chatRepository.fetchSupportChatMessages(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        SupportChatMessageResponseModel chatResponse = SupportChatMessageResponseModel.fromJson(myMap);
        String roomId = '';
        if (chatResponse.roomID!.isNotEmpty) {
          roomId = chatResponse.roomID!;
        }
        chatResponse.chats!.sort((a, b) {
          DateTime dateA = DateTime.parse(a.createdAt!);
          DateTime dateB = DateTime.parse(b.createdAt!);
          return dateA.compareTo(dateB);
        });
        emit(state.copyWith(status: SupportChatStatus.chatInitialize, model: chatResponse, chatRoomId: roomId));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SupportChatStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SupportChatStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSupportChatSendNewMessageEvent(SupportChatSendNewMessageEvent event, Emitter<SupportChatState> emit) async {
    final String userId = await _chatRepository.userId();
    DateTime now = DateTime.now().toUtc();
    String formattedDate = now.toIso8601String();
    final int indexOfNewMessage = state.model.chats!.indexWhere((element) => element.createdAt == formattedDate && element.message == event.msg);
    try {
      SendChatMessageRequestModel param = SendChatMessageRequestModel(room: state.model.roomID!, sender: userId, msg: event.msg, msgType: 'text');
      DioApiResponse response = await _chatRepository.sendSupportChatMessage(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          state.model.chats!.removeAt(indexOfNewMessage);
          emit(state.copyWith(status: SupportChatStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', model: state.model, extraMessage: ''));
        }
      } else {
        state.model.chats!.removeAt(indexOfNewMessage);
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SupportChatStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString(), model: state.model));
      }
    } catch (e, stacktrace) {
      state.model.chats!.removeAt(indexOfNewMessage);
      emit(state.copyWith(status: SupportChatStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', model: state.model));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSupportChatReceiveNewMessageEvent(SupportChatReceiveNewMessageEvent event, Emitter<SupportChatState> emit) async {
    try {
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
      emit(state.copyWith(status: SupportChatStatus.scrollDown, model: state.model));
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SupportChatStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSupportChatReceiveLoadMoreEvent(SupportChatReceiveLoadMoreEvent event, Emitter<SupportChatState> emit) async {
    try {
      emit(state.copyWith(loadMore: true, status: SupportChatStatus.loadMoreStart));
      LoadMoreChatConversionRequestModel param = LoadMoreChatConversionRequestModel(roomId: state.chatRoomId, limit: state.pageSize * 2, page: state.currentPage);
      DioApiResponse response = await _chatRepository.getSupportChatConversion(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        SupportChatMessageResponseModel chatResponse = SupportChatMessageResponseModel.fromJson(myMap);
        String roomId = '';
        if (chatResponse.roomID!.isNotEmpty) {
          roomId = chatResponse.roomID!;
        }
        chatResponse.chats!.sort((a, b) {
          DateTime dateA = DateTime.parse(a.createdAt!);
          DateTime dateB = DateTime.parse(b.createdAt!);
          return dateA.compareTo(dateB);
        });
        emit(state.copyWith(status: SupportChatStatus.loadMoreEnd, loadMore: false, model: chatResponse, chatRoomId: roomId));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SupportChatStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SupportChatStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
