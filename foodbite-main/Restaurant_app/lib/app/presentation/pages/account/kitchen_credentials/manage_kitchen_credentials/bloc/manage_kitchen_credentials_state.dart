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

part of 'manage_kitchen_credentials_bloc.dart';

enum ManageKitchenCredentialsStatus { loading, success, failure, changeDetail, submit, fetched, submitSuccess, submitFailed, update, updateSuccess, updateFailed }

extension ManageKitchenCredentialsStatusX on ManageKitchenCredentialsStatus {
  bool get isLoading => this == ManageKitchenCredentialsStatus.loading;
  bool get isSuccess => this == ManageKitchenCredentialsStatus.success;
  bool get isFailure => this == ManageKitchenCredentialsStatus.failure;
  bool get isChangeDetail => this == ManageKitchenCredentialsStatus.changeDetail;
  bool get isSubmit => this == ManageKitchenCredentialsStatus.submit;
  bool get isFetched => this == ManageKitchenCredentialsStatus.fetched;
  bool get isSubmitSuccess => this == ManageKitchenCredentialsStatus.submitSuccess;
  bool get isSubmitFailed => this == ManageKitchenCredentialsStatus.submitFailed;
  bool get isUpdate => this == ManageKitchenCredentialsStatus.update;
  bool get isUpdateSuccess => this == ManageKitchenCredentialsStatus.updateSuccess;
  bool get isUpdateFailed => this == ManageKitchenCredentialsStatus.updateFailed;
}

final class ManageKitchenCredentialsState {
  final String kitchenId;
  final KitchenOwnerInfoResponseModel model;
  final KitchenOwnerFirstNameField kitchenOwnerFirstName;
  final KitchenOwnerLastNameField kitchenOwnerLastName;
  final KitchenOwnerEmailField kitchenOwnerEmail;
  final KitchenOwnerPasswordField kitchenOwnerPassword;
  final KitchenOwnerCountryCodeField kitchenOwnerCountryCode;
  final String flag;
  final KitchenOwnerMobileNumberField kitchenOwnerMobile;
  final KitchenOwnerCoverField kitchenOwnerCover;
  final KitchenOwnerGenderModel kitchenOwnerGender;
  final List<KitchenOwnerGenderModel> kitchenOwnerGenderList;
  final bool isNew;
  final bool isValid;
  final ManageKitchenCredentialsStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ManageKitchenCredentialsState({
    this.kitchenId = '',
    required this.model,
    this.kitchenOwnerFirstName = const KitchenOwnerFirstNameField.pure(),
    this.kitchenOwnerLastName = const KitchenOwnerLastNameField.pure(),
    this.kitchenOwnerEmail = const KitchenOwnerEmailField.pure(),
    this.kitchenOwnerPassword = const KitchenOwnerPasswordField.pure(),
    this.kitchenOwnerCountryCode = const KitchenOwnerCountryCodeField.pure(),
    this.flag = '',
    this.kitchenOwnerMobile = const KitchenOwnerMobileNumberField.pure(),
    this.kitchenOwnerCover = const KitchenOwnerCoverField.pure(),
    required this.kitchenOwnerGender,
    this.kitchenOwnerGenderList = const [],
    this.isNew = false,
    this.isValid = false,
    this.status = ManageKitchenCredentialsStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ManageKitchenCredentialsState copyWith({
    String? kitchenId,
    KitchenOwnerInfoResponseModel? model,
    KitchenOwnerFirstNameField? kitchenOwnerFirstName,
    KitchenOwnerLastNameField? kitchenOwnerLastName,
    KitchenOwnerEmailField? kitchenOwnerEmail,
    KitchenOwnerPasswordField? kitchenOwnerPassword,
    KitchenOwnerCountryCodeField? kitchenOwnerCountryCode,
    String? flag,
    KitchenOwnerMobileNumberField? kitchenOwnerMobile,
    KitchenOwnerCoverField? kitchenOwnerCover,
    KitchenOwnerGenderModel? kitchenOwnerGender,
    List<KitchenOwnerGenderModel>? kitchenOwnerGenderList,
    bool? isNew,
    bool? isValid,
    ManageKitchenCredentialsStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ManageKitchenCredentialsState(
      kitchenId: kitchenId ?? this.kitchenId,
      model: model ?? this.model,
      kitchenOwnerFirstName: kitchenOwnerFirstName ?? this.kitchenOwnerFirstName,
      kitchenOwnerLastName: kitchenOwnerLastName ?? this.kitchenOwnerLastName,
      kitchenOwnerEmail: kitchenOwnerEmail ?? this.kitchenOwnerEmail,
      kitchenOwnerPassword: kitchenOwnerPassword ?? this.kitchenOwnerPassword,
      kitchenOwnerCountryCode: kitchenOwnerCountryCode ?? this.kitchenOwnerCountryCode,
      flag: flag ?? this.flag,
      kitchenOwnerMobile: kitchenOwnerMobile ?? this.kitchenOwnerMobile,
      kitchenOwnerCover: kitchenOwnerCover ?? this.kitchenOwnerCover,
      kitchenOwnerGender: kitchenOwnerGender ?? this.kitchenOwnerGender,
      kitchenOwnerGenderList: kitchenOwnerGenderList ?? this.kitchenOwnerGenderList,
      isNew: isNew ?? this.isNew,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class KitchenOwnerGenderModel {
  String? label;
  String? value;

  KitchenOwnerGenderModel({this.label, this.value});

  KitchenOwnerGenderModel.fromJson(Map<String, dynamic> json) {
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
