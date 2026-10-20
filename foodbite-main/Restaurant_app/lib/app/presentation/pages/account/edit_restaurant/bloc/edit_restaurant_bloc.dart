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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/modal_navigation_back_response_model.dart';
import 'package:vendor/app/core/models/request/restaurant_update_detail_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/edit_restaurant_form_translation.dart';
import 'package:vendor/app/core/models/vendor_detail_for_update_response_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/validations/restaurant_edit_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'edit_restaurant_event.dart';
part 'edit_restaurant_state.dart';

class EditRestaurantBloc extends Bloc<EditRestaurantEvent, EditRestaurantState> {
  final AccountRepository _accountRepository = AccountRepository();
  EditRestaurantBloc()
    : super(
        EditRestaurantState(
          model: VendorDetailForUpdateResponseModel(locale: ''),
          homeDelivery: HomeDeliverySupportModel(label: '', value: false),
          takeAway: TakeAwaySupportModel(label: '', value: false),
          scheduleOrder: ScheduleOrderSupportModel(label: '', value: false),
          license: RestaurantFoodLicenseConfigModel(id: '', name: '', translations: [], locale: ''),
        ),
      ) {
    on<EditRestaurantInitialEvent>(_onEditRestaurantInitialEvent);
    on<EditRestaurantNameChangedEvent>(_onEditRestaurantNameChangedEvent);
    on<EditRestaurantNameUnfocusedEvent>(_onEditRestaurantNameUnfocusedEvent);
    on<EditRestaurantShortDescriptionChangedEvent>(_onEditRestaurantShortDescriptionChangedEvent);
    on<EditRestaurantShortDescriptionUnfocusedEvent>(_onEditRestaurantShortDescriptionUnfocusedEvent);
    on<EditRestaurantAddressChangedEvent>(_onEditRestaurantAddressChangedEvent);
    on<EditRestaurantAddressUnfocusedEvent>(_onEditRestaurantAddressUnfocusedEvent);
    on<EditRestaurantMinOrderAmountChangedEvent>(_onEditRestaurantMinOrderAmountChangedEvent);
    on<EditRestaurantMinOrderAmountUnfocusedEvent>(_onEditRestaurantMinOrderAmountUnfocusedEvent);
    on<EditRestaurantDishForTwoChangedEvent>(_onEditRestaurantDishForTwoChangedEvent);
    on<EditRestaurantDishForTwoUnfocusedEvent>(_onEditRestaurantDishForTwoUnfocusedEvent);
    on<EditRestaurantFoodLicenseChangedEvent>(_onEditRestaurantFoodLicenseChangedEvent);
    on<EditRestaurantFoodLicenseUnfocusedEvent>(_onEditRestaurantFoodLicenseUnfocusedEvent);
    on<EditRestaurantLogoChangeEvent>(_onEditRestaurantLogoChangeEvent);
    on<EditRestaurantCoverChangeEvent>(_onEditRestaurantCoverChangeEvent);
    on<EditRestaurantHomeDeliveryChangeEvent>(_onEditRestaurantHomeDeliveryChangeEvent);
    on<EditRestaurantTakeAwayChangeEvent>(_onEditRestaurantTakeAwayChangeEvent);
    on<EditRestaurantScheduleOrderChangeEvent>(_onEditRestaurantScheduleOrderChangeEvent);
    on<EditRestaurantLicenseChangeEvent>(_onEditRestaurantLicenseChangeEvent);
    on<EditRestaurantCuisineChangeEvent>(_onEditRestaurantCuisineChangeEvent);
    on<EditRestaurantTypeChangeEvent>(_onEditRestaurantTypeChangeEvent);
    on<EditRestaurantFacilitiesChangeEvent>(_onEditRestaurantFacilitiesChangeEvent);
    on<EditRestaurantDeliveryTimeChangeEvent>(_onEditRestaurantDeliveryTimeChangeEvent);
    on<EditRestaurantSocialLinkChangeEvent>(_onEditRestaurantSocialLinkChangeEvent);
    on<EditRestaurantSubmitEvent>(_onEditRestaurantSubmitEvent);
  }

