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
import 'package:vendor/app/core/models/localities_by_city_model.dart';
import 'package:vendor/app/core/models/modal_navigation_back_response_model.dart';
import 'package:vendor/app/core/models/register_request_basic_detail_model.dart';
import 'package:vendor/app/core/models/register_request_response_model.dart';
import 'package:vendor/app/core/models/request/check_register_request_model.dart';
import 'package:vendor/app/core/models/request/restaurant_joining_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/register_request_form_translation.dart';
import 'package:vendor/app/core/models/upload_image_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/auth_repository.dart';
import 'package:vendor/app/core/validations/register_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'register_request_event.dart';
part 'register_request_state.dart';

class RegisterRequestBloc extends Bloc<RegisterRequestEvent, RegisterRequestState> {
  final AuthRepository _authRepository = AuthRepository();
  final AccountRepository _accountRepository = AccountRepository();
  RegisterRequestBloc()
    : super(
        RegisterRequestState(
          model: RegisterRequestBasicDetailModel(cities: [], licenses: [], subscriptionPackages: [], success: false, locale: ''),
          homeDelivery: HomeDeliverySupportModel(label: '', value: false),
          takeAway: TakeAwaySupportModel(label: '', value: false),
          scheduleOrder: ScheduleOrderSupportModel(label: '', value: false),
          selectedCity: RegisterRequestCitiesModel(locale: ''),
          selectedLicense: RegisterRequestLicenseModel(locale: ''),
          selectedLocality: LocalitiesFromCityModel(locale: ''),
        ),
      ) {
    on<RegisterRequestInitialEvent>(_onRegisterRequestInitialEvent);
    on<RegisterRequestNameChangedEvent>(_onRegisterRequestNameChangedEvent);
    on<RegisterRequestNameUnfocusedEvent>(_onRegisterRequestNameUnfocusedEvent);
    on<RegisterRequestShortDescriptionChangedEvent>(_onRegisterRequestShortDescriptionChangedEvent);
    on<RegisterRequestShortDescriptionUnfocusedEvent>(_onRegisterRequestShortDescriptionUnfocusedEvent);
    on<RegisterRequestAddressChangedEvent>(_onRegisterRequestAddressChangedEvent);
    on<RegisterRequestAddressUnfocusedEvent>(_onRegisterRequestAddressUnfocusedEvent);
    on<RegisterRequestMinOrderAmountChangedEvent>(_onRegisterRequestMinOrderAmountChangedEvent);
    on<RegisterRequestMinOrderAmountUnfocusedEvent>(_onRegisterRequestMinOrderAmountUnfocusedEvent);
    on<RegisterRequestDishForTwoChangedEvent>(_onRegisterRequestDishForTwoChangedEvent);
    on<RegisterRequestDishForTwoUnfocusedEvent>(_onRegisterRequestDishForTwoUnfocusedEvent);
    on<RegisterRequestFoodLicenseChangedEvent>(_onRegisterRequestFoodLicenseChangedEvent);
    on<RegisterRequestFoodLicenseUnfocusedEvent>(_onRegisterRequestFoodLicenseUnfocusedEvent);
    on<RegisterRequestEmailChangedEvent>(_onRegisterRequestEmailChangedEvent);
    on<RegisterRequestEmailUnfocusedEvent>(_onRegisterRequestEmailUnfocusedEvent);
    on<RegisterRequestPasswordChangedEvent>(_onRegisterRequestPasswordChangedEvent);
    on<RegisterRequestPasswordUnfocusedEvent>(_onRegisterRequestPasswordUnfocusedEvent);
    on<RegisterRequestFirstNameChangedEvent>(_onRegisterRequestFirstNameChangedEvent);
    on<RegisterRequestFirstNameUnfocusedEvent>(_onRegisterRequestFirstNameUnfocusedEvent);
    on<RegisterRequestLastNameChangedEvent>(_onRegisterRequestLastNameChangedEvent);
    on<RegisterRequestLastNameUnfocusedEvent>(_onRegisterRequestLastNameUnfocusedEvent);
    on<RegisterRequestCountryCodeChangedEvent>(_onRegisterRequestCountryCodeChangedEvent);
    on<RegisterRequestCountryCodeUnfocusedEvent>(_onRegisterRequestCountryCodeUnfocusedEvent);
    on<RegisterRequestMobileNumberChangedEvent>(_onRegisterRequestMobileNumberChangedEvent);
    on<RegisterRequestMobileNumberUnfocusedEvent>(_onRegisterRequestMobileNumberUnfocusedEvent);
    on<RegisterRequestHomeDeliveryChangeEvent>(_onRegisterRequestHomeDeliveryChangeEvent);
    on<RegisterRequestTakeAwayChangeEvent>(_onRegisterRequestTakeAwayChangeEvent);
    on<RegisterRequestScheduleOrderChangeEvent>(_onRegisterRequestScheduleOrderChangeEvent);
    on<RegisterRequestCuisineChangeEvent>(_onRegisterRequestCuisineChangeEvent);
    on<RegisterRequestCusineUnfocusedEvent>(_onRegisterRequestCusineUnfocusedEvent);
    on<RegisterRequestTypeChangeEvent>(_onRegisterRequestTypeChangeEvent);
    on<RegisterRequestTypeUnfocusedEvent>(_onRegisterRequestTypeUnfocusedEvent);
    on<RegisterRequestFacilitiesChangeEvent>(_onRegisterRequestFacilitiesChangeEvent);
    on<RegisterRequestFacilityUnfocusedEvent>(_onRegisterRequestFacilityUnfocusedEvent);
    on<RegisterRequestDeliveryTimeChangeEvent>(_onRegisterRequestDeliveryTimeChangeEvent);
    on<RegisterRequestLicenseChangeEvent>(_onRegisterRequestLicenseChangeEvent);
    on<RegisterRequestCityChangeEvent>(_onRegisterRequestCityChangeEvent);
    on<RegisterRequestLocalityChangeEvent>(_onRegisterRequestLocalityChangeEvent);
    on<RegisterRequestLocationChangeEvent>(_onRegisterRequestLocationChangeEvent);
    on<RegisterRequestFormTextInputChangeEvent>(_onRegisterRequestFormTextInputChangeEvent);
    on<RegisterRequestFormCountryCodeChangeEvent>(_onRegisterRequestFormCountryCodeChangeEvent);
    on<RegisterRequestFormCheckboxChangeEvent>(_onRegisterRequestFormCheckboxChangeEvent);
    on<RegisterRequestUploadImageEvent>(_onRegisterRequestUploadImageEvent);
    on<RegisterRequestOnBackPageEvent>(_onRegisterRequestOnBackPageEvent);
    on<RegisterRequestSubmitEvent>(_onRegisterRequestSubmitEvent);
    on<RegisterRequestBusinessModelChangeEvent>(_onRegisterRequestBusinessModelChangeEvent);
    on<RegisterRequestChangeSubscriptionPackageEvent>(_onRegisterRequestChangeSubscriptionPackageEvent);
    on<RegisterRequestBusinessPlanSelectEvent>(_onRegisterRequestBusinessPlanSelectEvent);
    on<RegisterRequestChangePaymentMethodEvent>(_onRegisterRequestChangePaymentMethodEvent);
    on<RegisterRequestSocialLinkChangeEvent>(_onRegisterRequestSocialLinkChangeEvent);
    on<RegisterRequestCreateProfileRequestEvent>(_onRegisterRequestCreateProfileRequestEvent);
  }

