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
import 'package:vendor/app/core/models/dining_coupon_info_response_model.dart';
import 'package:vendor/app/core/models/dining_coupon_list_response_model.dart';
import 'package:vendor/app/core/models/request/dining_coupon_info_request_model.dart';
import 'package:vendor/app/core/models/request/dining_coupon_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/dining_coupon_translation_form.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/coupon_repository.dart';
import 'package:vendor/app/core/validations/dining_coupon_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dialog_dining_coupon_event.dart';
part 'dialog_dining_coupon_state.dart';

class DialogDiningCouponBloc extends Bloc<DialogDiningCouponEvent, DialogDiningCouponState> {
  final CouponRepository _couponRepository = CouponRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DialogDiningCouponBloc()
    : super(
        DialogDiningCouponState(
          type: DiningCouponTypeModel(label: '', value: ''),
          availability: DiningCouponAvailabilityModel(label: '', value: ''),
          preeBookingChargeRequired: DiningCouponPreBookingModel(label: '', value: false),
          model: DiningCouponInfoResponseModel(locale: ''),
        ),
      ) {
    on<DialogDiningCouponInitialEvent>(_onDialogDiningCouponInitialEvent);
    on<DialogDiningCouponNameChangedEvent>(_onDialogDiningCouponNameChangedEvent);
    on<DialogDiningCouponNameUnfocusedEvent>(_onDialogDiningCouponNameUnfocusedEvent);
    on<DialogDiningCouponCodeChangedEvent>(_onDialogDiningCouponCodeChangedEvent);
    on<DialogDiningCouponCodeUnfocusedEvent>(_onDialogDiningCouponCodeUnfocusedEvent);
    on<DialogDiningCouponLimitChangedEvent>(_onDialogDiningCouponLimitChangedEvent);
    on<DialogDiningCouponLimitUnfocusedEvent>(_onDialogDiningCouponLimitUnfocusedEvent);
    on<DialogDiningCouponStartDateChangedEvent>(_onDialogDiningCouponStartDateChangedEvent);
    on<DialogDiningCouponStartDateUnfocusedEvent>(_onDialogDiningCouponStartDateUnfocusedEvent);
    on<DialogDiningCouponExpireDateChangedEvent>(_onDialogDiningCouponExpireDateChangedEvent);
    on<DialogDiningCouponExpireDateUnfocusedEvent>(_onDialogDiningCouponExpireDateUnfocusedEvent);
    on<DialogDiningCouponMinDiscountChangedEvent>(_onDialogDiningCouponMinDiscountChangedEvent);
    on<DialogDiningCouponMinDiscountUnfocusedEvent>(_onDialogDiningCouponMinDiscountUnfocusedEvent);
    on<DialogDiningCouponMaxDiscountChangedEvent>(_onDialogDiningCouponMaxDiscountChangedEvent);
    on<DialogDiningCouponMaxDiscountUnfocusedEvent>(_onDialogDiningCouponMaxDiscountUnfocusedEvent);
    on<DialogDiningCouponPreBookingChargeChangedEvent>(_onDialogDiningCouponPreBookingChargeChangedEvent);
    on<DialogDiningCouponPreBookingChargeUnfocusedEvent>(_onDialogDiningCouponPreBookingChargeUnfocusedEvent);
    on<DialogDiningTypeChangeEvent>(_onDialogDiningTypeChangeEvent);
    on<DialogDiningCouponAvailabilityChangeEvent>(_onDialogDiningCouponAvailabilityChangeEvent);
    on<DialogDiningCouponPreBookingChargeChangeEvent>(_onDialogDiningCouponPreBookingChargeChangeEvent);
    on<DialogDiningCouponSubmitEvent>(_onDialogDiningCouponSubmitEvent);
  }

