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
import 'package:driver/app/core/models/offline_messages_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/feeds_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'offline_reasons_event.dart';
part 'offline_reasons_state.dart';

class OfflineReasonsBloc extends Bloc<OfflineReasonsEvent, OfflineReasonsState> {
  final FeedsRepository _feedsRepository = FeedsRepository();
  final AuthRepository _authRepository = AuthRepository();
  OfflineReasonsBloc()
    : super(
        OfflineReasonsState(
          reasons: OfflineMessagesModel(offlines: [], totalResults: 0, success: false, locale: ''),
        ),
      ) {
    on<OfflineReasonInitialEvent>(_onOfflineReasonInitialEvent);
    on<OfflineReasonSelectEvent>(_onOfflineReasonSelectEvent);
  }

  FutureOr<void> _onOfflineReasonInitialEvent(OfflineReasonInitialEvent event, Emitter<OfflineReasonsState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "offline_reason"}, 'offline_reason_screen', 'offline_reason_screen');
      emit(state.copyWith(status: OfflineReasonsStatus.loading));
      DioApiResponse response = await _feedsRepository.getOfflineMessageList();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OfflineMessagesModel data = OfflineMessagesModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(reasons: data, status: data.offlines!.isNotEmpty ? OfflineReasonsStatus.success : OfflineReasonsStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OfflineReasonsStatus.failure, statusCode: 0, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OfflineReasonsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOfflineReasonSelectEvent(OfflineReasonSelectEvent event, Emitter<OfflineReasonsState> emit) async {
    emit(state.copyWith(status: OfflineReasonsStatus.success, reasonId: event.id));
  }
}
