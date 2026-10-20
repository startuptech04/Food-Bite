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
import 'package:driver/app/core/models/driver_settings_model.dart';
import 'package:driver/app/core/models/localities_by_city_model.dart';
import 'package:driver/app/core/models/register_request_basic_detail_model.dart';
import 'package:driver/app/core/models/request/deliveryman_joining_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/models/upload_image_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/validations/register_form.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'register_request_event.dart';
part 'register_request_state.dart';

class RegisterRequestBloc extends Bloc<RegisterRequestEvent, RegisterRequestState> {
  final AuthRepository _authRepository = AuthRepository();
  RegisterRequestBloc()
    : super(
        RegisterRequestState(
          model: RegisterRequestBasicDetailModel(cities: [], vehicles: [], success: false, locale: ''),
          selectedCity: RegisterRequestCitiesModel(locale: ''),
          selectedLocality: LocalitiesFromCityModel(locale: ''),
          selectedVehicle: RegisterRequestVehicleModel(locale: ''),
          identityType: RegisterRequestIdentityTypeModel(label: '', value: ''),
          jobType: RegisterRequestJobTypeModel(label: '', value: ''),
        ),
      ) {
    on<RegisterRequestInitialEvent>(_onRegisterRequestInitialEvent);
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
    on<RegisterRequestAgeChangedEvent>(_onRegisterRequestAgeChangedEvent);
    on<RegisterRequestAgeUnfocusedEvent>(_onRegisterRequestAgeUnfocusedEvent);
    on<RegisterRequestDOBChangedEvent>(_onRegisterRequestDOBChangedEvent);
    on<RegisterRequestDOBUnfocusedEvent>(_onRegisterRequestDOBUnfocusedEvent);
    on<RegisterRequestIdentityNumberChangedEvent>(_onRegisterRequestIdentityNumberChangedEvent);
    on<RegisterRequestIdentityNumberUnfocusedEvent>(_onRegisterRequestIdentityNumberUnfocusedEvent);
    on<RegisterRequestJobTypeChangeEvent>(_onRegisterRequestJobTypeChangeEvent);
    on<RegisterRequestIdentityTypeChangeEvent>(_onRegisterRequestIdentityTypeChangeEvent);
    on<RegisterRequestCityChangeEvent>(_onRegisterRequestCityChangeEvent);
    on<RegisterRequestLocalityChangeEvent>(_onRegisterRequestLocalityChangeEvent);
    on<RegisterRequestVehicleChangeEvent>(_onRegisterRequestVehicleChangeEvent);
    on<RegisterRequestUploadImageEvent>(_onRegisterRequestUploadImageEvent);
    on<RegisterRequestFormTextInputChangeEvent>(_onRegisterRequestFormTextInputChangeEvent);
    on<RegisterRequestFormCountryCodeChangeEvent>(_onRegisterRequestFormCountryCodeChangeEvent);
    on<RegisterRequestFormCheckboxChangeEvent>(_onRegisterRequestFormCheckboxChangeEvent);
    on<RegisterRequestSubmitEvent>(_onRegisterRequestSubmitEvent);
  }

