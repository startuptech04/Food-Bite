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
import 'package:driver/app/core/models/app_pages_content_response_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'app_page_event.dart';
part 'app_page_state.dart';

class AppPageBloc extends Bloc<AppPageEvent, AppPageState> {
  final AuthRepository _authRepository = AuthRepository();
  AppPageBloc() : super(const AppPageState()) {
    on<AppPageInitialEvent>(_onAppPageInitialEvent);
  }

  FutureOr<void> _onAppPageInitialEvent(AppPageInitialEvent event, Emitter<AppPageState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "${event.slug}_pages"}, '${event.slug}_pages_screen', '${event.slug}_pages_screen');
      emit(state.copyWith(status: AppPageStatus.loading, title: event.slug));
      DioApiResponse response = await _authRepository.getPageContent(event.slug);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        final String locale = await _authRepository.getLocale();
        AppPageContentModel data = AppPageContentModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: AppPageStatus.loaded, description: data.content));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AppPageStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AppPageStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
