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
import 'package:intl/intl.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/deliveryman_vehicle_response_model.dart';
import 'package:vendor/app/core/models/manage_deliveryman_info_response_model.dart';
import 'package:vendor/app/core/models/manage_deliveryman_initial_response_model.dart';
import 'package:vendor/app/core/models/request/manage_deliveryman_create_profile_request_model.dart';
import 'package:vendor/app/core/models/request/update_deliveryman_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/deliveryman_repository.dart';
import 'package:vendor/app/core/validations/deliveryman_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'manage_deliveryman_event.dart';
part 'manage_deliveryman_state.dart';

class ManageDeliverymanBloc extends Bloc<ManageDeliverymanEvent, ManageDeliverymanState> {
  final DeliverymanRepository _deliverymanRepository = DeliverymanRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ManageDeliverymanBloc()
    : super(
        ManageDeliverymanState(
          proof: IdentityProofModel(label: '', value: ''),
          initialData: ManageDeliverymanInitialResponseModel(locale: ''),
          deliverymanData: ManageDeliverymanInfoResponseModel(locale: ''),
          vehicle: DeliverymanVehicleConfigModel(locale: ''),
        ),
      ) {
    on<ManageDeliverymanInitialEvent>(_onManageDeliverymanInitialEvent);
    on<ManageDeliverymanCoverChangeEvent>(_onManageDeliverymanCoverChangeEvent);
    on<ManageDeliverymanFirstNameChangedEvent>(_onManageDeliverymanFirstNameChangedEvent);
    on<ManageDeliverymanFirstNameUnfocusedEvent>(_onManageDeliverymanFirstNameUnfocusedEvent);
    on<ManageDeliverymanLastNameChangedEvent>(_onManageDeliverymanLastNameChangedEvent);
    on<ManageDeliverymanLastNameUnfocusedEvent>(_onManageDeliverymanLastNameUnfocusedEvent);
    on<ManageDeliverymanEmailChangedEvent>(_onManageDeliverymanEmailChangedEvent);
    on<ManageDeliverymanEmailUnfocusedEvent>(_onManageDeliverymanEmailUnfocusedEvent);
    on<ManageDeliverymanPasswordChangedEvent>(_onManageDeliverymanPasswordChangedEvent);
    on<ManageDeliverymanPasswordUnfocusedEvent>(_onManageDeliverymanPasswordUnfocusedEvent);
    on<ManageDeliverymanCountryCodeChangedEvent>(_onManageDeliverymanCountryCodeChangedEvent);
    on<ManageDeliverymanCountryCodeUnfocusedEvent>(_onManageDeliverymanCountryCodeUnfocusedEvent);
    on<ManageDeliverymanMobileNumberChangedEvent>(_onManageDeliverymanMobileNumberChangedEvent);
    on<ManageDeliverymanMobileNumberUnfocusedEvent>(_onManageDeliverymanMobileNumberUnfocusedEvent);
    on<ManageDeliverymanAgeChangedEvent>(_onManageDeliverymanAgeChangedEvent);
    on<ManageDeliverymanAgeUnfocusedEvent>(_onManageDeliverymanAgeUnfocusedEvent);
    on<ManageDeliverymanIdentityNumberChangedEvent>(_onManageDeliverymanIdentityNumberChangedEvent);
    on<ManageDeliverymanIdentityNumberUnfocusedEvent>(_onManageDeliverymanIdentityNumberUnfocusedEvent);
    on<ManageDeliverymanDOBChangedEvent>(_onManageDeliverymanDOBChangedEvent);
    on<ManageDeliverymanDOBUnfocusedEvent>(_onManageDeliverymanDOBUnfocusedEvent);
    on<ManageDeliverymanIdentityProofChangeEvent>(_onManageDeliverymanIdentityProofChangeEvent);
    on<ManageDeliverymanDrivingLicenseChangeEvent>(_onManageDeliverymanDrivingLicenseChangeEvent);
    on<ManageDeliverymanChangeIdentityTypeEvent>(_onManageDeliverymanChangeIdentityTypeEvent);
    on<ManageDeliverymanChangeVehicleEvent>(_onManageDeliverymanChangeVehicleEvent);
    on<ManageDeliverymanSubmitEvent>(_onManageDeliverymanSubmitEvent);
  }

