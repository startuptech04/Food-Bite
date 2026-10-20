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
import 'package:image_picker/image_picker.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/media_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/upload_image_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/media_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRepository _mediaRepository = MediaRepository();
  final AccountRepository _accountRepository = AccountRepository();
  MediaBloc() : super(MediaState(medias: VendorMediaListModel(), pageSize: ApiRequestService.pageSize)) {
    on<MediaInitialEvent>(_onMediaInitialEvent);
    on<MediaLoadMoreEvent>(_onMediaLoadMoreEvent);
    on<MediaSelectEvent>(_onMediaSelectEvent);
    on<MediaTabChangeEvent>(_onMediaTabChangeEvent);
    on<MediaUploadImageEvent>(_onMediaUploadImageEvent);
  }

  FutureOr<void> _onMediaInitialEvent(MediaInitialEvent event, Emitter<MediaState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "media"}, 'media_screen', 'media_screen');
      emit(state.copyWith(status: MediaStatus.loading, selectedMedia: event.file));
      final String userId = await _mediaRepository.getUserId();
      DioApiResponse response = await _mediaRepository.getVendorMedia(state.pageSize, state.currentPage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        VendorMediaListModel data = VendorMediaListModel.fromJson(myMap);
        emit(state.copyWith(status: MediaStatus.success, medias: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: MediaStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: MediaStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onMediaLoadMoreEvent(MediaLoadMoreEvent event, Emitter<MediaState> emit) async {
    emit(state.copyWith(status: MediaStatus.loadMoreStarted));
    try {
      final String userId = await _mediaRepository.getUserId();
      DioApiResponse response = await _mediaRepository.getVendorMedia(state.pageSize * 2, state.currentPage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        VendorMediaListModel data = VendorMediaListModel.fromJson(myMap);
        emit(state.copyWith(status: MediaStatus.loadMoreEnded, medias: data, pageSize: state.pageSize * 2));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: MediaStatus.loadMoreEnded, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: MediaStatus.loadMoreEnded, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onMediaSelectEvent(MediaSelectEvent event, Emitter<MediaState> emit) async {
    emit(state.copyWith(selectedMedia: event.file));
  }

  FutureOr<void> _onMediaTabChangeEvent(MediaTabChangeEvent event, Emitter<MediaState> emit) async {
    emit(state.copyWith(tabIndex: event.tabIndex));
  }

  FutureOr<void> _onMediaUploadImageEvent(MediaUploadImageEvent event, Emitter<MediaState> emit) async {
    emit(state.copyWith(status: MediaStatus.uploadLoaderStarted));
    try {
      final String userId = await _mediaRepository.getUserId();
      DioApiResponse response = await _mediaRepository.uploadMediaImage(event.newImage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        UploadImageModel data = UploadImageModel.fromJson(myMap);
        emit(state.copyWith(status: MediaStatus.uploadLoaderEnded, selectedMedia: data.path!));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: MediaStatus.uploadLoaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: MediaStatus.uploadLoaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
