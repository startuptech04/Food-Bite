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
import 'package:vendor/app/core/models/modal_navigation_back_response_model.dart';
import 'package:vendor/app/core/models/new_outlet_basic_detail_model.dart';
import 'package:vendor/app/core/models/outlet_cities_response_model.dart';
import 'package:vendor/app/core/models/outlet_detail_response_model.dart';
import 'package:vendor/app/core/models/outlet_license_response_model.dart';
import 'package:vendor/app/core/models/outlet_localities_response_model.dart';
import 'package:vendor/app/core/models/request/create_outlet_request_model.dart';
import 'package:vendor/app/core/models/request/update_outlet_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/outlet_form_translation.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/outlet_repository.dart';
import 'package:vendor/app/core/validations/outlet_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'manage_outlet_event.dart';
part 'manage_outlet_state.dart';

class ManageOutletBloc extends Bloc<ManageOutletEvent, ManageOutletState> {
  final OutletRepository _outletRepository = OutletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ManageOutletBloc()
    : super(
        ManageOutletState(
          basicDetail: NewOutletBasicDetailModel(cities: [], licenses: [], success: false, locale: ''),
          outletDetail: OutletDetailResponseModel(cities: [], localities: [], licenses: [], success: false, locale: ''),
          homeDelivery: HomeDeliverySupportModel(label: '', value: false),
          takeAway: TakeAwaySupportModel(label: '', value: false),
          scheduleOrder: ScheduleOrderSupportModel(label: '', value: false),
          selectedCity: OutletCitiesResponseModel(locale: ''),
          selectedLicense: OutletLicenseResponseModel(locale: ''),
          selectedLocality: OutletLocalitiesResponseModel(locale: ''),
        ),
      ) {
    on<ManageOutletInitialEvent>(_onManageOutletInitialEvent);
    on<ManageOutletNameChangedEvent>(_onManageOutletNameChangedEvent);
    on<ManageOutletNameUnfocusedEvent>(_onManageOutletNameUnfocusedEvent);
    on<ManageOutletShortDescriptionChangedEvent>(_onManageOutletShortDescriptionChangedEvent);
    on<ManageOutletShortDescriptionUnfocusedEvent>(_onManageOutletShortDescriptionUnfocusedEvent);
    on<ManageOutletAddressChangedEvent>(_onManageOutletAddressChangedEvent);
    on<ManageOutletAddressUnfocusedEvent>(_onManageOutletAddressUnfocusedEvent);
    on<ManageOutletMinOrderAmountChangedEvent>(_onManageOutletMinOrderAmountChangedEvent);
    on<ManageOutletMinOrderAmountUnfocusedEvent>(_onManageOutletMinOrderAmountUnfocusedEvent);
    on<ManageOutletDishForTwoChangedEvent>(_onManageOutletDishForTwoChangedEvent);
    on<ManageOutletDishForTwoUnfocusedEvent>(_onManageOutletDishForTwoUnfocusedEvent);
    on<ManageOutletFoodLicenseChangedEvent>(_onManageOutletFoodLicenseChangedEvent);
    on<ManageOutletFoodLicenseUnfocusedEvent>(_onManageOutletFoodLicenseUnfocusedEvent);
    on<ManageOutletLogoChangeEvent>(_onManageOutletLogoChangeEvent);
    on<ManageOutletCoverChangeEvent>(_onManageOutletCoverChangeEvent);
    on<ManageOutletHomeDeliveryChangeEvent>(_onManageOutletHomeDeliveryChangeEvent);
    on<ManageOutletTakeAwayChangeEvent>(_onManageOutletTakeAwayChangeEvent);
    on<ManageOutletScheduleOrderChangeEvent>(_onManageOutletScheduleOrderChangeEvent);
    on<ManageOutletEmailChangedEvent>(_onManageOutletEmailChangedEvent);
    on<ManageOutletEmailUnfocusedEvent>(_onManageOutletEmailUnfocusedEvent);
    on<ManageOutletPasswordChangedEvent>(_onManageOutletPasswordChangedEvent);
    on<ManageOutletPasswordUnfocusedEvent>(_onManageOutletPasswordUnfocusedEvent);
    on<ManageOutletFirstNameChangedEvent>(_onManageOutletFirstNameChangedEvent);
    on<ManageOutletFirstNameUnfocusedEvent>(_onManageOutletFirstNameUnfocusedEvent);
    on<ManageOutletLastNameChangedEvent>(_onManageOutletLastNameChangedEvent);
    on<ManageOutletLastNameUnfocusedEvent>(_onManageOutletLastNameUnfocusedEvent);
    on<ManageOutletCountryCodeChangedEvent>(_onManageOutletCountryCodeChangedEvent);
    on<ManageOutletCountryCodeUnfocusedEvent>(_onManageOutletCountryCodeUnfocusedEvent);
    on<ManageOutletMobileNumberChangedEvent>(_onManageOutletMobileNumberChangedEvent);
    on<ManageOutletMobileNumberUnfocusedEvent>(_onManageOutletMobileNumberUnfocusedEvent);
    on<ManageOutletCuisineChangeEvent>(_onManageOutletCuisineChangeEvent);
    on<ManageOutletTypeChangeEvent>(_onManageOutletTypeChangeEvent);
    on<ManageOutletFacilitiesChangeEvent>(_onManageOutletFacilitiesChangeEvent);
    on<ManageOutletDeliveryTimeChangeEvent>(_onManageOutletDeliveryTimeChangeEvent);
    on<ManageOutletLicenseChangeEvent>(_onManageOutletLicenseChangeEvent);
    on<ManageOutletCityChangeEvent>(_onManageOutletCityChangeEvent);
    on<ManageOutletLocalityChangeEvent>(_onManageOutletLocalityChangeEvent);
    on<ManageOutletLocationChangeEvent>(_onManageOutletLocationChangeEvent);
    on<ManageOutletSubmitEvent>(_onManageOutletSubmitEvent);
    on<ManageOutletCusineUnfocusedEvent>(_onManageOutletCusineUnfocusedEvent);
    on<ManageOutletTypeUnfocusedEvent>(_onManageOutletTypeUnfocusedEvent);
    on<ManageOutletFacilityUnfocusedEvent>(_onManageOutletFacilityUnfocusedEvent);
    on<ManageOutletSocialLinkChangeEvent>(_onManageOutletSocialLinkChangeEvent);
  }

