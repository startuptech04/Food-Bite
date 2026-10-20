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
import 'package:vendor/app/core/models/kitchen_owner_info_response_model.dart';
import 'package:vendor/app/core/models/request/create_kitchen_owner_request_model.dart';
import 'package:vendor/app/core/models/request/update_kitchen_owner_info_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/validations/kitchen_owner_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'manage_kitchen_credentials_event.dart';
part 'manage_kitchen_credentials_state.dart';

class ManageKitchenCredentialsBloc extends Bloc<ManageKitchenCredentialsEvent, ManageKitchenCredentialsState> {
  final AccountRepository _accountRepository = AccountRepository();
  ManageKitchenCredentialsBloc()
    : super(
        ManageKitchenCredentialsState(
          model: KitchenOwnerInfoResponseModel(),
          kitchenOwnerGender: KitchenOwnerGenderModel(label: '', value: ''),
        ),
      ) {
    on<ManageKitchenCredentialsInitialEvent>(_onManageKitchenCredentialsInitialEvent);
    on<ManageKitchenOwnerCoverChangeEvent>(_onManageKitchenOwnerCoverChangeEvent);
    on<ManageKitchenOwnerFirstNameChangedEvent>(_onManageKitchenOwnerFirstNameChangedEvent);
    on<ManageKitchenOwnerFirstNameUnfocusedEvent>(_onManageKitchenOwnerFirstNameUnfocusedEvent);
    on<ManageKitchenOwnerLastNameChangedEvent>(_onManageKitchenOwnerLastNameChangedEvent);
    on<ManageKitchenOwnerLastNameUnfocusedEvent>(_onManageKitchenOwnerLastNameUnfocusedEvent);
    on<ManageKitchenOwnerEmailChangedEvent>(_onManageKitchenOwnerEmailChangedEvent);
    on<ManageKitchenOwnerEmailUnfocusedEvent>(_onManageKitchenOwnerEmailUnfocusedEvent);
    on<ManageKitchenOwnerPasswordChangedEvent>(_onManageKitchenOwnerPasswordChangedEvent);
    on<ManageKitchenOwnerPasswordUnfocusedEvent>(_onManageKitchenOwnerPasswordUnfocusedEvent);
    on<ManageKitchenOwnerCountryCodeChangedEvent>(_onManageKitchenOwnerCountryCodeChangedEvent);
    on<ManageKitchenOwnerCountryCodeUnfocusedEvent>(_onManageKitchenOwnerCountryCodeUnfocusedEvent);
    on<ManageKitchenOwnerMobileNumberChangedEvent>(_onManageKitchenOwnerMobileNumberChangedEvent);
    on<ManageKitchenOwnerMobileNumberUnfocusedEvent>(_onManageKitchenOwnerMobileNumberUnfocusedEvent);
    on<ManageKitchenOwnerGenderChangeEvent>(_onManageKitchenOwnerGenderChangeEvent);
    on<ManageKitchenOwnerSubmitEvent>(_onManageKitchenOwnerSubmitEvent);
  }

