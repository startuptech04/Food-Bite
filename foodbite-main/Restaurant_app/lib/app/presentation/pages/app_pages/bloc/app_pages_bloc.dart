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
import 'package:vendor/app/core/models/app_pages_content_response_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'app_pages_event.dart';
part 'app_pages_state.dart';

class AppPagesBloc extends Bloc<AppPagesEvent, AppPagesState> {
  final AuthRepository _authRepository = AuthRepository();
  final AccountRepository _accountRepository = AccountRepository();
  AppPagesBloc() : super(const AppPagesState()) {
    on<AppPagesInitialEvent>(_onAppPagesInitialEvent);
  }

  FutureOr<void> _onAppPagesInitialEvent(AppPagesInitialEvent event, Emitter<AppPagesState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "app_pages_${event.slug}"}, '${event.slug}_pages', '${event.slug}_pages');
      emit(state.copyWith(status: AppPagesStatus.loading, title: event.slug));
      DioApiResponse response = await _authRepository.getPageContent(event.slug);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        final String locale = await _authRepository.getLocale();
        AppPageContentModel data = AppPageContentModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: AppPagesStatus.loaded, description: data.content));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AppPagesStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AppPagesStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
