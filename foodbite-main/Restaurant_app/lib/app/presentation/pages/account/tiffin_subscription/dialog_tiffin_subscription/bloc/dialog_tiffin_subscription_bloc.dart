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
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/request/tiffin_subscription_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_food_modal_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_info_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_instruction_list_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_offday_modal_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_package_list_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_timeslot_list_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_timeslot_modal_response_model.dart';
import 'package:vendor/app/core/models/translations/tiffin_subscription_form_translation.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/tiffin_subscription_repository.dart';
import 'package:vendor/app/core/validations/tiffin_subscription_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dialog_tiffin_subscription_event.dart';
part 'dialog_tiffin_subscription_state.dart';

class DialogTiffinSubscriptionBloc extends Bloc<DialogTiffinSubscriptionEvent, DialogTiffinSubscriptionState> {
  final TiffinSubscriptionRepository _tiffinSubscriptionRepository = TiffinSubscriptionRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DialogTiffinSubscriptionBloc()
    : super(
        DialogTiffinSubscriptionState(
          addonValidation: AddonValidationModel(label: '', value: false),
          variationValidation: VariationValidationModel(label: '', value: false),
          deliveryValidation: DeliveryValidationModel(label: '', value: ''),
          orderValidation: OrderValidationModel(label: '', value: ''),
          availabilityValidation: AvailabilityValidationModel(label: '', value: ''),
          discountType: DiscountModel(label: '', value: ''),
          model: TiffinSubscriptionInfoResponseModel(locale: ''),
        ),
      ) {
    on<DialogTiffinSubscriptionInitialEvent>(_onDialogTiffinSubscriptionInitialEvent);
    on<DialogTiffinSubscriptionCoverChangeEvent>(_onDialogTiffinSubscriptionCoverChangeEvent);
    on<DialogTiffinSubscriptionNameChangeEvent>(_onDialogTiffinSubscriptionNameChangeEvent);
    on<DialogTiffinSubscriptionNameUnfocusedEvent>(_onDialogTiffinSubscriptionNameUnfocusedEvent);
    on<DialogTiffinSubscriptionShortDescriptionChangeEvent>(_onDialogTiffinSubscriptionShortDescriptionChangeEvent);
    on<DialogTiffinSubscriptionShortDescriptionUnfocusedEvent>(_onDialogTiffinSubscriptionShortDescriptionUnfocusedEvent);
    on<DialogTiffinSubscriptionFoodsChangeEvent>(_onDialogTiffinSubscriptionFoodsChangeEvent);
    on<DialogTiffinSubscriptionFoodsUnfocusedEvent>(_onDialogTiffinSubscriptionFoodsUnfocusedEvent);
    on<DialogTiffinSubscriptionDeliveryAreaChangeEvent>(_onDialogTiffinSubscriptionDeliveryAreaChangeEvent);
    on<DialogTiffinSubscriptionDeliveryAreaUnfocusedEvent>(_onDialogTiffinSubscriptionDeliveryAreaUnfocusedEvent);
    on<DialogTiffinSubscriptionPriceChangeEvent>(_onDialogTiffinSubscriptionPriceChangeEvent);
    on<DialogTiffinSubscriptionPriceUnfocusedEvent>(_onDialogTiffinSubscriptionPriceUnfocusedEvent);
    on<DialogTiffinSubscriptionDiscountChangeEvent>(_onDialogTiffinSubscriptionDiscountChangeEvent);
    on<DialogTiffinSubscriptionDiscountUnfocusedEvent>(_onDialogTiffinSubscriptionDiscountUnfocusedEvent);
    on<DialogTiffinSubscriptionDiscountTypeChangeEvent>(_onDialogTiffinSubscriptionDiscountTypeChangeEvent);
    on<DialogTiffinSubscriptionAvailabilityChangeEvent>(_onDialogTiffinSubscriptionAvailabilityChangeEvent);
    on<DialogTiffinSubscriptionOrderNumberEvent>(_onDialogTiffinSubscriptionOrderNumberEvent);
    on<DialogTiffinSubscriptionAddonSelectEvent>(_onDialogTiffinSubscriptionAddonSelectEvent);
    on<DialogTiffinSubscriptionVariationSelectEvent>(_onDialogTiffinSubscriptionVariationSelectEvent);
    on<DialogTiffinSubscriptionDeliveryChangeEvent>(_onDialogTiffinSubscriptionDeliveryChangeEvent);
    on<DialogTiffinSubscriptionTimeSlotEvent>(_onDialogTiffinSubscriptionTimeSlotEvent);
    on<DialogTiffinSubscriptionEditSlotEvent>(_onDialogTiffinSubscriptionEditSlotEvent);
    on<DialogTiffinSubscriptionDeleteSlotEvent>(_onDialogTiffinSubscriptionDeleteSlotEvent);
    on<DialogTiffinSubscriptionInstructionAddEvent>(_onDialogTiffinSubscriptionInstructionAddEvent);
    on<DialogTiffinSubscriptionDeleteInstructionEvent>(_onDialogTiffinSubscriptionDeleteInstructionEvent);
    on<DialogTiffinSubscriptionEditInstructionEvent>(_onDialogTiffinSubscriptionEditInstructionEvent);
    on<DialogTiffinSubscriptionOffDayEvent>(_onDialogTiffinSubscriptionOffDayEvent);
    on<DialogTiffinSubscriptionSubmitEvent>(_onDialogTiffinSubscriptionSubmitEvent);
  }

