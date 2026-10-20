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
import 'package:intl/intl.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/order_coupon_info_response_model.dart';
import 'package:vendor/app/core/models/order_coupon_list_model.dart';
import 'package:vendor/app/core/models/request/order_coupon_info_request_model.dart';
import 'package:vendor/app/core/models/request/order_coupon_new_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/order_coupon_translation_form.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/coupon_repository.dart';
import 'package:vendor/app/core/validations/order_coupon_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dialog_order_coupon_event.dart';
part 'dialog_order_coupon_state.dart';

class DialogOrderCouponBloc extends Bloc<DialogOrderCouponEvent, DialogOrderCouponState> {
  final CouponRepository _couponRepository = CouponRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DialogOrderCouponBloc()
    : super(
        DialogOrderCouponState(
          type: OrderCouponTypeModel(label: '', value: ''),
          model: OrderCouponInfoResponseModel(locale: ''),
        ),
      ) {
    on<DialogOrderCouponInitialEvent>(_onDialogOrderCouponInitialEvent);
    on<DialogOrderCouponNameChangedEvent>(_onDialogOrderCouponNameChangedEvent);
    on<DialogOrderCouponNameUnfocusedEvent>(_onDialogOrderCouponNameUnfocusedEvent);
    on<DialogOrderCouponCodeChangedEvent>(_onDialogOrderCouponCodeChangedEvent);
    on<DialogOrderCouponCodeUnfocusedEvent>(_onDialogOrderCouponCodeUnfocusedEvent);
    on<DialogOrderCouponLimitChangedEvent>(_onDialogOrderCouponLimitChangedEvent);
    on<DialogOrderCouponLimitUnfocusedEvent>(_onDialogOrderCouponLimitUnfocusedEvent);
    on<DialogOrderCouponStartDateChangedEvent>(_onDialogOrderCouponStartDateChangedEvent);
    on<DialogOrderCouponStartDateUnfocusedEvent>(_onDialogOrderCouponStartDateUnfocusedEvent);
    on<DialogOrderCouponExpireDateChangedEvent>(_onDialogOrderCouponExpireDateChangedEvent);
    on<DialogOrderCouponExpireDateUnfocusedEvent>(_onDialogOrderCouponExpireDateUnfocusedEvent);
    on<DialogOrderCouponMinDiscountChangedEvent>(_onDialogOrderCouponMinDiscountChangedEvent);
    on<DialogOrderCouponMinDiscountUnfocusedEvent>(_onDialogOrderCouponMinDiscountUnfocusedEvent);
    on<DialogOrderCouponMaxDiscountChangedEvent>(_onDialogOrderCouponMaxDiscountChangedEvent);
    on<DialogOrderCouponMaxDiscountUnfocusedEvent>(_onDialogOrderCouponMaxDiscountUnfocusedEvent);
    on<DialogOrderCouponMinCartChangedEvent>(_onDialogOrderCouponMinCartChangedEvent);
    on<DialogOrderCouponMinCartUnfocusedEvent>(_onDialogOrderCouponMinCartUnfocusedEvent);
    on<DialogOrderCouponTypeEvent>(_onDialogOrderCouponTypeEvent);
    on<DialogOrderCouponSubmitEvent>(_onDialogOrderCouponSubmitEvent);
  }

