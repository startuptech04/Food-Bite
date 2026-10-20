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

part of 'edit_profile_bloc.dart';

enum EditProfileStatus { loading, success, failure, changeDetail, submit, submitSuccess, submitFailed, uploadStarted, uploadIdentityProof, uploadDrivingLicense, uploadFailed, uploadSuccess }

extension EditProfileStatusX on EditProfileStatus {
  bool get isLoading => this == EditProfileStatus.loading;
  bool get isSuccess => this == EditProfileStatus.success;
  bool get isFailure => this == EditProfileStatus.failure;
  bool get isChangeDetail => this == EditProfileStatus.changeDetail;
  bool get isSubmit => this == EditProfileStatus.submit;
  bool get isSubmitSuccess => this == EditProfileStatus.submitSuccess;
  bool get isSubmitFailed => this == EditProfileStatus.submitFailed;
  bool get isUploadStarted => this == EditProfileStatus.uploadStarted;
  bool get isUploadIdentityProof => this == EditProfileStatus.uploadIdentityProof;
  bool get isUploadDrivingLicense => this == EditProfileStatus.uploadDrivingLicense;
  bool get isUploadFailed => this == EditProfileStatus.uploadFailed;
  bool get isUploadSuccess => this == EditProfileStatus.uploadSuccess;
}

final class EditProfileState {
  final String userId;
  final DriverProfileInfoResponseModel model;
  final String cityName;
  final String localityName;
  final String type;
  final String dob;
  final VehicleInfoConfigModel vehicle;
  final List<VehicleInfoConfigModel> vehicleList;
  final UserProfileEmailField email;
  final UserProfileFirstNameField firstName;
  final UserProfileLastNameField lastName;
  final UserProfileIdentityNumberField identityNumber;
  final UserProfileCountryCodeField countryCode;
  final String flag;
  final UserProfileMobileNumberField mobile;
  final String image;
  final EditProfileGenderModel gender;
  final bool isValid;
  final List<EditProfileGenderModel> genderList;
  final String identityProof;
  final String drivingLicense;
  final EditProfileIdentityTypeModel identity;
  final List<EditProfileIdentityTypeModel> identityList;
  final EditProfileStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const EditProfileState({
    this.userId = '',
    required this.model,
    this.cityName = '',
    this.localityName = '',
    this.type = '',
    this.dob = '',
    required this.vehicle,
    this.vehicleList = const [],
    this.email = const UserProfileEmailField.pure(),
    this.firstName = const UserProfileFirstNameField.pure(),
    this.lastName = const UserProfileLastNameField.pure(),
    this.countryCode = const UserProfileCountryCodeField.pure(),
    this.flag = '',
    this.mobile = const UserProfileMobileNumberField.pure(),
    this.image = '',
    required this.gender,
    this.isValid = false,
    this.genderList = const [],
    this.identityProof = '',
    this.drivingLicense = '',
    required this.identity,
    this.identityList = const [],
    this.identityNumber = const UserProfileIdentityNumberField.pure(),
    this.status = EditProfileStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  EditProfileState copyWith({
    String? userId,
    DriverProfileInfoResponseModel? model,
    String? cityName,
    String? localityName,
    VehicleInfoConfigModel? vehicle,
    List<VehicleInfoConfigModel>? vehicleList,
    UserProfileEmailField? email,
    UserProfileFirstNameField? firstName,
    UserProfileLastNameField? lastName,
    UserProfileCountryCodeField? countryCode,
    String? flag,
    UserProfileMobileNumberField? mobile,
    String? image,
    EditProfileGenderModel? gender,
    EditProfileIdentityTypeModel? identity,
    List<EditProfileIdentityTypeModel>? identityList,
    String? identityProof,
    String? drivingLicense,
    bool? isValid,
    List<EditProfileGenderModel>? genderList,
    UserProfileIdentityNumberField? identityNumber,
    EditProfileStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return EditProfileState(
      userId: userId ?? this.userId,
      model: model ?? this.model,
      cityName: cityName ?? this.cityName,
      localityName: localityName ?? this.localityName,
      vehicle: vehicle ?? this.vehicle,
      vehicleList: vehicleList ?? this.vehicleList,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      countryCode: countryCode ?? this.countryCode,
      flag: flag ?? this.flag,
      mobile: mobile ?? this.mobile,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      identity: identity ?? this.identity,
      identityList: identityList ?? this.identityList,
      identityProof: identityProof ?? this.identityProof,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      isValid: isValid ?? this.isValid,
      genderList: genderList ?? this.genderList,
      identityNumber: identityNumber ?? this.identityNumber,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}

class EditProfileGenderModel {
  String? label;
  String? value;

  EditProfileGenderModel({this.label, this.value});

  EditProfileGenderModel.fromJson(Map<String, dynamic> json) {
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

class EditProfileIdentityTypeModel {
  String? label;
  String? value;

  EditProfileIdentityTypeModel({this.label, this.value});

  EditProfileIdentityTypeModel.fromJson(Map<String, dynamic> json) {
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