  FutureOr<void> _onManageOutletInitialEvent(ManageOutletInitialEvent event, Emitter<ManageOutletState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_outlet"}, 'add_update_outlet_screen', 'add_update_outlet_screen');
    HomeDeliverySupportModel homeDeliveryTrue = HomeDeliverySupportModel(label: 'dd_yes_home_delivery', value: true);
    HomeDeliverySupportModel homeDeliveryFalse = HomeDeliverySupportModel(label: 'dd_no_home_delivery', value: false);
    List<HomeDeliverySupportModel> homeDeliveryListOption = <HomeDeliverySupportModel>[];
    homeDeliveryListOption.clear();
    homeDeliveryListOption.add(homeDeliveryTrue);
    homeDeliveryListOption.add(homeDeliveryFalse);

    TakeAwaySupportModel takeAwayTrue = TakeAwaySupportModel(label: 'dd_yes_takeaway', value: true);
    TakeAwaySupportModel takeAwayFalse = TakeAwaySupportModel(label: 'dd_no_takeaway', value: false);
    List<TakeAwaySupportModel> takeAwayListOption = <TakeAwaySupportModel>[];
    takeAwayListOption.clear();
    takeAwayListOption.add(takeAwayTrue);
    takeAwayListOption.add(takeAwayFalse);

    ScheduleOrderSupportModel scheduleOrderTrue = ScheduleOrderSupportModel(label: 'dd_yes_schedule_order', value: true);
    ScheduleOrderSupportModel scheduleOrderFalse = ScheduleOrderSupportModel(label: 'dd_no_schedule_order', value: false);
    List<ScheduleOrderSupportModel> scheduleOrderOption = <ScheduleOrderSupportModel>[];
    scheduleOrderOption.clear();
    scheduleOrderOption.add(scheduleOrderTrue);
    scheduleOrderOption.add(scheduleOrderFalse);

    if (event.isNew) {
      try {
        emit(state.copyWith(status: ManageOutletStatus.loading, isNew: event.isNew));
        DioApiResponse response = await _outletRepository.getBasicDataForNewOutlet();
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          NewOutletBasicDetailModel data = NewOutletBasicDetailModel.fromJson(myMap, locale.toString());
          String defaultCountryCode = '';
          String flag = '';
          await _outletRepository.getDefaultCountryCode().then((value) {
            if (value != '' && value.isNotEmpty) {
              try {
                Map<String, dynamic>? myMap = jsonDecode(value) as Map<String, dynamic>;
                AppDefaultCountryCodeConfigModel countryCodeData = AppDefaultCountryCodeConfigModel.fromJson(myMap);
                defaultCountryCode = countryCodeData.dialCode!;
                flag = countryCodeData.flag!;
              } catch (e, stacktrace) {
                if (!kIsWeb) {
                  FirebaseCrashlytics.instance.recordError(e, stacktrace);
                }
              }
            }
          });
          String latitude = '0';
          String longitude = '0';
          List<OutletCitiesResponseModel> cityList = <OutletCitiesResponseModel>[];
          cityList.clear();
          for (var element in data.cities!) {
            cityList.add(element);
          }
          List<OutletLocalitiesResponseModel> localityList = <OutletLocalitiesResponseModel>[];
          localityList.clear();
          if (cityList.isNotEmpty) {
            localityList = data.localities!.where((element) => element.city == cityList.first.id).toList();
          }

          if (localityList.isNotEmpty) {
            latitude = localityList.first.location!.coordinates![1].toString();
            longitude = localityList.first.location!.coordinates![0].toString();
          }

          List<OutletLicenseResponseModel> licenseList = <OutletLicenseResponseModel>[];
          licenseList.clear();
          for (var element in data.licenses!) {
            licenseList.add(element);
          }

          const deliveryTime = OutletDeliveryTimeField.dirty('10 to 20 min');
          final countryCode = OutletCountryCodeField.dirty(defaultCountryCode);
          final latitudeField = OutletLatitudeField.dirty(latitude);
          final longitudeField = OutletLongitudeField.dirty(longitude);

          emit(
            state.copyWith(
              countryCodeField: countryCode,
              deliveryTimeField: deliveryTime,
              latitudeField: latitudeField,
              longitudeField: longitudeField,
              flag: flag,
              homeDelivery: homeDeliveryListOption.first,
              homeDeliveryList: homeDeliveryListOption,
              takeAway: takeAwayListOption.first,
              takeAwayList: takeAwayListOption,
              scheduleOrder: scheduleOrderOption.first,
              scheduleOrderList: scheduleOrderOption,
              selectedCity: cityList.first,
              cityList: cityList,
              selectedLocality: localityList.isNotEmpty ? localityList.first : OutletLocalitiesResponseModel(id: '', name: '', translations: [], locale: locale.toString()),
              localityList: localityList,
              selectedLicense: licenseList.first,
              licenseList: licenseList,
              basicDetail: data,
              status: ManageOutletStatus.basicFetched,
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageOutletStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageOutletStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      try {
        final String locale = await _accountRepository.getLocale();
        emit(state.copyWith(status: ManageOutletStatus.loading, isNew: event.isNew, outletId: event.outletId));
        final String vendorId = await _outletRepository.getVendorId();
        DioApiResponse response = await _outletRepository.getOutletInfo(event.outletId, vendorId);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OutletDetailResponseModel data = OutletDetailResponseModel.fromJson(myMap, locale.toString());

          List<OutletCitiesResponseModel> cityList = <OutletCitiesResponseModel>[];
          cityList.clear();
          for (var element in data.cities!) {
            cityList.add(element);
          }
          final int cityIndex = cityList.indexWhere((element) => data.result!.city! == element.id!);

          List<OutletLocalitiesResponseModel> localityList = <OutletLocalitiesResponseModel>[];
          localityList.clear();
          if (cityList.isNotEmpty) {
            localityList = data.localities!.where((element) => element.city == data.result!.city!).toList();
          }
          final int localityIndex = localityList.indexWhere((element) => data.result!.locality! == element.id!);

          List<OutletLicenseResponseModel> licenseList = <OutletLicenseResponseModel>[];
          licenseList.clear();
          for (var element in data.licenses!) {
            licenseList.add(element);
          }
          final int licenseIndex = licenseList.indexWhere((element) => data.result!.license! == element.id);

          final List<String> cuisineName = <String>[];
          final List<String> cuisineIds = <String>[];
          cuisineName.clear();
          cuisineIds.clear();
          for (var element in data.result!.cuisine!) {
            cuisineName.add(element.name!);
            cuisineIds.add(element.id!);
          }

          final List<String> typeName = <String>[];
          final List<String> typeIds = <String>[];
          typeName.clear();
          typeIds.clear();
          for (var element in data.result!.restauranttypes!) {
            typeIds.add(element.id!);
            typeName.add(element.name!);
          }

          final List<String> facilitiesName = <String>[];
          final List<String> facilitiesIds = <String>[];
          facilitiesName.clear();
          facilitiesIds.clear();
          for (var element in data.result!.restaurantfacilities!) {
            facilitiesName.add(element.name!);
            facilitiesIds.add(element.id!);
          }

          final int homeDeliveryIndex = homeDeliveryListOption.indexWhere((element) => data.result!.acceptHomeDelivery! == element.value);
          final int takeAwayIndex = takeAwayListOption.indexWhere((element) => data.result!.takeAway! == element.value);
          final int scheduleOrderIndex = scheduleOrderOption.indexWhere((element) => data.result!.acceptScheduleDelivery! == element.value);

          final name = OutletNameField.dirty(data.result!.name!);
          final shortDescription = OutletShortDescriptionField.dirty(data.result!.shortDescription!);
          final address = OutletAddressField.dirty(data.result!.address!);
          final minOrderAmount = OutletMinOrderAmountField.dirty(data.result!.minOrderAmount!.toString());
          final dishForTwo = OutletDishPriceForTwoField.dirty(data.result!.dishPriceForTwo!.toString());
          final license = OutletFoodLicenseField.dirty(data.result!.licenseId!);
          final deliveryTime = OutletDeliveryTimeField.dirty(data.result!.approxDeliveryTime!);
          const email = OutletEmailField.dirty('none@gmail.com');
          const password = OutletPasswordField.dirty('none');
          const firstName = OutletFirstNameField.dirty('none');
          const lastName = OutletLastNameField.dirty('none');
          const countryCode = OutletCountryCodeField.dirty('none');
          const mobileNumber = OutletMobileNumberField.dirty('none');
          final latitude = OutletLatitudeField.dirty(data.result!.location!.coordinates![1].toString());
          final longitude = OutletLongitudeField.dirty(data.result!.location!.coordinates![0].toString());
          final cover = OutletCoverField.dirty(data.result!.cover!);
          final logo = OutletLogoField.dirty(data.result!.logo!);
          final cuisine = OutletCuisineField.dirty(cuisineIds.isNotEmpty ? cuisineIds.join(',') : '');
          final type = OutletTypeField.dirty(typeIds.isNotEmpty ? typeIds.join(',') : '');
          final facility = OutletFacilitiesField.dirty(facilitiesIds.isNotEmpty ? facilitiesIds.join(',') : '');

          emit(
            state.copyWith(
              status: ManageOutletStatus.fetched,
              outletDetail: data,
              selectedCity: cityIndex != -1 ? cityList[cityIndex] : cityList.first,
              cityList: cityList,
              selectedLocality: localityIndex != -1 ? localityList[localityIndex] : localityList.first,
              localityList: localityList,
              selectedLicense: licenseIndex != -1 ? licenseList[licenseIndex] : licenseList.first,
              licenseList: licenseList,
              nameField: name,
              shortDescriptionField: shortDescription,
              addressField: address,
              minOrderAmountField: minOrderAmount,
              dishPriceForTwoField: dishForTwo,
              licenseField: license,
              deliveryTimeField: deliveryTime,
              emailField: email,
              passwordField: password,
              firstNameField: firstName,
              lastNameField: lastName,
              countryCodeField: countryCode,
              mobileNumberField: mobileNumber,
              latitudeField: latitude,
              longitudeField: longitude,
              coverField: cover,
              logoField: logo,
              cuisineField: cuisine,
              homeDelivery: homeDeliveryIndex != -1 ? homeDeliveryListOption[homeDeliveryIndex] : homeDeliveryListOption.first,
              homeDeliveryList: homeDeliveryListOption,
              takeAway: takeAwayIndex != -1 ? takeAwayListOption[takeAwayIndex] : takeAwayListOption.first,
              takeAwayList: takeAwayListOption,
              scheduleOrder: scheduleOrderIndex != -1 ? scheduleOrderOption[scheduleOrderIndex] : scheduleOrderOption.first,
              scheduleOrderList: scheduleOrderOption,
              typeField: type,
              facilitiesField: facility,
              typeIds: typeIds.join(','),
              typeName: typeName.join(','),
              cuisineIds: cuisineIds.join(','),
              cuisineNames: cuisineName.join(','),
              facilitiesIds: facilitiesIds.join(','),
              facilitiesName: facilitiesName.join(','),
              socialFacebook: data.result!.socialFacebook!,
              socialInstagram: data.result!.socialInstagram!,
              socialX: data.result!.socialX!,
              socialYoutube: data.result!.socialYoutube!,
              socialLinkedIn: data.result!.socialLinkedIn!,
              socialPinterest: data.result!.socialPinterest!,
              isValid: Formz.validate([
                name,
                shortDescription,
                address,
                minOrderAmount,
                dishForTwo,
                license,
                deliveryTime,
                email,
                password,
                firstName,
                lastName,
                countryCode,
                mobileNumber,
                latitude,
                longitude,
                cover,
                logo,
                cuisine,
                type,
                facility,
              ]),
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageOutletStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageOutletStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onManageOutletNameChangedEvent(ManageOutletNameChangedEvent event, Emitter<ManageOutletState> emit) async {
    final name = OutletNameField.dirty(event.name);
    emit(
      state.copyWith(
        nameField: name.isValid ? name : OutletNameField.pure(event.name),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          name,
          state.shortDescriptionField,
          state.addressField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletNameUnfocusedEvent(ManageOutletNameUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final name = OutletNameField.dirty(state.nameField.value);
    emit(
      state.copyWith(
        nameField: name,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          name,
          state.shortDescriptionField,
          state.addressField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletShortDescriptionChangedEvent(ManageOutletShortDescriptionChangedEvent event, Emitter<ManageOutletState> emit) async {
    final shortDescription = OutletShortDescriptionField.dirty(event.shortDescription);
    emit(
      state.copyWith(
        shortDescriptionField: shortDescription.isValid ? shortDescription : OutletShortDescriptionField.pure(event.shortDescription),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          shortDescription,
          state.nameField,
          state.addressField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletShortDescriptionUnfocusedEvent(ManageOutletShortDescriptionUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final shortDescription = OutletShortDescriptionField.dirty(state.shortDescriptionField.value);
    emit(
      state.copyWith(
        shortDescriptionField: shortDescription,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          shortDescription,
          state.nameField,
          state.addressField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletAddressChangedEvent(ManageOutletAddressChangedEvent event, Emitter<ManageOutletState> emit) async {
    final address = OutletAddressField.dirty(event.address);
    emit(
      state.copyWith(
        addressField: address.isValid ? address : OutletAddressField.pure(event.address),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          address,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletAddressUnfocusedEvent(ManageOutletAddressUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final address = OutletAddressField.dirty(state.addressField.value);
    emit(
      state.copyWith(
        addressField: address,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          address,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletMinOrderAmountChangedEvent(ManageOutletMinOrderAmountChangedEvent event, Emitter<ManageOutletState> emit) async {
    final minOrderAmount = OutletMinOrderAmountField.dirty(event.minOrderAmount);
    emit(
      state.copyWith(
        minOrderAmountField: minOrderAmount.isValid ? minOrderAmount : OutletMinOrderAmountField.pure(event.minOrderAmount),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          minOrderAmount,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.dishPriceForTwoField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletMinOrderAmountUnfocusedEvent(ManageOutletMinOrderAmountUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final minOrderAmount = OutletMinOrderAmountField.dirty(state.minOrderAmountField.value);
    emit(
      state.copyWith(
        minOrderAmountField: minOrderAmount,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          minOrderAmount,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.dishPriceForTwoField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletDishForTwoChangedEvent(ManageOutletDishForTwoChangedEvent event, Emitter<ManageOutletState> emit) async {
    final dishForTwo = OutletDishPriceForTwoField.dirty(event.dishForTwo);
    emit(
      state.copyWith(
        dishPriceForTwoField: dishForTwo.isValid ? dishForTwo : OutletDishPriceForTwoField.pure(event.dishForTwo),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          dishForTwo,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletDishForTwoUnfocusedEvent(ManageOutletDishForTwoUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final dishForTwo = OutletDishPriceForTwoField.dirty(state.dishPriceForTwoField.value);
    emit(
      state.copyWith(
        dishPriceForTwoField: dishForTwo,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          dishForTwo,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.licenseField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletFoodLicenseChangedEvent(ManageOutletFoodLicenseChangedEvent event, Emitter<ManageOutletState> emit) async {
    final license = OutletFoodLicenseField.dirty(event.license);
    emit(
      state.copyWith(
        licenseField: license.isValid ? license : OutletFoodLicenseField.pure(event.license),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          license,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletFoodLicenseUnfocusedEvent(ManageOutletFoodLicenseUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final license = OutletFoodLicenseField.dirty(state.licenseField.value);
    emit(
      state.copyWith(
        licenseField: license,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          license,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletLogoChangeEvent(ManageOutletLogoChangeEvent event, Emitter<ManageOutletState> emit) async {
    final logo = OutletLogoField.dirty(event.logo);
    emit(
      state.copyWith(
        logoField: logo.isValid ? logo : OutletLogoField.pure(event.logo),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          logo,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.licenseField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletCoverChangeEvent(ManageOutletCoverChangeEvent event, Emitter<ManageOutletState> emit) async {
    final cover = OutletCoverField.dirty(event.cover);
    emit(
      state.copyWith(
        coverField: cover.isValid ? cover : OutletCoverField.pure(event.cover),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          cover,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletHomeDeliveryChangeEvent(ManageOutletHomeDeliveryChangeEvent event, Emitter<ManageOutletState> emit) async {
    emit(state.copyWith(homeDelivery: event.option, status: ManageOutletStatus.initial));
  }

  FutureOr<void> _onManageOutletTakeAwayChangeEvent(ManageOutletTakeAwayChangeEvent event, Emitter<ManageOutletState> emit) async {
    emit(state.copyWith(takeAway: event.option, status: ManageOutletStatus.initial));
  }

  FutureOr<void> _onManageOutletScheduleOrderChangeEvent(ManageOutletScheduleOrderChangeEvent event, Emitter<ManageOutletState> emit) async {
    emit(state.copyWith(scheduleOrder: event.option, status: ManageOutletStatus.initial));
  }

  FutureOr<void> _onManageOutletEmailChangedEvent(ManageOutletEmailChangedEvent event, Emitter<ManageOutletState> emit) async {
    final email = OutletEmailField.dirty(event.email);
    emit(
      state.copyWith(
        emailField: email.isValid ? email : OutletEmailField.pure(event.email),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          email,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletEmailUnfocusedEvent(ManageOutletEmailUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final email = OutletEmailField.dirty(state.emailField.value);
    emit(
      state.copyWith(
        emailField: email,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          email,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletPasswordChangedEvent(ManageOutletPasswordChangedEvent event, Emitter<ManageOutletState> emit) async {
    final password = OutletPasswordField.dirty(event.password);
    emit(
      state.copyWith(
        passwordField: password.isValid ? password : OutletPasswordField.pure(event.password),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          password,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletPasswordUnfocusedEvent(ManageOutletPasswordUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final password = OutletPasswordField.dirty(state.passwordField.value);
    emit(
      state.copyWith(
        passwordField: password,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          password,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletFirstNameChangedEvent(ManageOutletFirstNameChangedEvent event, Emitter<ManageOutletState> emit) async {
    final firstName = OutletFirstNameField.dirty(event.firstName);
    emit(
      state.copyWith(
        firstNameField: firstName.isValid ? firstName : OutletFirstNameField.pure(event.firstName),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          firstName,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletFirstNameUnfocusedEvent(ManageOutletFirstNameUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final firstName = OutletFirstNameField.dirty(state.firstNameField.value);
    emit(
      state.copyWith(
        firstNameField: firstName,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          firstName,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletLastNameChangedEvent(ManageOutletLastNameChangedEvent event, Emitter<ManageOutletState> emit) async {
    final lastName = OutletLastNameField.dirty(event.lastName);
    emit(
      state.copyWith(
        lastNameField: lastName.isValid ? lastName : OutletLastNameField.pure(event.lastName),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          lastName,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletLastNameUnfocusedEvent(ManageOutletLastNameUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final lastName = OutletLastNameField.dirty(state.lastNameField.value);
    emit(
      state.copyWith(
        lastNameField: lastName,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          lastName,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletCountryCodeChangedEvent(ManageOutletCountryCodeChangedEvent event, Emitter<ManageOutletState> emit) async {
    final countryCode = OutletCountryCodeField.dirty(event.countryCode);
    emit(
      state.copyWith(
        countryCodeField: countryCode.isValid ? countryCode : OutletCountryCodeField.pure(event.countryCode),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          countryCode,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletCountryCodeUnfocusedEvent(ManageOutletCountryCodeUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final countryCode = OutletCountryCodeField.dirty(state.countryCodeField.value);
    emit(
      state.copyWith(
        countryCodeField: countryCode,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          countryCode,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.mobileNumberField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletMobileNumberChangedEvent(ManageOutletMobileNumberChangedEvent event, Emitter<ManageOutletState> emit) async {
    final mobileNumber = OutletMobileNumberField.dirty(event.mobileNumber);
    emit(
      state.copyWith(
        mobileNumberField: mobileNumber.isValid ? mobileNumber : OutletMobileNumberField.pure(event.mobileNumber),
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          mobileNumber,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletMobileNumberUnfocusedEvent(ManageOutletMobileNumberUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final mobileNumber = OutletMobileNumberField.dirty(state.mobileNumberField.value);
    emit(
      state.copyWith(
        mobileNumberField: mobileNumber,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          mobileNumber,
          state.nameField,
          state.shortDescriptionField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletCuisineChangeEvent(ManageOutletCuisineChangeEvent event, Emitter<ManageOutletState> emit) async {
    final cuisine = OutletCuisineField.dirty(event.param.ids!);
    emit(
      state.copyWith(
        cuisineField: cuisine.isValid ? cuisine : OutletCuisineField.pure(event.param.ids!),
        cuisineIds: event.param.ids!,
        cuisineNames: event.param.names!,
        status: ManageOutletStatus.changeDetailFromModal,
        isValid: Formz.validate([
          cuisine,
          state.shortDescriptionField,
          state.nameField,
          state.mobileNumberField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletTypeChangeEvent(ManageOutletTypeChangeEvent event, Emitter<ManageOutletState> emit) async {
    final type = OutletTypeField.dirty(event.param.ids!);
    emit(
      state.copyWith(
        typeField: type.isValid ? type : OutletTypeField.pure(event.param.ids!),
        typeIds: event.param.ids!,
        typeName: event.param.names!,
        status: ManageOutletStatus.changeDetailFromModal,
        isValid: Formz.validate([
          type,
          state.shortDescriptionField,
          state.nameField,
          state.mobileNumberField,
          state.cuisineField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletFacilitiesChangeEvent(ManageOutletFacilitiesChangeEvent event, Emitter<ManageOutletState> emit) async {
    final facilities = OutletFacilitiesField.dirty(event.param.ids!);
    emit(
      state.copyWith(
        facilitiesField: facilities.isValid ? facilities : OutletFacilitiesField.pure(event.param.ids!),
        facilitiesIds: event.param.ids!,
        facilitiesName: event.param.names!,
        status: ManageOutletStatus.changeDetailFromModal,
        isValid: Formz.validate([
          facilities,
          state.shortDescriptionField,
          state.nameField,
          state.mobileNumberField,
          state.cuisineField,
          state.typeField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletDeliveryTimeChangeEvent(ManageOutletDeliveryTimeChangeEvent event, Emitter<ManageOutletState> emit) async {
    final deliveryTime = OutletDeliveryTimeField.dirty(event.time);
    emit(
      state.copyWith(
        deliveryTimeField: deliveryTime.isValid ? deliveryTime : OutletDeliveryTimeField.pure(event.time),
        status: ManageOutletStatus.changeDetailFromModal,
        isValid: Formz.validate([
          deliveryTime,
          state.shortDescriptionField,
          state.nameField,
          state.cuisineField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.mobileNumberField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletLicenseChangeEvent(ManageOutletLicenseChangeEvent event, Emitter<ManageOutletState> emit) {
    emit(state.copyWith(selectedLicense: event.option, status: ManageOutletStatus.initial));
  }

  FutureOr<void> _onManageOutletCityChangeEvent(ManageOutletCityChangeEvent event, Emitter<ManageOutletState> emit) async {
    emit(state.copyWith(selectedCity: event.city, status: ManageOutletStatus.basicFetched));
    List<OutletLocalitiesResponseModel> localities = <OutletLocalitiesResponseModel>[];
    if (state.isNew) {
      localities = state.basicDetail.localities!.where((element) => element.city == event.city.id).toList();
    } else {
      localities = state.outletDetail.localities!.where((element) => element.city == event.city.id).toList();
    }
    if (localities.isNotEmpty) {
      emit(
        state.copyWith(
          latitudeField: OutletLatitudeField.pure(localities.first.location!.coordinates![1].toString()),
          longitudeField: OutletLongitudeField.pure(localities.first.location!.coordinates![0].toString()),
          selectedLocality: localities.first,
          localityList: [...localities],
          status: ManageOutletStatus.basicFetched,
        ),
      );
    } else {
      final String locale = await _accountRepository.getLocale();
      emit(
        state.copyWith(
          latitudeField: OutletLatitudeField.pure(event.city.location!.coordinates![1].toString()),
          longitudeField: OutletLongitudeField.pure(event.city.location!.coordinates![0].toString()),
          selectedLocality: OutletLocalitiesResponseModel(id: '', city: '', name: '', translations: [], locale: locale.toString()),
          localityList: [],
          status: ManageOutletStatus.basicFetched,
        ),
      );
    }
  }

  FutureOr<void> _onManageOutletLocalityChangeEvent(ManageOutletLocalityChangeEvent event, Emitter<ManageOutletState> emit) async {
    emit(
      state.copyWith(
        selectedLocality: event.locality,
        latitudeField: OutletLatitudeField.pure(event.locality.location!.coordinates![1].toString()),
        longitudeField: OutletLongitudeField.pure(event.locality.location!.coordinates![0].toString()),
        status: ManageOutletStatus.basicFetched,
      ),
    );
  }

  FutureOr<void> _onManageOutletLocationChangeEvent(ManageOutletLocationChangeEvent event, Emitter<ManageOutletState> emit) async {
    emit(state.copyWith(latitudeField: OutletLatitudeField.pure(event.latitude.toString()), longitudeField: OutletLongitudeField.pure(event.longitude.toString()), status: ManageOutletStatus.locationChange));
  }

  FutureOr<void> _onManageOutletCusineUnfocusedEvent(ManageOutletCusineUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final cuisineField = OutletCuisineField.dirty(state.cuisineField.value);
    emit(
      state.copyWith(
        cuisineField: cuisineField,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          cuisineField,
          state.nameField,
          state.shortDescriptionField,
          state.mobileNumberField,
          state.typeField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletTypeUnfocusedEvent(ManageOutletTypeUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final typeField = OutletTypeField.dirty(state.typeField.value);
    emit(
      state.copyWith(
        typeField: typeField,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          typeField,
          state.nameField,
          state.shortDescriptionField,
          state.mobileNumberField,
          state.cuisineField,
          state.facilitiesField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletFacilityUnfocusedEvent(ManageOutletFacilityUnfocusedEvent event, Emitter<ManageOutletState> emit) async {
    final facilityField = OutletFacilitiesField.dirty(state.facilitiesField.value);
    emit(
      state.copyWith(
        facilitiesField: facilityField,
        status: ManageOutletStatus.initial,
        isValid: Formz.validate([
          facilityField,
          state.nameField,
          state.shortDescriptionField,
          state.mobileNumberField,
          state.cuisineField,
          state.typeField,
          state.addressField,
          state.minOrderAmountField,
          state.dishPriceForTwoField,
          state.deliveryTimeField,
          state.licenseField,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.latitudeField,
          state.longitudeField,
          state.coverField,
          state.logoField,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageOutletSubmitEvent(ManageOutletSubmitEvent event, Emitter<ManageOutletState> emit) async {
    try {
      final name = OutletNameField.dirty(state.nameField.value);
      final shortDescription = OutletShortDescriptionField.dirty(state.shortDescriptionField.value);
      final address = OutletAddressField.dirty(state.addressField.value);
      final cuisine = OutletCuisineField.dirty(state.cuisineField.value);
      final type = OutletTypeField.dirty(state.typeField.value);
      final facility = OutletFacilitiesField.dirty(state.facilitiesField.value);
      final minOrderAmount = OutletMinOrderAmountField.dirty(state.minOrderAmountField.value);
      final dishForTwo = OutletDishPriceForTwoField.dirty(state.dishPriceForTwoField.value);
      final license = OutletFoodLicenseField.dirty(state.licenseField.value);
      final deliveryTime = OutletDeliveryTimeField.dirty(state.deliveryTimeField.value);
      final email = OutletEmailField.dirty(state.emailField.value);
      final password = OutletPasswordField.dirty(state.passwordField.value);
      final firstName = OutletFirstNameField.dirty(state.firstNameField.value);
      final lastName = OutletLastNameField.dirty(state.lastNameField.value);
      final countryCode = OutletCountryCodeField.dirty(state.countryCodeField.value);
      final mobileNumber = OutletMobileNumberField.dirty(state.mobileNumberField.value);
      final latitude = OutletLatitudeField.dirty(state.latitudeField.value);
      final longitude = OutletLongitudeField.dirty(state.longitudeField.value);
      final cover = OutletCoverField.dirty(state.coverField.value);
      final logo = OutletLogoField.dirty(state.logoField.value);
      emit(
        state.copyWith(
          nameField: name,
          shortDescriptionField: shortDescription,
          addressField: address,
          cuisineField: cuisine,
          typeField: type,
          facilitiesField: facility,
          minOrderAmountField: minOrderAmount,
          dishPriceForTwoField: dishForTwo,
          licenseField: license,
          deliveryTimeField: deliveryTime,
          emailField: email,
          passwordField: password,
          firstNameField: firstName,
          lastNameField: lastName,
          countryCodeField: countryCode,
          mobileNumberField: mobileNumber,
          latitudeField: latitude,
          longitudeField: longitude,
          coverField: cover,
          logoField: logo,
          status: ManageOutletStatus.initial,
          isValid: Formz.validate([
            name,
            shortDescription,
            address,
            cuisine,
            type,
            facility,
            minOrderAmount,
            dishForTwo,
            license,
            deliveryTime,
            email,
            password,
            firstName,
            lastName,
            countryCode,
            mobileNumber,
            latitude,
            longitude,
            cover,
            logo,
          ]),
        ),
      );
      if (state.isValid &&
          state.nameField.value.isNotEmpty &&
          state.shortDescriptionField.value.isNotEmpty &&
          state.addressField.value.isNotEmpty &&
          state.cuisineField.value.isNotEmpty &&
          state.typeField.value.isNotEmpty &&
          state.facilitiesField.value.isNotEmpty &&
          state.minOrderAmountField.value.isNotEmpty &&
          state.dishPriceForTwoField.value.isNotEmpty &&
          state.licenseField.value.isNotEmpty &&
          state.deliveryTimeField.value.isNotEmpty &&
          state.emailField.value.isNotEmpty &&
          state.passwordField.value.isNotEmpty &&
          state.firstNameField.value.isNotEmpty &&
          state.lastNameField.value.isNotEmpty &&
          state.countryCodeField.value.isNotEmpty &&
          state.mobileNumberField.value.isNotEmpty &&
          state.latitudeField.value.isNotEmpty &&
          state.longitudeField.value.isNotEmpty &&
          state.coverField.value.isNotEmpty &&
          state.logoField.value.isNotEmpty) {
        if (state.isNew) {
          try {
            emit(state.copyWith(status: ManageOutletStatus.submit));
            final String vendorId = await _outletRepository.getVendorId();
            CreateOutletRequestModel param = CreateOutletRequestModel(
              email: email.value.toString(),
              password: password.value.toString(),
              firstName: firstName.value.toString(),
              lastName: lastName.value.toString(),
              countryCode: countryCode.value.toString(),
              mobile: mobileNumber.value.toString(),
              managerId: vendorId,
              name: name.value.toString(),
              shortDescription: shortDescription.value.toString(),
              address: address.value.toString(),
              cuisine: cuisine.value.toString(),
              logo: logo.value.toString(),
              cover: cover.value.toString(),
              city: state.selectedCity.id!.isNotEmpty ? state.selectedCity.id! : '',
              locality: state.selectedLocality.id!.isNotEmpty ? state.selectedLocality.id! : '',
              latitude: latitude.value.toString(),
              longitude: longitude.value.toString(),
              approxDeliveryTime: deliveryTime.value.toString(),
              dishPriceForTwo: dishForTwo.value.toString(),
              takeAway: state.takeAway.value,
              restaurantType: type.value.toString(),
              restaurantFacility: facility.value.toString(),
              acceptScheduleDelivery: state.scheduleOrder.value,
              acceptHomeDelivery: state.homeDelivery.value,
              minOrderAmount: minOrderAmount.value.toString(),
              license: state.selectedLicense.id!.isNotEmpty ? state.selectedLicense.id! : '',
              licenseId: license.value.toString(),
              socialFacebook: state.socialFacebook,
              socialInstagram: state.socialInstagram,
              socialX: state.socialX,
              socialYoutube: state.socialYoutube,
              socialLinkedIn: state.socialLinkedIn,
              socialPinterest: state.socialPinterest,
              translations: event.translations,
            );
            DioApiResponse response = await _outletRepository.saveOutlet(param);
            if (response.errorType == NetErrorType.none) {
              emit(state.copyWith(status: ManageOutletStatus.submitSuccess));
            } else {
              Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
              ServerErrorModel data = ServerErrorModel.fromJson(myMap);
              emit(state.copyWith(status: ManageOutletStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
            }
          } catch (e, stacktrace) {
            emit(state.copyWith(status: ManageOutletStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
            if (!kIsWeb) {
              FirebaseCrashlytics.instance.recordError(e, stacktrace);
            }
          }
        } else {
          emit(state.copyWith(status: ManageOutletStatus.submit));
          UpdateOutletRequestModel param = UpdateOutletRequestModel(
            name: name.value.toString(),
            shortDescription: shortDescription.value.toString(),
            address: address.value.toString(),
            cuisine: cuisine.value.toString(),
            logo: logo.value.toString(),
            cover: cover.value.toString(),
            city: state.selectedCity.id!.isNotEmpty ? state.selectedCity.id! : '',
            locality: state.selectedLocality.id!.isNotEmpty ? state.selectedLocality.id! : '',
            latitude: latitude.value.toString(),
            longitude: longitude.value.toString(),
            approxDeliveryTime: deliveryTime.value.toString(),
            dishPriceForTwo: dishForTwo.value.toString(),
            takeAway: state.takeAway.value,
            restaurantType: type.value.toString(),
            restaurantFacility: facility.value.toString(),
            acceptScheduleDelivery: state.scheduleOrder.value,
            acceptHomeDelivery: state.homeDelivery.value,
            minOrderAmount: minOrderAmount.value.toString(),
            license: state.selectedLicense.id!.isNotEmpty ? state.selectedLicense.id! : '',
            licenseId: license.value.toString(),
            socialFacebook: state.socialFacebook,
            socialInstagram: state.socialInstagram,
            socialX: state.socialX,
            socialYoutube: state.socialYoutube,
            socialLinkedIn: state.socialLinkedIn,
            socialPinterest: state.socialPinterest,
            translations: event.translations,
          );
          DioApiResponse response = await _outletRepository.updateOutletInfo(state.outletId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageOutletStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageOutletStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ManageOutletStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onManageOutletSocialLinkChangeEvent(ManageOutletSocialLinkChangeEvent event, Emitter<ManageOutletState> emit) async {
    if (event.type == 'facebook') {
      emit(state.copyWith(socialFacebook: event.value, status: ManageOutletStatus.initial));
    } else if (event.type == 'instagram') {
      emit(state.copyWith(socialInstagram: event.value, status: ManageOutletStatus.initial));
    } else if (event.type == 'x') {
      emit(state.copyWith(socialX: event.value, status: ManageOutletStatus.initial));
    } else if (event.type == 'youtube') {
      emit(state.copyWith(socialYoutube: event.value, status: ManageOutletStatus.initial));
    } else if (event.type == 'linkedin') {
      emit(state.copyWith(socialLinkedIn: event.value, status: ManageOutletStatus.initial));
    } else if (event.type == 'pinterest') {
      emit(state.copyWith(socialPinterest: event.value, status: ManageOutletStatus.initial));
    }
  }
}