  FutureOr<void> _onDialogOrderCouponInitialEvent(DialogOrderCouponInitialEvent event, Emitter<DialogOrderCouponState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_order_coupon"}, 'add_update_order_coupon_screen', 'add_update_order_coupon_screen');
    if (!event.isNew) {
      try {
        final String userId = await _couponRepository.getUserId();
        OrderCouponInfoRequestModel param = OrderCouponInfoRequestModel(id: event.model.id!, userId: userId);
        DioApiResponse response = await _couponRepository.getOrderCouponInfo(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OrderCouponInfoResponseModel data = OrderCouponInfoResponseModel.fromJson(myMap, locale.toString());

          final orderCouponName = OrderCouponNameField.dirty(data.info!.realName!);
          final orderCouponCode = OrderCouponCodeField.dirty(data.info!.code!);
          final orderCouponLimit = OrderCouponLimitField.dirty(data.info!.limitSameUser!.toString());
          DateTime startDateParse = DateTime.parse(data.info!.start!);
          String startDate = DateFormat('yyyy-MM-dd').format(startDateParse);
          final orderCouponStartDate = OrderCouponStartDateField.dirty(startDate);
          DateTime endDateParse = DateTime.parse(data.info!.expires!);
          String endDate = DateFormat('yyyy-MM-dd').format(endDateParse);
          final orderCouponExpireDate = OrderCouponExpireDateField.dirty(endDate);
          final orderCouponMinDiscount = OrderCouponMinDiscountField.dirty(data.info!.minDiscount!.toString());
          final orderCouponMaxDiscount = OrderCouponMaxDiscountField.dirty(data.info!.maxDiscount!.toString());
          final orderCouponMinCart = OrderCouponMinCartField.dirty(data.info!.minCartTotal!.toString());

          List<OrderCouponTypeModel> typeList = <OrderCouponTypeModel>[];
          typeList.clear();
          OrderCouponTypeModel amount = OrderCouponTypeModel(label: 'dd_amount', value: 'amount');
          OrderCouponTypeModel percentage = OrderCouponTypeModel(label: 'dd_percentage', value: 'percentage');
          typeList.add(amount);
          typeList.add(percentage);
          final int indexOfType = typeList.indexWhere((element) => element.value == data.info!.discountType!);
          emit(
            state.copyWith(
              couponId: event.model.id!,
              orderCouponName: orderCouponName,
              orderCouponCode: orderCouponCode,
              orderCouponLimit: orderCouponLimit,
              orderCouponStartDate: orderCouponStartDate,
              orderCouponExpireDate: orderCouponExpireDate,
              orderCouponMinDiscount: orderCouponMinDiscount,
              orderCouponMaxDiscount: orderCouponMaxDiscount,
              orderCouponMinCart: orderCouponMinCart,
              status: DialogOrderCouponStatus.success,
              model: data,
              isNew: event.isNew,
              type: indexOfType != -1 ? typeList[indexOfType] : typeList.first,
              typeList: typeList,
              isValid: Formz.validate([orderCouponName, orderCouponCode, orderCouponLimit, orderCouponStartDate, orderCouponExpireDate, orderCouponMinDiscount, orderCouponMaxDiscount, orderCouponMinCart]),
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DialogOrderCouponStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DialogOrderCouponStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      List<OrderCouponTypeModel> typeList = <OrderCouponTypeModel>[];
      typeList.clear();
      OrderCouponTypeModel amount = OrderCouponTypeModel(label: 'dd_amount', value: 'amount');
      OrderCouponTypeModel percentage = OrderCouponTypeModel(label: 'dd_percentage', value: 'percentage');
      typeList.add(amount);
      typeList.add(percentage);
      emit(state.copyWith(status: DialogOrderCouponStatus.success, isNew: event.isNew, type: typeList.first, typeList: typeList));
      if (state.type.value == 'amount') {
        const maxDiscount = OrderCouponMaxDiscountField.dirty('0');
        emit(state.copyWith(orderCouponMaxDiscount: maxDiscount, status: DialogOrderCouponStatus.success));
      }
    }
  }

  FutureOr<void> _onDialogOrderCouponNameChangedEvent(DialogOrderCouponNameChangedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponName = OrderCouponNameField.dirty(event.name);
    emit(
      state.copyWith(
        orderCouponName: couponName.isValid ? couponName : OrderCouponNameField.pure(event.name),
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponNameUnfocusedEvent(DialogOrderCouponNameUnfocusedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponName = OrderCouponNameField.dirty(state.orderCouponName.value);
    emit(
      state.copyWith(
        orderCouponName: couponName,
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponCodeChangedEvent(DialogOrderCouponCodeChangedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponCode = OrderCouponCodeField.dirty(event.code);
    emit(
      state.copyWith(
        orderCouponCode: couponCode.isValid ? couponCode : OrderCouponCodeField.pure(event.code),
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponCode,
          state.orderCouponName,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponCodeUnfocusedEvent(DialogOrderCouponCodeUnfocusedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponCode = OrderCouponCodeField.dirty(state.orderCouponCode.value);
    emit(
      state.copyWith(
        orderCouponCode: couponCode,
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponCode,
          state.orderCouponName,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponLimitChangedEvent(DialogOrderCouponLimitChangedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponLimit = OrderCouponLimitField.dirty(event.limit);
    emit(
      state.copyWith(
        orderCouponLimit: couponLimit.isValid ? couponLimit : OrderCouponLimitField.pure(event.limit),
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponLimit,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponLimitUnfocusedEvent(DialogOrderCouponLimitUnfocusedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponLimit = OrderCouponLimitField.dirty(state.orderCouponLimit.value);
    emit(
      state.copyWith(
        orderCouponLimit: couponLimit,
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponLimit,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponStartDateChangedEvent(DialogOrderCouponStartDateChangedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponStartDate = OrderCouponStartDateField.dirty(event.startDate);
    emit(
      state.copyWith(
        orderCouponStartDate: couponStartDate.isValid ? couponStartDate : OrderCouponStartDateField.pure(event.startDate),
        status: DialogOrderCouponStatus.success,
        isValid: Formz.validate([
          couponStartDate,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponStartDateUnfocusedEvent(DialogOrderCouponStartDateUnfocusedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponStartDate = OrderCouponStartDateField.dirty(state.orderCouponStartDate.value);
    emit(
      state.copyWith(
        orderCouponStartDate: couponStartDate,
        status: DialogOrderCouponStatus.success,
        isValid: Formz.validate([
          couponStartDate,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponExpireDateChangedEvent(DialogOrderCouponExpireDateChangedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponExpireDate = OrderCouponExpireDateField.dirty(event.expireDate);
    emit(
      state.copyWith(
        orderCouponExpireDate: couponExpireDate.isValid ? couponExpireDate : OrderCouponExpireDateField.pure(event.expireDate),
        status: DialogOrderCouponStatus.success,
        isValid: Formz.validate([
          couponExpireDate,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponExpireDateUnfocusedEvent(DialogOrderCouponExpireDateUnfocusedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponExpireDate = OrderCouponExpireDateField.dirty(state.orderCouponExpireDate.value);
    emit(
      state.copyWith(
        orderCouponExpireDate: couponExpireDate,
        status: DialogOrderCouponStatus.success,
        isValid: Formz.validate([
          couponExpireDate,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponMinDiscountChangedEvent(DialogOrderCouponMinDiscountChangedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponMinDiscount = OrderCouponMinDiscountField.dirty(event.minDiscount);
    emit(
      state.copyWith(
        orderCouponMinDiscount: couponMinDiscount.isValid ? couponMinDiscount : OrderCouponMinDiscountField.pure(event.minDiscount),
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMinDiscount,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponMinDiscountUnfocusedEvent(DialogOrderCouponMinDiscountUnfocusedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponMinDiscount = OrderCouponMinDiscountField.dirty(state.orderCouponMinDiscount.value);
    emit(
      state.copyWith(
        orderCouponMinDiscount: couponMinDiscount,
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMinDiscount,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMaxDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponMaxDiscountChangedEvent(DialogOrderCouponMaxDiscountChangedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponMaxDiscount = OrderCouponMaxDiscountField.dirty(event.maxDiscount);
    emit(
      state.copyWith(
        orderCouponMaxDiscount: couponMaxDiscount.isValid ? couponMaxDiscount : OrderCouponMaxDiscountField.pure(event.maxDiscount),
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMaxDiscount,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponMaxDiscountUnfocusedEvent(DialogOrderCouponMaxDiscountUnfocusedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponMaxDiscount = OrderCouponMaxDiscountField.dirty(state.orderCouponMaxDiscount.value);
    emit(
      state.copyWith(
        orderCouponMaxDiscount: couponMaxDiscount,
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMaxDiscount,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMinCart,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponMinCartChangedEvent(DialogOrderCouponMinCartChangedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponMinCart = OrderCouponMinCartField.dirty(event.minCart);
    emit(
      state.copyWith(
        orderCouponMinCart: couponMinCart.isValid ? couponMinCart : OrderCouponMinCartField.pure(event.minCart),
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMinCart,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponMinCartUnfocusedEvent(DialogOrderCouponMinCartUnfocusedEvent event, Emitter<DialogOrderCouponState> emit) async {
    final couponMinCart = OrderCouponMinCartField.dirty(state.orderCouponMinCart.value);
    emit(
      state.copyWith(
        orderCouponMinCart: couponMinCart,
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMinCart,
          state.orderCouponName,
          state.orderCouponCode,
          state.orderCouponLimit,
          state.orderCouponStartDate,
          state.orderCouponExpireDate,
          state.orderCouponMinDiscount,
          state.orderCouponMaxDiscount,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogOrderCouponTypeEvent(DialogOrderCouponTypeEvent event, Emitter<DialogOrderCouponState> emit) async {
    if (event.type.value == 'amount') {
      const maxDiscount = OrderCouponMaxDiscountField.dirty('0');
      emit(state.copyWith(orderCouponMaxDiscount: maxDiscount, status: DialogOrderCouponStatus.success));
    } else {
      const maxDiscount = OrderCouponMaxDiscountField.dirty('');
      emit(state.copyWith(orderCouponMaxDiscount: maxDiscount, status: DialogOrderCouponStatus.success));
    }
    emit(state.copyWith(type: event.type, status: DialogOrderCouponStatus.changeDetail));
  }

  FutureOr<void> _onDialogOrderCouponSubmitEvent(DialogOrderCouponSubmitEvent event, Emitter<DialogOrderCouponState> emit) async {
    final orderCouponName = OrderCouponNameField.dirty(state.orderCouponName.value);
    final orderCouponCode = OrderCouponCodeField.dirty(state.orderCouponCode.value);
    final orderCouponLimit = OrderCouponLimitField.dirty(state.orderCouponLimit.value);
    final orderCouponStartDate = OrderCouponStartDateField.dirty(state.orderCouponStartDate.value);
    final orderCouponExpireDate = OrderCouponExpireDateField.dirty(state.orderCouponExpireDate.value);
    final orderCouponMinDiscount = OrderCouponMinDiscountField.dirty(state.orderCouponMinDiscount.value);
    final orderCouponMaxDiscount = OrderCouponMaxDiscountField.dirty(state.orderCouponMaxDiscount.value);
    final orderCouponMinCart = OrderCouponMinCartField.dirty(state.orderCouponMinCart.value);
    emit(
      state.copyWith(
        orderCouponName: orderCouponName,
        orderCouponCode: orderCouponCode,
        orderCouponLimit: orderCouponLimit,
        orderCouponStartDate: orderCouponStartDate,
        orderCouponExpireDate: orderCouponExpireDate,
        orderCouponMinDiscount: orderCouponMinDiscount,
        orderCouponMaxDiscount: orderCouponMaxDiscount,
        orderCouponMinCart: orderCouponMinCart,
        status: DialogOrderCouponStatus.changeDetail,
        isValid: Formz.validate([orderCouponName, orderCouponCode, orderCouponLimit, orderCouponStartDate, orderCouponExpireDate, orderCouponMinDiscount, orderCouponMaxDiscount, orderCouponMinCart]),
      ),
    );
    if (state.isValid &&
        state.orderCouponName.value.isNotEmpty &&
        state.orderCouponCode.value.isNotEmpty &&
        state.orderCouponLimit.value.isNotEmpty &&
        state.orderCouponStartDate.value.isNotEmpty &&
        state.orderCouponExpireDate.value.isNotEmpty &&
        state.orderCouponMinDiscount.value.isNotEmpty &&
        state.orderCouponMaxDiscount.value.isNotEmpty &&
        state.orderCouponMinCart.value.isNotEmpty) {
      if (state.isNew) {
        try {
          emit(state.copyWith(status: DialogOrderCouponStatus.submit));
          final String vendorId = await _couponRepository.getVendorId();
          final String userId = await _couponRepository.getUserId();
          OrderCouponNewRequestModel param = OrderCouponNewRequestModel(
            name: state.orderCouponName.value.toString(),
            code: state.orderCouponCode.value.toString(),
            limitSameUser: state.orderCouponLimit.value.toString(),
            start: state.orderCouponStartDate.value.toString(),
            expires: state.orderCouponExpireDate.value.toString(),
            minDiscount: state.orderCouponMinDiscount.value.toString(),
            maxDiscount: state.orderCouponMaxDiscount.value.toString(),
            minCartTotal: state.orderCouponMinCart.value.toString(),
            discountType: state.type.value,
            restaurantId: vendorId,
            createdById: userId,
            translations: event.translations,
          );
          DioApiResponse response = await _couponRepository.saveOrderCoupon(param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: DialogOrderCouponStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: DialogOrderCouponStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: DialogOrderCouponStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      } else {
        try {
          emit(state.copyWith(status: DialogOrderCouponStatus.submit));
          final String vendorId = await _couponRepository.getVendorId();
          final String userId = await _couponRepository.getUserId();
          OrderCouponNewRequestModel param = OrderCouponNewRequestModel(
            name: state.orderCouponName.value.toString(),
            code: state.orderCouponCode.value.toString(),
            limitSameUser: state.orderCouponLimit.value.toString(),
            start: state.orderCouponStartDate.value.toString(),
            expires: state.orderCouponExpireDate.value.toString(),
            minDiscount: state.orderCouponMinDiscount.value.toString(),
            maxDiscount: state.orderCouponMaxDiscount.value.toString(),
            minCartTotal: state.orderCouponMinCart.value.toString(),
            discountType: state.type.value,
            restaurantId: vendorId,
            createdById: userId,
            translations: event.translations,
          );
          DioApiResponse response = await _couponRepository.updateOrderCoupon(state.couponId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: DialogOrderCouponStatus.updateSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: DialogOrderCouponStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: DialogOrderCouponStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    }
  }
}
