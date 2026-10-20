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
import 'package:vendor/app/core/models/request/create_waiter_request_model.dart';
import 'package:vendor/app/core/models/request/update_waiter_info_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/models/waiter_info_response_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/waiter_repository.dart';
import 'package:vendor/app/core/validations/waiter_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'manage_waiter_event.dart';
part 'manage_waiter_state.dart';

class ManageWaiterBloc extends Bloc<ManageWaiterEvent, ManageWaiterState> {
  final WaiterRepository _waiterRepository = WaiterRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ManageWaiterBloc()
    : super(
        ManageWaiterState(
          model: WaiterInfoResponseModel(),
          waiterGender: WaiterGenderModel(label: '', value: ''),
        ),
      ) {
    on<ManageWaiterInitialEvent>(_onManageWaiterInitialEvent);
    on<ManageWaiterCoverChangeEvent>(_onManageWaiterCoverChangeEvent);
    on<ManageWaiterFirstNameChangedEvent>(_onManageWaiterFirstNameChangedEvent);
    on<ManageWaiterFirstNameUnfocusedEvent>(_onManageWaiterFirstNameUnfocusedEvent);
    on<ManageWaiterLastNameChangedEvent>(_onManageWaiterLastNameChangedEvent);
    on<ManageWaiterLastNameUnfocusedEvent>(_onManageWaiterLastNameUnfocusedEvent);
    on<ManageWaiterEmailChangedEvent>(_onManageWaiterEmailChangedEvent);
    on<ManageWaiterEmailUnfocusedEvent>(_onManageWaiterEmailUnfocusedEvent);
    on<ManageWaiterPasswordChangedEvent>(_onManageWaiterPasswordChangedEvent);
    on<ManageWaiterPasswordUnfocusedEvent>(_onManageWaiterPasswordUnfocusedEvent);
    on<ManageWaiterCountryCodeChangedEvent>(_onManageWaiterCountryCodeChangedEvent);
    on<ManageWaiterCountryCodeUnfocusedEvent>(_onManageWaiterCountryCodeUnfocusedEvent);
    on<ManageWaiterMobileNumberChangedEvent>(_onManageWaiterMobileNumberChangedEvent);
    on<ManageWaiterMobileNumberUnfocusedEvent>(_onManageWaiterMobileNumberUnfocusedEvent);
    on<ManageWaiterGenderChangeEvent>(_onManageWaiterGenderChangeEvent);
    on<ManageWaiterSubmitEvent>(_onManageWaiterSubmitEvent);
  }

