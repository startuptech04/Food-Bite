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
import 'package:driver/app/core/models/request/order_proof_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/models/upload_image_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/feeds_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_delivery_proof_event.dart';
part 'order_delivery_proof_state.dart';

class OrderDeliveryProofBloc extends Bloc<OrderDeliveryProofEvent, OrderDeliveryProofState> {
  final FeedsRepository _feedsRepository = FeedsRepository();
  final AuthRepository _authRepository = AuthRepository();
  OrderDeliveryProofBloc() : super(const OrderDeliveryProofState()) {
    on<OrderDeliveryProofInitialEvent>(_onOrderDeliveryProofInitialEvent);
    on<OrderDeliveryProofUploadImageEvent>(_onOrderDeliveryProofUploadImageEvent);
  }

  FutureOr<void> _onOrderDeliveryProofInitialEvent(OrderDeliveryProofInitialEvent event, Emitter<OrderDeliveryProofState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "order_delivery_proof"}, 'order_delivery_proof_screen', 'order_delivery_proof_screen');
    emit(state.copyWith(orderId: event.orderId, status: OrderDeliveryProofStatus.initial));
  }

  FutureOr<void> _onOrderDeliveryProofUploadImageEvent(OrderDeliveryProofUploadImageEvent event, Emitter<OrderDeliveryProofState> emit) async {
    try {
      emit(state.copyWith(status: OrderDeliveryProofStatus.uploadLoaderStarted));
      final String userId = await _feedsRepository.driverId();
      DioApiResponse response = await _feedsRepository.uploadMediaImage(event.newImage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        UploadImageModel data = UploadImageModel.fromJson(myMap);
        if (data.path!.isNotEmpty) {
          OrderProofRequestModel pickupParam = OrderProofRequestModel(orderId: state.orderId, pickup: '', dropup: data.path!, type: 'drop');
          DioApiResponse pickupResponse = await _feedsRepository.saveDeliveryPickupProof(pickupParam);
          if (response.errorType == NetErrorType.none) {
            Map<String, dynamic>? pickupMyMap = jsonDecode(pickupResponse.body) as Map<String, dynamic>;
            ApiStatusResponseModel pickData = ApiStatusResponseModel.fromJson(pickupMyMap);
            if (pickData.success!) {
              emit(state.copyWith(status: OrderDeliveryProofStatus.uploadLoaderEnded, selectedMedia: data.path!));
            } else {
              emit(state.copyWith(status: OrderDeliveryProofStatus.uploadLoaderEndedWithError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
            }
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: OrderDeliveryProofStatus.uploadLoaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          emit(state.copyWith(status: OrderDeliveryProofStatus.uploadLoaderEndedWithError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDeliveryProofStatus.uploadLoaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDeliveryProofStatus.uploadLoaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
