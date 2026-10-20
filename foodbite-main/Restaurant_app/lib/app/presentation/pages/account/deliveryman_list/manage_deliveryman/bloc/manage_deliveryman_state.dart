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

part of 'manage_deliveryman_bloc.dart';

enum ManageDeliverymanStatus { loading, success, failure, changeDetail, submit, submitSuccess, submitFailed, update, updateSuccess, updateFailed }

extension ManageDeliverymanStatusX on ManageDeliverymanStatus {
  bool get isLoading => this == ManageDeliverymanStatus.loading;
  bool get isSuccess => this == ManageDeliverymanStatus.success;
  bool get isFailure => this == ManageDeliverymanStatus.failure;
  bool get isChangeDetail => this == ManageDeliverymanStatus.changeDetail;
  bool get isSubmit => this == ManageDeliverymanStatus.submit;
  bool get isSubmitSuccess => this == ManageDeliverymanStatus.submitSuccess;
  bool get isSubmitFailed => this == ManageDeliverymanStatus.submitFailed;
  bool get isUpdate => this == ManageDeliverymanStatus.update;
  bool get isUpdateSuccess => this == ManageDeliverymanStatus.updateSuccess;
  bool get isUpdateFailed => this == ManageDeliverymanStatus.updateFailed;
}

final class ManageDeliverymanState {
  final String deliverymanId;
  final ManageDeliverymanInitialResponseModel initialData;
  final ManageDeliverymanInfoResponseModel deliverymanData;
  final DeliverymanFirstNameField deliverymanFirstName;
  final DeliverymanLastNameField deliverymanLastName;
  final DeliverymanEmailField deliverymanEmail;
  final DeliverymanPasswordField deliverymanPassword;
  final DeliverymanCountryCodeField deliverymanCountryCode;
  final String flag;
  final DeliverymanMobileNumberField deliverymanMobile;
  final DeliverymanAgeField deliverymanAge;
  final IdentityProofModel proof;
  final List<IdentityProofModel> proofList;
  final DeliverymanIdentityNumberField deliverymanIdentityNumber;
  final DeliverymanDOBField deliverymanDOB;
  final DeliverymanCoverField deliverymanCover;
  final DeliverymanIdentityProofField identityProof;
  final DeliverymanDrivingLicenseField drivingLicense;
  final DeliverymanVehicleConfigModel vehicle;
  final List<DeliverymanVehicleConfigModel> vehicleList;
  final bool isNew;
  final bool isValid;
  final ManageDeliverymanStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ManageDeliverymanState({
    this.deliverymanId = '',
    required this.initialData,
    required this.deliverymanData,
    this.deliverymanFirstName = const DeliverymanFirstNameField.pure(),
    this.deliverymanLastName = const DeliverymanLastNameField.pure(),
    this.deliverymanEmail = const DeliverymanEmailField.pure(),
    this.deliverymanPassword = const DeliverymanPasswordField.pure(),
    this.deliverymanCountryCode = const DeliverymanCountryCodeField.pure(),
    this.flag = '',
    this.deliverymanMobile = const DeliverymanMobileNumberField.pure(),
    this.deliverymanAge = const DeliverymanAgeField.pure(),
    required this.proof,
    this.proofList = const [],
    this.deliverymanIdentityNumber = const DeliverymanIdentityNumberField.pure(),
    this.deliverymanDOB = const DeliverymanDOBField.pure(),
    this.deliverymanCover = const DeliverymanCoverField.pure(),
    this.identityProof = const DeliverymanIdentityProofField.pure(),
    this.drivingLicense = const DeliverymanDrivingLicenseField.pure(),
    required this.vehicle,
    this.vehicleList = const [],
    this.isNew = false,
    this.isValid = false,
    this.status = ManageDeliverymanStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ManageDeliverymanState copyWith({
    String? deliverymanId,
    ManageDeliverymanInitialResponseModel? initialData,
    ManageDeliverymanInfoResponseModel? deliverymanData,
    DeliverymanFirstNameField? deliverymanFirstName,
    DeliverymanLastNameField? deliverymanLastName,
    DeliverymanEmailField? deliverymanEmail,
    DeliverymanPasswordField? deliverymanPassword,
    DeliverymanCountryCodeField? deliverymanCountryCode,
    String? flag,
    DeliverymanMobileNumberField? deliverymanMobile,
    DeliverymanAgeField? deliverymanAge,
    IdentityProofModel? proof,
    List<IdentityProofModel>? proofList,
    DeliverymanIdentityNumberField? deliverymanIdentityNumber,
    DeliverymanDOBField? deliverymanDOB,
    DeliverymanCoverField? deliverymanCover,
    DeliverymanIdentityProofField? identityProof,
    DeliverymanDrivingLicenseField? drivingLicense,
    DeliverymanVehicleConfigModel? vehicle,
    List<DeliverymanVehicleConfigModel>? vehicleList,
    bool? isNew,
    bool? isValid,
    ManageDeliverymanStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ManageDeliverymanState(
      deliverymanId: deliverymanId ?? this.deliverymanId,
      initialData: initialData ?? this.initialData,
      deliverymanData: deliverymanData ?? this.deliverymanData,
      deliverymanFirstName: deliverymanFirstName ?? this.deliverymanFirstName,
      deliverymanLastName: deliverymanLastName ?? this.deliverymanLastName,
      deliverymanEmail: deliverymanEmail ?? this.deliverymanEmail,
      deliverymanPassword: deliverymanPassword ?? this.deliverymanPassword,
      deliverymanCountryCode: deliverymanCountryCode ?? this.deliverymanCountryCode,
      flag: flag ?? this.flag,
      deliverymanMobile: deliverymanMobile ?? this.deliverymanMobile,
      deliverymanAge: deliverymanAge ?? this.deliverymanAge,
      proof: proof ?? this.proof,
      proofList: proofList ?? this.proofList,
      deliverymanIdentityNumber: deliverymanIdentityNumber ?? this.deliverymanIdentityNumber,
      deliverymanDOB: deliverymanDOB ?? this.deliverymanDOB,
      deliverymanCover: deliverymanCover ?? this.deliverymanCover,
      identityProof: identityProof ?? this.identityProof,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      vehicle: vehicle ?? this.vehicle,
      vehicleList: vehicleList ?? this.vehicleList,
      isNew: isNew ?? this.isNew,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class IdentityProofModel {
  String? label;
  String? value;

  IdentityProofModel({this.label, this.value});

  IdentityProofModel.fromJson(Map<String, dynamic> json) {
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
