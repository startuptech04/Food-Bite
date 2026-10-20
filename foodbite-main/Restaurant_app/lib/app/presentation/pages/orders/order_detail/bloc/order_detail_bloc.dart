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
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/order_call_customer_number_response_model.dart';
import 'package:vendor/app/core/models/order_call_deliveryman_number_response_model.dart';
import 'package:vendor/app/core/models/order_detail_response_model.dart';
import 'package:vendor/app/core/models/request/accept_schedule_order_request_model.dart';
import 'package:vendor/app/core/models/request/order_handover_to_customer_request_model.dart';
import 'package:vendor/app/core/models/request/order_handover_to_driver_request_model.dart';
import 'package:vendor/app/core/models/request/order_ready_request_model.dart';
import 'package:vendor/app/core/models/request/prepare_order_request_model.dart';
import 'package:vendor/app/core/models/request/reject_order_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_detail_event.dart';
part 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  OrderDetailBloc() : super(OrderDetailState(model: OrderDetailResponseModel(locale: ''))) {
    on<OrderDetailInitialEvent>(_onOrderDetailInitialEvent);
    on<OrderDetailCallCustomerEvent>(_onOrderDetailCallCustomerEvent);
    on<OrderDetailCallDeliverymanEvent>(_onOrderDetailCallDeliverymanEvent);
    on<OrderDetailRejectOrderEvent>(_onOrderDetailRejectOrderEvent);
    on<OrderDetailAcceptOrderEvent>(_onOrderDetailAcceptOrderEvent);
    on<OrderDetailPreparationTimeChangeEvent>(_onOrderDetailPreparationTimeChangeEvent);
    on<OrderDetailAcceptScheduleOrderEvent>(_onOrderDetailAcceptScheduleOrderEvent);
    on<OrderDetailReadyEvent>(_onOrderDetailReadyEvent);
    on<OrderDetailHandoverOrderEvent>(_onOrderDetailHandoverOrderEvent);
  }

  FutureOr<void> _onOrderDetailInitialEvent(OrderDetailInitialEvent event, Emitter<OrderDetailState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "order_detail"}, 'order_detail_screen', 'order_detail_screen');
      emit(state.copyWith(status: OrderDetailStatus.loading, orderId: event.id));
      final String vendorId = await _orderRepository.getVendorId();
      DioApiResponse response = await _orderRepository.getOrderDetail(event.id, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          double bottomHeight = 0.0;
          OrderDetailResponseModel data = OrderDetailResponseModel.fromJson(myMap, locale.toString());
          if (data.detail!.status! == 'created' && data.detail!.scheduleOrder!) {
            bottomHeight = 120.0;
          } else if (data.detail!.status! == 'accepted' && data.detail!.scheduleOrder!) {
            bottomHeight = 150.0;
          } else if (data.detail!.status! == 'created' && data.detail!.instantOrder!) {
            bottomHeight = 150;
          } else if (data.detail!.status! == 'preparing') {
            bottomHeight = 90.0;
          } else if (data.detail!.status! == 'ready') {
            if (data.detail!.driverInfo!.id!.isEmpty && data.detail!.orderTo! == 'homedelivery') {
              bottomHeight = 90.0;
            } else if (data.detail!.orderTo! == 'selfpickup') {
              bottomHeight = 150.0;
            } else if (data.detail!.driverInfo!.id!.isNotEmpty && data.detail!.orderTo! == 'homedelivery') {
              bottomHeight = 150.0;
            }
          }
          emit(state.copyWith(status: OrderDetailStatus.success, model: data, bottomHeight: bottomHeight));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailCallCustomerEvent(OrderDetailCallCustomerEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.callCustomer));
      final String vendorId = await _orderRepository.getVendorId();
      DioApiResponse response = await _orderRepository.callCustomer(state.orderId, vendorId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          OrderCallCustomerNumberResponseModel data = OrderCallCustomerNumberResponseModel.fromJson(myMap);
          String customerNumber = '';
          if (data.orderInfo!.orderTo! == 'selfpickup') {
            customerNumber = '${data.userInfo!.countryCode!}${data.userInfo!.mobile!}';
          } else {
            customerNumber = '${data.orderInfo!.countryCode!}${data.orderInfo!.receiverContact!}';
          }
          emit(state.copyWith(status: OrderDetailStatus.callCustomerSuccess));
          final Uri numberLaunchUri = Uri(scheme: 'tel', path: customerNumber);
          launchUrl(numberLaunchUri);
        } else {
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
        //
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailCallDeliverymanEvent(OrderDetailCallDeliverymanEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.callDeliveryman));
      final String vendorId = await _orderRepository.getVendorId();
      DioApiResponse response = await _orderRepository.callDeliveryman(state.orderId, vendorId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          OrderCallDeliverymanNumberResponseModel data = OrderCallDeliverymanNumberResponseModel.fromJson(myMap);
          emit(state.copyWith(status: OrderDetailStatus.callDeliverymanSuccess));
          final Uri numberLaunchUri = Uri(scheme: 'tel', path: '${data.driverInfo!.countryCode!}${data.driverInfo!.mobile!}');
          launchUrl(numberLaunchUri);
        } else {
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
        //
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailRejectOrderEvent(OrderDetailRejectOrderEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.rejectOrder));
      final String vendorId = await _orderRepository.getVendorId();
      RejectOrderRequestModel param = RejectOrderRequestModel(id: state.orderId, restaurant: vendorId, reason: event.reasonId);
      DioApiResponse response = await _orderRepository.rejectOrder(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: OrderDetailStatus.rejectOrderSuccess));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailAcceptOrderEvent(OrderDetailAcceptOrderEvent event, Emitter<OrderDetailState> emit) async {
    if (state.model.detail!.instantOrder!) {
      try {
        emit(state.copyWith(status: OrderDetailStatus.acceptOrder));
        final String vendorId = await _orderRepository.getVendorId();
        final int prepareTime = state.model.detail!.preparationTime!;
        final String orderId = state.orderId;
        final String userId = state.model.detail!.userInfo!.id!;
        PrepareOrderRequestModel param = PrepareOrderRequestModel(id: orderId, time: prepareTime, vendorId: vendorId, driverId: event.driverId, user: userId);
        DioApiResponse response = await _orderRepository.prepareOrder(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (initialResponse.success!) {
            emit(state.copyWith(status: OrderDetailStatus.acceptOrderSuccess));
          } else {
            emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      try {
        emit(state.copyWith(status: OrderDetailStatus.acceptOrder));
        final String vendorId = await _orderRepository.getVendorId();
        final String orderId = state.orderId;
        final String userId = state.model.detail!.userInfo!.id!;
        AcceptScheduleOrderRequestModel param = AcceptScheduleOrderRequestModel(id: orderId, vendorId: vendorId, user: userId);
        DioApiResponse response = await _orderRepository.acceptScheduleOrder(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (initialResponse.success!) {
            emit(state.copyWith(status: OrderDetailStatus.acceptOrderSuccess));
          } else {
            emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onOrderDetailPreparationTimeChangeEvent(OrderDetailPreparationTimeChangeEvent event, Emitter<OrderDetailState> emit) async {
    if (state.model.detail!.preparationTime! == 5 && event.action == 'decrease') {
      state.model.detail!.preparationTime = 5;
      emit(state.copyWith(model: state.model));
    } else if (event.action == 'decrease') {
      state.model.detail!.preparationTime = state.model.detail!.preparationTime! - 5;
      emit(state.copyWith(model: state.model));
    } else {
      state.model.detail!.preparationTime = state.model.detail!.preparationTime! + 5;
      emit(state.copyWith(model: state.model));
    }
  }

  FutureOr<void> _onOrderDetailAcceptScheduleOrderEvent(OrderDetailAcceptScheduleOrderEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.acceptOrder));
      final String vendorId = await _orderRepository.getVendorId();
      final int prepareTime = state.model.detail!.preparationTime!;
      final String orderId = state.orderId;
      final String userId = state.model.detail!.userInfo!.id!;
      PrepareOrderRequestModel param = PrepareOrderRequestModel(id: orderId, time: prepareTime, vendorId: vendorId, driverId: event.driverId, user: userId);
      DioApiResponse response = await _orderRepository.prepareOrder(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: OrderDetailStatus.acceptOrderSuccess));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailReadyEvent(OrderDetailReadyEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.readyOrder));
      final String vendorId = await _orderRepository.getVendorId();
      final String orderId = state.orderId;
      final String userId = state.model.detail!.userInfo!.id!;
      OrderReadyRequestModel param = OrderReadyRequestModel(id: orderId, vendorId: vendorId, user: userId);
      DioApiResponse response = await _orderRepository.orderReady(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: OrderDetailStatus.readyOrderSuccess));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailHandoverOrderEvent(OrderDetailHandoverOrderEvent event, Emitter<OrderDetailState> emit) async {
    try {
      if (state.model.detail!.orderTo! == 'homedelivery') {
        final String vendorId = await _orderRepository.getVendorId();
        final String orderId = state.orderId;
        final String userId = state.model.detail!.userInfo!.id!;
        OrderHandoverToDriverRequestModel param = OrderHandoverToDriverRequestModel(id: orderId, vendorId: vendorId, user: userId);
        DioApiResponse response = await _orderRepository.orderHandoverToDriver(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (initialResponse.success!) {
            emit(state.copyWith(status: OrderDetailStatus.handoverOrderSuccess));
          } else {
            emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } else {
        final String vendorId = await _orderRepository.getVendorId();
        final String orderId = state.orderId;
        final String userId = state.model.detail!.userInfo!.id!;
        OrderHandoverToCustomerRequestModel param = OrderHandoverToCustomerRequestModel(id: orderId, vendorId: vendorId, user: userId);
        DioApiResponse response = await _orderRepository.orderHandoverToCustomer(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (initialResponse.success!) {
            emit(state.copyWith(status: OrderDetailStatus.handoverOrderSuccess));
          } else {
            emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
