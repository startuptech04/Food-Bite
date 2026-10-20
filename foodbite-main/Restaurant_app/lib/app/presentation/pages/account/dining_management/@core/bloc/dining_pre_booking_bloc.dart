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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/custom_tabs_list_model.dart';
import 'package:vendor/app/core/models/dining_booking_list_response_model.dart';
import 'package:vendor/app/core/models/request/accept_dining_booking_request_model.dart';
import 'package:vendor/app/core/models/request/dining_booking_list_request_model.dart';
import 'package:vendor/app/core/models/request/reject_dining_booking_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/dining_booking_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_pre_booking_event.dart';
part 'dining_pre_booking_state.dart';

class DiningPreBookingBloc extends Bloc<DiningPreBookingEvent, DiningPreBookingState> {
  final DiningBookingRepository _diningBookingRepository = DiningBookingRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningPreBookingBloc()
    : super(
        DiningPreBookingState(
          pageSize: ApiRequestService.pageSize,
          model: DiningBookingResponseListModel(locale: ''),
        ),
      ) {
    on<DiningPreBookingInitialEvent>(_onDiningPreBookingInitialEvent);
    on<DiningPreBookingTabChangeEvent>(_onDiningPreBookingTabChangeEvent);
    on<DiningPreBookingLoadMoreBookingEvent>(_onDiningPreBookingLoadMoreBookingEvent);
    on<DiningPreBookingPullRefreshEvent>(_onDiningPreBookingPullRefreshEvent);
    on<DiningPreBookingAcceptNewBookingEvent>(_onDiningPreBookingAcceptNewBookingEvent);
    on<DiningPreBookingRejectNewBookingEvent>(_onDiningPreBookingRejectNewBookingEvent);
    on<DiningPreBookingCompleteBookingEvent>(_onDiningPreBookingCompleteBookingEvent);
  }

