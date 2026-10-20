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

part of 'manage_waiter_bloc.dart';

enum ManageWaiterStatus { loading, success, failure, changeDetail, submit, fetched, submitSuccess, submitFailed, update, updateSuccess, updateFailed }

extension ManageWaiterStatusX on ManageWaiterStatus {
  bool get isLoading => this == ManageWaiterStatus.loading;
  bool get isSuccess => this == ManageWaiterStatus.success;
  bool get isFailure => this == ManageWaiterStatus.failure;
  bool get isChangeDetail => this == ManageWaiterStatus.changeDetail;
  bool get isSubmit => this == ManageWaiterStatus.submit;
  bool get isFetched => this == ManageWaiterStatus.fetched;
  bool get isSubmitSuccess => this == ManageWaiterStatus.submitSuccess;
  bool get isSubmitFailed => this == ManageWaiterStatus.submitFailed;
  bool get isUpdate => this == ManageWaiterStatus.update;
  bool get isUpdateSuccess => this == ManageWaiterStatus.updateSuccess;
  bool get isUpdateFailed => this == ManageWaiterStatus.updateFailed;
}

final class ManageWaiterState {
  final String waiterId;
  final WaiterInfoResponseModel model;
  final WaiterFirstNameField waiterFirstName;
  final WaiterLastNameField waiterLastName;
  final WaiterEmailField waiterEmail;
  final WaiterPasswordField waiterPassword;
  final WaiterCountryCodeField waiterCountryCode;
  final String flag;
  final WaiterMobileNumberField waiterMobile;
  final WaiterCoverField waiterCover;
  final WaiterGenderModel waiterGender;
  final List<WaiterGenderModel> waiterGenderList;
  final bool isNew;
  final bool isValid;
  final ManageWaiterStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ManageWaiterState({
    this.waiterId = '',
    required this.model,
    this.waiterFirstName = const WaiterFirstNameField.pure(),
    this.waiterLastName = const WaiterLastNameField.pure(),
    this.waiterEmail = const WaiterEmailField.pure(),
    this.waiterPassword = const WaiterPasswordField.pure(),
    this.waiterCountryCode = const WaiterCountryCodeField.pure(),
    this.flag = '',
    this.waiterMobile = const WaiterMobileNumberField.pure(),
    this.waiterCover = const WaiterCoverField.pure(),
    required this.waiterGender,
    this.waiterGenderList = const [],
    this.isNew = false,
    this.isValid = false,
    this.status = ManageWaiterStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ManageWaiterState copyWith({
    String? waiterId,
    WaiterInfoResponseModel? model,
    WaiterFirstNameField? waiterFirstName,
    WaiterLastNameField? waiterLastName,
    WaiterEmailField? waiterEmail,
    WaiterPasswordField? waiterPassword,
    WaiterCountryCodeField? waiterCountryCode,
    String? flag,
    WaiterMobileNumberField? waiterMobile,
    WaiterCoverField? waiterCover,
    WaiterGenderModel? waiterGender,
    List<WaiterGenderModel>? waiterGenderList,
    bool? isNew,
    bool? isValid,
    ManageWaiterStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ManageWaiterState(
      waiterId: waiterId ?? this.waiterId,
      model: model ?? this.model,
      waiterFirstName: waiterFirstName ?? this.waiterFirstName,
      waiterLastName: waiterLastName ?? this.waiterLastName,
      waiterEmail: waiterEmail ?? this.waiterEmail,
      waiterPassword: waiterPassword ?? this.waiterPassword,
      waiterCountryCode: waiterCountryCode ?? this.waiterCountryCode,
      flag: flag ?? this.flag,
      waiterMobile: waiterMobile ?? this.waiterMobile,
      waiterCover: waiterCover ?? this.waiterCover,
      waiterGender: waiterGender ?? this.waiterGender,
      waiterGenderList: waiterGenderList ?? this.waiterGenderList,
      isNew: isNew ?? this.isNew,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class WaiterGenderModel {
  String? label;
  String? value;

  WaiterGenderModel({this.label, this.value});

  WaiterGenderModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