  FutureOr<void> _onRegisterRequestInitialEvent(RegisterRequestInitialEvent event, Emitter<RegisterRequestState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "restaurant_register_request"}, 'restaurant_register_request_screen', 'restaurant_register_request_screen');
      emit(state.copyWith(status: RegisterRequestStatus.loading));
      DioApiResponse response = await _authRepository.getRestaurantRegisterRequestBasicDetail();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        RegisterRequestBasicDetailModel data = RegisterRequestBasicDetailModel.fromJson(myMap, locale.toString());
        String defaultCountryCode = '';
        String flag = '';
        await _authRepository.getDefaultCountryCode().then((value) {
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

        List<RegisterRequestCitiesModel> cityList = <RegisterRequestCitiesModel>[];
        cityList.clear();
        for (var element in data.cities!) {
          cityList.add(element);
        }

        if (cityList.isNotEmpty) {
          latitude = cityList.first.location!.coordinates![1].toString();
          longitude = cityList.first.location!.coordinates![0].toString();
        }

        List<RegisterRequestLicenseModel> licenseList = <RegisterRequestLicenseModel>[];
        licenseList.clear();
        for (var element in data.licenses!) {
          licenseList.add(element);
        }

        const deliveryTime = RegisterRequestDeliveryTimeField.dirty('10 to 20 min');
        final countryCode = RegisterRequestCountryCodeField.dirty(defaultCountryCode);
        final latitudeField = RegisterRequestLatitudeField.dirty(latitude);
        final longitudeField = RegisterRequestLongitudeField.dirty(longitude);

        List<FormElementConfigModel> formFieldList = <FormElementConfigModel>[];
        formFieldList.clear();
        if (data.joiningForm!.success! == true && data.joiningForm!.result!.restaurantForm!.isNotEmpty) {
          for (var element in data.joiningForm!.result!.restaurantForm!) {
            List<FormElementItemConfigModel> checkboxItems = <FormElementItemConfigModel>[];
            checkboxItems.clear();
            if (element.type! == 'choose' && element.items!.isNotEmpty) {
              for (var checkboxItemElement in element.items!) {
                FormElementItemConfigModel checkboxFieldParam = FormElementItemConfigModel(name: checkboxItemElement.name, value: false);
                checkboxItems.add(checkboxFieldParam);
              }
            }
            FormElementConfigModel fieldParam = FormElementConfigModel(
              uuid: element.uuid!,
              isRequired: element.isRequired!,
              type: element.type!,
              title: element.title!,
              placeholder: element.placeholder!,
              value: '',
              items: checkboxItems,
              extraValue: element.type! == 'phone' ? defaultCountryCode : '',
            );
            formFieldList.add(fieldParam);
          }
        }

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
            selectedLocality: LocalitiesFromCityModel(id: '', name: '', translations: [], locale: locale.toString()),
            localityList: [],
            selectedLicense: licenseList.first,
            licenseList: licenseList,
            model: data,
            formField: formFieldList,
            businessModel: data.settings!.commissionBasedSystem! == false ? 'subscription' : 'commission',
            status: RegisterRequestStatus.basicFetched,
          ),
        );

        if (cityList.isNotEmpty) {
          add(RegisterRequestCityChangeEvent(city: cityList.first));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RegisterRequestStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RegisterRequestStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRegisterRequestNameChangedEvent(RegisterRequestNameChangedEvent event, Emitter<RegisterRequestState> emit) {
    final name = RegisterRequestNameField.dirty(event.name);
    emit(
      state.copyWith(
        nameField: name.isValid ? name : RegisterRequestNameField.pure(event.name),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestNameUnfocusedEvent(RegisterRequestNameUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final name = RegisterRequestNameField.dirty(state.nameField.value);
    emit(
      state.copyWith(
        nameField: name,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestShortDescriptionChangedEvent(RegisterRequestShortDescriptionChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final shortDescription = RegisterRequestShortDescriptionField.dirty(event.shortDescription);
    emit(
      state.copyWith(
        shortDescriptionField: shortDescription.isValid ? shortDescription : RegisterRequestShortDescriptionField.pure(event.shortDescription),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestShortDescriptionUnfocusedEvent(RegisterRequestShortDescriptionUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final shortDescription = RegisterRequestShortDescriptionField.dirty(state.shortDescriptionField.value);
    emit(
      state.copyWith(
        shortDescriptionField: shortDescription,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestAddressChangedEvent(RegisterRequestAddressChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final address = RegisterRequestAddressField.dirty(event.address);
    emit(
      state.copyWith(
        addressField: address.isValid ? address : RegisterRequestAddressField.pure(event.address),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestAddressUnfocusedEvent(RegisterRequestAddressUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final address = RegisterRequestAddressField.dirty(state.addressField.value);
    emit(
      state.copyWith(
        addressField: address,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestMinOrderAmountChangedEvent(RegisterRequestMinOrderAmountChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final minOrderAmount = RegisterRequestMinOrderAmountField.dirty(event.minOrderAmount);
    emit(
      state.copyWith(
        minOrderAmountField: minOrderAmount.isValid ? minOrderAmount : RegisterRequestMinOrderAmountField.pure(event.minOrderAmount),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestMinOrderAmountUnfocusedEvent(RegisterRequestMinOrderAmountUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final minOrderAmount = RegisterRequestMinOrderAmountField.dirty(state.minOrderAmountField.value);
    emit(
      state.copyWith(
        minOrderAmountField: minOrderAmount,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestDishForTwoChangedEvent(RegisterRequestDishForTwoChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final dishForTwo = RegisterRequestDishPriceForTwoField.dirty(event.dishForTwo);
    emit(
      state.copyWith(
        dishPriceForTwoField: dishForTwo.isValid ? dishForTwo : RegisterRequestDishPriceForTwoField.pure(event.dishForTwo),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestDishForTwoUnfocusedEvent(RegisterRequestDishForTwoUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final dishForTwo = RegisterRequestDishPriceForTwoField.dirty(state.dishPriceForTwoField.value);
    emit(
      state.copyWith(
        dishPriceForTwoField: dishForTwo,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestFoodLicenseChangedEvent(RegisterRequestFoodLicenseChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final license = RegisterRequestFoodLicenseField.dirty(event.license);
    emit(
      state.copyWith(
        licenseField: license.isValid ? license : RegisterRequestFoodLicenseField.pure(event.license),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestFoodLicenseUnfocusedEvent(RegisterRequestFoodLicenseUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final license = RegisterRequestFoodLicenseField.dirty(state.licenseField.value);
    emit(
      state.copyWith(
        licenseField: license,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestEmailChangedEvent(RegisterRequestEmailChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final email = RegisterRequestEmailField.dirty(event.email);
    emit(
      state.copyWith(
        emailField: email.isValid ? email : RegisterRequestEmailField.pure(event.email),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestEmailUnfocusedEvent(RegisterRequestEmailUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final email = RegisterRequestEmailField.dirty(state.emailField.value);
    emit(
      state.copyWith(
        emailField: email,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestPasswordChangedEvent(RegisterRequestPasswordChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final password = RegisterRequestPasswordField.dirty(event.password);
    emit(
      state.copyWith(
        passwordField: password.isValid ? password : RegisterRequestPasswordField.pure(event.password),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestPasswordUnfocusedEvent(RegisterRequestPasswordUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final password = RegisterRequestPasswordField.dirty(state.passwordField.value);
    emit(
      state.copyWith(
        passwordField: password,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestFirstNameChangedEvent(RegisterRequestFirstNameChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final firstName = RegisterRequestFirstNameField.dirty(event.firstName);
    emit(
      state.copyWith(
        firstNameField: firstName.isValid ? firstName : RegisterRequestFirstNameField.pure(event.firstName),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestFirstNameUnfocusedEvent(RegisterRequestFirstNameUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final firstName = RegisterRequestFirstNameField.dirty(state.firstNameField.value);
    emit(
      state.copyWith(
        firstNameField: firstName,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestLastNameChangedEvent(RegisterRequestLastNameChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final lastName = RegisterRequestLastNameField.dirty(event.lastName);
    emit(
      state.copyWith(
        lastNameField: lastName.isValid ? lastName : RegisterRequestLastNameField.pure(event.lastName),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestLastNameUnfocusedEvent(RegisterRequestLastNameUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final lastName = RegisterRequestLastNameField.dirty(state.lastNameField.value);
    emit(
      state.copyWith(
        lastNameField: lastName,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestCountryCodeChangedEvent(RegisterRequestCountryCodeChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final countryCode = RegisterRequestCountryCodeField.dirty(event.countryCode);
    emit(
      state.copyWith(
        countryCodeField: countryCode.isValid ? countryCode : RegisterRequestCountryCodeField.pure(event.countryCode),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestCountryCodeUnfocusedEvent(RegisterRequestCountryCodeUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final countryCode = RegisterRequestCountryCodeField.dirty(state.countryCodeField.value);
    emit(
      state.copyWith(
        countryCodeField: countryCode,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestMobileNumberChangedEvent(RegisterRequestMobileNumberChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final mobileNumber = RegisterRequestMobileNumberField.dirty(event.mobileNumber);
    emit(
      state.copyWith(
        mobileNumberField: mobileNumber.isValid ? mobileNumber : RegisterRequestMobileNumberField.pure(event.mobileNumber),
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestMobileNumberUnfocusedEvent(RegisterRequestMobileNumberUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final mobileNumber = RegisterRequestMobileNumberField.dirty(state.mobileNumberField.value);
    emit(
      state.copyWith(
        mobileNumberField: mobileNumber,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestHomeDeliveryChangeEvent(RegisterRequestHomeDeliveryChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(homeDelivery: event.option, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestTakeAwayChangeEvent(RegisterRequestTakeAwayChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(takeAway: event.option, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestScheduleOrderChangeEvent(RegisterRequestScheduleOrderChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(scheduleOrder: event.option, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestCuisineChangeEvent(RegisterRequestCuisineChangeEvent event, Emitter<RegisterRequestState> emit) async {
    final cuisine = RegisterRequestCuisineField.dirty(event.param.ids!);
    emit(
      state.copyWith(
        cuisineField: cuisine.isValid ? cuisine : RegisterRequestCuisineField.pure(event.param.ids!),
        cuisineIds: event.param.ids!,
        cuisineNames: event.param.names!,
        status: RegisterRequestStatus.changeDetailFromModal,
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

  FutureOr<void> _onRegisterRequestCusineUnfocusedEvent(RegisterRequestCusineUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final cuisineField = RegisterRequestCuisineField.dirty(state.cuisineField.value);
    emit(
      state.copyWith(
        cuisineField: cuisineField,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestTypeChangeEvent(RegisterRequestTypeChangeEvent event, Emitter<RegisterRequestState> emit) async {
    final type = RegisterRequestTypeField.dirty(event.param.ids!);
    emit(
      state.copyWith(
        typeField: type.isValid ? type : RegisterRequestTypeField.pure(event.param.ids!),
        typeIds: event.param.ids!,
        typeName: event.param.names!,
        status: RegisterRequestStatus.changeDetailFromModal,
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

  FutureOr<void> _onRegisterRequestTypeUnfocusedEvent(RegisterRequestTypeUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final typeField = RegisterRequestTypeField.dirty(state.typeField.value);
    emit(
      state.copyWith(
        typeField: typeField,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestFacilitiesChangeEvent(RegisterRequestFacilitiesChangeEvent event, Emitter<RegisterRequestState> emit) async {
    final facilities = RegisterRequestFacilitiesField.dirty(event.param.ids!);
    emit(
      state.copyWith(
        facilitiesField: facilities.isValid ? facilities : RegisterRequestFacilitiesField.pure(event.param.ids!),
        facilitiesIds: event.param.ids!,
        facilitiesName: event.param.names!,
        status: RegisterRequestStatus.changeDetailFromModal,
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

  FutureOr<void> _onRegisterRequestFacilityUnfocusedEvent(RegisterRequestFacilityUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final facilityField = RegisterRequestFacilitiesField.dirty(state.facilitiesField.value);
    emit(
      state.copyWith(
        facilitiesField: facilityField,
        status: RegisterRequestStatus.initial,
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

  FutureOr<void> _onRegisterRequestDeliveryTimeChangeEvent(RegisterRequestDeliveryTimeChangeEvent event, Emitter<RegisterRequestState> emit) async {
    final deliveryTime = RegisterRequestDeliveryTimeField.dirty(event.time);
    emit(
      state.copyWith(
        deliveryTimeField: deliveryTime.isValid ? deliveryTime : RegisterRequestDeliveryTimeField.pure(event.time),
        status: RegisterRequestStatus.changeDetailFromModal,
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

  FutureOr<void> _onRegisterRequestLicenseChangeEvent(RegisterRequestLicenseChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(selectedLicense: event.option, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestCityChangeEvent(RegisterRequestCityChangeEvent event, Emitter<RegisterRequestState> emit) async {
    try {
      emit(state.copyWith(selectedCity: event.city, status: RegisterRequestStatus.localityFetching));
      DioApiResponse response = await _authRepository.localityByCity(event.city.id!);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        final String locale = await _authRepository.getLocale();
        RegisterRequestLocalitiesResponseModel data = RegisterRequestLocalitiesResponseModel.fromJson(myMap, locale.toString());
        if (data.localities!.isNotEmpty) {
          emit(
            state.copyWith(
              latitudeField: RegisterRequestLatitudeField.pure(data.localities!.first.location!.coordinates![1].toString()),
              longitudeField: RegisterRequestLongitudeField.pure(data.localities!.first.location!.coordinates![0].toString()),
              selectedLocality: data.localities!.first,
              localityList: data.localities!,
              status: RegisterRequestStatus.localityFetched,
            ),
          );
        } else {
          final String locale = await _authRepository.getLocale();
          emit(
            state.copyWith(
              latitudeField: RegisterRequestLatitudeField.pure(event.city.location!.coordinates![1].toString()),
              longitudeField: RegisterRequestLongitudeField.pure(event.city.location!.coordinates![0].toString()),
              selectedLocality: LocalitiesFromCityModel(id: '', name: '', translations: [], locale: locale.toString()),
              localityList: [],
              status: RegisterRequestStatus.localityFetched,
            ),
          );
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RegisterRequestStatus.localityFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RegisterRequestStatus.localityFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRegisterRequestLocalityChangeEvent(RegisterRequestLocalityChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(
      state.copyWith(
        selectedLocality: event.locality,
        latitudeField: RegisterRequestLatitudeField.pure(event.locality.location!.coordinates![1].toString()),
        longitudeField: RegisterRequestLongitudeField.pure(event.locality.location!.coordinates![0].toString()),
        status: RegisterRequestStatus.basicFetched,
      ),
    );
  }

  FutureOr<void> _onRegisterRequestLocationChangeEvent(RegisterRequestLocationChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(latitudeField: RegisterRequestLatitudeField.pure(event.latitude.toString()), longitudeField: RegisterRequestLongitudeField.pure(event.longitude.toString()), status: RegisterRequestStatus.locationChange));
  }

  FutureOr<void> _onRegisterRequestFormTextInputChangeEvent(RegisterRequestFormTextInputChangeEvent event, Emitter<RegisterRequestState> emit) async {
    state.formField[event.formIndex].value = event.value;
    emit(state.copyWith(formField: [...state.formField], status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestFormCountryCodeChangeEvent(RegisterRequestFormCountryCodeChangeEvent event, Emitter<RegisterRequestState> emit) async {
    state.formField[event.formIndex].extraValue = event.value;
    emit(state.copyWith(formField: [...state.formField], status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestFormCheckboxChangeEvent(RegisterRequestFormCheckboxChangeEvent event, Emitter<RegisterRequestState> emit) async {
    if (state.formField[event.formIndex].type! == 'choose' && state.formField[event.formIndex].items!.isNotEmpty) {
      state.formField[event.formIndex].items![event.checkboxIndex].value = !state.formField[event.formIndex].items![event.checkboxIndex].value!;
      emit(state.copyWith(formField: [...state.formField], status: RegisterRequestStatus.initial));
    }
  }

  FutureOr<void> _onRegisterRequestUploadImageEvent(RegisterRequestUploadImageEvent event, Emitter<RegisterRequestState> emit) async {
    try {
      emit(state.copyWith(status: RegisterRequestStatus.uploadStarted, uploadingImageTag: event.uploadImageTag, formUploadingImageUUID: event.formUploadingImageUUID));
      DioApiResponse response = await _authRepository.uploadMediaImage(event.newImage, '');
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        UploadImageModel data = UploadImageModel.fromJson(myMap);
        if (event.uploadImageTag == 'logo') {
          final logo = RegisterRequestLogoField.dirty(data.path!);
          emit(
            state.copyWith(
              logoField: logo.isValid ? logo : RegisterRequestLogoField.pure(data.path!),
              status: RegisterRequestStatus.uploadSuccess,
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
        } else if (event.uploadImageTag == 'cover') {
          final cover = RegisterRequestCoverField.dirty(data.path!);
          emit(
            state.copyWith(
              coverField: cover.isValid ? cover : RegisterRequestCoverField.pure(data.path!),
              status: RegisterRequestStatus.uploadSuccess,
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
        } else if (event.uploadImageTag == 'form') {
          state.formField[event.formIndex].value = data.path!;
          emit(state.copyWith(formField: [...state.formField], status: RegisterRequestStatus.uploadSuccess));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RegisterRequestStatus.uploadFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RegisterRequestStatus.uploadFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRegisterRequestOnBackPageEvent(RegisterRequestOnBackPageEvent event, Emitter<RegisterRequestState> emit) async {
    final int newPageIndex = state.currentPageIndex - 1;
    emit(state.copyWith(currentPageIndex: newPageIndex, status: RegisterRequestStatus.backPage));
  }

  FutureOr<void> _onRegisterRequestSubmitEvent(RegisterRequestSubmitEvent event, Emitter<RegisterRequestState> emit) async {
    try {
      emit(state.copyWith(isFormSubmitted: true));
      final int indexOfRequiredField = state.formField.indexWhere((element) => element.isRequired! == true && element.value == '' && element.type! != 'choose');
      final name = RegisterRequestNameField.dirty(state.nameField.value);
      final shortDescription = RegisterRequestShortDescriptionField.dirty(state.shortDescriptionField.value);
      final address = RegisterRequestAddressField.dirty(state.addressField.value);
      final cuisine = RegisterRequestCuisineField.dirty(state.cuisineField.value);
      final type = RegisterRequestTypeField.dirty(state.typeField.value);
      final facility = RegisterRequestFacilitiesField.dirty(state.facilitiesField.value);
      final minOrderAmount = RegisterRequestMinOrderAmountField.dirty(state.minOrderAmountField.value);
      final dishForTwo = RegisterRequestDishPriceForTwoField.dirty(state.dishPriceForTwoField.value);
      final license = RegisterRequestFoodLicenseField.dirty(state.licenseField.value);
      final deliveryTime = RegisterRequestDeliveryTimeField.dirty(state.deliveryTimeField.value);
      final email = RegisterRequestEmailField.dirty(state.emailField.value);
      final password = RegisterRequestPasswordField.dirty(state.passwordField.value);
      final firstName = RegisterRequestFirstNameField.dirty(state.firstNameField.value);
      final lastName = RegisterRequestLastNameField.dirty(state.lastNameField.value);
      final countryCode = RegisterRequestCountryCodeField.dirty(state.countryCodeField.value);
      final mobileNumber = RegisterRequestMobileNumberField.dirty(state.mobileNumberField.value);
      final latitude = RegisterRequestLatitudeField.dirty(state.latitudeField.value);
      final longitude = RegisterRequestLongitudeField.dirty(state.longitudeField.value);
      final cover = RegisterRequestCoverField.dirty(state.coverField.value);
      final logo = RegisterRequestLogoField.dirty(state.logoField.value);
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
          status: RegisterRequestStatus.initial,
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
          state.logoField.value.isNotEmpty &&
          indexOfRequiredField == -1) {
        emit(state.copyWith(status: RegisterRequestStatus.submit));
        CheckRegisterStatusRequestModel param = CheckRegisterStatusRequestModel(email: state.emailField.value.toString(), countryCode: state.countryCodeField.value.toString(), mobile: state.mobileNumberField.value.toString());
        DioApiResponse response = await _authRepository.checkRegisterStatus(param);
        if (response.errorType == NetErrorType.none) {
          emit(state.copyWith(status: RegisterRequestStatus.submitSuccess, translations: event.translations, currentPageIndex: 1));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: RegisterRequestStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } else {
        emit(state.copyWith(status: RegisterRequestStatus.customError, statusCode: 0, alertMessage: 'Please fill all the required inputs', extraMessage: ''));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RegisterRequestStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRegisterRequestBusinessModelChangeEvent(RegisterRequestBusinessModelChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(businessModel: event.businessModel, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestChangeSubscriptionPackageEvent(RegisterRequestChangeSubscriptionPackageEvent event, Emitter<RegisterRequestState> emit) async {
    final int indexOfSubscriptionId = state.model.subscriptionPackages!.indexWhere((x) => x.id! == event.subscriptionPackage);
    bool haveTrial = false;
    double payAmount = 0.0;
    int trialPeriod = 0;
    if (indexOfSubscriptionId != -1) {
      haveTrial = state.model.subscriptionPackages![indexOfSubscriptionId].haveTrial!;
      trialPeriod = state.model.subscriptionPackages![indexOfSubscriptionId].trialValidity!;
      if (state.model.subscriptionPackages![indexOfSubscriptionId].discount! > 0) {
        payAmount = state.model.subscriptionPackages![indexOfSubscriptionId].offerPrice!;
      } else {
        payAmount = state.model.subscriptionPackages![indexOfSubscriptionId].price!;
      }
    }
    String paymentId = 'trial';
    if (haveTrial == false && state.model.payment!.primary != null && state.model.payment!.primary!.id!.isNotEmpty) {
      paymentId = state.model.payment!.primary!.id!;
    } else if (haveTrial == false && state.model.payment!.payments!.isNotEmpty) {
      paymentId = state.model.payment!.payments![0].id!;
    }
    emit(state.copyWith(selectedPackage: event.subscriptionPackage, haveTrial: haveTrial, paymentId: paymentId, payAmount: payAmount, trialPeriod: trialPeriod, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestBusinessPlanSelectEvent(RegisterRequestBusinessPlanSelectEvent event, Emitter<RegisterRequestState> emit) async {
    if (state.businessModel == 'subscription') {
      if (state.selectedPackage.isNotEmpty) {
        emit(state.copyWith(status: RegisterRequestStatus.submitSuccess, currentPageIndex: 2));
      } else {
        emit(state.copyWith(statusCode: 0, alertMessage: 'Please select package', extraMessage: '', status: RegisterRequestStatus.customError));
      }
    } else {
      add(RegisterRequestCreateProfileRequestEvent());
    }
  }

  FutureOr<void> _onRegisterRequestChangePaymentMethodEvent(RegisterRequestChangePaymentMethodEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(paymentId: event.paymentId, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestSocialLinkChangeEvent(RegisterRequestSocialLinkChangeEvent event, Emitter<RegisterRequestState> emit) async {
    if (event.type == 'facebook') {
      emit(state.copyWith(socialFacebook: event.value, status: RegisterRequestStatus.initial));
    } else if (event.type == 'instagram') {
      emit(state.copyWith(socialInstagram: event.value, status: RegisterRequestStatus.initial));
    } else if (event.type == 'x') {
      emit(state.copyWith(socialX: event.value, status: RegisterRequestStatus.initial));
    } else if (event.type == 'youtube') {
      emit(state.copyWith(socialYoutube: event.value, status: RegisterRequestStatus.initial));
    } else if (event.type == 'linkedin') {
      emit(state.copyWith(socialLinkedIn: event.value, status: RegisterRequestStatus.initial));
    } else if (event.type == 'pinterest') {
      emit(state.copyWith(socialPinterest: event.value, status: RegisterRequestStatus.initial));
    }
  }

  FutureOr<void> _onRegisterRequestCreateProfileRequestEvent(RegisterRequestCreateProfileRequestEvent event, Emitter<RegisterRequestState> emit) async {
    try {
      List<RestaurantJoiningFormElementModel> filledFormElement = <RestaurantJoiningFormElementModel>[];
      for (var item in state.formField) {
        List<RestaurantJoiningFormElementOptionModel> fieldItemElement = <RestaurantJoiningFormElementOptionModel>[];
        fieldItemElement.clear();
        if (item.type! == 'choose') {
          item.value = item.title!;
          for (var subItem in item.items!) {
            RestaurantJoiningFormElementOptionModel formElementOptionModel = RestaurantJoiningFormElementOptionModel(name: subItem.name!, value: subItem.value!);
            fieldItemElement.add(formElementOptionModel);
          }
        }
        RestaurantJoiningFormElementModel formElementModel = RestaurantJoiningFormElementModel(
          fieldName: item.title!,
          fieldType: item.type!,
          fieldValue: item.type == 'phone' ? '${item.extraValue} ${item.value!}' : item.value!,
          fieldItems: fieldItemElement,
        );
        filledFormElement.add(formElementModel);
      }
      final String appLocale = await _authRepository.getLocale();
      RestaurantJoiningRequestModel param = RestaurantJoiningRequestModel(
        email: state.emailField.value.toString(),
        password: state.passwordField.value.toString(),
        firstName: state.firstNameField.value.toString(),
        lastName: state.lastNameField.value.toString(),
        countryCode: state.countryCodeField.value.toString(),
        mobile: state.mobileNumberField.value.toString(),
        name: state.nameField.value.toString(),
        address: state.addressField.value.toString(),
        shortDescription: state.shortDescriptionField.value.toString(),
        cuisine: state.cuisineField.value.toString(),
        logo: state.logoField.value.toString(),
        cover: state.coverField.value.toString(),
        city: state.selectedCity.id!.isNotEmpty ? state.selectedCity.id! : '',
        locality: state.selectedLocality.id!.isNotEmpty ? state.selectedLocality.id! : '',
        latitude: state.latitudeField.value.toString(),
        longitude: state.longitudeField.value.toString(),
        locationType: 'Point',
        approxDeliveryTime: state.deliveryTimeField.value.toString(),
        dishPriceForTwo: state.dishPriceForTwoField.value.toString(),
        takeAway: state.takeAway.value,
        restaurantType: state.typeField.value.toString(),
        restaurantFacility: state.facilitiesField.value.toString(),
        acceptScheduleDelivery: state.scheduleOrder.value,
        acceptHomeDelivery: state.homeDelivery.value,
        minOrderAmount: state.minOrderAmountField.value.toString(),
        license: state.selectedLicense.id!.isNotEmpty ? state.selectedLicense.id! : '',
        licenseId: state.licenseField.value.toString(),
        businessType: state.businessModel,
        subscriptionId: state.selectedPackage,
        translations: state.translations,
        paymentId: state.paymentId,
        formElement: filledFormElement,
        locale: appLocale,
        socialFacebook: state.socialFacebook,
        socialInstagram: state.socialInstagram,
        socialX: state.socialX,
        socialYoutube: state.socialYoutube,
        socialLinkedIn: state.socialLinkedIn,
        socialPinterest: state.socialPinterest,
      );
      emit(state.copyWith(status: RegisterRequestStatus.payment));
      DioApiResponse response = await _authRepository.registerRequest(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        RegisterRequestResponseModel registerResponse = RegisterRequestResponseModel.fromJson(myMap);
        if (registerResponse.status == 'offline') {
          emit(state.copyWith(status: RegisterRequestStatus.paymentSuccess));
        } else {
          emit(state.copyWith(status: RegisterRequestStatus.makePayment, paymentURL: registerResponse.payLink));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RegisterRequestStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RegisterRequestStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