  FutureOr<void> _onDialogDiningCouponInitialEvent(DialogDiningCouponInitialEvent event, Emitter<DialogDiningCouponState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_dining_booking_coupon"}, 'add_update_dining_booking_coupon_screen', 'add_update_dining_booking_coupon_screen');
    if (event.isNew) {
      List<DiningCouponTypeModel> typeList = <DiningCouponTypeModel>[];
      typeList.clear();
      DiningCouponTypeModel amount = DiningCouponTypeModel(label: 'dd_amount', value: 'amount');
      DiningCouponTypeModel percentage = DiningCouponTypeModel(label: 'dd_percentage', value: 'percentage');
      typeList.add(amount);
      typeList.add(percentage);

      List<DiningCouponAvailabilityModel> availabilityList = <DiningCouponAvailabilityModel>[];
      availabilityList.clear();
      DiningCouponAvailabilityModel breakfast = DiningCouponAvailabilityModel(label: 'dd_breakfast', value: 'breakfast');
      DiningCouponAvailabilityModel lunch = DiningCouponAvailabilityModel(label: 'dd_lunch', value: 'lunch');
      DiningCouponAvailabilityModel dinner = DiningCouponAvailabilityModel(label: 'dd_dinner', value: 'dinner');
      availabilityList.add(breakfast);
      availabilityList.add(lunch);
      availabilityList.add(dinner);

      List<DiningCouponPreBookingModel> preBookingPermissionList = <DiningCouponPreBookingModel>[];
      preBookingPermissionList.clear();
      DiningCouponPreBookingModel yesRequired = DiningCouponPreBookingModel(label: 'dd_yes', value: true);
      DiningCouponPreBookingModel notRequired = DiningCouponPreBookingModel(label: 'dd_no', value: false);
      preBookingPermissionList.add(yesRequired);
      preBookingPermissionList.add(notRequired);

      emit(
        state.copyWith(
          status: DialogDiningCouponStatus.success,
          isNew: event.isNew,
          type: typeList.first,
          typeList: typeList,
          availability: availabilityList.first,
          availabilityList: availabilityList,
          preeBookingChargeRequired: preBookingPermissionList.first,
          preeBookingChargeRequiredList: preBookingPermissionList,
        ),
      );
      if (state.type.value == 'amount') {
        const maxDiscount = DiningCouponMaxDiscountField.dirty('0');
        emit(state.copyWith(diningCouponMaxDiscount: maxDiscount, status: DialogDiningCouponStatus.success));
      }
    } else {
      try {
        final String userId = await _couponRepository.getUserId();
        DiningCouponInfoRequestModel param = DiningCouponInfoRequestModel(id: event.model.id!, userId: userId);
        DioApiResponse response = await _couponRepository.getDiningCouponInfo(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          DiningCouponInfoResponseModel data = DiningCouponInfoResponseModel.fromJson(myMap, locale.toString());

          final diningCouponName = DiningCouponNameField.dirty(data.info!.realName!.toString());
          final diningCouponCode = DiningCouponCodeField.dirty(data.info!.code!.toString());
          final diningCouponLimit = DiningCouponLimitField.dirty(data.info!.limitSameUser!.toString());
          DateTime startDateParse = DateTime.parse(data.info!.start!);
          String startDate = DateFormat('yyyy-MM-dd').format(startDateParse);
          final diningCouponStartDate = DiningCouponStartDateField.dirty(startDate);
          DateTime endDateParse = DateTime.parse(data.info!.expires!);
          String endDate = DateFormat('yyyy-MM-dd').format(endDateParse);
          final diningCouponExpireDate = DiningCouponExpireDateField.dirty(endDate);
          final diningCouponMinDiscount = DiningCouponMinDiscountField.dirty(data.info!.minDiscount!.toString());
          final diningCouponMaxDiscount = DiningCouponMaxDiscountField.dirty(data.info!.maxDiscount!.toString());
          final diningCouponPreBookingCharge = DiningCouponPreBookingChargeField.dirty(data.info!.preBookingChargeAmount!.toString());

          List<DiningCouponTypeModel> typeList = <DiningCouponTypeModel>[];
          typeList.clear();
          DiningCouponTypeModel amount = DiningCouponTypeModel(label: 'dd_amount', value: 'amount');
          DiningCouponTypeModel percentage = DiningCouponTypeModel(label: 'dd_percentage', value: 'percentage');
          typeList.add(amount);
          typeList.add(percentage);

          List<DiningCouponAvailabilityModel> availabilityList = <DiningCouponAvailabilityModel>[];
          availabilityList.clear();
          DiningCouponAvailabilityModel breakfast = DiningCouponAvailabilityModel(label: 'dd_breakfast', value: 'breakfast');
          DiningCouponAvailabilityModel lunch = DiningCouponAvailabilityModel(label: 'dd_lunch', value: 'lunch');
          DiningCouponAvailabilityModel dinner = DiningCouponAvailabilityModel(label: 'dd_dinner', value: 'dinner');
          availabilityList.add(breakfast);
          availabilityList.add(lunch);
          availabilityList.add(dinner);

          List<DiningCouponPreBookingModel> preBookingPermissionList = <DiningCouponPreBookingModel>[];
          preBookingPermissionList.clear();
          DiningCouponPreBookingModel yesRequired = DiningCouponPreBookingModel(label: 'dd_yes', value: true);
          DiningCouponPreBookingModel notRequired = DiningCouponPreBookingModel(label: 'dd_no', value: false);
          preBookingPermissionList.add(yesRequired);
          preBookingPermissionList.add(notRequired);

          final int indexOfType = typeList.indexWhere((element) => element.value == data.info!.discountType!);
          final int indexOfAvailability = availabilityList.indexWhere((element) => element.value == data.info!.availability!);
          final int indexOfPreBookingCharge = preBookingPermissionList.indexWhere((element) => element.value == data.info!.preBookingChargeRequired!);
          emit(
            state.copyWith(
              couponId: event.model.id!,
              status: DialogDiningCouponStatus.success,
              model: data,
              isNew: event.isNew,
              type: indexOfType != -1 ? typeList[indexOfType] : typeList.first,
              typeList: typeList,
              availability: indexOfAvailability != -1 ? availabilityList[indexOfAvailability] : availabilityList.first,
              availabilityList: availabilityList,
              preeBookingChargeRequired: indexOfPreBookingCharge != -1 ? preBookingPermissionList[indexOfPreBookingCharge] : preBookingPermissionList.first,
              preeBookingChargeRequiredList: preBookingPermissionList,
              diningCouponName: diningCouponName,
              diningCouponCode: diningCouponCode,
              diningCouponLimit: diningCouponLimit,
              diningCouponStartDate: diningCouponStartDate,
              diningCouponExpireDate: diningCouponExpireDate,
              diningCouponMinDiscount: diningCouponMinDiscount,
              diningCouponMaxDiscount: diningCouponMaxDiscount,
              diningCouponPreBookingCharge: diningCouponPreBookingCharge,
              isValid: Formz.validate([diningCouponName, diningCouponCode, diningCouponLimit, diningCouponStartDate, diningCouponExpireDate, diningCouponMinDiscount, diningCouponMaxDiscount, diningCouponPreBookingCharge]),
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DialogDiningCouponStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DialogDiningCouponStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onDialogDiningCouponNameChangedEvent(DialogDiningCouponNameChangedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponName = DiningCouponNameField.dirty(event.name);
    emit(
      state.copyWith(
        diningCouponName: couponName.isValid ? couponName : DiningCouponNameField.pure(event.name),
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponNameUnfocusedEvent(DialogDiningCouponNameUnfocusedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponName = DiningCouponNameField.dirty(state.diningCouponName.value);
    emit(
      state.copyWith(
        diningCouponName: couponName,
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponCodeChangedEvent(DialogDiningCouponCodeChangedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponCode = DiningCouponCodeField.dirty(event.code);
    emit(
      state.copyWith(
        diningCouponCode: couponCode.isValid ? couponCode : DiningCouponCodeField.pure(event.code),
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponCode,
          state.diningCouponName,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponCodeUnfocusedEvent(DialogDiningCouponCodeUnfocusedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponCode = DiningCouponCodeField.dirty(state.diningCouponCode.value);
    emit(
      state.copyWith(
        diningCouponCode: couponCode,
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponCode,
          state.diningCouponName,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponLimitChangedEvent(DialogDiningCouponLimitChangedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponLimit = DiningCouponLimitField.dirty(event.limit);
    emit(
      state.copyWith(
        diningCouponLimit: couponLimit.isValid ? couponLimit : DiningCouponLimitField.pure(event.limit),
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponLimit,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponLimitUnfocusedEvent(DialogDiningCouponLimitUnfocusedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponLimit = DiningCouponLimitField.dirty(state.diningCouponLimit.value);
    emit(
      state.copyWith(
        diningCouponLimit: couponLimit,
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponLimit,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponStartDateChangedEvent(DialogDiningCouponStartDateChangedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponStartDate = DiningCouponStartDateField.dirty(event.startDate);
    emit(
      state.copyWith(
        diningCouponStartDate: couponStartDate.isValid ? couponStartDate : DiningCouponStartDateField.pure(event.startDate),
        status: DialogDiningCouponStatus.success,
        isValid: Formz.validate([
          couponStartDate,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponStartDateUnfocusedEvent(DialogDiningCouponStartDateUnfocusedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponStartDate = DiningCouponStartDateField.dirty(state.diningCouponStartDate.value);
    emit(
      state.copyWith(
        diningCouponStartDate: couponStartDate,
        status: DialogDiningCouponStatus.success,
        isValid: Formz.validate([
          couponStartDate,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponExpireDateChangedEvent(DialogDiningCouponExpireDateChangedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponExpireDate = DiningCouponExpireDateField.dirty(event.expireDate);
    emit(
      state.copyWith(
        diningCouponExpireDate: couponExpireDate.isValid ? couponExpireDate : DiningCouponExpireDateField.pure(event.expireDate),
        status: DialogDiningCouponStatus.success,
        isValid: Formz.validate([
          couponExpireDate,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponExpireDateUnfocusedEvent(DialogDiningCouponExpireDateUnfocusedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponExpireDate = DiningCouponExpireDateField.dirty(state.diningCouponExpireDate.value);
    emit(
      state.copyWith(
        diningCouponExpireDate: couponExpireDate,
        status: DialogDiningCouponStatus.success,
        isValid: Formz.validate([
          couponExpireDate,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponMinDiscountChangedEvent(DialogDiningCouponMinDiscountChangedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponMinDiscount = DiningCouponMinDiscountField.dirty(event.minDiscount);
    emit(
      state.copyWith(
        diningCouponMinDiscount: couponMinDiscount.isValid ? couponMinDiscount : DiningCouponMinDiscountField.pure(event.minDiscount),
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMinDiscount,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponMinDiscountUnfocusedEvent(DialogDiningCouponMinDiscountUnfocusedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponMinDiscount = DiningCouponMinDiscountField.dirty(state.diningCouponMinDiscount.value);
    emit(
      state.copyWith(
        diningCouponMinDiscount: couponMinDiscount,
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMinDiscount,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMaxDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponMaxDiscountChangedEvent(DialogDiningCouponMaxDiscountChangedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponMaxDiscount = DiningCouponMaxDiscountField.dirty(event.maxDiscount);
    emit(
      state.copyWith(
        diningCouponMaxDiscount: couponMaxDiscount.isValid ? couponMaxDiscount : DiningCouponMaxDiscountField.pure(event.maxDiscount),
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMaxDiscount,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponMaxDiscountUnfocusedEvent(DialogDiningCouponMaxDiscountUnfocusedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponMaxDiscount = DiningCouponMaxDiscountField.dirty(state.diningCouponMaxDiscount.value);
    emit(
      state.copyWith(
        diningCouponMaxDiscount: couponMaxDiscount,
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponMaxDiscount,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponPreBookingCharge,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponPreBookingChargeChangedEvent(DialogDiningCouponPreBookingChargeChangedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponpreBookingCharge = DiningCouponPreBookingChargeField.dirty(event.preBookingCharge);
    emit(
      state.copyWith(
        diningCouponPreBookingCharge: couponpreBookingCharge.isValid ? couponpreBookingCharge : DiningCouponPreBookingChargeField.pure(event.preBookingCharge),
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponpreBookingCharge,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningCouponPreBookingChargeUnfocusedEvent(DialogDiningCouponPreBookingChargeUnfocusedEvent event, Emitter<DialogDiningCouponState> emit) async {
    final couponPreBookingCharge = DiningCouponPreBookingChargeField.dirty(state.diningCouponPreBookingCharge.value);
    emit(
      state.copyWith(
        diningCouponPreBookingCharge: couponPreBookingCharge,
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([
          couponPreBookingCharge,
          state.diningCouponName,
          state.diningCouponCode,
          state.diningCouponLimit,
          state.diningCouponStartDate,
          state.diningCouponExpireDate,
          state.diningCouponMinDiscount,
          state.diningCouponMaxDiscount,
        ]),
      ),
    );
  }

  FutureOr<void> _onDialogDiningTypeChangeEvent(DialogDiningTypeChangeEvent event, Emitter<DialogDiningCouponState> emit) async {
    if (event.type.value == 'amount') {
      const maxDiscount = DiningCouponMaxDiscountField.dirty('0');
      emit(state.copyWith(diningCouponMaxDiscount: maxDiscount, status: DialogDiningCouponStatus.success));
    } else {
      const maxDiscount = DiningCouponMaxDiscountField.dirty('');
      emit(state.copyWith(diningCouponMaxDiscount: maxDiscount, status: DialogDiningCouponStatus.success));
    }
    emit(state.copyWith(type: event.type, status: DialogDiningCouponStatus.changeDetail));
  }

  FutureOr<void> _onDialogDiningCouponAvailabilityChangeEvent(DialogDiningCouponAvailabilityChangeEvent event, Emitter<DialogDiningCouponState> emit) async {
    emit(state.copyWith(availability: event.availability, status: DialogDiningCouponStatus.changeDetail));
  }

  FutureOr<void> _onDialogDiningCouponPreBookingChargeChangeEvent(DialogDiningCouponPreBookingChargeChangeEvent event, Emitter<DialogDiningCouponState> emit) async {
    if (event.preBooking.value == true) {
      const preBookingCharge = DiningCouponPreBookingChargeField.dirty('0');
      emit(state.copyWith(diningCouponPreBookingCharge: preBookingCharge, status: DialogDiningCouponStatus.success));
    } else {
      const preBookingCharge = DiningCouponPreBookingChargeField.dirty('0');
      emit(state.copyWith(diningCouponPreBookingCharge: preBookingCharge, status: DialogDiningCouponStatus.success));
    }
    emit(state.copyWith(preeBookingChargeRequired: event.preBooking, status: DialogDiningCouponStatus.changeDetail));
  }

  FutureOr<void> _onDialogDiningCouponSubmitEvent(DialogDiningCouponSubmitEvent event, Emitter<DialogDiningCouponState> emit) async {
    final diningCouponName = DiningCouponNameField.dirty(state.diningCouponName.value);
    final diningCouponCode = DiningCouponCodeField.dirty(state.diningCouponCode.value);
    final diningCouponLimit = DiningCouponLimitField.dirty(state.diningCouponLimit.value);
    final diningCouponStartDate = DiningCouponStartDateField.dirty(state.diningCouponStartDate.value);
    final diningCouponExpireDate = DiningCouponExpireDateField.dirty(state.diningCouponExpireDate.value);
    final diningCouponMinDiscount = DiningCouponMinDiscountField.dirty(state.diningCouponMinDiscount.value);
    final diningCouponMaxDiscount = DiningCouponMaxDiscountField.dirty(state.diningCouponMaxDiscount.value);
    final diningCouponPreBookingCharge = DiningCouponPreBookingChargeField.dirty(state.diningCouponPreBookingCharge.value);

    emit(
      state.copyWith(
        diningCouponName: diningCouponName,
        diningCouponCode: diningCouponCode,
        diningCouponLimit: diningCouponLimit,
        diningCouponStartDate: diningCouponStartDate,
        diningCouponExpireDate: diningCouponExpireDate,
        diningCouponMinDiscount: diningCouponMinDiscount,
        diningCouponMaxDiscount: diningCouponMaxDiscount,
        diningCouponPreBookingCharge: diningCouponPreBookingCharge,
        status: DialogDiningCouponStatus.changeDetail,
        isValid: Formz.validate([diningCouponName, diningCouponCode, diningCouponLimit, diningCouponStartDate, diningCouponExpireDate, diningCouponMinDiscount, diningCouponMaxDiscount, diningCouponPreBookingCharge]),
      ),
    );
    if (state.isValid &&
        state.diningCouponName.value.isNotEmpty &&
        state.diningCouponCode.value.isNotEmpty &&
        state.diningCouponLimit.value.isNotEmpty &&
        state.diningCouponStartDate.value.isNotEmpty &&
        state.diningCouponExpireDate.value.isNotEmpty &&
        state.diningCouponMinDiscount.value.isNotEmpty &&
        state.diningCouponMaxDiscount.value.isNotEmpty &&
        state.diningCouponPreBookingCharge.value.isNotEmpty) {
      if (state.isNew) {
        try {
          emit(state.copyWith(status: DialogDiningCouponStatus.submit));
          final String vendorId = await _couponRepository.getVendorId();
          final String userId = await _couponRepository.getUserId();
          DiningCouponRequestModel param = DiningCouponRequestModel(
            name: state.diningCouponName.value.toString(),
            code: state.diningCouponCode.value.toString(),
            limitSameUser: state.diningCouponLimit.value.toString(),
            start: state.diningCouponStartDate.value.toString(),
            expires: state.diningCouponExpireDate.value.toString(),
            minDiscount: state.diningCouponMinDiscount.value.toString(),
            maxDiscount: state.diningCouponMaxDiscount.value.toString(),
            preBookingChargeRequired: state.preeBookingChargeRequired.value!.toString(),
            preBookingChargeAmount: state.diningCouponPreBookingCharge.value.toString(),
            availability: state.availability.value!.toString(),
            discountType: state.type.value,
            restaurantId: vendorId,
            createdById: userId,
            translations: event.translations,
          );
          DioApiResponse response = await _couponRepository.saveDiningCoupon(param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: DialogDiningCouponStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: DialogDiningCouponStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: DialogDiningCouponStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      } else {
        try {
          emit(state.copyWith(status: DialogDiningCouponStatus.update));
          final String vendorId = await _couponRepository.getVendorId();
          final String userId = await _couponRepository.getUserId();
          DiningCouponRequestModel param = DiningCouponRequestModel(
            name: state.diningCouponName.value.toString(),
            code: state.diningCouponCode.value.toString(),
            limitSameUser: state.diningCouponLimit.value.toString(),
            start: state.diningCouponStartDate.value.toString(),
            expires: state.diningCouponExpireDate.value.toString(),
            minDiscount: state.diningCouponMinDiscount.value.toString(),
            maxDiscount: state.diningCouponMaxDiscount.value.toString(),
            preBookingChargeRequired: state.preeBookingChargeRequired.value!.toString(),
            preBookingChargeAmount: state.diningCouponPreBookingCharge.value.toString(),
            availability: state.availability.value!.toString(),
            discountType: state.type.value,
            restaurantId: vendorId,
            createdById: userId,
            translations: event.translations,
          );
          DioApiResponse response = await _couponRepository.updateDiningCoupon(state.couponId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: DialogDiningCouponStatus.updateSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: DialogDiningCouponStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: DialogDiningCouponStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    }
  }
}