  FutureOr<void> _onManageKitchenCredentialsInitialEvent(ManageKitchenCredentialsInitialEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_kitchen_owner"}, 'add_update_kitchen_owner_screen', 'add_update_kitchen_owner_screen');
    List<KitchenOwnerGenderModel> genderList = <KitchenOwnerGenderModel>[];
    genderList.clear();
    KitchenOwnerGenderModel male = KitchenOwnerGenderModel(label: 'dd_male', value: 'male');
    KitchenOwnerGenderModel female = KitchenOwnerGenderModel(label: 'dd_female', value: 'female');
    KitchenOwnerGenderModel other = KitchenOwnerGenderModel(label: 'dd_other', value: 'other');
    KitchenOwnerGenderModel notDisclose = KitchenOwnerGenderModel(label: 'dd_not_disclose', value: 'not-disclose');
    genderList.add(male);
    genderList.add(female);
    genderList.add(other);
    genderList.add(notDisclose);
    if (event.isNew) {
      String defaultCountryCode = '';
      String flag = '';
      await _accountRepository.getDefaultCountryCode().then((value) {
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
      emit(
        state.copyWith(
          kitchenOwnerCountryCode: KitchenOwnerCountryCodeField.pure(defaultCountryCode),
          flag: flag,
          isNew: event.isNew,
          kitchenOwnerGender: genderList.first,
          kitchenOwnerGenderList: genderList,
          status: ManageKitchenCredentialsStatus.success,
        ),
      );
    } else {
      try {
        emit(state.copyWith(status: ManageKitchenCredentialsStatus.loading, kitchenId: event.kitchenId, isNew: event.isNew));
        DioApiResponse response = await _accountRepository.getKitchenOwnerInfo(event.kitchenId);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          KitchenOwnerInfoResponseModel profileResponse = KitchenOwnerInfoResponseModel.fromJson(myMap);
          String flag = '';
          await _accountRepository.getCountryList().then((value) {
            final selected = value.firstWhere((element) => element.dialCode == '+${profileResponse.info!.countryCode!}');
            if (selected.dialCode != null && selected.flag != null) {
              flag = selected.flag!;
            }
          });
          final email = KitchenOwnerEmailField.dirty(profileResponse.info!.email!);
          final firstName = KitchenOwnerFirstNameField.dirty(profileResponse.info!.firstName!);
          final lastName = KitchenOwnerLastNameField.dirty(profileResponse.info!.lastName!);
          final countryCode = KitchenOwnerCountryCodeField.dirty('+${profileResponse.info!.countryCode!}');
          final mobile = KitchenOwnerMobileNumberField.dirty(profileResponse.info!.mobile!);
          final cover = KitchenOwnerCoverField.dirty(profileResponse.info!.image!);
          const password = KitchenOwnerPasswordField.dirty('password');
          final int kitchenOwnerGenderIndex = genderList.indexWhere((element) => element.value == profileResponse.info!.gender!);
          emit(
            state.copyWith(
              status: ManageKitchenCredentialsStatus.fetched,
              model: profileResponse,
              flag: flag,
              kitchenOwnerEmail: email.isValid ? email : KitchenOwnerEmailField.pure(profileResponse.info!.email!),
              kitchenOwnerPassword: password.isValid ? password : const KitchenOwnerPasswordField.pure('password'),
              kitchenOwnerFirstName: firstName.isValid ? firstName : KitchenOwnerFirstNameField.pure(profileResponse.info!.firstName!),
              kitchenOwnerLastName: lastName.isValid ? lastName : KitchenOwnerLastNameField.pure(profileResponse.info!.lastName!),
              kitchenOwnerCountryCode: countryCode.isValid ? countryCode : KitchenOwnerCountryCodeField.pure('+${profileResponse.info!.countryCode!}'),
              kitchenOwnerMobile: mobile.isValid ? mobile : KitchenOwnerMobileNumberField.pure(profileResponse.info!.mobile!),
              kitchenOwnerCover: cover.isValid ? cover : KitchenOwnerCoverField.pure(profileResponse.info!.image!),
              kitchenOwnerGender: kitchenOwnerGenderIndex != -1 ? genderList[kitchenOwnerGenderIndex] : genderList.first,
              kitchenOwnerGenderList: genderList,
              isValid: Formz.validate([firstName, lastName, email, password, countryCode, mobile, cover]),
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageKitchenCredentialsStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageKitchenCredentialsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onManageKitchenOwnerCoverChangeEvent(ManageKitchenOwnerCoverChangeEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final kitchenOwnerCover = KitchenOwnerCoverField.dirty(event.image);
    emit(
      state.copyWith(
        kitchenOwnerCover: kitchenOwnerCover.isValid ? kitchenOwnerCover : KitchenOwnerCoverField.pure(event.image),
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([kitchenOwnerCover, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerFirstName]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerFirstNameChangedEvent(ManageKitchenOwnerFirstNameChangedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final firstName = KitchenOwnerFirstNameField.dirty(event.firstName);
    emit(
      state.copyWith(
        kitchenOwnerFirstName: firstName.isValid ? firstName : KitchenOwnerFirstNameField.pure(event.firstName),
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([firstName, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerFirstNameUnfocusedEvent(ManageKitchenOwnerFirstNameUnfocusedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final firstName = KitchenOwnerFirstNameField.dirty(state.kitchenOwnerFirstName.value);
    emit(
      state.copyWith(
        kitchenOwnerFirstName: firstName,
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([firstName, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerLastNameChangedEvent(ManageKitchenOwnerLastNameChangedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final lastName = KitchenOwnerLastNameField.dirty(event.lastName);
    emit(
      state.copyWith(
        kitchenOwnerLastName: lastName.isValid ? lastName : KitchenOwnerLastNameField.pure(event.lastName),
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([lastName, state.kitchenOwnerFirstName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerLastNameUnfocusedEvent(ManageKitchenOwnerLastNameUnfocusedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final lastName = KitchenOwnerLastNameField.dirty(state.kitchenOwnerLastName.value);
    emit(
      state.copyWith(
        kitchenOwnerLastName: lastName,
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([lastName, state.kitchenOwnerFirstName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerEmailChangedEvent(ManageKitchenOwnerEmailChangedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final email = KitchenOwnerEmailField.dirty(event.email);
    emit(
      state.copyWith(
        kitchenOwnerEmail: email.isValid ? email : KitchenOwnerEmailField.pure(event.email),
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([email, state.kitchenOwnerFirstName, state.kitchenOwnerLastName, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerEmailUnfocusedEvent(ManageKitchenOwnerEmailUnfocusedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final email = KitchenOwnerEmailField.dirty(state.kitchenOwnerEmail.value);
    emit(
      state.copyWith(
        kitchenOwnerEmail: email,
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([email, state.kitchenOwnerFirstName, state.kitchenOwnerLastName, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerPasswordChangedEvent(ManageKitchenOwnerPasswordChangedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final password = KitchenOwnerPasswordField.dirty(event.password);
    emit(
      state.copyWith(
        kitchenOwnerPassword: password.isValid ? password : KitchenOwnerPasswordField.pure(event.password),
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([password, state.kitchenOwnerFirstName, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerPasswordUnfocusedEvent(ManageKitchenOwnerPasswordUnfocusedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final password = KitchenOwnerPasswordField.dirty(state.kitchenOwnerPassword.value);
    emit(
      state.copyWith(
        kitchenOwnerPassword: password,
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([password, state.kitchenOwnerFirstName, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerCountryCode, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerCountryCodeChangedEvent(ManageKitchenOwnerCountryCodeChangedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final countryCode = KitchenOwnerCountryCodeField.dirty(event.countryCode);
    emit(
      state.copyWith(
        kitchenOwnerCountryCode: countryCode.isValid ? countryCode : KitchenOwnerCountryCodeField.pure(event.countryCode),
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([countryCode, state.kitchenOwnerFirstName, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerCountryCodeUnfocusedEvent(ManageKitchenOwnerCountryCodeUnfocusedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final countryCode = KitchenOwnerCountryCodeField.dirty(state.kitchenOwnerCountryCode.value);
    emit(
      state.copyWith(
        kitchenOwnerCountryCode: countryCode,
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([countryCode, state.kitchenOwnerFirstName, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerMobile, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerMobileNumberChangedEvent(ManageKitchenOwnerMobileNumberChangedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final mobileNumber = KitchenOwnerMobileNumberField.dirty(event.mobileNumber);
    emit(
      state.copyWith(
        kitchenOwnerMobile: mobileNumber.isValid ? mobileNumber : KitchenOwnerMobileNumberField.pure(event.mobileNumber),
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([mobileNumber, state.kitchenOwnerFirstName, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerMobileNumberUnfocusedEvent(ManageKitchenOwnerMobileNumberUnfocusedEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final mobileNumber = KitchenOwnerMobileNumberField.dirty(state.kitchenOwnerMobile.value);
    emit(
      state.copyWith(
        kitchenOwnerMobile: mobileNumber,
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([mobileNumber, state.kitchenOwnerFirstName, state.kitchenOwnerLastName, state.kitchenOwnerEmail, state.kitchenOwnerPassword, state.kitchenOwnerCountryCode, state.kitchenOwnerCover]),
      ),
    );
  }

  FutureOr<void> _onManageKitchenOwnerGenderChangeEvent(ManageKitchenOwnerGenderChangeEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    emit(state.copyWith(kitchenOwnerGender: event.gender, status: ManageKitchenCredentialsStatus.changeDetail));
  }

  FutureOr<void> _onManageKitchenOwnerSubmitEvent(ManageKitchenOwnerSubmitEvent event, Emitter<ManageKitchenCredentialsState> emit) async {
    final firstName = KitchenOwnerFirstNameField.dirty(state.kitchenOwnerFirstName.value);
    final lastName = KitchenOwnerLastNameField.dirty(state.kitchenOwnerLastName.value);
    final email = KitchenOwnerEmailField.dirty(state.kitchenOwnerEmail.value);
    final password = KitchenOwnerPasswordField.dirty(state.kitchenOwnerPassword.value);
    final countryCode = KitchenOwnerCountryCodeField.dirty(state.kitchenOwnerCountryCode.value);
    final mobileNumber = KitchenOwnerMobileNumberField.dirty(state.kitchenOwnerMobile.value);
    final cover = KitchenOwnerCoverField.dirty(state.kitchenOwnerCover.value);

    emit(
      state.copyWith(
        kitchenOwnerFirstName: firstName,
        kitchenOwnerLastName: lastName,
        kitchenOwnerEmail: email,
        kitchenOwnerPassword: password,
        kitchenOwnerCountryCode: countryCode,
        kitchenOwnerMobile: mobileNumber,
        kitchenOwnerCover: cover,
        status: ManageKitchenCredentialsStatus.changeDetail,
        isValid: Formz.validate([firstName, lastName, email, password, countryCode, mobileNumber, cover]),
      ),
    );

    if (state.isValid &&
        state.kitchenOwnerFirstName.value.isNotEmpty &&
        state.kitchenOwnerLastName.value.isNotEmpty &&
        state.kitchenOwnerEmail.value.isNotEmpty &&
        state.kitchenOwnerPassword.value.isNotEmpty &&
        state.kitchenOwnerCountryCode.value.isNotEmpty &&
        state.kitchenOwnerMobile.value.isNotEmpty &&
        state.kitchenOwnerCover.value.isNotEmpty) {
      if (state.isNew) {
        try {
          emit(state.copyWith(status: ManageKitchenCredentialsStatus.submit));
          final String vendorId = await _accountRepository.getVendorId();
          CreateKitchenOwnerRequestModel param = CreateKitchenOwnerRequestModel(
            firstName: state.kitchenOwnerFirstName.value.toString(),
            lastName: state.kitchenOwnerLastName.value.toString(),
            email: state.kitchenOwnerEmail.value.toString(),
            password: state.kitchenOwnerPassword.value.toString(),
            countryCode: state.kitchenOwnerCountryCode.value.toString(),
            mobile: state.kitchenOwnerMobile.value.toString(),
            image: state.kitchenOwnerCover.value.toString(),
            restaurant: vendorId,
            gender: state.kitchenOwnerGender.value.toString(),
          );
          DioApiResponse response = await _accountRepository.createKitchenOwner(param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageKitchenCredentialsStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageKitchenCredentialsStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: ManageKitchenCredentialsStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      } else {
        try {
          emit(state.copyWith(status: ManageKitchenCredentialsStatus.update));
          final String userId = state.model.info!.id!;
          UpdateKitchenOwnerInfoRequestModel param = UpdateKitchenOwnerInfoRequestModel(
            firstName: state.kitchenOwnerFirstName.value.toString(),
            lastName: state.kitchenOwnerLastName.value.toString(),
            image: state.kitchenOwnerCover.value.toString(),
            gender: state.kitchenOwnerGender.value.toString(),
          );
          DioApiResponse response = await _accountRepository.updateKitchenOwnerInfo(userId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageKitchenCredentialsStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageKitchenCredentialsStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: ManageKitchenCredentialsStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    }
  }
}
