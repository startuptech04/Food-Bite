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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/request/update_user_profile_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/upload_image_model.dart';
import 'package:vendor/app/core/models/user_profile_response_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/validations/user_profile_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AccountRepository _accountRepository = AccountRepository();
  EditProfileBloc()
    : super(
        EditProfileState(
          model: UserProfileReponseModel(),
          gender: UserProfileGenderModel(label: '', value: ''),
        ),
      ) {
    on<EditProfileInitialEvent>(_onEditProfileInitialEvent);
    on<EditProfileFirstNameChangedEvent>(_onEditProfileFirstNameChangedEvent);
    on<EditProfileFirstNameUnfocusedEvent>(_onEditProfileFirstNameUnfocusedEvent);
    on<EditProfileLastNameChangedEvent>(_onEditProfileLastNameChangedEvent);
    on<EditProfileLastNameUnfocusedEvent>(_onEditProfileLastNameUnfocusedEvent);
    on<EditProfileChangeGenderEvent>(_onEditProfileChangeGenderEvent);
    on<EditProfileUploadImageEvent>(_onEditProfileUploadImageEvent);
    on<EditProfileSubmitEvent>(_onEditProfileSubmitEvent);
  }

  FutureOr<void> _onEditProfileInitialEvent(EditProfileInitialEvent event, Emitter<EditProfileState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "edit_profile"}, 'edit_profile_screen', 'edit_profile_screen');
      final String userId = await _accountRepository.userId();
      emit(state.copyWith(userId: userId, status: EditProfileStatus.loading));
      DioApiResponse response = await _accountRepository.getMyProfile(userId.toString());
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: EditProfileStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          UserProfileReponseModel profileResponse = UserProfileReponseModel.fromJson(myMap);
          String flag = '';
          await _accountRepository.getCountryList().then((value) {
            final selected = value.firstWhere((element) => element.dialCode == '+${profileResponse.info!.countryCode!}');
            if (selected.dialCode != null && selected.flag != null) {
              flag = selected.flag!;
            }
          });
          final email = UserProfileEmailField.dirty(profileResponse.info!.email!);
          final firstName = UserProfileFirstNameField.dirty(profileResponse.info!.firstName!);
          final lastName = UserProfileLastNameField.dirty(profileResponse.info!.lastName!);
          final countryCode = UserProfileCountryCodeField.dirty('+${profileResponse.info!.countryCode!}');
          final mobile = UserProfileMobileNumberField.dirty(profileResponse.info!.mobile!);
          List<UserProfileGenderModel> genderList = <UserProfileGenderModel>[];
          genderList.clear();
          UserProfileGenderModel male = UserProfileGenderModel(label: 'dd_male', value: 'male');
          UserProfileGenderModel female = UserProfileGenderModel(label: 'dd_female', value: 'female');
          UserProfileGenderModel other = UserProfileGenderModel(label: 'dd_other', value: 'other');
          UserProfileGenderModel notDisclose = UserProfileGenderModel(label: 'dd_not_disclose', value: 'not-disclose');
          genderList.add(male);
          genderList.add(female);
          genderList.add(other);
          genderList.add(notDisclose);
          UserProfileGenderModel selectedGender = genderList.firstWhere((element) => element.value == profileResponse.info!.gender!);
          emit(
            state.copyWith(
              model: profileResponse,
              email: email.isValid ? email : UserProfileEmailField.pure(profileResponse.info!.email!),
              firstName: firstName.isValid ? firstName : UserProfileFirstNameField.pure(profileResponse.info!.firstName!),
              lastName: lastName.isValid ? lastName : UserProfileLastNameField.pure(profileResponse.info!.lastName!),
              countryCode: countryCode.isValid ? countryCode : UserProfileCountryCodeField.pure('+${profileResponse.info!.countryCode!}'),
              mobile: mobile.isValid ? mobile : UserProfileMobileNumberField.pure(profileResponse.info!.mobile!),
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

  FutureOr<void> _onEditProfileFirstNameChangedEvent(EditProfileFirstNameChangedEvent event, Emitter<EditProfileState> emit) async {
    final firstName = UserProfileFirstNameField.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName.isValid ? firstName : UserProfileFirstNameField.pure(event.firstName),
        status: EditProfileStatus.changeDetail,
        isValid: Formz.validate([firstName, state.email, state.lastName, state.countryCode, state.mobile]),
      ),
    );
  }

  FutureOr<void> _onEditProfileFirstNameUnfocusedEvent(EditProfileFirstNameUnfocusedEvent event, Emitter<EditProfileState> emit) async {
    final firstName = UserProfileFirstNameField.dirty(state.firstName.value);
    emit(state.copyWith(firstName: firstName, status: EditProfileStatus.changeDetail, isValid: Formz.validate([firstName, state.email, state.lastName, state.countryCode, state.mobile])));
  }

  FutureOr<void> _onEditProfileLastNameChangedEvent(EditProfileLastNameChangedEvent event, Emitter<EditProfileState> emit) async {
    final lastName = UserProfileLastNameField.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName.isValid ? lastName : UserProfileLastNameField.pure(event.lastName),
        status: EditProfileStatus.changeDetail,
        isValid: Formz.validate([lastName, state.email, state.firstName, state.countryCode, state.mobile]),
      ),
    );
  }

  FutureOr<void> _onEditProfileLastNameUnfocusedEvent(EditProfileLastNameUnfocusedEvent event, Emitter<EditProfileState> emit) async {
    final lastName = UserProfileLastNameField.dirty(state.lastName.value);
    emit(state.copyWith(lastName: lastName, status: EditProfileStatus.changeDetail, isValid: Formz.validate([lastName, state.email, state.firstName, state.countryCode, state.mobile])));
  }

  FutureOr<void> _onEditProfileChangeGenderEvent(EditProfileChangeGenderEvent event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(gender: event.gender, status: EditProfileStatus.changeDetail));
  }

  FutureOr<void> _onEditProfileUploadImageEvent(EditProfileUploadImageEvent event, Emitter<EditProfileState> emit) async {
    try {
      emit(state.copyWith(status: EditProfileStatus.uploadStarted));
      final String userId = await _accountRepository.userId();
      DioApiResponse response = await _accountRepository.uploadMediaImage(event.newImage, userId);
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

  FutureOr<void> _onEditProfileSubmitEvent(EditProfileSubmitEvent event, Emitter<EditProfileState> emit) async {
    try {
      final firstName = UserProfileFirstNameField.dirty(state.firstName.value);
      final lastName = UserProfileLastNameField.dirty(state.lastName.value);
      emit(state.copyWith(firstName: firstName, lastName: lastName, status: EditProfileStatus.changeDetail, isValid: Formz.validate([firstName, lastName])));
      if (state.isValid && state.firstName.value.isNotEmpty && state.lastName.value.isNotEmpty) {
        emit(state.copyWith(status: EditProfileStatus.submit));
        UpdateUserProfileRequestModel param = UpdateUserProfileRequestModel(firstName: state.firstName.value, lastName: state.lastName.value, image: state.image, gender: state.gender.value!);
        DioApiResponse response = await _accountRepository.updateMyProfile(state.userId, param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (!initialResponse.success!) {
            emit(state.copyWith(status: EditProfileStatus.submitFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          } else {
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
