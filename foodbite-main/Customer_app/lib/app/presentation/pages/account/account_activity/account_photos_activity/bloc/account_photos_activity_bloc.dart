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
import 'package:user/app/core/models/my_media_files_response_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'account_photos_activity_event.dart';
part 'account_photos_activity_state.dart';

class AccountPhotosActivityBloc extends Bloc<AccountPhotosActivityEvent, AccountPhotosActivityState> {
  final AuthRepository _authRepository = AuthRepository();
  AccountPhotosActivityBloc() : super(AccountPhotosActivityState(model: MyMediaFilesResponseModel(results: [], success: false))) {
    on<AccountPhotosActivityInitialEvent>(_onAccountPhotosActivityInitialEvent);
  }

  FutureOr<void> _onAccountPhotosActivityInitialEvent(AccountPhotosActivityInitialEvent event, Emitter<AccountPhotosActivityState> emit) async {
    try {
      emit(state.copyWith(status: AccountPhotosActivityStatus.loading));
      await _authRepository.saveEvent('visited_screen', {"screen": "account_photos"}, 'account_photo_screen', 'account_photo_screen');
      final String userId = await _authRepository.userId();
      DioApiResponse response = await _authRepository.getMyMediaFiles(userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        MyMediaFilesResponseModel mediaFiles = MyMediaFilesResponseModel.fromJson(myMap);
        emit(state.copyWith(status: mediaFiles.results!.isNotEmpty ? AccountPhotosActivityStatus.success : AccountPhotosActivityStatus.empty, model: mediaFiles));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AccountPhotosActivityStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AccountPhotosActivityStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