  FutureOr<void> _onRegisterRequestInitialEvent(RegisterRequestInitialEvent event, Emitter<RegisterRequestState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "deliveryman_register_request"}, 'deliveryman_register_request_screen', 'deliveryman_register_request_screen');
      emit(state.copyWith(status: RegisterRequestStatus.loading));
      DioApiResponse response = await _authRepository.getBasicRegisterRequestDetail();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
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

        List<RegisterRequestCitiesModel> cityList = <RegisterRequestCitiesModel>[];
        cityList.clear();
        for (var element in data.cities!) {
          cityList.add(element);
        }

        if (cityList.isNotEmpty) {
          latitude = cityList.first.location!.coordinates![1].toString();
          longitude = cityList.first.location!.coordinates![0].toString();
        }

        List<RegisterRequestVehicleModel> vehicleList = <RegisterRequestVehicleModel>[];
        vehicleList.clear();
        for (var element in data.vehicles!) {
          vehicleList.add(element);
        }

        List<FormElementConfigModel> formFieldList = <FormElementConfigModel>[];
        formFieldList.clear();
        if (data.joiningForm!.success! == true && data.joiningForm!.result!.deliverymanForm!.isNotEmpty) {
          for (var element in data.joiningForm!.result!.deliverymanForm!) {
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

        RegisterRequestIdentityTypeModel passportIdentity = RegisterRequestIdentityTypeModel(label: 'dd_passport', value: 'passport');
        RegisterRequestIdentityTypeModel licenseIdentity = RegisterRequestIdentityTypeModel(label: 'dd_driving_license', value: 'license');
        RegisterRequestIdentityTypeModel nicIdentity = RegisterRequestIdentityTypeModel(label: 'dd_nic', value: 'nic');
        List<RegisterRequestIdentityTypeModel> identityTypeListOptions = <RegisterRequestIdentityTypeModel>[];
        identityTypeListOptions.clear();
        identityTypeListOptions.add(passportIdentity);
        identityTypeListOptions.add(licenseIdentity);
        identityTypeListOptions.add(nicIdentity);

        RegisterRequestJobTypeModel freelanceJobType = RegisterRequestJobTypeModel(label: 'dd_freelancer', value: 'freelancer');
        RegisterRequestJobTypeModel salaryJobType = RegisterRequestJobTypeModel(label: 'dd_salary', value: 'salary');
        List<RegisterRequestJobTypeModel> jobTypeListOptions = <RegisterRequestJobTypeModel>[];
        jobTypeListOptions.clear();
        jobTypeListOptions.add(freelanceJobType);
        jobTypeListOptions.add(salaryJobType);

        final countryCode = RegisterRequestCountryCodeField.dirty(defaultCountryCode);
        final latitudeField = RegisterRequestLatitudeField.dirty(latitude);
        final longitudeField = RegisterRequestLongitudeField.dirty(longitude);

        emit(
          state.copyWith(
            model: data,
            countryCodeField: countryCode,
            flag: flag,
            selectedCity: cityList.first,
            cityList: cityList,
            selectedLocality: LocalitiesFromCityModel(id: '', name: '', translations: [], locale: locale.toString()),
            localityList: [],
            latitudeField: latitudeField,
            longitudeField: longitudeField,
            formField: formFieldList,
            identityType: identityTypeListOptions.first,
            identityTypeList: identityTypeListOptions,
            selectedVehicle: vehicleList.first,
            vehicleList: vehicleList,
            jobType: jobTypeListOptions.first,
            jobTypeList: jobTypeListOptions,
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

  FutureOr<void> _onRegisterRequestEmailChangedEvent(RegisterRequestEmailChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final email = RegisterRequestEmailField.dirty(event.email);
    emit(
      state.copyWith(
        emailField: email.isValid ? email : RegisterRequestEmailField.pure(event.email),
        status: RegisterRequestStatus.initial,
        isValid: Formz.validate([
          email,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.passwordField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.passwordField,
          state.lastNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.countryCodeField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.mobileNumberField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
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
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.ageField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
        ]),
      ),
    );
  }

  FutureOr<void> _onRegisterRequestAgeChangedEvent(RegisterRequestAgeChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final age = RegisterRequestAgeField.dirty(event.age);
    emit(
      state.copyWith(
        ageField: age.isValid ? age : RegisterRequestAgeField.pure(event.age),
        status: RegisterRequestStatus.initial,
        isValid: Formz.validate([
          age,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.mobileNumberField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
        ]),
      ),
    );
  }

  FutureOr<void> _onRegisterRequestAgeUnfocusedEvent(RegisterRequestAgeUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final age = RegisterRequestAgeField.dirty(state.ageField.value);
    emit(
      state.copyWith(
        ageField: age,
        status: RegisterRequestStatus.initial,
        isValid: Formz.validate([
          age,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.mobileNumberField,
          state.dobField,
          state.latitudeField,
          state.longitudeField,
        ]),
      ),
    );
  }

  FutureOr<void> _onRegisterRequestDOBChangedEvent(RegisterRequestDOBChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final dob = RegisterRequestDOBField.dirty(event.dob);
    emit(
      state.copyWith(
        dobField: dob.isValid ? dob : RegisterRequestDOBField.pure(event.dob),
        status: RegisterRequestStatus.initial,
        isValid: Formz.validate([
          dob,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.mobileNumberField,
          state.ageField,
          state.latitudeField,
          state.longitudeField,
        ]),
      ),
    );
  }

  FutureOr<void> _onRegisterRequestDOBUnfocusedEvent(RegisterRequestDOBUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final dob = RegisterRequestDOBField.dirty(state.dobField.value);
    emit(
      state.copyWith(
        dobField: dob,
        status: RegisterRequestStatus.initial,
        isValid: Formz.validate([
          dob,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.coverImageField,
          state.drivingLicenseField,
          state.identityNumberField,
          state.indentityProofField,
          state.mobileNumberField,
          state.ageField,
          state.latitudeField,
          state.longitudeField,
        ]),
      ),
    );
  }

  FutureOr<void> _onRegisterRequestIdentityNumberChangedEvent(RegisterRequestIdentityNumberChangedEvent event, Emitter<RegisterRequestState> emit) async {
    final identity = RegisterRequestIdentityNumberField.dirty(event.identity);
    emit(
      state.copyWith(
        identityNumberField: identity.isValid ? identity : RegisterRequestIdentityNumberField.pure(event.identity),
        status: RegisterRequestStatus.initial,
        isValid: Formz.validate([
          identity,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.coverImageField,
          state.drivingLicenseField,
          state.dobField,
          state.indentityProofField,
          state.mobileNumberField,
          state.ageField,
          state.latitudeField,
          state.longitudeField,
        ]),
      ),
    );
  }

  FutureOr<void> _onRegisterRequestIdentityNumberUnfocusedEvent(RegisterRequestIdentityNumberUnfocusedEvent event, Emitter<RegisterRequestState> emit) async {
    final identity = RegisterRequestIdentityNumberField.dirty(state.identityNumberField.value);
    emit(
      state.copyWith(
        identityNumberField: identity,
        status: RegisterRequestStatus.initial,
        isValid: Formz.validate([
          identity,
          state.emailField,
          state.passwordField,
          state.firstNameField,
          state.lastNameField,
          state.countryCodeField,
          state.coverImageField,
          state.drivingLicenseField,
          state.dobField,
          state.indentityProofField,
          state.mobileNumberField,
          state.ageField,
          state.latitudeField,
          state.longitudeField,
        ]),
      ),
    );
  }

  FutureOr<void> _onRegisterRequestJobTypeChangeEvent(RegisterRequestJobTypeChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(jobType: event.jobType, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestIdentityTypeChangeEvent(RegisterRequestIdentityTypeChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(identityType: event.identity, status: RegisterRequestStatus.initial));
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

  FutureOr<void> _onRegisterRequestVehicleChangeEvent(RegisterRequestVehicleChangeEvent event, Emitter<RegisterRequestState> emit) async {
    emit(state.copyWith(selectedVehicle: event.vehicle, status: RegisterRequestStatus.initial));
  }

  FutureOr<void> _onRegisterRequestUploadImageEvent(RegisterRequestUploadImageEvent event, Emitter<RegisterRequestState> emit) async {
    try {
      emit(state.copyWith(status: RegisterRequestStatus.uploadStarted, uploadingImageTag: event.uploadImageTag, formUploadingImageUUID: event.formUploadingImageUUID));
      DioApiResponse response = await _authRepository.uploadMediaImagePublic(event.newImage, '');
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        UploadImageModel data = UploadImageModel.fromJson(myMap);
        if (event.uploadImageTag == 'cover') {
          final cover = RegisterRequestCoverField.dirty(data.path!);
          emit(
            state.copyWith(
              coverImageField: cover.isValid ? cover : RegisterRequestCoverField.pure(data.path!),
              status: RegisterRequestStatus.uploadSuccess,
              isValid: Formz.validate([
                cover,
                state.emailField,
                state.passwordField,
                state.firstNameField,
                state.lastNameField,
                state.countryCodeField,
                state.identityNumberField,
                state.drivingLicenseField,
                state.dobField,
                state.indentityProofField,
                state.mobileNumberField,
                state.ageField,
              ]),
            ),
          );
        } else if (event.uploadImageTag == 'identityProof') {
          final identityProof = RegisterRequestIndentityProofField.dirty(data.path!);
          emit(
            state.copyWith(
              indentityProofField: identityProof.isValid ? identityProof : RegisterRequestIndentityProofField.pure(data.path!),
              status: RegisterRequestStatus.uploadSuccess,
              isValid: Formz.validate([
                identityProof,
                state.emailField,
                state.passwordField,
                state.firstNameField,
                state.lastNameField,
                state.countryCodeField,
                state.identityNumberField,
                state.drivingLicenseField,
                state.dobField,
                state.coverImageField,
                state.mobileNumberField,
                state.ageField,
              ]),
            ),
          );
        } else if (event.uploadImageTag == 'license') {
          final drivingLicense = RegisterRequestDrivingLicenseField.dirty(data.path!);
          emit(
            state.copyWith(
              drivingLicenseField: drivingLicense.isValid ? drivingLicense : RegisterRequestDrivingLicenseField.pure(data.path!),
              status: RegisterRequestStatus.uploadSuccess,
              isValid: Formz.validate([
                drivingLicense,
                state.emailField,
                state.passwordField,
                state.firstNameField,
                state.lastNameField,
                state.countryCodeField,
                state.identityNumberField,
                state.indentityProofField,
                state.dobField,
                state.coverImageField,
                state.mobileNumberField,
                state.ageField,
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

  FutureOr<void> _onRegisterRequestSubmitEvent(RegisterRequestSubmitEvent event, Emitter<RegisterRequestState> emit) async {
    try {
      emit(state.copyWith(isFormSubmitted: true));
      final int indexOfRequiredField = state.formField.indexWhere((element) => element.isRequired! == true && element.value == '' && element.type! != 'choose');
      final email = RegisterRequestEmailField.dirty(state.emailField.value);
      final password = RegisterRequestPasswordField.dirty(state.passwordField.value);
      final firstName = RegisterRequestFirstNameField.dirty(state.firstNameField.value);
      final lastName = RegisterRequestLastNameField.dirty(state.lastNameField.value);
      final countryCode = RegisterRequestCountryCodeField.dirty(state.countryCodeField.value);
      final mobileNumber = RegisterRequestMobileNumberField.dirty(state.mobileNumberField.value);
      final cover = RegisterRequestCoverField.dirty(state.coverImageField.value);
      final identityProof = RegisterRequestIndentityProofField.dirty(state.indentityProofField.value);
      final age = RegisterRequestAgeField.dirty(state.ageField.value);
      final dob = RegisterRequestDOBField.dirty(state.dobField.value);
      final identityNumber = RegisterRequestIdentityNumberField.dirty(state.identityNumberField.value);
      final drivingLicense = RegisterRequestDrivingLicenseField.dirty(state.drivingLicenseField.value);
      final latitude = RegisterRequestLatitudeField.dirty(state.latitudeField.value);
      final longitude = RegisterRequestLongitudeField.dirty(state.longitudeField.value);
      emit(
        state.copyWith(
          emailField: email,
          passwordField: password,
          firstNameField: firstName,
          lastNameField: lastName,
          countryCodeField: countryCode,
          mobileNumberField: mobileNumber,
          coverImageField: cover,
          indentityProofField: identityProof,
          ageField: age,
          dobField: dob,
          identityNumberField: identityNumber,
          drivingLicenseField: drivingLicense,
          latitudeField: latitude,
          longitudeField: longitude,
          status: RegisterRequestStatus.initial,
          isValid: Formz.validate([email, password, firstName, lastName, countryCode, mobileNumber, cover, identityProof, age, dob, identityNumber, drivingLicense, latitude, longitude]),
        ),
      );
      if (state.isValid &&
          state.emailField.value.isNotEmpty &&
          state.passwordField.value.isNotEmpty &&
          state.firstNameField.value.isNotEmpty &&
          state.lastNameField.value.isNotEmpty &&
          state.countryCodeField.value.isNotEmpty &&
          state.mobileNumberField.value.isNotEmpty &&
          state.coverImageField.value.isNotEmpty &&
          state.indentityProofField.value.isNotEmpty &&
          state.ageField.value.isNotEmpty &&
          state.dobField.value.isNotEmpty &&
          state.identityNumberField.value.isNotEmpty &&
          state.drivingLicenseField.value.isNotEmpty &&
          state.latitudeField.value.isNotEmpty &&
          state.longitudeField.value.isNotEmpty &&
          indexOfRequiredField == -1) {
        List<DeliverymanJoiningFormElementModel> filledFormElement = <DeliverymanJoiningFormElementModel>[];
        for (var item in state.formField) {
          List<DeliverymanJoiningFormElementOptionModel> fieldItemElement = <DeliverymanJoiningFormElementOptionModel>[];
          fieldItemElement.clear();
          if (item.type! == 'choose') {
            item.value = item.title!;
            for (var subItem in item.items!) {
              DeliverymanJoiningFormElementOptionModel formElementOptionModel = DeliverymanJoiningFormElementOptionModel(name: subItem.name!, value: subItem.value!);
              fieldItemElement.add(formElementOptionModel);
            }
          }
          DeliverymanJoiningFormElementModel formElementModel = DeliverymanJoiningFormElementModel(
            fieldName: item.title!,
            fieldType: item.type!,
            fieldValue: item.type == 'phone' ? '${item.extraValue} ${item.value!}' : item.value!,
            fieldItems: fieldItemElement,
          );
          filledFormElement.add(formElementModel);
        }
        final String appLocale = await _authRepository.getLocale();
        DeliverymanJoiningRequestModel param = DeliverymanJoiningRequestModel(
          email: state.emailField.value.toString(),
          password: state.passwordField.value.toString(),
          firstName: state.firstNameField.value.toString(),
          lastName: state.lastNameField.value.toString(),
          countryCode: state.countryCodeField.value.toString(),
          mobile: state.mobileNumberField.value.toString(),
          city: state.selectedCity.id!.isNotEmpty ? state.selectedCity.id! : '',
          locality: state.selectedLocality.id!.isNotEmpty ? state.selectedLocality.id! : '',
          latitude: state.latitudeField.value.toString(),
          longitude: state.longitudeField.value.toString(),
          vehicle: state.selectedVehicle.id!.isNotEmpty ? state.selectedVehicle.id! : '',
          cover: state.coverImageField.value.toString(),
          age: state.ageField.value.toString(),
          dob: state.dobField.value.toString(),
          type: state.jobType.value.toString(),
          identity: state.identityType.value.toString(),
          identityNumber: state.identityNumberField.value.toString(),
          identityProof: state.indentityProofField.value.toString(),
          drivingLicense: state.drivingLicenseField.value.toString(),
          locationType: 'Point',
          formElement: filledFormElement,
          locale: appLocale,
        );
        emit(state.copyWith(status: RegisterRequestStatus.submit));
        DioApiResponse response = await _authRepository.delivermanJoiningRequest(param);
        if (response.errorType == NetErrorType.none) {
          emit(state.copyWith(status: RegisterRequestStatus.submitSuccess));
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
}