  FutureOr<void> _onDialogTiffinSubscriptionInitialEvent(DialogTiffinSubscriptionInitialEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_tiffin_subscription_package"}, 'add_update_tiffin_subscription_package_screen', 'add_update_tiffin_subscription_package_screen');
    List<AddonValidationModel> addonValidationList = <AddonValidationModel>[];
    addonValidationList.clear();
    AddonValidationModel yesAddon = AddonValidationModel(label: 'dd_yes', value: true);
    AddonValidationModel noAddon = AddonValidationModel(label: 'dd_no', value: false);
    addonValidationList.add(yesAddon);
    addonValidationList.add(noAddon);

    List<VariationValidationModel> variationValidationList = <VariationValidationModel>[];
    variationValidationList.clear();
    VariationValidationModel yesVariation = VariationValidationModel(label: 'dd_yes', value: true);
    VariationValidationModel novariation = VariationValidationModel(label: 'dd_no', value: false);
    variationValidationList.add(yesVariation);
    variationValidationList.add(novariation);

    List<DeliveryValidationModel> deliveryValidationList = <DeliveryValidationModel>[];
    DeliveryValidationModel homeDelivery = DeliveryValidationModel(label: 'dd_home_delivery', value: 'homedelivery');
    DeliveryValidationModel selfPickup = DeliveryValidationModel(label: 'dd_self_pickup', value: 'selfpickup');
    deliveryValidationList.clear();
    deliveryValidationList.add(homeDelivery);
    deliveryValidationList.add(selfPickup);

    List<OrderValidationModel> orderValidationList = <OrderValidationModel>[];
    OrderValidationModel week = OrderValidationModel(label: 'dd_week_days', value: 'week');
    OrderValidationModel fortnight = OrderValidationModel(label: 'dd_fortnight_days', value: 'fortnight');
    OrderValidationModel month = OrderValidationModel(label: 'dd_month_days', value: 'month');
    orderValidationList.clear();
    orderValidationList.add(week);
    orderValidationList.add(fortnight);
    orderValidationList.add(month);

    List<AvailabilityValidationModel> availabilityValidationList = <AvailabilityValidationModel>[];
    AvailabilityValidationModel breakfast = AvailabilityValidationModel(label: 'dd_breakfast_food', value: 'breakfast');
    AvailabilityValidationModel lunch = AvailabilityValidationModel(label: 'dd_lunch_food', value: 'lunch');
    AvailabilityValidationModel dinner = AvailabilityValidationModel(label: 'dd_dinner_food', value: 'dinner');
    availabilityValidationList.clear();
    availabilityValidationList.add(breakfast);
    availabilityValidationList.add(lunch);
    availabilityValidationList.add(dinner);

    List<DiscountModel> discountTypeList = <DiscountModel>[];
    DiscountModel percentage = DiscountModel(label: 'dd_percentage', value: '%');
    DiscountModel amount = DiscountModel(label: 'dd_amount', value: '\$');
    discountTypeList.clear();
    discountTypeList.add(percentage);
    discountTypeList.add(amount);

    final String locale = await _accountRepository.getLocale();

    emit(
      state.copyWith(
        addonValidationList: addonValidationList,
        variationValidationList: variationValidationList,
        deliveryValidationList: deliveryValidationList,
        orderValidationList: orderValidationList,
        availabilityValidationList: availabilityValidationList,
        discountTypeList: discountTypeList,
        appLocale: locale.toString(),
      ),
    );
    if (event.isNew) {
      emit(
        state.copyWith(
          isNew: event.isNew,
          addonValidation: addonValidationList.first,
          variationValidation: variationValidationList.first,
          availabilityValidation: availabilityValidationList.first,
          discountType: discountTypeList.first,
          orderValidation: orderValidationList.first,
          deliveryValidation: deliveryValidationList.first,
          status: DialogTiffinSubscriptionStatus.success,
        ),
      );
      if (state.orderValidation.value == 'week') {
        emit(state.copyWith(tiffinTotalOrders: const TiffinSubscriptionTotalOrdersField.dirty('7'), status: DialogTiffinSubscriptionStatus.success));
      } else if (state.orderValidation.value == 'fortnight') {
        emit(state.copyWith(tiffinTotalOrders: const TiffinSubscriptionTotalOrdersField.dirty('15'), status: DialogTiffinSubscriptionStatus.success));
      } else if (state.orderValidation.value == 'month') {
        emit(state.copyWith(tiffinTotalOrders: const TiffinSubscriptionTotalOrdersField.dirty('30'), status: DialogTiffinSubscriptionStatus.success));
      }
      emit(state.copyWith(tiffinDiscount: const TiffinSubscriptionDiscountField.dirty('0'), status: DialogTiffinSubscriptionStatus.success));
    } else {
      try {
        final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
        final String tiffinId = event.model.id!;
        DioApiResponse response = await _tiffinSubscriptionRepository.getTiffinSubscriptionInfo(tiffinId, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          TiffinSubscriptionInfoResponseModel data = TiffinSubscriptionInfoResponseModel.fromJson(myMap, locale.toString());
          final int indexOfAddon = addonValidationList.indexWhere((element) => element.value == data.info!.canSelectAddon!);
          final int indexOfVariation = variationValidationList.indexWhere((element) => element.value == data.info!.canSelectVariation!);
          final int indexOfAvaibility = availabilityValidationList.indexWhere((element) => element.value == data.info!.available!);
          final int indexOfDiscount = discountTypeList.indexWhere((element) => element.value == data.info!.discountType!);
          final int indexOfOrderValidation = orderValidationList.indexWhere((element) => element.value == data.info!.interval!);
          final int indexOfDelivery = deliveryValidationList.indexWhere((element) => element.value == data.info!.orderTo!);
          emit(
            state.copyWith(
              isNew: event.isNew,
              addonValidation: indexOfAddon != -1 ? addonValidationList[indexOfAddon] : addonValidationList.first,
              variationValidation: indexOfVariation != -1 ? variationValidationList[indexOfVariation] : variationValidationList.first,
              availabilityValidation: indexOfAvaibility != -1 ? availabilityValidationList[indexOfAvaibility] : availabilityValidationList.first,
              discountType: indexOfDiscount != -1 ? discountTypeList[indexOfDiscount] : discountTypeList.first,
              orderValidation: indexOfOrderValidation != -1 ? orderValidationList[indexOfOrderValidation] : orderValidationList.first,
              deliveryValidation: indexOfDelivery != -1 ? deliveryValidationList[indexOfDelivery] : deliveryValidationList.first,
            ),
          );
          final tiffinCover = TiffinSubscriptionCoverField.dirty(data.info!.image!);
          final tiffinName = TiffinSubscriptionNameField.dirty(data.info!.realName!);
          final tiffinShortDescription = TiffinSubscriptionShortDescriptionField.dirty(data.info!.realShortDescription!);
          List<String> foodName = <String>[];
          for (var element in data.food!) {
            if (data.info!.foods!.contains(element.id)) {
              foodName.add(element.name!);
            }
          }
          final tiffinFoods = TiffinSubscriptionFoodsField.dirty(foodName.join(','));
          final tiffinDeliveryArea = TiffinSubscriptionDeliveryAreaField.dirty(data.info!.deliveryArea!.toString());
          final tiffinPrice = TiffinSubscriptionPriceField.dirty(data.info!.price!.toString());
          final tiffinDiscount = TiffinSubscriptionDiscountField.dirty(data.info!.discount!.toString());
          final tiffinTotalOrder = TiffinSubscriptionTotalOrdersField.dirty(data.info!.totalOrder!.toString());
          List<TiffinSubscriptionTimeSlotListModel> timeSlot = <TiffinSubscriptionTimeSlotListModel>[];
          timeSlot.clear();
          for (var element in data.info!.timeSlots!) {
            timeSlot.add(element);
          }
          List<TiffinSubscriptionInstructionModel> instruction = <TiffinSubscriptionInstructionModel>[];
          instruction.clear();
          for (var element in data.info!.notice!) {
            instruction.add(element);
          }

          emit(
            state.copyWith(
              tiffinId: event.model.id!,
              tiffinCover: tiffinCover,
              tiffinName: tiffinName,
              tiffinShortDescription: tiffinShortDescription,
              tiffinFoods: tiffinFoods,
              tiffinDeliveryArea: tiffinDeliveryArea,
              tiffinPrice: tiffinPrice,
              tiffinDiscount: tiffinDiscount,
              tiffinTotalOrders: tiffinTotalOrder,
              offDays: data.info!.offDays!,
              timeslotList: timeSlot,
              instructions: instruction,
              foodIds: data.info!.foods!,
              status: DialogTiffinSubscriptionStatus.success,
              isValid: Formz.validate([tiffinCover, tiffinName, tiffinShortDescription, tiffinFoods, tiffinDeliveryArea, tiffinPrice, tiffinDiscount, tiffinTotalOrder]),
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DialogTiffinSubscriptionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DialogTiffinSubscriptionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onDialogTiffinSubscriptionCoverChangeEvent(DialogTiffinSubscriptionCoverChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageCover = TiffinSubscriptionCoverField.dirty(event.image);
    emit(
      state.copyWith(
        tiffinCover: packageCover.isValid ? packageCover : TiffinSubscriptionCoverField.pure(event.image),
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageCover, state.tiffinName, state.tiffinShortDescription, state.tiffinFoods, state.tiffinDeliveryArea, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionNameChangeEvent(DialogTiffinSubscriptionNameChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageName = TiffinSubscriptionNameField.dirty(event.name);
    emit(
      state.copyWith(
        tiffinName: packageName.isValid ? packageName : TiffinSubscriptionNameField.pure(event.name),
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageName, state.tiffinCover, state.tiffinShortDescription, state.tiffinFoods, state.tiffinDeliveryArea, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionNameUnfocusedEvent(DialogTiffinSubscriptionNameUnfocusedEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageName = TiffinSubscriptionNameField.dirty(state.tiffinName.value);
    emit(
      state.copyWith(
        tiffinName: packageName,
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageName, state.tiffinCover, state.tiffinShortDescription, state.tiffinFoods, state.tiffinDeliveryArea, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionShortDescriptionChangeEvent(DialogTiffinSubscriptionShortDescriptionChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageShortDescription = TiffinSubscriptionShortDescriptionField.dirty(event.shortDescription);
    emit(
      state.copyWith(
        tiffinShortDescription: packageShortDescription.isValid ? packageShortDescription : TiffinSubscriptionShortDescriptionField.pure(event.shortDescription),
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageShortDescription, state.tiffinCover, state.tiffinName, state.tiffinFoods, state.tiffinDeliveryArea, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionShortDescriptionUnfocusedEvent(DialogTiffinSubscriptionShortDescriptionUnfocusedEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageShortDescription = TiffinSubscriptionShortDescriptionField.dirty(state.tiffinShortDescription.value);
    emit(
      state.copyWith(
        tiffinShortDescription: packageShortDescription,
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageShortDescription, state.tiffinCover, state.tiffinName, state.tiffinFoods, state.tiffinDeliveryArea, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionFoodsChangeEvent(DialogTiffinSubscriptionFoodsChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    emit(state.copyWith(foodIds: event.foods.id));
    final packageFoods = TiffinSubscriptionFoodsField.dirty(event.foods.name!.join(','));
    emit(
      state.copyWith(
        tiffinFoods: packageFoods.isValid ? packageFoods : TiffinSubscriptionFoodsField.pure(event.foods.name!.join(',')),
        status: DialogTiffinSubscriptionStatus.success,
        isValid: Formz.validate([packageFoods, state.tiffinCover, state.tiffinName, state.tiffinShortDescription, state.tiffinDeliveryArea, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionFoodsUnfocusedEvent(DialogTiffinSubscriptionFoodsUnfocusedEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageFoods = TiffinSubscriptionFoodsField.dirty(state.tiffinFoods.value);
    emit(
      state.copyWith(
        tiffinFoods: packageFoods,
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageFoods, state.tiffinCover, state.tiffinName, state.tiffinShortDescription, state.tiffinDeliveryArea, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionDeliveryAreaChangeEvent(DialogTiffinSubscriptionDeliveryAreaChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageDeliveryArea = TiffinSubscriptionDeliveryAreaField.dirty(event.deliveryArea);
    emit(
      state.copyWith(
        tiffinDeliveryArea: packageDeliveryArea.isValid ? packageDeliveryArea : TiffinSubscriptionDeliveryAreaField.pure(event.deliveryArea),
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageDeliveryArea, state.tiffinCover, state.tiffinName, state.tiffinFoods, state.tiffinShortDescription, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionDeliveryAreaUnfocusedEvent(DialogTiffinSubscriptionDeliveryAreaUnfocusedEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageDeliveryArea = TiffinSubscriptionDeliveryAreaField.dirty(state.tiffinDeliveryArea.value);
    emit(
      state.copyWith(
        tiffinDeliveryArea: packageDeliveryArea,
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageDeliveryArea, state.tiffinCover, state.tiffinName, state.tiffinShortDescription, state.tiffinFoods, state.tiffinPrice, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionPriceChangeEvent(DialogTiffinSubscriptionPriceChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packagePrice = TiffinSubscriptionPriceField.dirty(event.price);
    emit(
      state.copyWith(
        tiffinPrice: packagePrice.isValid ? packagePrice : TiffinSubscriptionPriceField.pure(event.price),
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packagePrice, state.tiffinCover, state.tiffinName, state.tiffinFoods, state.tiffinShortDescription, state.tiffinDeliveryArea, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionPriceUnfocusedEvent(DialogTiffinSubscriptionPriceUnfocusedEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packagePrice = TiffinSubscriptionPriceField.dirty(state.tiffinPrice.value);
    emit(
      state.copyWith(
        tiffinPrice: packagePrice,
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packagePrice, state.tiffinCover, state.tiffinName, state.tiffinShortDescription, state.tiffinFoods, state.tiffinDeliveryArea, state.tiffinDiscount]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionDiscountChangeEvent(DialogTiffinSubscriptionDiscountChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageDiscount = TiffinSubscriptionDiscountField.dirty(event.discount);
    emit(
      state.copyWith(
        tiffinDiscount: packageDiscount.isValid ? packageDiscount : TiffinSubscriptionDiscountField.pure(event.discount),
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageDiscount, state.tiffinCover, state.tiffinName, state.tiffinFoods, state.tiffinShortDescription, state.tiffinDeliveryArea, state.tiffinPrice]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionDiscountUnfocusedEvent(DialogTiffinSubscriptionDiscountUnfocusedEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final packageDiscount = TiffinSubscriptionDiscountField.dirty(state.tiffinDiscount.value);
    emit(
      state.copyWith(
        tiffinDiscount: packageDiscount,
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([packageDiscount, state.tiffinCover, state.tiffinName, state.tiffinShortDescription, state.tiffinFoods, state.tiffinDeliveryArea, state.tiffinPrice]),
      ),
    );
  }

  FutureOr<void> _onDialogTiffinSubscriptionDiscountTypeChangeEvent(DialogTiffinSubscriptionDiscountTypeChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    emit(state.copyWith(discountType: event.type));
  }

  FutureOr<void> _onDialogTiffinSubscriptionAvailabilityChangeEvent(DialogTiffinSubscriptionAvailabilityChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    emit(state.copyWith(availabilityValidation: event.availability));
  }

  FutureOr<void> _onDialogTiffinSubscriptionOrderNumberEvent(DialogTiffinSubscriptionOrderNumberEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    emit(state.copyWith(orderValidation: event.orderNumber));
    if (state.orderValidation.value == 'week') {
      emit(state.copyWith(tiffinTotalOrders: const TiffinSubscriptionTotalOrdersField.dirty('7'), status: DialogTiffinSubscriptionStatus.success));
    } else if (state.orderValidation.value == 'fortnight') {
      emit(state.copyWith(tiffinTotalOrders: const TiffinSubscriptionTotalOrdersField.dirty('15'), status: DialogTiffinSubscriptionStatus.success));
    } else if (state.orderValidation.value == 'month') {
      emit(state.copyWith(tiffinTotalOrders: const TiffinSubscriptionTotalOrdersField.dirty('30'), status: DialogTiffinSubscriptionStatus.success));
    }
  }

  FutureOr<void> _onDialogTiffinSubscriptionAddonSelectEvent(DialogTiffinSubscriptionAddonSelectEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    emit(state.copyWith(addonValidation: event.addon));
  }

  FutureOr<void> _onDialogTiffinSubscriptionVariationSelectEvent(DialogTiffinSubscriptionVariationSelectEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    emit(state.copyWith(variationValidation: event.variation));
  }

  FutureOr<void> _onDialogTiffinSubscriptionDeliveryChangeEvent(DialogTiffinSubscriptionDeliveryChangeEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    emit(state.copyWith(deliveryValidation: event.delivery));
    if (state.deliveryValidation.value == 'selfpickup') {
      const maxDiscount = TiffinSubscriptionDeliveryAreaField.dirty('0');
      emit(state.copyWith(tiffinDeliveryArea: maxDiscount, status: DialogTiffinSubscriptionStatus.success));
    } else {
      const maxDiscount = TiffinSubscriptionDeliveryAreaField.dirty('');
      emit(state.copyWith(tiffinDeliveryArea: maxDiscount, status: DialogTiffinSubscriptionStatus.success));
    }
  }

  FutureOr<void> _onDialogTiffinSubscriptionTimeSlotEvent(DialogTiffinSubscriptionTimeSlotEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    List<TiffinSubscriptionTimeSlotListModel> timeSlotList = <TiffinSubscriptionTimeSlotListModel>[];
    for (var element in state.timeslotList) {
      timeSlotList.add(element);
    }
    TiffinSubscriptionTimeSlotListModel slot = TiffinSubscriptionTimeSlotListModel(startTime: event.timeslot.start!, endTime: event.timeslot.end!);
    timeSlotList.add(slot);
    emit(state.copyWith(timeslotList: [...timeSlotList]));
  }

  FutureOr<void> _onDialogTiffinSubscriptionEditSlotEvent(DialogTiffinSubscriptionEditSlotEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    state.timeslotList[event.index].startTime = event.timeslot.start!;
    state.timeslotList[event.index].endTime = event.timeslot.end!;
    emit(state.copyWith(timeslotList: [...state.timeslotList]));
  }

  FutureOr<void> _onDialogTiffinSubscriptionDeleteSlotEvent(DialogTiffinSubscriptionDeleteSlotEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    state.timeslotList.removeAt(event.index);
    emit(state.copyWith(timeslotList: [...state.timeslotList]));
  }

  FutureOr<void> _onDialogTiffinSubscriptionInstructionAddEvent(DialogTiffinSubscriptionInstructionAddEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    List<TiffinSubscriptionInstructionModel> instructionList = <TiffinSubscriptionInstructionModel>[];
    final String locale = await _accountRepository.getLocale();
    for (var element in state.instructions) {
      instructionList.add(element);
    }
    String displayName = event.instruction.name!;
    if (locale.isNotEmpty && event.instruction.translations!.isNotEmpty) {
      final int localeIndex = event.instruction.translations!.indexWhere((tLocale) => tLocale.code! == locale);
      if (localeIndex != -1) {
        if (event.instruction.translations![localeIndex].value!.isNotEmpty) {
          displayName = event.instruction.translations![localeIndex].value!;
        }
      }
    }
    TiffinSubscriptionInstructionModel newInstruction = TiffinSubscriptionInstructionModel(name: event.instruction.name, translations: event.instruction.translations, displayName: displayName, locale: locale.toString());
    instructionList.add(newInstruction);
    emit(state.copyWith(instructions: [...instructionList]));
  }

  FutureOr<void> _onDialogTiffinSubscriptionDeleteInstructionEvent(DialogTiffinSubscriptionDeleteInstructionEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    state.instructions.removeAt(event.index);
    emit(state.copyWith(instructions: [...state.instructions]));
  }

  FutureOr<void> _onDialogTiffinSubscriptionEditInstructionEvent(DialogTiffinSubscriptionEditInstructionEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final String locale = await _accountRepository.getLocale();
    String displayName = event.instruction.name!;
    if (locale.isNotEmpty && event.instruction.translations!.isNotEmpty) {
      final int localeIndex = event.instruction.translations!.indexWhere((tLocale) => tLocale.code! == locale);
      if (localeIndex != -1) {
        if (event.instruction.translations![localeIndex].value!.isNotEmpty) {
          displayName = event.instruction.translations![localeIndex].value!;
        }
      }
    }
    state.instructions[event.index].name = event.instruction.name!;
    state.instructions[event.index].displayName = displayName;
    state.instructions[event.index].translations = event.instruction.translations;
    emit(state.copyWith(instructions: [...state.instructions]));
  }

  FutureOr<void> _onDialogTiffinSubscriptionOffDayEvent(DialogTiffinSubscriptionOffDayEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    emit(state.copyWith(offDays: event.offdays.days!, status: DialogTiffinSubscriptionStatus.success));
  }

  FutureOr<void> _onDialogTiffinSubscriptionSubmitEvent(DialogTiffinSubscriptionSubmitEvent event, Emitter<DialogTiffinSubscriptionState> emit) async {
    final tiffinCover = TiffinSubscriptionCoverField.dirty(state.tiffinCover.value);
    final tiffinName = TiffinSubscriptionNameField.dirty(state.tiffinName.value);
    final tiffinShortDescription = TiffinSubscriptionShortDescriptionField.dirty(state.tiffinShortDescription.value);
    final tiffinFoods = TiffinSubscriptionFoodsField.dirty(state.tiffinFoods.value);
    final tiffinDeliveryArea = TiffinSubscriptionDeliveryAreaField.dirty(state.tiffinDeliveryArea.value);
    final tiffinPrice = TiffinSubscriptionPriceField.dirty(state.tiffinPrice.value);
    final tiffinDiscount = TiffinSubscriptionDiscountField.dirty(state.tiffinDiscount.value);
    final tiffinTotalOrder = TiffinSubscriptionTotalOrdersField.dirty(state.tiffinTotalOrders.value);
    emit(
      state.copyWith(
        tiffinCover: tiffinCover,
        tiffinName: tiffinName,
        tiffinShortDescription: tiffinShortDescription,
        tiffinFoods: tiffinFoods,
        tiffinDeliveryArea: tiffinDeliveryArea,
        tiffinPrice: tiffinPrice,
        tiffinDiscount: tiffinDiscount,
        tiffinTotalOrders: tiffinTotalOrder,
        status: DialogTiffinSubscriptionStatus.changeDetail,
        isValid: Formz.validate([tiffinCover, tiffinName, tiffinShortDescription, tiffinFoods, tiffinDeliveryArea, tiffinPrice, tiffinDiscount, tiffinTotalOrder]),
      ),
    );
    if (state.isValid &&
        state.tiffinCover.value.isNotEmpty &&
        state.tiffinName.value.isNotEmpty &&
        state.tiffinShortDescription.value.isNotEmpty &&
        state.tiffinFoods.value.isNotEmpty &&
        state.tiffinDeliveryArea.value.isNotEmpty &&
        state.tiffinPrice.value.isNotEmpty &&
        state.tiffinDiscount.value.isNotEmpty &&
        state.tiffinTotalOrders.value.isNotEmpty) {
      if (state.isNew) {
        try {
          emit(state.copyWith(status: DialogTiffinSubscriptionStatus.submit));
          final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
          TiffinSubscriptionRequestModel param = TiffinSubscriptionRequestModel(
            name: tiffinName.value.toString(),
            shortDescription: tiffinShortDescription.value.toString(),
            image: tiffinCover.value.toString(),
            restaurant: vendorId,
            foods: state.foodIds.join(','),
            interval: state.orderValidation.value.toString(),
            offDays: state.offDays.join(','),
            totalOrder: state.tiffinTotalOrders.value.toString(),
            available: state.availabilityValidation.value.toString(),
            timeSlots: state.timeslotList,
            orderTo: state.deliveryValidation.value.toString(),
            deliveryArea: state.deliveryValidation.value == 'homedelivery' ? state.tiffinDeliveryArea.value.toString() : '0',
            canSelectAddon: state.addonValidation.value!,
            canSelectVariation: state.variationValidation.value!,
            price: state.tiffinPrice.value.toString(),
            discountType: state.discountType.value.toString(),
            discount: state.tiffinDiscount.value.toString(),
            notice: state.instructions,
            translations: event.translations,
          );
          DioApiResponse response = await _tiffinSubscriptionRepository.saveTiffinSubscription(param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: DialogTiffinSubscriptionStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: DialogTiffinSubscriptionStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: DialogTiffinSubscriptionStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      } else {
        try {
          emit(state.copyWith(status: DialogTiffinSubscriptionStatus.update));
          final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
          TiffinSubscriptionRequestModel param = TiffinSubscriptionRequestModel(
            name: tiffinName.value.toString(),
            shortDescription: tiffinShortDescription.value.toString(),
            image: tiffinCover.value.toString(),
            restaurant: vendorId,
            foods: state.foodIds.join(','),
            interval: state.orderValidation.value.toString(),
            offDays: state.offDays.join(','),
            totalOrder: state.tiffinTotalOrders.value.toString(),
            available: state.availabilityValidation.value.toString(),
            timeSlots: state.timeslotList,
            orderTo: state.deliveryValidation.value.toString(),
            deliveryArea: state.deliveryValidation.value == 'homedelivery' ? state.tiffinDeliveryArea.value.toString() : '0',
            canSelectAddon: state.addonValidation.value!,
            canSelectVariation: state.variationValidation.value!,
            price: state.tiffinPrice.value.toString(),
            discountType: state.discountType.value.toString(),
            discount: state.tiffinDiscount.value.toString(),
            notice: state.instructions,
            translations: event.translations,
          );
          DioApiResponse response = await _tiffinSubscriptionRepository.updateTiffinSubscription(state.tiffinId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: DialogTiffinSubscriptionStatus.updateSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: DialogTiffinSubscriptionStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: DialogTiffinSubscriptionStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    }
  }
}
