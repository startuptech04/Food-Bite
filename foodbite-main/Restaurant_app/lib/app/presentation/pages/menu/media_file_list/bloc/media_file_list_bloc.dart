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
import 'package:vendor/app/core/models/media_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/media_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'media_file_list_event.dart';
part 'media_file_list_state.dart';

class MediaFileListBloc extends Bloc<MediaFileListEvent, MediaFileListState> {
  final MediaRepository _mediaRepository = MediaRepository();
  final AccountRepository _accountRepository = AccountRepository();
  MediaFileListBloc() : super(MediaFileListState(medias: VendorMediaListModel(), pageSize: ApiRequestService.pageSize)) {
    on<MediaFileListInitialEvent>(_onMediaFileListInitialEvent);
    on<MediaFileListLoadMoreEvent>(_onMediaFileListLoadMoreEvent);
  }

  FutureOr<void> _onMediaFileListInitialEvent(MediaFileListInitialEvent event, Emitter<MediaFileListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "media_files"}, 'media_files_screen', 'media_files_screen');
      emit(state.copyWith(status: MediaFileListStatus.loading));
      final String userId = await _mediaRepository.getUserId();
      DioApiResponse response = await _mediaRepository.getVendorMedia(state.pageSize, state.currentPage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        VendorMediaListModel data = VendorMediaListModel.fromJson(myMap);
        emit(state.copyWith(medias: data, status: data.results!.isNotEmpty ? MediaFileListStatus.success : MediaFileListStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: MediaFileListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: MediaFileListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onMediaFileListLoadMoreEvent(MediaFileListLoadMoreEvent event, Emitter<MediaFileListState> emit) async {
    if (state.medias.results!.length < state.medias.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String userId = await _mediaRepository.getUserId();
        DioApiResponse response = await _mediaRepository.getVendorMedia(state.pageSize * 2, state.currentPage, userId);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          VendorMediaListModel data = VendorMediaListModel.fromJson(myMap);
          emit(state.copyWith(medias: data, status: data.results!.isNotEmpty ? MediaFileListStatus.success : MediaFileListStatus.empty, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: MediaFileListStatus.failure, statusCode: data.code, loadMore: false, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: MediaFileListStatus.failure, statusCode: 0, loadMore: false, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
