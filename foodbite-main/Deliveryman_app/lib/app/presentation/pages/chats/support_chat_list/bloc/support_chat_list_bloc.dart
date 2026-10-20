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
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/models/api_status_response_model.dart';
import 'package:driver/app/core/models/my_support_chat_list_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/chat_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'support_chat_list_event.dart';
part 'support_chat_list_state.dart';

class SupportChatListBloc extends Bloc<SupportChatListEvent, SupportChatListState> {
  final ChatRepository _chatRepository = ChatRepository();
  final AuthRepository _authRepository = AuthRepository();
  SupportChatListBloc()
    : super(
        SupportChatListState(
          model: MySupportChatListResponseModel(chats: [], success: false, locale: ''),
        ),
      ) {
    on<SupportChatListInitialEvent>(_onSupportChatListInitialEvent);
  }

  FutureOr<void> _onSupportChatListInitialEvent(SupportChatListInitialEvent event, Emitter<SupportChatListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "support_chat_list"}, 'support_chat_list_screen', 'support_chat_list_screen');
      final String userId = await _chatRepository.userId();
      emit(state.copyWith(status: SupportChatListStatus.loading, userId: userId.toString()));
      DioApiResponse response = await _chatRepository.getSupportChatList(userId.toString());
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: SupportChatListStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          MySupportChatListResponseModel chatResponse = MySupportChatListResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: chatResponse.chats!.isNotEmpty ? SupportChatListStatus.success : SupportChatListStatus.empty, model: chatResponse));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SupportChatListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SupportChatListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
