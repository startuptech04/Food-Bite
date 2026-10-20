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
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/payout_method_detail_model.dart';
import 'package:vendor/app/core/models/payout_method_list_model.dart';
import 'package:vendor/app/core/models/payout_method_model.dart';
import 'package:vendor/app/core/models/request/payout_field_value_request_model.dart';
import 'package:vendor/app/core/models/request/save_payout_method_request_model.dart';
import 'package:vendor/app/core/models/request/update_payout_method_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/wallet_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'manage_payout_method_event.dart';
part 'manage_payout_method_state.dart';

class ManagePayoutMethodBloc extends Bloc<ManagePayoutMethodEvent, ManagePayoutMethodState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ManagePayoutMethodBloc() : super(ManagePayoutMethodState(detail: PayoutMethodDetailModel())) {
    on<ManagePayoutMethodInitialEvent>(_onManagePayoutMethodInitialEvent);
    on<ManagePayoutMethodChangeEvent>(_onManagePayoutMethodChangeEvent);
    on<ManagePayoutMethodTextInputChangeEvent>(_onManagePayoutMethodTextInputChangeEvent);
    on<ManagePayoutMethodCountryCodeChangeEvent>(_onManagePayoutMethodCountryCodeChangeEvent);
    on<ManagePayoutMethodSubmitEvent>(_onManagePayoutMethodSubmitEvent);
  }

  FutureOr<void> _onManagePayoutMethodInitialEvent(ManagePayoutMethodInitialEvent event, Emitter<ManagePayoutMethodState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_payout_method"}, 'add_update_payout_method_screen', 'add_update_payout_method_screen');
    if (event.isNew) {
      try {
        emit(state.copyWith(status: ManagePayoutMethodStatus.loading));
        DioApiResponse response = await _walletRepository.payoutMethodList();
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          PayoutMethodListModel data = PayoutMethodListModel.fromJson(myMap, locale.toString());
          List<PayoutMethodConfigModel> methods = <PayoutMethodConfigModel>[];
          List<FormElementConfigModel> formElements = <FormElementConfigModel>[];
          for (var element in data.methods!) {
            methods.add(element);
          }
          String defaultCountryCode = '';
          String flag = '';
          await _walletRepository.getDefaultCountryCode().then((value) {
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
          String methodId = '';
          if (methods.isNotEmpty) {
            final int defaultPayoutMethod = methods.indexWhere((method) => method.isDefault! == true);
            if (defaultPayoutMethod != -1) {
              methodId = methods[defaultPayoutMethod].id!;
            } else {
              methodId = methods.first.id!;
            }
            if (methodId.isNotEmpty) {
              formElements.clear();
              final indexOfMethod = methods.indexWhere((method) => method.id! == methodId);
              for (var element in methods[indexOfMethod].formElement!) {
                FormElementConfigModel fieldElement = FormElementConfigModel(
                  isRequired: element.isRequired!,
                  fieldType: element.fieldType!,
                  fieldName: element.fieldName!,
                  placeholder: element.placeholder!,
                  value: '',
                  extraValue: element.fieldType == 'phone' ? defaultCountryCode : '',
                );
                formElements.add(fieldElement);
              }
            }
          }

          emit(
            state.copyWith(
              methods: methods,
              formField: formElements,
              methodId: methodId,
              isNew: event.isNew,
              flag: flag,
              countryCode: defaultCountryCode,
              status: methods.isNotEmpty ? ManagePayoutMethodStatus.success : ManagePayoutMethodStatus.empty,
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManagePayoutMethodStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManagePayoutMethodStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      try {
        emit(state.copyWith(status: ManagePayoutMethodStatus.loading, payoutId: event.id));
        DioApiResponse response = await _walletRepository.getPayoutMethodDetail(event.id);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          PayoutMethodDetailModel data = PayoutMethodDetailModel.fromJson(myMap);
          List<FormElementConfigModel> formElements = <FormElementConfigModel>[];
          data.methodData!.methodDetail!.methodFormElement!.forEach(((element) {
            FormElementConfigModel fieldElement = FormElementConfigModel(isRequired: element.isRequired!, fieldType: element.fieldType!, fieldName: element.fieldName!, placeholder: element.placeholder!, value: '', extraValue: '');
            formElements.add(fieldElement);
          }));
          String defaultCountryCode = '';
          String flag = '';
          await _walletRepository.getDefaultCountryCode().then((value) {
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
          for (var formElement in data.methodData!.formElement!) {
            for (var element in formElements) {
              final String formElementName = '${formElement.fieldName}-${formElement.fieldType}';
              final String methodFormElementName = '${element.fieldName}-${element.fieldType}';
              if (formElementName == methodFormElementName) {
                if (element.fieldType! != 'phone') {
                  element.value = formElement.fieldValue!;
                } else {
                  if (formElement.fieldValue!.isNotEmpty) {
                    List<String> splitNumber = formElement.fieldValue!.split(' ');
                    if (splitNumber.length == 2) {
                      element.extraValue = splitNumber[0];
                      element.value = splitNumber[1];
                    } else {
                      element.extraValue = defaultCountryCode;
                      element.value = formElement.fieldValue!;
                    }
                  }
                }
              }
            }
          }
          emit(state.copyWith(formField: formElements, isNew: event.isNew, countryCode: defaultCountryCode, flag: flag, status: ManagePayoutMethodStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManagePayoutMethodStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManagePayoutMethodStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onManagePayoutMethodChangeEvent(ManagePayoutMethodChangeEvent event, Emitter<ManagePayoutMethodState> emit) async {
    try {
      List<FormElementConfigModel> formElements = <FormElementConfigModel>[];
      formElements.clear();
      final indexOfMethod = state.methods.indexWhere((method) => method.id! == event.methodId);
      for (var element in state.methods[indexOfMethod].formElement!) {
        FormElementConfigModel fieldElement = FormElementConfigModel(
          isRequired: element.isRequired!,
          fieldType: element.fieldType!,
          fieldName: element.fieldName!,
          placeholder: element.placeholder!,
          value: '',
          extraValue: element.fieldType == 'phone' ? state.countryCode : '',
        );
        formElements.add(fieldElement);
      }
      emit(state.copyWith(formField: formElements, methodId: event.methodId, isFormSubmitted: false, status: ManagePayoutMethodStatus.changeDetail));
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ManagePayoutMethodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onManagePayoutMethodTextInputChangeEvent(ManagePayoutMethodTextInputChangeEvent event, Emitter<ManagePayoutMethodState> emit) async {
    state.formField[event.formIndex].value = event.value;
    emit(state.copyWith(formField: [...state.formField], status: ManagePayoutMethodStatus.changeDetail));
  }

  FutureOr<void> _onManagePayoutMethodCountryCodeChangeEvent(ManagePayoutMethodCountryCodeChangeEvent event, Emitter<ManagePayoutMethodState> emit) async {
    state.formField[event.formIndex].extraValue = event.value;
    emit(state.copyWith(formField: [...state.formField], status: ManagePayoutMethodStatus.changeDetail));
  }

  FutureOr<void> _onManagePayoutMethodSubmitEvent(ManagePayoutMethodSubmitEvent event, Emitter<ManagePayoutMethodState> emit) async {
    try {
      emit(state.copyWith(isFormSubmitted: true, status: ManagePayoutMethodStatus.changeDetail));
      final int indexOfRequiredField = state.formField.indexWhere((element) => element.isRequired! == true && element.value == '');
      if (indexOfRequiredField == -1) {
        List<PayoutFieldValueRequestModel> fieldValueArray = <PayoutFieldValueRequestModel>[];
        fieldValueArray.clear();
        for (var element in state.formField) {
          PayoutFieldValueRequestModel fieldValueParam = PayoutFieldValueRequestModel(
            fieldName: element.fieldName!,
            fieldType: element.fieldType!,
            fieldValue: element.fieldType == 'phone' ? '${element.extraValue} ${element.value!}' : element.value!,
          );
          fieldValueArray.add(fieldValueParam);
        }
        if (state.isNew) {
          try {
            SavePayoutMethodRequestModel param = SavePayoutMethodRequestModel(method: state.methodId, restaurant: await _walletRepository.getVendorId(), formElement: fieldValueArray);
            emit(state.copyWith(status: ManagePayoutMethodStatus.submit));
            DioApiResponse response = await _walletRepository.savePayoutMethod(param);
            if (response.errorType == NetErrorType.none) {
              emit(state.copyWith(status: ManagePayoutMethodStatus.submitSuccess));
            } else {
              Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
              ServerErrorModel data = ServerErrorModel.fromJson(myMap);
              emit(state.copyWith(status: ManagePayoutMethodStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
            }
          } catch (e, stacktrace) {
            emit(state.copyWith(status: ManagePayoutMethodStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
            if (!kIsWeb) {
              FirebaseCrashlytics.instance.recordError(e, stacktrace);
            }
          }
        } else {
          try {
            UpdatePayoutMethodRequestModel param = UpdatePayoutMethodRequestModel(id: state.payoutId, restaurant: await _walletRepository.getVendorId(), formElement: fieldValueArray);
            emit(state.copyWith(status: ManagePayoutMethodStatus.submit));
            DioApiResponse response = await _walletRepository.updatePayoutMethodDetail(param);
            if (response.errorType == NetErrorType.none) {
              emit(state.copyWith(status: ManagePayoutMethodStatus.updateSuccess));
            } else {
              Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
              ServerErrorModel data = ServerErrorModel.fromJson(myMap);
              emit(state.copyWith(status: ManagePayoutMethodStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
            }
          } catch (e, stacktrace) {
            emit(state.copyWith(status: ManagePayoutMethodStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
            if (!kIsWeb) {
              FirebaseCrashlytics.instance.recordError(e, stacktrace);
            }
          }
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ManagePayoutMethodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