  FutureOr<void> _onManageDeliverymanInitialEvent(ManageDeliverymanInitialEvent event, Emitter<ManageDeliverymanState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_deliveryman"}, 'add_update_deliveryman_screen', 'add_update_deliveryman_screen');
    if (event.isNew) {
      try {
        final String vendorId = await _deliverymanRepository.getVendorId();
        emit(state.copyWith(status: ManageDeliverymanStatus.loading));
        DioApiResponse response = await _deliverymanRepository.getInitialData(vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ManageDeliverymanInitialResponseModel data = ManageDeliverymanInitialResponseModel.fromJson(myMap, locale.toString());
          String defaultCountryCode = '';
          String flag = '';
          await _deliverymanRepository.getDefaultCountryCode().then((value) {
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

          List<IdentityProofModel> proofList = <IdentityProofModel>[];
          proofList.clear();
          IdentityProofModel passport = IdentityProofModel(label: 'dd_passport', value: 'passport');
          IdentityProofModel license = IdentityProofModel(label: 'dd_driving_license', value: 'license');
          IdentityProofModel nic = IdentityProofModel(label: 'dd_nic', value: 'nic');
          proofList.add(passport);
          proofList.add(license);
          proofList.add(nic);
          emit(
            state.copyWith(
              deliverymanCountryCode: DeliverymanCountryCodeField.pure(defaultCountryCode),
              initialData: data,
              flag: flag,
              deliverymanId: event.deliverymanId,
              vehicle: data.vehicles!.isNotEmpty ? data.vehicles!.first : DeliverymanVehicleConfigModel(id: 'none', name: 'None', translations: [], locale: locale.toString()),
              vehicleList: data.vehicles!,
              proof: proofList.first,
              proofList: proofList,
              isNew: event.isNew,
              status: ManageDeliverymanStatus.success,
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageDeliverymanStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageDeliverymanStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      try {
        final String locale = await _accountRepository.getLocale();
        DioApiResponse response = await _deliverymanRepository.getDeliverymanInfo(event.deliverymanId);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ManageDeliverymanInfoResponseModel data = ManageDeliverymanInfoResponseModel.fromJson(myMap, locale.toString());
          List<IdentityProofModel> proofList = <IdentityProofModel>[];
          proofList.clear();
          IdentityProofModel passport = IdentityProofModel(label: 'dd_passport', value: 'passport');
          IdentityProofModel license = IdentityProofModel(label: 'dd_driving_license', value: 'license');
          IdentityProofModel nic = IdentityProofModel(label: 'dd_nic', value: 'nic');
          proofList.add(passport);
          proofList.add(license);
          proofList.add(nic);

          final int vehicleIndex = data.vehicles!.indexWhere((element) => element.id == data.info!.vehicle!);
          final int proofIndex = proofList.indexWhere((element) => element.value == data.info!.identity!);

          emit(state.copyWith(vehicleList: data.vehicles!));
          emit(
            state.copyWith(
              vehicle: vehicleIndex != -1 ? data.vehicles![vehicleIndex] : DeliverymanVehicleConfigModel(id: 'none', name: 'None', translations: [], locale: locale.toString()),
            ),
          );
          emit(state.copyWith(proof: proofIndex != -1 ? proofList[proofIndex] : proofList.first));
          const firstName = DeliverymanFirstNameField.dirty('none');
          const lastName = DeliverymanLastNameField.dirty('none');
          const email = DeliverymanEmailField.dirty('none@gmail.com');
          const password = DeliverymanPasswordField.dirty('none');
          const countryCode = DeliverymanCountryCodeField.dirty('none');
          const mobileNumber = DeliverymanMobileNumberField.dirty('none');
          final age = DeliverymanAgeField.dirty(data.info!.age!);
          final identityNumber = DeliverymanIdentityNumberField.dirty(data.info!.identityNumber!);
          DateTime parsedDate = DateTime.parse(data.info!.dob!);
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          final dob = DeliverymanDOBField.dirty(formattedDate);
          const cover = DeliverymanCoverField.dirty('none');
          final proof = DeliverymanIdentityProofField.dirty(data.info!.identityProof!);
          final drivingLicense = DeliverymanDrivingLicenseField.dirty(data.info!.drivingLicense!);
          emit(
            state.copyWith(
              deliverymanFirstName: firstName,
              deliverymanLastName: lastName,
              deliverymanEmail: email,
              deliverymanPassword: password,
              deliverymanCountryCode: countryCode,
              deliverymanMobile: mobileNumber,
              deliverymanAge: age,
              deliverymanIdentityNumber: identityNumber,
              deliverymanDOB: dob,
              deliverymanCover: cover,
              identityProof: proof,
              drivingLicense: drivingLicense,
              deliverymanId: event.deliverymanId,
              deliverymanData: data,
              proofList: proofList,
              isNew: event.isNew,
              status: ManageDeliverymanStatus.success,
              isValid: Formz.validate([firstName, lastName, email, password, countryCode, mobileNumber, age, identityNumber, dob, cover, proof, drivingLicense]),
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageDeliverymanStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageDeliverymanStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onManageDeliverymanCoverChangeEvent(ManageDeliverymanCoverChangeEvent event, Emitter<ManageDeliverymanState> emit) async {
    final deliverymanCover = DeliverymanCoverField.dirty(event.image);
    emit(
      state.copyWith(
        deliverymanCover: deliverymanCover.isValid ? deliverymanCover : DeliverymanCoverField.pure(event.image),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          deliverymanCover,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanFirstName,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanFirstNameChangedEvent(ManageDeliverymanFirstNameChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final firstName = DeliverymanFirstNameField.dirty(event.firstName);
    emit(
      state.copyWith(
        deliverymanFirstName: firstName.isValid ? firstName : DeliverymanFirstNameField.pure(event.firstName),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          firstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanFirstNameUnfocusedEvent(ManageDeliverymanFirstNameUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final firstName = DeliverymanFirstNameField.dirty(state.deliverymanFirstName.value);
    emit(
      state.copyWith(
        deliverymanFirstName: firstName,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          firstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanLastNameChangedEvent(ManageDeliverymanLastNameChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final lastName = DeliverymanLastNameField.dirty(event.lastName);
    emit(
      state.copyWith(
        deliverymanLastName: lastName.isValid ? lastName : DeliverymanLastNameField.pure(event.lastName),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          lastName,
          state.deliverymanFirstName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanLastNameUnfocusedEvent(ManageDeliverymanLastNameUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final lastName = DeliverymanLastNameField.dirty(state.deliverymanLastName.value);
    emit(
      state.copyWith(
        deliverymanLastName: lastName,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          lastName,
          state.deliverymanFirstName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanEmailChangedEvent(ManageDeliverymanEmailChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final email = DeliverymanEmailField.dirty(event.email);
    emit(
      state.copyWith(
        deliverymanEmail: email.isValid ? email : DeliverymanEmailField.pure(event.email),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          email,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanEmailUnfocusedEvent(ManageDeliverymanEmailUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final email = DeliverymanEmailField.dirty(state.deliverymanEmail.value);
    emit(
      state.copyWith(
        deliverymanEmail: email,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          email,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanPasswordChangedEvent(ManageDeliverymanPasswordChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final password = DeliverymanPasswordField.dirty(event.password);
    emit(
      state.copyWith(
        deliverymanPassword: password.isValid ? password : DeliverymanPasswordField.pure(event.password),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          password,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanPasswordUnfocusedEvent(ManageDeliverymanPasswordUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final password = DeliverymanPasswordField.dirty(state.deliverymanPassword.value);
    emit(
      state.copyWith(
        deliverymanPassword: password,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          password,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanCountryCodeChangedEvent(ManageDeliverymanCountryCodeChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final countryCode = DeliverymanCountryCodeField.dirty(event.countryCode);
    emit(
      state.copyWith(
        deliverymanCountryCode: countryCode.isValid ? countryCode : DeliverymanCountryCodeField.pure(event.countryCode),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          countryCode,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanCountryCodeUnfocusedEvent(ManageDeliverymanCountryCodeUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final countryCode = DeliverymanCountryCodeField.dirty(state.deliverymanCountryCode.value);
    emit(
      state.copyWith(
        deliverymanCountryCode: countryCode,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          countryCode,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanMobileNumberChangedEvent(ManageDeliverymanMobileNumberChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final mobileNumber = DeliverymanMobileNumberField.dirty(event.mobileNumber);
    emit(
      state.copyWith(
        deliverymanMobile: mobileNumber.isValid ? mobileNumber : DeliverymanMobileNumberField.pure(event.mobileNumber),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          mobileNumber,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanMobileNumberUnfocusedEvent(ManageDeliverymanMobileNumberUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final mobileNumber = DeliverymanMobileNumberField.dirty(state.deliverymanMobile.value);
    emit(
      state.copyWith(
        deliverymanMobile: mobileNumber,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          mobileNumber,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanAgeChangedEvent(ManageDeliverymanAgeChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final age = DeliverymanAgeField.dirty(event.age);
    emit(
      state.copyWith(
        deliverymanAge: age.isValid ? age : DeliverymanAgeField.pure(event.age),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          age,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanAgeUnfocusedEvent(ManageDeliverymanAgeUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final age = DeliverymanAgeField.dirty(state.deliverymanAge.value);
    emit(
      state.copyWith(
        deliverymanAge: age,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          age,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanIdentityNumber,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanIdentityNumberChangedEvent(ManageDeliverymanIdentityNumberChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final identity = DeliverymanIdentityNumberField.dirty(event.identity);
    emit(
      state.copyWith(
        deliverymanIdentityNumber: identity.isValid ? identity : DeliverymanIdentityNumberField.pure(event.identity),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          identity,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanIdentityNumberUnfocusedEvent(ManageDeliverymanIdentityNumberUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final identityNumber = DeliverymanIdentityNumberField.dirty(state.deliverymanIdentityNumber.value);
    emit(
      state.copyWith(
        deliverymanIdentityNumber: identityNumber,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          identityNumber,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanDOB,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanDOBChangedEvent(ManageDeliverymanDOBChangedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final dob = DeliverymanDOBField.dirty(event.dob);
    emit(
      state.copyWith(
        deliverymanDOB: dob.isValid ? dob : DeliverymanDOBField.pure(event.dob),
        status: ManageDeliverymanStatus.success,
        isValid: Formz.validate([
          dob,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanDOBUnfocusedEvent(ManageDeliverymanDOBUnfocusedEvent event, Emitter<ManageDeliverymanState> emit) async {
    final dob = DeliverymanDOBField.dirty(state.deliverymanDOB.value);
    emit(
      state.copyWith(
        deliverymanDOB: dob,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          dob,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanCover,
          state.identityProof,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanIdentityProofChangeEvent(ManageDeliverymanIdentityProofChangeEvent event, Emitter<ManageDeliverymanState> emit) async {
    final proof = DeliverymanIdentityProofField.dirty(event.image);
    emit(
      state.copyWith(
        identityProof: proof.isValid ? proof : DeliverymanIdentityProofField.pure(event.image),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          proof,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanCover,
          state.deliverymanDOB,
          state.drivingLicense,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanDrivingLicenseChangeEvent(ManageDeliverymanDrivingLicenseChangeEvent event, Emitter<ManageDeliverymanState> emit) async {
    final license = DeliverymanDrivingLicenseField.dirty(event.image);
    emit(
      state.copyWith(
        drivingLicense: license.isValid ? license : DeliverymanDrivingLicenseField.pure(event.image),
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([
          license,
          state.deliverymanFirstName,
          state.deliverymanLastName,
          state.deliverymanEmail,
          state.deliverymanPassword,
          state.deliverymanCountryCode,
          state.deliverymanMobile,
          state.deliverymanAge,
          state.deliverymanIdentityNumber,
          state.deliverymanCover,
          state.deliverymanDOB,
          state.identityProof,
        ]),
      ),
    );
  }

  FutureOr<void> _onManageDeliverymanChangeIdentityTypeEvent(ManageDeliverymanChangeIdentityTypeEvent event, Emitter<ManageDeliverymanState> emit) async {
    emit(state.copyWith(proof: event.type, status: ManageDeliverymanStatus.changeDetail));
  }

  FutureOr<void> _onManageDeliverymanChangeVehicleEvent(ManageDeliverymanChangeVehicleEvent event, Emitter<ManageDeliverymanState> emit) async {
    emit(state.copyWith(vehicle: event.vehicle, status: ManageDeliverymanStatus.changeDetail));
  }

  FutureOr<void> _onManageDeliverymanSubmitEvent(ManageDeliverymanSubmitEvent event, Emitter<ManageDeliverymanState> emit) async {
    final firstName = DeliverymanFirstNameField.dirty(state.deliverymanFirstName.value);
    final lastName = DeliverymanLastNameField.dirty(state.deliverymanLastName.value);
    final email = DeliverymanEmailField.dirty(state.deliverymanEmail.value);
    final password = DeliverymanPasswordField.dirty(state.deliverymanPassword.value);
    final countryCode = DeliverymanCountryCodeField.dirty(state.deliverymanCountryCode.value);
    final mobileNumber = DeliverymanMobileNumberField.dirty(state.deliverymanMobile.value);
    final age = DeliverymanAgeField.dirty(state.deliverymanAge.value);
    final identityNumber = DeliverymanIdentityNumberField.dirty(state.deliverymanIdentityNumber.value);
    final dob = DeliverymanDOBField.dirty(state.deliverymanDOB.value);
    final cover = DeliverymanCoverField.dirty(state.deliverymanCover.value);
    final proof = DeliverymanIdentityProofField.dirty(state.identityProof.value);
    final license = DeliverymanDrivingLicenseField.dirty(state.drivingLicense.value);
    emit(
      state.copyWith(
        deliverymanFirstName: firstName,
        deliverymanLastName: lastName,
        deliverymanEmail: email,
        deliverymanPassword: password,
        deliverymanCountryCode: countryCode,
        deliverymanMobile: mobileNumber,
        deliverymanAge: age,
        deliverymanIdentityNumber: identityNumber,
        deliverymanDOB: dob,
        deliverymanCover: cover,
        identityProof: proof,
        drivingLicense: license,
        status: ManageDeliverymanStatus.changeDetail,
        isValid: Formz.validate([firstName, lastName, email, password, countryCode, mobileNumber, age, identityNumber, dob, cover, proof, license]),
      ),
    );
    if (state.isValid &&
        state.deliverymanFirstName.value.isNotEmpty &&
        state.deliverymanLastName.value.isNotEmpty &&
        state.deliverymanEmail.value.isNotEmpty &&
        state.deliverymanPassword.value.isNotEmpty &&
        state.deliverymanCountryCode.value.isNotEmpty &&
        state.deliverymanMobile.value.isNotEmpty &&
        state.deliverymanAge.value.isNotEmpty &&
        state.deliverymanIdentityNumber.value.isNotEmpty &&
        state.deliverymanDOB.value.isNotEmpty &&
        state.deliverymanCover.value.isNotEmpty &&
        state.identityProof.value.isNotEmpty &&
        state.drivingLicense.value.isNotEmpty) {
      if (state.isNew) {
        try {
          emit(state.copyWith(status: ManageDeliverymanStatus.submit));
          final String vendorId = await _deliverymanRepository.getVendorId();
          ManageDeliverymanCreateProfileRequestModel param = ManageDeliverymanCreateProfileRequestModel(
            firstName: state.deliverymanFirstName.value.toString(),
            lastName: state.deliverymanLastName.value.toString(),
            email: state.deliverymanEmail.value.toString(),
            password: state.deliverymanPassword.value.toString(),
            countryCode: state.deliverymanCountryCode.value.toString(),
            mobile: state.deliverymanMobile.value.toString(),
            image: state.deliverymanCover.value.toString(),
            restaurant: vendorId,
            locality: state.initialData.info!.locality!,
            city: state.initialData.info!.city!,
            vehicle: state.vehicle.id!.toString(),
            latitude: 0,
            longitude: 0,
            identity: state.proof.value.toString(),
            identityNumber: state.deliverymanIdentityNumber.value.toString(),
            identityProof: state.identityProof.value.toString(),
            drivingLicense: state.drivingLicense.value.toString(),
            age: state.deliverymanAge.value.toString(),
            dob: state.deliverymanDOB.value.toString(),
          );
          DioApiResponse response = await _deliverymanRepository.saveDeliveryman(param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageDeliverymanStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageDeliverymanStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: ManageDeliverymanStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      } else {
        try {
          emit(state.copyWith(status: ManageDeliverymanStatus.update));
          UpdateDeliverymanRequestModel param = UpdateDeliverymanRequestModel(
            city: state.deliverymanData.info!.city!,
            locality: state.deliverymanData.info!.locality!,
            restaurant: state.deliverymanData.info!.restaurant!,
            age: state.deliverymanAge.value.toString(),
            identity: state.proof.value.toString(),
            identityNumber: state.deliverymanIdentityNumber.value.toString(),
            identityProof: state.identityProof.value.toString(),
            drivingLicense: state.drivingLicense.value.toString(),
            dob: state.deliverymanDOB.value.toString(),
            vehicle: state.vehicle.id!.toString(),
            latitude: state.deliverymanData.info!.location!.coordinates![1],
            longitude: state.deliverymanData.info!.location!.coordinates![0],
            locationType: 'Point',
            type: 'salary',
          );
          DioApiResponse response = await _deliverymanRepository.updateDEliveryman(state.deliverymanId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageDeliverymanStatus.updateSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageDeliverymanStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: ManageDeliverymanStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    }
  }
}
