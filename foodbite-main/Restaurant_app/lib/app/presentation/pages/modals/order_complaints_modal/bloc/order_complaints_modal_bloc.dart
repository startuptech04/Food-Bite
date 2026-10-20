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
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/order_detail_for_complaints_response_model.dart';
import 'package:vendor/app/core/models/request/remove_image_file_request_model.dart';
import 'package:vendor/app/core/models/request/save_order_complaints_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/upload_image_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:vendor/app/core/validations/order_complaints_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_complaints_modal_event.dart';
part 'order_complaints_modal_state.dart';

class OrderComplaintsModalBloc extends Bloc<OrderComplaintsModalEvent, OrderComplaintsModalState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  OrderComplaintsModalBloc()
    : super(
        OrderComplaintsModalState(
          complaintTo: ComplaintIssueWithListModel(label: '', value: ''),
          reason: OrderComplaintReasonConfigModel(name: '', type: '', translations: [], status: false, id: '', locale: ''),
          detail: OrderDetailForComplaintResponseModel(locale: ''),
        ),
      ) {
    on<OrderComplaintsModalInitialEvent>(_onOrderComplaintsModalInitialEvent);
    on<OrderComplaintModalIssueWithEvent>(_onOrderComplaintModalIssueWithEvent);
    on<OrderComplaintModalReasonSelectEvent>(_onOrderComplaintModalReasonSelectEvent);
    on<OrderComplaintModalTitleChangedEvent>(_onOrderComplaintModalTitleChangedEvent);
    on<OrderComplaintModalTitleUnfocusedEvent>(_onOrderComplaintModalTitleUnfocusedEvent);
    on<OrderComplaintModalBriefChangedEvent>(_onOrderComplaintModalBriefChangedEvent);
    on<OrderComplaintModalBriefUnfocusedEvent>(_onOrderComplaintModalBriefUnfocusedEvent);
    on<OrderComplaintModalUploadImageEvent>(_onOrderComplaintModalUploadImageEvent);
    on<OrderComplaintModalRemoveUploadImageEvent>(_onOrderComplaintModalRemoveUploadImageEvent);
    on<OrderComplaintModalSubmitEvent>(_onOrderComplaintModalSubmitEvent);
  }

  FutureOr<void> _onOrderComplaintsModalInitialEvent(OrderComplaintsModalInitialEvent event, Emitter<OrderComplaintsModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "order_complaint"}, 'order_complaint_screen', 'order_complaint_screen');
      final String locale = await _accountRepository.getLocale();
      emit(state.copyWith(status: OrderComplaintsModalStatus.loading, orderId: event.orderId));
      final String vendorId = await _orderRepository.getVendorId();
      DioApiResponse response = await _orderRepository.getOrderDetailForComplaints(event.orderId, vendorId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: OrderComplaintsModalStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          OrderDetailForComplaintResponseModel data = OrderDetailForComplaintResponseModel.fromJson(myMap, locale.toString());
          List<ComplaintIssueWithListModel> complaintWithList = <ComplaintIssueWithListModel>[];
          complaintWithList.clear();
          ComplaintIssueWithListModel customer = ComplaintIssueWithListModel(label: 'dd_customer', value: 'customer');
          complaintWithList.add(customer);
          if (data.details!.orderTo! == 'homedelivery' && data.details!.driverInfo!.id!.isNotEmpty) {
            ComplaintIssueWithListModel deliveryman = ComplaintIssueWithListModel(label: 'dd_deliveryman', value: 'deliveryman');
            complaintWithList.add(deliveryman);
          }
          if (complaintWithList.isNotEmpty) {
            emit(state.copyWith(complaintTo: complaintWithList.first));
            List<OrderComplaintReasonConfigModel> reasonList = <OrderComplaintReasonConfigModel>[];
            reasonList = data.reason!.where((element) => element.type == state.complaintTo.value!.toString()).toList();
            emit(state.copyWith(reasonList: reasonList));
            if (reasonList.isNotEmpty) {
              emit(state.copyWith(reason: reasonList.first));
            }
          }
          emit(state.copyWith(detail: data, complaintsWith: complaintWithList, status: OrderComplaintsModalStatus.success));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderComplaintsModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderComplaintsModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderComplaintModalIssueWithEvent(OrderComplaintModalIssueWithEvent event, Emitter<OrderComplaintsModalState> emit) async {
    List<OrderComplaintReasonConfigModel> reasonList = <OrderComplaintReasonConfigModel>[];
    reasonList = state.detail.reason!.where((element) => element.type == event.issueWith.value!.toString()).toList();
    emit(state.copyWith(complaintTo: event.issueWith, reasonList: reasonList, status: OrderComplaintsModalStatus.success));
    if (reasonList.isNotEmpty) {
      emit(state.copyWith(reason: reasonList.first, status: OrderComplaintsModalStatus.success));
    }
  }

  FutureOr<void> _onOrderComplaintModalReasonSelectEvent(OrderComplaintModalReasonSelectEvent event, Emitter<OrderComplaintsModalState> emit) async {
    emit(state.copyWith(reason: event.reason, status: OrderComplaintsModalStatus.success));
  }

  FutureOr<void> _onOrderComplaintModalTitleChangedEvent(OrderComplaintModalTitleChangedEvent event, Emitter<OrderComplaintsModalState> emit) async {
    final title = ComplaintsTitleField.dirty(event.title);
    emit(state.copyWith(complaintTitle: title.isValid ? title : ComplaintsTitleField.pure(event.title), isValid: Formz.validate([title, state.complaintBrief]), status: OrderComplaintsModalStatus.success));
  }

  FutureOr<void> _onOrderComplaintModalTitleUnfocusedEvent(OrderComplaintModalTitleUnfocusedEvent event, Emitter<OrderComplaintsModalState> emit) async {
    final title = ComplaintsTitleField.dirty(state.complaintTitle.value);
    emit(state.copyWith(complaintTitle: title, isValid: Formz.validate([title, state.complaintBrief]), status: OrderComplaintsModalStatus.success));
  }

  FutureOr<void> _onOrderComplaintModalBriefChangedEvent(OrderComplaintModalBriefChangedEvent event, Emitter<OrderComplaintsModalState> emit) async {
    final brief = ComplaintsBriefField.dirty(event.brief);
    emit(state.copyWith(complaintBrief: brief.isValid ? brief : ComplaintsBriefField.pure(event.brief), isValid: Formz.validate([brief, state.complaintTitle]), status: OrderComplaintsModalStatus.success));
  }

  FutureOr<void> _onOrderComplaintModalBriefUnfocusedEvent(OrderComplaintModalBriefUnfocusedEvent event, Emitter<OrderComplaintsModalState> emit) async {
    final brief = ComplaintsBriefField.dirty(state.complaintBrief.value);
    emit(state.copyWith(complaintBrief: brief, isValid: Formz.validate([brief, state.complaintTitle]), status: OrderComplaintsModalStatus.success));
  }

  FutureOr<void> _onOrderComplaintModalUploadImageEvent(OrderComplaintModalUploadImageEvent event, Emitter<OrderComplaintsModalState> emit) async {
    try {
      emit(state.copyWith(status: OrderComplaintsModalStatus.uploadStarted));
      final String userId = await _orderRepository.userId();
      DioApiResponse response = await _orderRepository.uploadMediaImage(event.newImage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        UploadImageModel data = UploadImageModel.fromJson(myMap);
        List<String> imageList = <String>[];
        for (var element in state.imageProof) {
          imageList.add(element);
        }
        imageList.add(data.path!);
        emit(state.copyWith(status: OrderComplaintsModalStatus.uploadSuccess, imageProof: imageList));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderComplaintsModalStatus.uploadFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderComplaintsModalStatus.uploadFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderComplaintModalRemoveUploadImageEvent(OrderComplaintModalRemoveUploadImageEvent event, Emitter<OrderComplaintsModalState> emit) async {
    try {
      emit(state.copyWith(status: OrderComplaintsModalStatus.mediaDeleteStarted, mediaDeleteIndex: event.index));
      final String userId = await _orderRepository.userId();
      RemoveImageFileRequestModel param = RemoveImageFileRequestModel(path: state.imageProof[event.index], uid: userId);
      DioApiResponse response = await _orderRepository.deleteMediaFile(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: OrderComplaintsModalStatus.mediaDeleteFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          state.imageProof.removeAt(event.index);
          emit(state.copyWith(status: OrderComplaintsModalStatus.mediaDeleteSuccess, imageProof: [...state.imageProof]));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderComplaintsModalStatus.mediaDeleteFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderComplaintsModalStatus.mediaDeleteFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderComplaintModalSubmitEvent(OrderComplaintModalSubmitEvent event, Emitter<OrderComplaintsModalState> emit) async {
    final title = ComplaintsTitleField.dirty(state.complaintTitle.value);
    final brief = ComplaintsBriefField.dirty(state.complaintBrief.value);
    emit(state.copyWith(complaintTitle: title, complaintBrief: brief, isValid: Formz.validate([title, brief]), status: OrderComplaintsModalStatus.success));
    if (state.isValid && state.complaintTitle.value.isNotEmpty && state.complaintBrief.value.isNotEmpty) {
      try {
        final String issueFrom = state.complaintTo.value!;
        String userId = '';
        String driverId = '';
        final String vendorId = await _orderRepository.getVendorId();
        final String user = await _orderRepository.userId();
        final String title = state.complaintTitle.value;
        final String brief = state.complaintBrief.value;
        final String proof = state.imageProof.join(',');
        String complaintsReasonId = state.reason.id!.isNotEmpty ? state.reason.id! : '';
        if (issueFrom == 'customer') {
          userId = state.detail.details!.customer!.id!;
        } else {
          driverId = state.detail.details!.driverInfo!.id!;
        }

        SaveOrderComplaintRequestModel param = SaveOrderComplaintRequestModel(
          orders: state.orderId,
          reason: complaintsReasonId,
          title: title,
          brief: brief,
          proof: proof,
          issueWith: issueFrom,
          restaurant: vendorId,
          driver: driverId,
          customer: userId,
          user: user,
        );
        emit(state.copyWith(status: OrderComplaintsModalStatus.inProgress));
        DioApiResponse response = await _orderRepository.saveComplaint(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (!initialResponse.success!) {
            emit(state.copyWith(status: OrderComplaintsModalStatus.submitFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          } else {
            emit(state.copyWith(status: OrderComplaintsModalStatus.submitSuccess));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrderComplaintsModalStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrderComplaintsModalStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
