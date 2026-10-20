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
import 'package:driver/app/core/models/api_status_response_model.dart';
import 'package:driver/app/core/models/driver_profile_info_response_model.dart';
import 'package:driver/app/core/models/request/update_deliveryman_profile_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/models/upload_image_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/validations/user_profile_form.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRepository _authRepository = AuthRepository();
  EditProfileBloc()
    : super(
        EditProfileState(
          model: DriverProfileInfoResponseModel(locale: ''),
          gender: EditProfileGenderModel(label: '', value: ''),
          identity: EditProfileIdentityTypeModel(label: '', value: ''),
          vehicle: VehicleInfoConfigModel(id: '', name: '', translations: [], locale: ''),
        ),
      ) {
    on<EditProfileInitialEvent>(_onEditProfileInitialEvent);
    on<EditProfileFirstNameChangedEvent>(_onEditProfileFirstNameChangedEvent);
    on<EditProfileFirstNameUnfocusedEvent>(_onEditProfileFirstNameUnfocusedEvent);
    on<EditProfileLastNameChangedEvent>(_onEditProfileLastNameChangedEvent);
    on<EditProfileLastNameUnfocusedEvent>(_onEditProfileLastNameUnfocusedEvent);
    on<EditProfileChangeGenderEvent>(_onEditProfileChangeGenderEvent);
    on<EditProfileUploadImageEvent>(_onEditProfileUploadImageEvent);
    on<EditProfileIdentityChangedEvent>(_onEditProfileIdentityChangedEvent);
    on<EditProfileIdentityUnfocusedEvent>(_onEditProfileIdentityUnfocusedEvent);
    on<EditProfileChangeIdentityType>(_onEditProfileChangeIdentityType);
    on<EditProfileUploadDrivingLicenseEvent>(_onEditProfileUploadDrivingLicenseEvent);
    on<EditProfileUploadIdentityProofEvent>(_onEditProfileUploadIdentityProofEvent);
    on<EditProfileSelectVehicleEvent>(_onEditProfileSelectVehicleEvent);
    on<EditProfileSubmitEvent>(_onEditProfileSubmitEvent);
  }

  FutureOr<void> _onEditProfileInitialEvent(EditProfileInitialEvent event, Emitter<EditProfileState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "edit_profile"}, 'edit_profile_screen', 'edit_profile_screen');
      final String userId = await _authRepository.userId();
      emit(state.copyWith(userId: userId, status: EditProfileStatus.loading));
      DioApiResponse response = await _authRepository.getMyProfile(userId.toString());
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: EditProfileStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          final String locale = await _authRepository.getLocale();
          DriverProfileInfoResponseModel profileResponse = DriverProfileInfoResponseModel.fromJson(myMap, locale.toString());
          String flag = '';
          await _authRepository.getCountryList().then((value) {
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
          final identity = UserProfileIdentityNumberField.dirty(profileResponse.driver!.identityNumber!);

          List<EditProfileIdentityTypeModel> identityList = <EditProfileIdentityTypeModel>[];
          identityList.clear();
          EditProfileIdentityTypeModel passport = EditProfileIdentityTypeModel(label: 'dd_passport', value: 'passport');
          EditProfileIdentityTypeModel license = EditProfileIdentityTypeModel(label: 'dd_driving_license', value: 'license');
          EditProfileIdentityTypeModel nic = EditProfileIdentityTypeModel(label: 'dd_nic', value: 'nic');
          identityList.add(passport);
          identityList.add(license);
          identityList.add(nic);
          EditProfileIdentityTypeModel selectedIdentity = identityList.firstWhere((element) => element.value == profileResponse.driver!.identity!);

          List<EditProfileGenderModel> genderList = <EditProfileGenderModel>[];
          genderList.clear();
          EditProfileGenderModel male = EditProfileGenderModel(label: 'dd_male', value: 'male');
          EditProfileGenderModel female = EditProfileGenderModel(label: 'dd_female', value: 'female');
          EditProfileGenderModel other = EditProfileGenderModel(label: 'dd_other', value: 'other');
          EditProfileGenderModel notDisclose = EditProfileGenderModel(label: 'dd_not_disclose', value: 'not-disclose');
          genderList.add(male);
          genderList.add(female);
          genderList.add(other);
          genderList.add(notDisclose);
          EditProfileGenderModel selectedGender = genderList.firstWhere((element) => element.value == profileResponse.info!.gender!);
          VehicleInfoConfigModel selectedVehicle = profileResponse.vehicleList!.firstWhere((element) => element.id! == profileResponse.driver!.vehicle!.id!);
          emit(
            state.copyWith(
              model: profileResponse,
              email: email.isValid ? email : UserProfileEmailField.pure(profileResponse.info!.email!),
              firstName: firstName.isValid ? firstName : UserProfileFirstNameField.pure(profileResponse.info!.firstName!),
              lastName: lastName.isValid ? lastName : UserProfileLastNameField.pure(profileResponse.info!.lastName!),
              countryCode: countryCode.isValid ? countryCode : UserProfileCountryCodeField.pure('+${profileResponse.info!.countryCode!}'),
              mobile: mobile.isValid ? mobile : UserProfileMobileNumberField.pure(profileResponse.info!.mobile!),
              identityNumber: identity.isValid ? identity : UserProfileIdentityNumberField.pure(profileResponse.driver!.identity!),
              flag: flag,
              image: profileResponse.info!.image!,
              genderList: genderList,
              gender: selectedGender,
              identity: selectedIdentity,
              identityList: identityList,
              identityProof: profileResponse.driver!.identityProof!,
              drivingLicense: profileResponse.driver!.drivingLicense!,
              vehicle: selectedVehicle,
              vehicleList: profileResponse.vehicleList,
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
        isValid: Formz.validate([firstName, state.email, state.lastName, state.countryCode, state.mobile, state.identityNumber]),
      ),
    );
  }

  FutureOr<void> _onEditProfileFirstNameUnfocusedEvent(EditProfileFirstNameUnfocusedEvent event, Emitter<EditProfileState> emit) async {
    final firstName = UserProfileFirstNameField.dirty(state.firstName.value);
    emit(state.copyWith(firstName: firstName, status: EditProfileStatus.changeDetail, isValid: Formz.validate([firstName, state.email, state.lastName, state.countryCode, state.mobile, state.identityNumber])));
  }

  FutureOr<void> _onEditProfileLastNameChangedEvent(EditProfileLastNameChangedEvent event, Emitter<EditProfileState> emit) async {
    final lastName = UserProfileLastNameField.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName.isValid ? lastName : UserProfileLastNameField.pure(event.lastName),
        status: EditProfileStatus.changeDetail,
        isValid: Formz.validate([lastName, state.email, state.firstName, state.countryCode, state.mobile, state.identityNumber]),
      ),
    );
  }

  FutureOr<void> _onEditProfileLastNameUnfocusedEvent(EditProfileLastNameUnfocusedEvent event, Emitter<EditProfileState> emit) async {
    final lastName = UserProfileLastNameField.dirty(state.lastName.value);
    emit(state.copyWith(lastName: lastName, status: EditProfileStatus.changeDetail, isValid: Formz.validate([lastName, state.email, state.firstName, state.countryCode, state.mobile, state.identityNumber])));
  }

  FutureOr<void> _onEditProfileChangeGenderEvent(EditProfileChangeGenderEvent event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(gender: event.gender, status: EditProfileStatus.changeDetail));
  }

  FutureOr<void> _onEditProfileUploadImageEvent(EditProfileUploadImageEvent event, Emitter<EditProfileState> emit) async {
    try {
      emit(state.copyWith(status: EditProfileStatus.uploadStarted));
      final String userId = await _authRepository.userId();
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

  FutureOr<void> _onEditProfileIdentityChangedEvent(EditProfileIdentityChangedEvent event, Emitter<EditProfileState> emit) async {
    final identityNumber = UserProfileIdentityNumberField.dirty(event.identity);
    emit(
      state.copyWith(
        identityNumber: identityNumber.isValid ? identityNumber : UserProfileIdentityNumberField.pure(event.identity),
        status: EditProfileStatus.changeDetail,
        isValid: Formz.validate([identityNumber, state.email, state.firstName, state.countryCode, state.lastName]),
      ),
    );
  }

  FutureOr<void> _onEditProfileIdentityUnfocusedEvent(EditProfileIdentityUnfocusedEvent event, Emitter<EditProfileState> emit) async {
    final identityNumber = UserProfileIdentityNumberField.dirty(state.identityNumber.value);
    emit(state.copyWith(identityNumber: identityNumber, status: EditProfileStatus.changeDetail, isValid: Formz.validate([identityNumber, state.email, state.firstName, state.countryCode, state.lastName])));
  }

  FutureOr<void> _onEditProfileChangeIdentityType(EditProfileChangeIdentityType event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(identity: event.identity, status: EditProfileStatus.changeDetail));
  }

  FutureOr<void> _onEditProfileUploadDrivingLicenseEvent(EditProfileUploadDrivingLicenseEvent event, Emitter<EditProfileState> emit) async {
    try {
      emit(state.copyWith(status: EditProfileStatus.uploadDrivingLicense));
      final String userId = await _authRepository.userId();
      DioApiResponse response = await _authRepository.uploadMediaImage(event.newImage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        UploadImageModel data = UploadImageModel.fromJson(myMap);
        emit(state.copyWith(status: EditProfileStatus.uploadSuccess, drivingLicense: data.path!));
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

  FutureOr<void> _onEditProfileUploadIdentityProofEvent(EditProfileUploadIdentityProofEvent event, Emitter<EditProfileState> emit) async {
    try {
      emit(state.copyWith(status: EditProfileStatus.uploadIdentityProof));
      final String userId = await _authRepository.userId();
      DioApiResponse response = await _authRepository.uploadMediaImage(event.newImage, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        UploadImageModel data = UploadImageModel.fromJson(myMap);
        emit(state.copyWith(status: EditProfileStatus.uploadSuccess, identityProof: data.path!));
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

  FutureOr<void> _onEditProfileSelectVehicleEvent(EditProfileSelectVehicleEvent event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(vehicle: event.vehicle, status: EditProfileStatus.changeDetail));
  }

  FutureOr<void> _onEditProfileSubmitEvent(EditProfileSubmitEvent event, Emitter<EditProfileState> emit) async {
    try {
      final firstName = UserProfileFirstNameField.dirty(state.firstName.value);
      final lastName = UserProfileLastNameField.dirty(state.lastName.value);
      final identityNumber = UserProfileIdentityNumberField.dirty(state.identityNumber.value);
      emit(state.copyWith(firstName: firstName, lastName: lastName, identityNumber: identityNumber, status: EditProfileStatus.changeDetail, isValid: Formz.validate([firstName, lastName, identityNumber])));
      if (state.isValid && state.firstName.value.isNotEmpty && state.lastName.value.isNotEmpty && state.identityNumber.value.isNotEmpty) {
        UpdateDeliverymanProfileRequestModel param = UpdateDeliverymanProfileRequestModel(
          firstName: state.firstName.value.toString(),
          lastName: state.lastName.value.toString(),
          image: state.image,
          gender: state.gender.value!,
          identity: state.identity.value!,
          identityNumber: state.identityNumber.value.toString(),
          identityProof: state.identityProof,
          drivingLicense: state.drivingLicense,
          vehicle: state.vehicle.id!,
        );
        DioApiResponse response = await _authRepository.updateProfile(state.userId, param);
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