  FutureOr<void> _onManageWaiterInitialEvent(ManageWaiterInitialEvent event, Emitter<ManageWaiterState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_waiter"}, 'add_update_waiter_screen', 'add_update_waiter_screen');
    List<WaiterGenderModel> genderList = <WaiterGenderModel>[];
    genderList.clear();
    WaiterGenderModel male = WaiterGenderModel(label: 'dd_male', value: 'male');
    WaiterGenderModel female = WaiterGenderModel(label: 'dd_female', value: 'female');
    WaiterGenderModel other = WaiterGenderModel(label: 'dd_other', value: 'other');
    WaiterGenderModel notDisclose = WaiterGenderModel(label: 'dd_not_disclose', value: 'not-disclose');
    genderList.add(male);
    genderList.add(female);
    genderList.add(other);
    genderList.add(notDisclose);
    if (event.isNew) {
      String defaultCountryCode = '';
      String flag = '';
      await _waiterRepository.getDefaultCountryCode().then((value) {
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
      emit(state.copyWith(waiterCountryCode: WaiterCountryCodeField.pure(defaultCountryCode), flag: flag, isNew: event.isNew, waiterGender: genderList.first, waiterGenderList: genderList, status: ManageWaiterStatus.success));
    } else {
      try {
        emit(state.copyWith(status: ManageWaiterStatus.loading, waiterId: event.waiterId, isNew: event.isNew));
        DioApiResponse response = await _waiterRepository.getWaiterInfo(event.waiterId);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          WaiterInfoResponseModel profileResponse = WaiterInfoResponseModel.fromJson(myMap);
          String flag = '';
          await _waiterRepository.getCountryList().then((value) {
            final selected = value.firstWhere((element) => element.dialCode == '+${profileResponse.info!.countryCode!}');
            if (selected.dialCode != null && selected.flag != null) {
              flag = selected.flag!;
            }
          });
          final email = WaiterEmailField.dirty(profileResponse.info!.email!);
          final firstName = WaiterFirstNameField.dirty(profileResponse.info!.firstName!);
          final lastName = WaiterLastNameField.dirty(profileResponse.info!.lastName!);
          final countryCode = WaiterCountryCodeField.dirty('+${profileResponse.info!.countryCode!}');
          final mobile = WaiterMobileNumberField.dirty(profileResponse.info!.mobile!);
          final cover = WaiterCoverField.dirty(profileResponse.info!.image!);
          const password = WaiterPasswordField.dirty('password');
          final int waiterGenderIndex = genderList.indexWhere((element) => element.value == profileResponse.info!.gender!);
          emit(
            state.copyWith(
              status: ManageWaiterStatus.fetched,
              model: profileResponse,
              flag: flag,
              waiterEmail: email.isValid ? email : WaiterEmailField.pure(profileResponse.info!.email!),
              waiterPassword: password.isValid ? password : const WaiterPasswordField.pure('password'),
              waiterFirstName: firstName.isValid ? firstName : WaiterFirstNameField.pure(profileResponse.info!.firstName!),
              waiterLastName: lastName.isValid ? lastName : WaiterLastNameField.pure(profileResponse.info!.lastName!),
              waiterCountryCode: countryCode.isValid ? countryCode : WaiterCountryCodeField.pure('+${profileResponse.info!.countryCode!}'),
              waiterMobile: mobile.isValid ? mobile : WaiterMobileNumberField.pure(profileResponse.info!.mobile!),
              waiterCover: cover.isValid ? cover : WaiterCoverField.pure(profileResponse.info!.image!),
              waiterGender: waiterGenderIndex != -1 ? genderList[waiterGenderIndex] : genderList.first,
              waiterGenderList: genderList,
              isValid: Formz.validate([firstName, lastName, email, password, countryCode, mobile, cover]),
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageWaiterStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageWaiterStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onManageWaiterCoverChangeEvent(ManageWaiterCoverChangeEvent event, Emitter<ManageWaiterState> emit) async {
    final waiterCover = WaiterCoverField.dirty(event.image);
    emit(
      state.copyWith(
        waiterCover: waiterCover.isValid ? waiterCover : WaiterCoverField.pure(event.image),
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([waiterCover, state.waiterLastName, state.waiterEmail, state.waiterPassword, state.waiterCountryCode, state.waiterMobile, state.waiterFirstName]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterFirstNameChangedEvent(ManageWaiterFirstNameChangedEvent event, Emitter<ManageWaiterState> emit) async {
    final firstName = WaiterFirstNameField.dirty(event.firstName);
    emit(
      state.copyWith(
        waiterFirstName: firstName.isValid ? firstName : WaiterFirstNameField.pure(event.firstName),
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([firstName, state.waiterLastName, state.waiterEmail, state.waiterPassword, state.waiterCountryCode, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterFirstNameUnfocusedEvent(ManageWaiterFirstNameUnfocusedEvent event, Emitter<ManageWaiterState> emit) async {
    final firstName = WaiterFirstNameField.dirty(state.waiterFirstName.value);
    emit(
      state.copyWith(
        waiterFirstName: firstName,
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([firstName, state.waiterLastName, state.waiterEmail, state.waiterPassword, state.waiterCountryCode, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterLastNameChangedEvent(ManageWaiterLastNameChangedEvent event, Emitter<ManageWaiterState> emit) async {
    final lastName = WaiterLastNameField.dirty(event.lastName);
    emit(
      state.copyWith(
        waiterLastName: lastName.isValid ? lastName : WaiterLastNameField.pure(event.lastName),
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([lastName, state.waiterFirstName, state.waiterEmail, state.waiterPassword, state.waiterCountryCode, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterLastNameUnfocusedEvent(ManageWaiterLastNameUnfocusedEvent event, Emitter<ManageWaiterState> emit) async {
    final lastName = WaiterLastNameField.dirty(state.waiterLastName.value);
    emit(
      state.copyWith(
        waiterLastName: lastName,
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([lastName, state.waiterFirstName, state.waiterEmail, state.waiterPassword, state.waiterCountryCode, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterEmailChangedEvent(ManageWaiterEmailChangedEvent event, Emitter<ManageWaiterState> emit) async {
    final email = WaiterEmailField.dirty(event.email);
    emit(
      state.copyWith(
        waiterEmail: email.isValid ? email : WaiterEmailField.pure(event.email),
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([email, state.waiterFirstName, state.waiterLastName, state.waiterPassword, state.waiterCountryCode, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterEmailUnfocusedEvent(ManageWaiterEmailUnfocusedEvent event, Emitter<ManageWaiterState> emit) async {
    final email = WaiterEmailField.dirty(state.waiterEmail.value);
    emit(
      state.copyWith(
        waiterEmail: email,
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([email, state.waiterFirstName, state.waiterLastName, state.waiterPassword, state.waiterCountryCode, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterPasswordChangedEvent(ManageWaiterPasswordChangedEvent event, Emitter<ManageWaiterState> emit) async {
    final password = WaiterPasswordField.dirty(event.password);
    emit(
      state.copyWith(
        waiterPassword: password.isValid ? password : WaiterPasswordField.pure(event.password),
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([password, state.waiterFirstName, state.waiterLastName, state.waiterEmail, state.waiterCountryCode, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterPasswordUnfocusedEvent(ManageWaiterPasswordUnfocusedEvent event, Emitter<ManageWaiterState> emit) async {
    final password = WaiterPasswordField.dirty(state.waiterPassword.value);
    emit(
      state.copyWith(
        waiterPassword: password,
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([password, state.waiterFirstName, state.waiterLastName, state.waiterEmail, state.waiterCountryCode, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterCountryCodeChangedEvent(ManageWaiterCountryCodeChangedEvent event, Emitter<ManageWaiterState> emit) async {
    final countryCode = WaiterCountryCodeField.dirty(event.countryCode);
    emit(
      state.copyWith(
        waiterCountryCode: countryCode.isValid ? countryCode : WaiterCountryCodeField.pure(event.countryCode),
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([countryCode, state.waiterFirstName, state.waiterLastName, state.waiterEmail, state.waiterPassword, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterCountryCodeUnfocusedEvent(ManageWaiterCountryCodeUnfocusedEvent event, Emitter<ManageWaiterState> emit) async {
    final countryCode = WaiterCountryCodeField.dirty(state.waiterCountryCode.value);
    emit(
      state.copyWith(
        waiterCountryCode: countryCode,
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([countryCode, state.waiterFirstName, state.waiterLastName, state.waiterEmail, state.waiterPassword, state.waiterMobile, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterMobileNumberChangedEvent(ManageWaiterMobileNumberChangedEvent event, Emitter<ManageWaiterState> emit) async {
    final mobileNumber = WaiterMobileNumberField.dirty(event.mobileNumber);
    emit(
      state.copyWith(
        waiterMobile: mobileNumber.isValid ? mobileNumber : WaiterMobileNumberField.pure(event.mobileNumber),
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([mobileNumber, state.waiterFirstName, state.waiterLastName, state.waiterEmail, state.waiterPassword, state.waiterCountryCode, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterMobileNumberUnfocusedEvent(ManageWaiterMobileNumberUnfocusedEvent event, Emitter<ManageWaiterState> emit) async {
    final mobileNumber = WaiterMobileNumberField.dirty(state.waiterMobile.value);
    emit(
      state.copyWith(
        waiterMobile: mobileNumber,
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([mobileNumber, state.waiterFirstName, state.waiterLastName, state.waiterEmail, state.waiterPassword, state.waiterCountryCode, state.waiterCover]),
      ),
    );
  }

  FutureOr<void> _onManageWaiterGenderChangeEvent(ManageWaiterGenderChangeEvent event, Emitter<ManageWaiterState> emit) async {
    emit(state.copyWith(waiterGender: event.gender, status: ManageWaiterStatus.changeDetail));
  }

  FutureOr<void> _onManageWaiterSubmitEvent(ManageWaiterSubmitEvent event, Emitter<ManageWaiterState> emit) async {
    final firstName = WaiterFirstNameField.dirty(state.waiterFirstName.value);
    final lastName = WaiterLastNameField.dirty(state.waiterLastName.value);
    final email = WaiterEmailField.dirty(state.waiterEmail.value);
    final password = WaiterPasswordField.dirty(state.waiterPassword.value);
    final countryCode = WaiterCountryCodeField.dirty(state.waiterCountryCode.value);
    final mobileNumber = WaiterMobileNumberField.dirty(state.waiterMobile.value);
    final cover = WaiterCoverField.dirty(state.waiterCover.value);
    emit(
      state.copyWith(
        waiterFirstName: firstName,
        waiterLastName: lastName,
        waiterEmail: email,
        waiterPassword: password,
        waiterCountryCode: countryCode,
        waiterMobile: mobileNumber,
        waiterCover: cover,
        status: ManageWaiterStatus.changeDetail,
        isValid: Formz.validate([firstName, lastName, email, password, countryCode, mobileNumber, cover]),
      ),
    );

    if (state.isValid &&
        state.waiterFirstName.value.isNotEmpty &&
        state.waiterLastName.value.isNotEmpty &&
        state.waiterEmail.value.isNotEmpty &&
        state.waiterPassword.value.isNotEmpty &&
        state.waiterCountryCode.value.isNotEmpty &&
        state.waiterMobile.value.isNotEmpty &&
        state.waiterCover.value.isNotEmpty) {
      if (state.isNew) {
        try {
          emit(state.copyWith(status: ManageWaiterStatus.submit));
          final String vendorId = await _waiterRepository.getVendorId();
          CreateWaiterRequestModel param = CreateWaiterRequestModel(
            firstName: state.waiterFirstName.value.toString(),
            lastName: state.waiterLastName.value.toString(),
            email: state.waiterEmail.value.toString(),
            password: state.waiterPassword.value.toString(),
            countryCode: state.waiterCountryCode.value.toString(),
            mobile: state.waiterMobile.value.toString(),
            image: state.waiterCover.value.toString(),
            restaurant: vendorId,
            gender: state.waiterGender.value.toString(),
          );
          DioApiResponse response = await _waiterRepository.createWaiter(param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageWaiterStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageWaiterStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: ManageWaiterStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      } else {
        try {
          emit(state.copyWith(status: ManageWaiterStatus.update));
          final String userId = state.model.info!.id!;
          UpdateWaiterInfoRequestModel param = UpdateWaiterInfoRequestModel(
            firstName: state.waiterFirstName.value.toString(),
            lastName: state.waiterLastName.value.toString(),
            image: state.waiterCover.value.toString(),
            gender: state.waiterGender.value.toString(),
          );
          DioApiResponse response = await _waiterRepository.updateWaiterInfo(userId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageWaiterStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageWaiterStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: ManageWaiterStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    }
  }
}