  FutureOr<void> _onDiningPreBookingInitialEvent(DiningPreBookingInitialEvent event, Emitter<DiningPreBookingState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_booking_list"}, 'dining_booking_list_screen', 'dining_booking_list_screen');
      emit(state.copyWith(status: DiningPreBookingStatus.loading, activeTab: 'created'));
      final String vendorId = await _diningBookingRepository.getVendorId();
      DiningBookingListRequestModel param = DiningBookingListRequestModel(limit: state.pageSize, page: state.currentPage, vendor: vendorId, status: 'created');
      DioApiResponse response = await _diningBookingRepository.getDiningBookingList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningBookingResponseListModel bookingResponse = DiningBookingResponseListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel createdBooking = CustomTabListModel(label: 'New (##dynamic##)', key: 'created', orderNo: 1, countNumber: bookingResponse.createdBooking!);
        CustomTabListModel acceptedBooking = CustomTabListModel(label: 'Accepted (##dynamic##)', key: 'accepted', orderNo: 2, countNumber: bookingResponse.acceptedBooking!);
        CustomTabListModel completedBooking = CustomTabListModel(label: 'Completed (##dynamic##)', key: 'completed', orderNo: 3, countNumber: bookingResponse.completedBooking!);
        CustomTabListModel cancelledBooking = CustomTabListModel(label: 'Cancelled (##dynamic##)', key: 'cancelled', orderNo: 4, countNumber: bookingResponse.cancelledBooking!);
        CustomTabListModel rejectedBooking = CustomTabListModel(label: 'Rejected (##dynamic##)', key: 'rejected', orderNo: 5, countNumber: bookingResponse.rejectedBooking!);
        CustomTabListModel refundedBooking = CustomTabListModel(label: 'Refunded (##dynamic##)', key: 'refunded', orderNo: 6, countNumber: bookingResponse.refundedBooking!);
        CustomTabListModel partialRefundBooking = CustomTabListModel(label: 'Partially Refunded (##dynamic##)', key: 'partially_refunded', orderNo: 7, countNumber: bookingResponse.partialRefundedBooking!);
        tabsList.add(createdBooking);
        tabsList.add(acceptedBooking);
        tabsList.add(completedBooking);
        tabsList.add(cancelledBooking);
        tabsList.add(rejectedBooking);
        tabsList.add(refundedBooking);
        tabsList.add(partialRefundBooking);
        tabsList.sort((a, b) => a.orderNo!.compareTo(b.orderNo!));
        emit(state.copyWith(tabList: tabsList, model: bookingResponse, activeTab: 'created', status: bookingResponse.bookings!.isNotEmpty ? DiningPreBookingStatus.success : DiningPreBookingStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningPreBookingStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningPreBookingStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningPreBookingTabChangeEvent(DiningPreBookingTabChangeEvent event, Emitter<DiningPreBookingState> emit) async {
    try {
      emit(state.copyWith(status: DiningPreBookingStatus.changeTabs, activeTab: event.key));
      final String vendorId = await _diningBookingRepository.getVendorId();
      DiningBookingListRequestModel param = DiningBookingListRequestModel(limit: state.pageSize, page: state.currentPage, vendor: vendorId, status: event.key);
      DioApiResponse response = await _diningBookingRepository.getDiningBookingList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningBookingResponseListModel bookingResponse = DiningBookingResponseListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel createdBooking = CustomTabListModel(label: 'New (##dynamic##)', key: 'created', orderNo: 1, countNumber: bookingResponse.createdBooking!);
        CustomTabListModel acceptedBooking = CustomTabListModel(label: 'Accepted (##dynamic##)', key: 'accepted', orderNo: 2, countNumber: bookingResponse.acceptedBooking!);
        CustomTabListModel completedBooking = CustomTabListModel(label: 'Completed (##dynamic##)', key: 'completed', orderNo: 3, countNumber: bookingResponse.completedBooking!);
        CustomTabListModel cancelledBooking = CustomTabListModel(label: 'Cancelled (##dynamic##)', key: 'cancelled', orderNo: 4, countNumber: bookingResponse.cancelledBooking!);
        CustomTabListModel rejectedBooking = CustomTabListModel(label: 'Rejected (##dynamic##)', key: 'rejected', orderNo: 5, countNumber: bookingResponse.rejectedBooking!);
        CustomTabListModel refundedBooking = CustomTabListModel(label: 'Refunded (##dynamic##)', key: 'refunded', orderNo: 6, countNumber: bookingResponse.refundedBooking!);
        CustomTabListModel partialRefundBooking = CustomTabListModel(label: 'Partially Refunded (##dynamic##)', key: 'partially_refunded', orderNo: 7, countNumber: bookingResponse.partialRefundedBooking!);
        tabsList.add(createdBooking);
        tabsList.add(acceptedBooking);
        tabsList.add(completedBooking);
        tabsList.add(cancelledBooking);
        tabsList.add(rejectedBooking);
        tabsList.add(refundedBooking);
        tabsList.add(partialRefundBooking);
        tabsList.sort((a, b) => a.orderNo!.compareTo(b.orderNo!));
        emit(state.copyWith(tabList: tabsList, model: bookingResponse, activeTab: event.key, status: bookingResponse.bookings!.isNotEmpty ? DiningPreBookingStatus.success : DiningPreBookingStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningPreBookingStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningPreBookingStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningPreBookingLoadMoreBookingEvent(DiningPreBookingLoadMoreBookingEvent event, Emitter<DiningPreBookingState> emit) async {
    if (state.model.bookings!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _diningBookingRepository.getVendorId();
        DiningBookingListRequestModel param = DiningBookingListRequestModel(limit: state.pageSize * 2, page: state.currentPage, vendor: vendorId, status: state.activeTab);
        DioApiResponse response = await _diningBookingRepository.getDiningBookingList(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          DiningBookingResponseListModel bookingResponse = DiningBookingResponseListModel.fromJson(myMap, locale.toString());
          List<CustomTabListModel> tabsList = <CustomTabListModel>[];
          tabsList.clear();
          CustomTabListModel createdBooking = CustomTabListModel(label: 'New (##dynamic##)', key: 'created', orderNo: 1, countNumber: bookingResponse.createdBooking!);
          CustomTabListModel acceptedBooking = CustomTabListModel(label: 'Accepted (##dynamic##)', key: 'accepted', orderNo: 2, countNumber: bookingResponse.acceptedBooking!);
          CustomTabListModel completedBooking = CustomTabListModel(label: 'Completed (##dynamic##)', key: 'completed', orderNo: 3, countNumber: bookingResponse.completedBooking!);
          CustomTabListModel cancelledBooking = CustomTabListModel(label: 'Cancelled (##dynamic##)', key: 'cancelled', orderNo: 4, countNumber: bookingResponse.cancelledBooking!);
          CustomTabListModel rejectedBooking = CustomTabListModel(label: 'Rejected (##dynamic##)', key: 'rejected', orderNo: 5, countNumber: bookingResponse.rejectedBooking!);
          CustomTabListModel refundedBooking = CustomTabListModel(label: 'Refunded (##dynamic##)', key: 'refunded', orderNo: 6, countNumber: bookingResponse.refundedBooking!);
          CustomTabListModel partialRefundBooking = CustomTabListModel(label: 'Partially Refunded (##dynamic##)', key: 'partially_refunded', orderNo: 7, countNumber: bookingResponse.partialRefundedBooking!);
          tabsList.add(createdBooking);
          tabsList.add(acceptedBooking);
          tabsList.add(completedBooking);
          tabsList.add(cancelledBooking);
          tabsList.add(rejectedBooking);
          tabsList.add(refundedBooking);
          tabsList.add(partialRefundBooking);
          tabsList.sort((a, b) => a.orderNo!.compareTo(b.orderNo!));
          emit(
            state.copyWith(tabList: tabsList, model: bookingResponse, loadMore: false, pageSize: state.pageSize * 2, status: bookingResponse.bookings!.isNotEmpty ? DiningPreBookingStatus.success : DiningPreBookingStatus.empty),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DiningPreBookingStatus.failure, statusCode: data.code, loadMore: false, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DiningPreBookingStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onDiningPreBookingPullRefreshEvent(DiningPreBookingPullRefreshEvent event, Emitter<DiningPreBookingState> emit) async {
    try {
      emit(state.copyWith(status: DiningPreBookingStatus.loading));
      final String vendorId = await _diningBookingRepository.getVendorId();
      DiningBookingListRequestModel param = DiningBookingListRequestModel(limit: state.pageSize, page: state.currentPage, vendor: vendorId, status: state.activeTab);
      DioApiResponse response = await _diningBookingRepository.getDiningBookingList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningBookingResponseListModel bookingResponse = DiningBookingResponseListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel createdBooking = CustomTabListModel(label: 'New (##dynamic##)', key: 'created', orderNo: 1, countNumber: bookingResponse.createdBooking!);
        CustomTabListModel acceptedBooking = CustomTabListModel(label: 'Accepted (##dynamic##)', key: 'accepted', orderNo: 2, countNumber: bookingResponse.acceptedBooking!);
        CustomTabListModel completedBooking = CustomTabListModel(label: 'Completed (##dynamic##)', key: 'completed', orderNo: 3, countNumber: bookingResponse.completedBooking!);
        CustomTabListModel cancelledBooking = CustomTabListModel(label: 'Cancelled (##dynamic##)', key: 'cancelled', orderNo: 4, countNumber: bookingResponse.cancelledBooking!);
        CustomTabListModel rejectedBooking = CustomTabListModel(label: 'Rejected (##dynamic##)', key: 'rejected', orderNo: 5, countNumber: bookingResponse.rejectedBooking!);
        CustomTabListModel refundedBooking = CustomTabListModel(label: 'Refunded (##dynamic##)', key: 'refunded', orderNo: 6, countNumber: bookingResponse.refundedBooking!);
        CustomTabListModel partialRefundBooking = CustomTabListModel(label: 'Partially Refunded (##dynamic##)', key: 'partially_refunded', orderNo: 7, countNumber: bookingResponse.partialRefundedBooking!);
        tabsList.add(createdBooking);
        tabsList.add(acceptedBooking);
        tabsList.add(completedBooking);
        tabsList.add(cancelledBooking);
        tabsList.add(rejectedBooking);
        tabsList.add(refundedBooking);
        tabsList.add(partialRefundBooking);
        tabsList.sort((a, b) => a.orderNo!.compareTo(b.orderNo!));
        emit(state.copyWith(tabList: tabsList, model: bookingResponse, status: bookingResponse.bookings!.isNotEmpty ? DiningPreBookingStatus.success : DiningPreBookingStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningPreBookingStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningPreBookingStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningPreBookingAcceptNewBookingEvent(DiningPreBookingAcceptNewBookingEvent event, Emitter<DiningPreBookingState> emit) async {
    try {
      emit(state.copyWith(status: DiningPreBookingStatus.orderChange, newOrderStatus: 'accept', orderChangeId: state.model.bookings![event.bookingIndex].id));
      final String vendorId = await _diningBookingRepository.getVendorId();
      final String bookingId = state.model.bookings![event.bookingIndex].id!;
      AcceptDiningBookingRequestModel param = AcceptDiningBookingRequestModel(bookingId: bookingId, vendorId: vendorId);
      DioApiResponse response = await _diningBookingRepository.acceptDiningBooking(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          if (state.model.createdBooking! == 1) {
            state.model.createdBooking = 0;
          } else {
            state.model.createdBooking = state.model.createdBooking! - 1;
          }
          state.model.acceptedBooking = state.model.acceptedBooking! + 1;
          final int newTabIndex = state.tabList!.indexWhere((element) => element.key == 'created');
          final int acceptedTabIndex = state.tabList!.indexWhere((element) => element.key == 'accepted');
          if (newTabIndex != -1) {
            state.tabList![newTabIndex].label = "New (##dynamic##)";
            state.tabList![newTabIndex].countNumber = state.model.createdBooking!;
          }
          if (acceptedTabIndex != -1) {
            state.tabList![acceptedTabIndex].label = "Accepted (##dynamic##)";
            state.tabList![acceptedTabIndex].countNumber = state.model.acceptedBooking!;
          }
          state.model.bookings!.removeAt(event.bookingIndex);
          emit(state.copyWith(model: state.model, tabList: state.tabList, status: state.model.bookings!.isNotEmpty ? DiningPreBookingStatus.success : DiningPreBookingStatus.empty));
        } else {
          emit(state.copyWith(status: DiningPreBookingStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningPreBookingStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningPreBookingStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningPreBookingRejectNewBookingEvent(DiningPreBookingRejectNewBookingEvent event, Emitter<DiningPreBookingState> emit) async {
    try {
      emit(state.copyWith(status: DiningPreBookingStatus.orderChange, newOrderStatus: 'reject', orderChangeId: state.model.bookings![event.bookingIndex].id));
      final String vendorId = await _diningBookingRepository.getVendorId();
      final String bookingId = state.model.bookings![event.bookingIndex].id!;
      RejectDiningBookingRequestModel param = RejectDiningBookingRequestModel(vendorId: vendorId, bookingId: bookingId, reasonId: event.reasonId);
      DioApiResponse response = await _diningBookingRepository.rejectDiningBooking(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          if (state.model.createdBooking! == 1) {
            state.model.createdBooking = 0;
          } else {
            state.model.createdBooking = state.model.createdBooking! - 1;
          }
          state.model.rejectedBooking = state.model.rejectedBooking! + 1;
          final int newTabIndex = state.tabList!.indexWhere((element) => element.key == 'created');
          final int rejectedTabIndex = state.tabList!.indexWhere((element) => element.key == 'rejected');
          if (newTabIndex != -1) {
            state.tabList![newTabIndex].label = "New (##dynamic##)";
            state.tabList![newTabIndex].countNumber = state.model.createdBooking!;
          }
          if (rejectedTabIndex != -1) {
            state.tabList![rejectedTabIndex].label = "Rejected (##dynamic##)";
            state.tabList![rejectedTabIndex].countNumber = state.model.rejectedBooking!;
          }
          state.model.bookings!.removeAt(event.bookingIndex);
          emit(state.copyWith(model: state.model, tabList: state.tabList, status: state.model.bookings!.isNotEmpty ? DiningPreBookingStatus.success : DiningPreBookingStatus.empty));
        } else {
          emit(state.copyWith(status: DiningPreBookingStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningPreBookingStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningPreBookingStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningPreBookingCompleteBookingEvent(DiningPreBookingCompleteBookingEvent event, Emitter<DiningPreBookingState> emit) async {
    if (state.model.acceptedBooking! == 1) {
      state.model.acceptedBooking = 0;
    } else {
      state.model.acceptedBooking = state.model.acceptedBooking! - 1;
    }
    state.model.completedBooking = state.model.completedBooking! + 1;
    final int newTabIndex = state.tabList!.indexWhere((element) => element.key == 'accepted');
    final int completedTabIndex = state.tabList!.indexWhere((element) => element.key == 'completed');
    if (newTabIndex != -1) {
      state.tabList![newTabIndex].label = "Accepted (##dynamic##)";
      state.tabList![newTabIndex].countNumber = state.model.acceptedBooking!;
    }
    if (completedTabIndex != -1) {
      state.tabList![completedTabIndex].label = "Completed (##dynamic##)";
      state.tabList![completedTabIndex].countNumber = state.model.completedBooking!;
    }
    state.model.bookings!.removeAt(event.bookingIndex);
    emit(state.copyWith(model: state.model, tabList: state.tabList, status: state.model.bookings!.isNotEmpty ? DiningPreBookingStatus.success : DiningPreBookingStatus.empty));
  }
}
