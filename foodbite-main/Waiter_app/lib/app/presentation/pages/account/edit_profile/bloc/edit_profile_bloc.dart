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
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/models/api_status_response_model.dart';
import 'package:waiter/app/core/models/request/update_waiter_profile_request_model.dart';
import 'package:waiter/app/core/models/server_error_model.dart';
import 'package:waiter/app/core/models/upload_image_model.dart';
import 'package:waiter/app/core/models/waiter_profile_response_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/core/validations/waiter_profile_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRepository _authRepository = AuthRepository();
  EditProfileBloc()
    : super(
        EditProfileState(
          model: WaiterProfileReponseModel(),
          gender: WaiterGenderModel(label: '', value: ''),
        ),
      ) {
    on<EditUserProfileInitialEvent>(_onEditUserProfileInitialEvent);
    on<EditUserProfileFirstNameChangedEvent>(_onEditUserProfileFirstNameChangedEvent);
    on<EditUserProfileFirstNameUnfocusedEvent>(_onEditUserProfileFirstNameUnfocusedEvent);
    on<EditUserProfileLastNameChangedEvent>(_onEditUserProfileLastNameChangedEvent);
    on<EditUserProfileLastNameUnfocusedEvent>(_onEditUserProfileLastNameUnfocusedEvent);
    on<EditUserProfileChangeGenderEvent>(_onEditUserProfileChangeGenderEvent);
    on<EditUserProfileUploadImageEvent>(_onEditUserProfileUploadImageEvent);
    on<EditUserProfileSubmitEvent>(_onEditUserProfileSubmitEvent);
  }

  FutureOr<void> _onEditUserProfileInitialEvent(EditUserProfileInitialEvent event, Emitter<EditProfileState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "edit_profile"}, 'edit_profile_screen', 'edit_profile_screen');
      final String userId = await _authRepository.waiterId();
      emit(state.copyWith(userId: userId, status: EditProfileStatus.loading));
      DioApiResponse response = await _authRepository.getMyProfile(userId.toString());
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: EditProfileStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          WaiterProfileReponseModel profileResponse = WaiterProfileReponseModel.fromJson(myMap);
          String flag = '';
          await _authRepository.getCountryList().then((value) {
            final selected = value.firstWhere((element) => element.dialCode == '+${profileResponse.info!.countryCode!}');
            if (selected.dialCode != null && selected.flag != null) {
              flag = selected.flag!;
            }
          });
          final email = WaiterProfileEmailField.dirty(profileResponse.info!.email!);
          final firstName = WaiterProfileFirstNameField.dirty(profileResponse.info!.firstName!);
          final lastName = WaiterProfileLastNameField.dirty(profileResponse.info!.lastName!);
          final countryCode = WaiterProfileCountryCodeField.dirty('+${profileResponse.info!.countryCode!}');
          final mobile = WaiterProfileMobileNumberField.dirty(profileResponse.info!.mobile!);
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
          WaiterGenderModel selectedGender = genderList.firstWhere((element) => element.value == profileResponse.info!.gender!);
          emit(
            state.copyWith(
              model: profileResponse,
              email: email.isValid ? email : WaiterProfileEmailField.pure(profileResponse.info!.email!),
              firstName: firstName.isValid ? firstName : WaiterProfileFirstNameField.pure(profileResponse.info!.firstName!),
              lastName: lastName.isValid ? lastName : WaiterProfileLastNameField.pure(profileResponse.info!.lastName!),
              countryCode: countryCode.isValid ? countryCode : WaiterProfileCountryCodeField.pure('+${profileResponse.info!.countryCode!}'),
              mobile: mobile.isValid ? mobile : WaiterProfileMobileNumberField.pure(profileResponse.info!.mobile!),
              flag: flag,
              image: profileResponse.info!.image!,
              genderList: genderList,
              gender: selectedGender,
              isValid: Formz.validate([email, firstName, lastName, countryCode, mobile]),
              status: EditProfileStatus.success,
            ),
          );
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: EditProfileStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: EditProfileStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onEditUserProfileFirstNameChangedEvent(EditUserProfileFirstNameChangedEvent event, Emitter<EditProfileState> emit) async {
    final firstName = WaiterProfileFirstNameField.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName.isValid ? firstName : WaiterProfileFirstNameField.pure(event.firstName),
        status: EditProfileStatus.changeDetail,
        isValid: Formz.validate([firstName, state.email, state.lastName, state.countryCode, state.mobile]),
      ),
    );
  }

  FutureOr<void> _onEditUserProfileFirstNameUnfocusedEvent(EditUserProfileFirstNameUnfocusedEvent event, Emitter<EditProfileState> emit) async {
    final firstName = WaiterProfileFirstNameField.dirty(state.firstName.value);
    emit(state.copyWith(firstName: firstName, status: EditProfileStatus.changeDetail, isValid: Formz.validate([firstName, state.email, state.lastName, state.countryCode, state.mobile])));
  }

  FutureOr<void> _onEditUserProfileLastNameChangedEvent(EditUserProfileLastNameChangedEvent event, Emitter<EditProfileState> emit) async {
    final lastName = WaiterProfileLastNameField.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName.isValid ? lastName : WaiterProfileLastNameField.pure(event.lastName),
        status: EditProfileStatus.changeDetail,
        isValid: Formz.validate([lastName, state.email, state.firstName, state.countryCode, state.mobile]),
      ),
    );
  }

  FutureOr<void> _onEditUserProfileLastNameUnfocusedEvent(EditUserProfileLastNameUnfocusedEvent event, Emitter<EditProfileState> emit) async {
    final lastName = WaiterProfileLastNameField.dirty(state.lastName.value);
    emit(state.copyWith(lastName: lastName, status: EditProfileStatus.changeDetail, isValid: Formz.validate([lastName, state.email, state.firstName, state.countryCode, state.mobile])));
  }

  FutureOr<void> _onEditUserProfileChangeGenderEvent(EditUserProfileChangeGenderEvent event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(gender: event.gender, status: EditProfileStatus.changeDetail));
  }

  FutureOr<void> _onEditUserProfileUploadImageEvent(EditUserProfileUploadImageEvent event, Emitter<EditProfileState> emit) async {
    try {
      emit(state.copyWith(status: EditProfileStatus.uploadStarted));
      final String userId = await _authRepository.waiterId();
      DioApiResponse response = await _authRepository.uploadMediaImage(event.newImage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        UploadImageModel data = UploadImageModel.fromJson(myMap);
        emit(state.copyWith(status: EditProfileStatus.uploadSuccess, image: data.path!));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: EditProfileStatus.uploadFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: EditProfileStatus.uploadFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onEditUserProfileSubmitEvent(EditUserProfileSubmitEvent event, Emitter<EditProfileState> emit) async {
    try {
      final firstName = WaiterProfileFirstNameField.dirty(state.firstName.value);
      final lastName = WaiterProfileLastNameField.dirty(state.lastName.value);
      emit(state.copyWith(firstName: firstName, lastName: lastName, status: EditProfileStatus.changeDetail, isValid: Formz.validate([firstName, lastName])));
      if (state.isValid && state.firstName.value.isNotEmpty && state.lastName.value.isNotEmpty) {
        emit(state.copyWith(status: EditProfileStatus.submit));
        UpdateWaiterProfileRequestModel param = UpdateWaiterProfileRequestModel(firstName: state.firstName.value, lastName: state.lastName.value, image: state.image, gender: state.gender.value!);
        DioApiResponse response = await _authRepository.updateMyProfile(state.userId, param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (!initialResponse.success!) {
            emit(state.copyWith(status: EditProfileStatus.submitFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          } else {
            await _authRepository.updateProfileInfo(state.firstName.value, state.lastName.value, state.image);
            emit(state.copyWith(status: EditProfileStatus.submitSuccess));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: EditProfileStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: EditProfileStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