  FutureOr<void> _onEditRestaurantInitialEvent(EditRestaurantInitialEvent event, Emitter<EditRestaurantState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "edit_restaurant_detail"}, 'edit_restaurant_detail_screen', 'edit_restaurant_detail_screen');
      emit(state.copyWith(status: EditRestaurantStatus.loading));
      final String vendorId = await _accountRepository.getVendorId();
      DioApiResponse response = await _accountRepository.getRestaurantDetailForUpdate(vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          VendorDetailForUpdateResponseModel data = VendorDetailForUpdateResponseModel.fromJson(myMap, locale.toString());

          final List<String> cuisineName = <String>[];
          final List<String> cuisineIds = <String>[];
          cuisineName.clear();
          cuisineIds.clear();
          for (var element in data.details!.cuisine!) {
            cuisineName.add(element.name!);
            cuisineIds.add(element.id!);
          }

          final List<String> typeName = <String>[];
          final List<String> typeIds = <String>[];
          typeName.clear();
          typeIds.clear();
          for (var element in data.details!.restauranttypes!) {
            typeIds.add(element.id!);
            typeName.add(element.name!);
          }

          final List<String> facilitiesName = <String>[];
          final List<String> facilitiesIds = <String>[];
          facilitiesName.clear();
          facilitiesIds.clear();
          for (var element in data.details!.restaurantfacilities!) {
            facilitiesName.add(element.name!);
            facilitiesIds.add(element.id!);
          }

          final name = RestaurantEditNameField.dirty(data.details!.name!.toString());
          final shortDescription = RestaurantEditShortDescriptionField.dirty(data.details!.shortDescription!.toString());
          final address = RestaurantEditAddressField.dirty(data.details!.address!.toString());
          final cuisine = RestaurantEditCuisineField.dirty(cuisineName.isEmpty ? '' : cuisineName.join(','));
          final type = RestaurantEditTypeField.dirty(typeName.isEmpty ? '' : typeName.join(','));
          final facility = RestaurantEditFacilitiesField.dirty(facilitiesName.isEmpty ? '' : facilitiesName.join(','));
          final minOrderAmount = RestaurantEditMinOrderAmountField.dirty(data.details!.minOrderAmount!.toString());
          final dishPriceForTwo = RestaurantEditDishPriceForTwoField.dirty(data.details!.dishPriceForTwo!.toString());
          final license = RestaurantEditFoodLicenseField.dirty(data.details!.licenseId!.toString());
          final deliveryTime = RestaurantEditDeliveryTimeField.dirty(data.details!.approxDeliveryTime!);

          HomeDeliverySupportModel homeDeliveryTrue = HomeDeliverySupportModel(label: 'dd_yes_home_delivery', value: true);
          HomeDeliverySupportModel homeDeliveryFalse = HomeDeliverySupportModel(label: 'dd_no_home_delivery', value: false);
          List<HomeDeliverySupportModel> homeDeliveryListOption = <HomeDeliverySupportModel>[];
          homeDeliveryListOption.clear();
          homeDeliveryListOption.add(homeDeliveryTrue);
          homeDeliveryListOption.add(homeDeliveryFalse);
          final int indexOfHomeDelivery = homeDeliveryListOption.indexWhere((element) => element.value == data.details!.acceptHomeDelivery!);

          TakeAwaySupportModel takeAwayTrue = TakeAwaySupportModel(label: 'dd_yes_takeaway', value: true);
          TakeAwaySupportModel takeAwayFalse = TakeAwaySupportModel(label: 'dd_no_takeaway', value: false);
          List<TakeAwaySupportModel> takeAwayListOption = <TakeAwaySupportModel>[];
          takeAwayListOption.clear();
          takeAwayListOption.add(takeAwayTrue);
          takeAwayListOption.add(takeAwayFalse);
          final int indexOfTakeAway = takeAwayListOption.indexWhere((element) => element.value == data.details!.takeAway!);

          ScheduleOrderSupportModel scheduleOrderTrue = ScheduleOrderSupportModel(label: 'dd_yes_schedule_order', value: true);
          ScheduleOrderSupportModel scheduleOrderFalse = ScheduleOrderSupportModel(label: 'dd_no_schedule_order', value: false);
          List<ScheduleOrderSupportModel> scheduleOrderOption = <ScheduleOrderSupportModel>[];
          scheduleOrderOption.clear();
          scheduleOrderOption.add(scheduleOrderTrue);
          scheduleOrderOption.add(scheduleOrderFalse);
          final int indexOfScheduleOrder = scheduleOrderOption.indexWhere((element) => element.value == data.details!.acceptScheduleDelivery!);

          List<RestaurantFoodLicenseConfigModel> licenseList = <RestaurantFoodLicenseConfigModel>[];
          licenseList.clear();
          for (var element in data.license!) {
            licenseList.add(element);
          }
          final int indexOfLicense = licenseList.indexWhere((element) => element.id == data.details!.license!);

          emit(
            state.copyWith(
              model: data,
              name: name,
              shortDescription: shortDescription,
              address: address,
              cuisineNameField: cuisine,
              restaurantTypeField: type,
              restaurantFacilitiesField: facility,
              minOrderAmount: minOrderAmount,
              dishPriceForTwo: dishPriceForTwo,
              foodLicense: license,
              deliveryTime: deliveryTime,
              logo: data.details!.logo!,
              cover: data.details!.cover!,
              cuisineNames: cuisineName.isEmpty ? '' : cuisineName.join(','),
              cuisineIds: cuisineIds.isEmpty ? '' : cuisineIds.join(','),
              typeIds: typeIds.isEmpty ? '' : typeIds.join(','),
              typeName: typeName.isEmpty ? '' : typeName.join(','),
              facilitiesIds: facilitiesIds.isEmpty ? '' : facilitiesIds.join(','),
              facilitiesName: facilitiesName.isEmpty ? '' : facilitiesName.join(','),
              homeDelivery: indexOfHomeDelivery != -1 ? homeDeliveryListOption[indexOfHomeDelivery] : homeDeliveryListOption.first,
              homeDeliveryList: homeDeliveryListOption,
              takeAway: indexOfTakeAway != -1 ? takeAwayListOption[indexOfTakeAway] : takeAwayListOption.first,
              takeAwayList: takeAwayListOption,
              scheduleOrder: indexOfScheduleOrder != -1 ? scheduleOrderOption[indexOfScheduleOrder] : scheduleOrderOption.first,
              scheduleOrderList: scheduleOrderOption,
              license: indexOfLicense != -1 ? licenseList[indexOfLicense] : licenseList.first,
              licenseList: licenseList,
              socialFacebook: data.details!.socialFacebook!,
              socialInstagram: data.details!.socialInstagram!,
              socialX: data.details!.socialX!,
              socialYoutube: data.details!.socialYoutube!,
              socialLinkedIn: data.details!.socialLinkedIn!,
              socialPinterest: data.details!.socialPinterest!,
              isValid: Formz.validate([name, shortDescription, address, cuisine, type, facility, minOrderAmount, dishPriceForTwo, license, deliveryTime]),
              status: EditRestaurantStatus.fetched,
            ),
          );
        } else {
          emit(state.copyWith(status: EditRestaurantStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: EditRestaurantStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: EditRestaurantStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onEditRestaurantNameChangedEvent(EditRestaurantNameChangedEvent event, Emitter<EditRestaurantState> emit) async {
    final name = RestaurantEditNameField.dirty(event.name);
    emit(
      state.copyWith(
        name: name.isValid ? name : RestaurantEditNameField.pure(event.name),
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          name,
          state.shortDescription,
          state.address,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantNameUnfocusedEvent(EditRestaurantNameUnfocusedEvent event, Emitter<EditRestaurantState> emit) async {
    final name = RestaurantEditNameField.dirty(state.name.value);
    emit(
      state.copyWith(
        name: name,
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          name,
          state.shortDescription,
          state.address,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantShortDescriptionChangedEvent(EditRestaurantShortDescriptionChangedEvent event, Emitter<EditRestaurantState> emit) async {
    final shortDescription = RestaurantEditShortDescriptionField.dirty(event.shortDescription);
    emit(
      state.copyWith(
        shortDescription: shortDescription.isValid ? shortDescription : RestaurantEditShortDescriptionField.pure(event.shortDescription),
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          shortDescription,
          state.name,
          state.address,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantShortDescriptionUnfocusedEvent(EditRestaurantShortDescriptionUnfocusedEvent event, Emitter<EditRestaurantState> emit) async {
    final shortDescription = RestaurantEditShortDescriptionField.dirty(state.shortDescription.value);
    emit(
      state.copyWith(
        shortDescription: shortDescription,
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          shortDescription,
          state.name,
          state.address,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantAddressChangedEvent(EditRestaurantAddressChangedEvent event, Emitter<EditRestaurantState> emit) async {
    final address = RestaurantEditAddressField.dirty(event.address);
    emit(
      state.copyWith(
        address: address.isValid ? address : RestaurantEditAddressField.pure(event.address),
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          address,
          state.name,
          state.shortDescription,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantAddressUnfocusedEvent(EditRestaurantAddressUnfocusedEvent event, Emitter<EditRestaurantState> emit) async {
    final address = RestaurantEditAddressField.dirty(state.address.value);
    emit(
      state.copyWith(
        address: address,
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          address,
          state.name,
          state.shortDescription,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantMinOrderAmountChangedEvent(EditRestaurantMinOrderAmountChangedEvent event, Emitter<EditRestaurantState> emit) async {
    final minOrderAmount = RestaurantEditMinOrderAmountField.dirty(event.minOrderAmount);
    emit(
      state.copyWith(
        minOrderAmount: minOrderAmount.isValid ? minOrderAmount : RestaurantEditMinOrderAmountField.pure(event.minOrderAmount),
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          minOrderAmount,
          state.name,
          state.shortDescription,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.address,
          state.dishPriceForTwo,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantMinOrderAmountUnfocusedEvent(EditRestaurantMinOrderAmountUnfocusedEvent event, Emitter<EditRestaurantState> emit) async {
    final minOrderAmount = RestaurantEditMinOrderAmountField.dirty(state.minOrderAmount.value);
    emit(
      state.copyWith(
        minOrderAmount: minOrderAmount,
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          minOrderAmount,
          state.name,
          state.shortDescription,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.address,
          state.dishPriceForTwo,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantDishForTwoChangedEvent(EditRestaurantDishForTwoChangedEvent event, Emitter<EditRestaurantState> emit) async {
    final dishForTwo = RestaurantEditDishPriceForTwoField.dirty(event.dishForTwo);
    emit(
      state.copyWith(
        dishPriceForTwo: dishForTwo.isValid ? dishForTwo : RestaurantEditDishPriceForTwoField.pure(event.dishForTwo),
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          dishForTwo,
          state.name,
          state.shortDescription,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.address,
          state.minOrderAmount,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantDishForTwoUnfocusedEvent(EditRestaurantDishForTwoUnfocusedEvent event, Emitter<EditRestaurantState> emit) async {
    final dishPriceForTwo = RestaurantEditDishPriceForTwoField.dirty(state.dishPriceForTwo.value);
    emit(
      state.copyWith(
        dishPriceForTwo: dishPriceForTwo,
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          dishPriceForTwo,
          state.name,
          state.shortDescription,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.address,
          state.minOrderAmount,
          state.foodLicense,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantFoodLicenseChangedEvent(EditRestaurantFoodLicenseChangedEvent event, Emitter<EditRestaurantState> emit) async {
    final foodLicense = RestaurantEditFoodLicenseField.dirty(event.license);
    emit(
      state.copyWith(
        foodLicense: foodLicense.isValid ? foodLicense : RestaurantEditFoodLicenseField.pure(event.license),
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          foodLicense,
          state.name,
          state.shortDescription,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.address,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantFoodLicenseUnfocusedEvent(EditRestaurantFoodLicenseUnfocusedEvent event, Emitter<EditRestaurantState> emit) async {
    final foodLicense = RestaurantEditFoodLicenseField.dirty(state.foodLicense.value);
    emit(
      state.copyWith(
        foodLicense: foodLicense,
        status: EditRestaurantStatus.initial,
        isValid: Formz.validate([
          foodLicense,
          state.name,
          state.shortDescription,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.address,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.deliveryTime,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantLogoChangeEvent(EditRestaurantLogoChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(logo: event.logo, status: EditRestaurantStatus.initial));
  }

  FutureOr<void> _onEditRestaurantCoverChangeEvent(EditRestaurantCoverChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(cover: event.cover, status: EditRestaurantStatus.initial));
  }

  FutureOr<void> _onEditRestaurantHomeDeliveryChangeEvent(EditRestaurantHomeDeliveryChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(homeDelivery: event.option, status: EditRestaurantStatus.initial));
  }

  FutureOr<void> _onEditRestaurantTakeAwayChangeEvent(EditRestaurantTakeAwayChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(takeAway: event.option, status: EditRestaurantStatus.initial));
  }

  FutureOr<void> _onEditRestaurantScheduleOrderChangeEvent(EditRestaurantScheduleOrderChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(scheduleOrder: event.option, status: EditRestaurantStatus.initial));
  }

  FutureOr<void> _onEditRestaurantLicenseChangeEvent(EditRestaurantLicenseChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(license: event.option, status: EditRestaurantStatus.initial));
  }

  FutureOr<void> _onEditRestaurantCuisineChangeEvent(EditRestaurantCuisineChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(cuisineIds: event.param.ids!, cuisineNames: event.param.names!, status: EditRestaurantStatus.changeDetailFromModal));
  }

  FutureOr<void> _onEditRestaurantTypeChangeEvent(EditRestaurantTypeChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(typeIds: event.param.ids!, typeName: event.param.names!, status: EditRestaurantStatus.changeDetailFromModal));
  }

  FutureOr<void> _onEditRestaurantFacilitiesChangeEvent(EditRestaurantFacilitiesChangeEvent event, Emitter<EditRestaurantState> emit) async {
    emit(state.copyWith(facilitiesIds: event.param.ids!, facilitiesName: event.param.names!, status: EditRestaurantStatus.changeDetailFromModal));
  }

  FutureOr<void> _onEditRestaurantDeliveryTimeChangeEvent(EditRestaurantDeliveryTimeChangeEvent event, Emitter<EditRestaurantState> emit) async {
    final time = RestaurantEditDeliveryTimeField.dirty(event.time);
    emit(
      state.copyWith(
        deliveryTime: time.isValid ? time : RestaurantEditDeliveryTimeField.pure(event.time),
        status: EditRestaurantStatus.changeDetailFromModal,
        isValid: Formz.validate([
          time,
          state.shortDescription,
          state.address,
          state.cuisineNameField,
          state.restaurantTypeField,
          state.restaurantFacilitiesField,
          state.minOrderAmount,
          state.dishPriceForTwo,
          state.foodLicense,
          state.name,
        ]),
      ),
    );
  }

  FutureOr<void> _onEditRestaurantSocialLinkChangeEvent(EditRestaurantSocialLinkChangeEvent event, Emitter<EditRestaurantState> emit) async {
    if (event.type == 'facebook') {
      emit(state.copyWith(socialFacebook: event.value, status: EditRestaurantStatus.initial));
    } else if (event.type == 'instagram') {
      emit(state.copyWith(socialInstagram: event.value, status: EditRestaurantStatus.initial));
    } else if (event.type == 'x') {
      emit(state.copyWith(socialX: event.value, status: EditRestaurantStatus.initial));
    } else if (event.type == 'youtube') {
      emit(state.copyWith(socialYoutube: event.value, status: EditRestaurantStatus.initial));
    } else if (event.type == 'linkedin') {
      emit(state.copyWith(socialLinkedIn: event.value, status: EditRestaurantStatus.initial));
    } else if (event.type == 'pinterest') {
      emit(state.copyWith(socialPinterest: event.value, status: EditRestaurantStatus.initial));
    }
  }

  FutureOr<void> _onEditRestaurantSubmitEvent(EditRestaurantSubmitEvent event, Emitter<EditRestaurantState> emit) async {
    try {
      final name = RestaurantEditNameField.dirty(state.name.value);
      final shortDescription = RestaurantEditShortDescriptionField.dirty(state.shortDescription.value);
      final address = RestaurantEditAddressField.dirty(state.address.value);
      final cuisine = RestaurantEditCuisineField.dirty(state.cuisineNames.isEmpty ? '' : state.cuisineNames);
      final type = RestaurantEditTypeField.dirty(state.typeName.isEmpty ? '' : state.typeName);
      final facility = RestaurantEditFacilitiesField.dirty(state.facilitiesName.isEmpty ? '' : state.facilitiesName);
      final minOrderAmount = RestaurantEditMinOrderAmountField.dirty(state.minOrderAmount.value);
      final dishPriceForTwo = RestaurantEditDishPriceForTwoField.dirty(state.dishPriceForTwo.value);
      final license = RestaurantEditFoodLicenseField.dirty(state.foodLicense.value);
      final deliveryTime = RestaurantEditDeliveryTimeField.dirty(state.deliveryTime.value);
      emit(
        state.copyWith(
          name: name,
          shortDescription: shortDescription,
          address: address,
          cuisineNameField: cuisine,
          restaurantTypeField: type,
          restaurantFacilitiesField: facility,
          minOrderAmount: minOrderAmount,
          dishPriceForTwo: dishPriceForTwo,
          foodLicense: license,
          deliveryTime: deliveryTime,
          status: EditRestaurantStatus.initial,
          isValid: Formz.validate([name, shortDescription, address, cuisine, type, facility, minOrderAmount, dishPriceForTwo, license, deliveryTime]),
        ),
      );
      if (state.isValid &&
          state.name.value.isNotEmpty &&
          state.shortDescription.value.isNotEmpty &&
          state.address.value.isNotEmpty &&
          state.cuisineNameField.value.isNotEmpty &&
          state.restaurantTypeField.value.isNotEmpty &&
          state.restaurantFacilitiesField.value.isNotEmpty &&
          state.minOrderAmount.value.isNotEmpty &&
          state.dishPriceForTwo.value.isNotEmpty &&
          state.foodLicense.value.isNotEmpty &&
          state.deliveryTime.value.isNotEmpty) {
        emit(state.copyWith(status: EditRestaurantStatus.submit));
        RestaurantDetailUpdateRequestModel param = RestaurantDetailUpdateRequestModel(
          logo: state.logo,
          cover: state.cover,
          name: state.name.value.toString(),
          address: state.address.value.toString(),
          shortDescription: state.shortDescription.value.toString(),
          cuisine: state.cuisineIds,
          type: state.typeIds,
          facility: state.facilitiesIds,
          homeDelivery: state.homeDelivery.value,
          takeaway: state.takeAway.value,
          scheduleOrder: state.scheduleOrder.value,
          license: state.license.id,
          licenseId: state.foodLicense.value.toString(),
          minOrderAmount: state.minOrderAmount.value.toString(),
          dishPriceForTwo: state.dishPriceForTwo.value.toString(),
          deliveryTime: state.deliveryTime.value.toString(),
          socialFacebook: state.socialFacebook,
          socialInstagram: state.socialInstagram,
          socialX: state.socialX,
          socialYoutube: state.socialYoutube,
          socialLinkedIn: state.socialLinkedIn,
          socialPinterest: state.socialPinterest,
          translations: event.translations,
        );
        final String vendorId = await _accountRepository.getVendorId();
        DioApiResponse response = await _accountRepository.updateRestaurantDetail(vendorId, param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (initialResponse.success!) {
            await _accountRepository.updateRestaurantDetailLocal(state.name.value.toString(), state.address.value.toString(), state.logo.toString());
            emit(state.copyWith(status: EditRestaurantStatus.submitSuccess));
          } else {
            emit(state.copyWith(status: EditRestaurantStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: EditRestaurantStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: EditRestaurantStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
