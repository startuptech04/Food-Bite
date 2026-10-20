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

enum EditProfileStatus { loading, success, failure, changeDetail, submit, submitSuccess, submitFailed, uploadStarted, uploadFailed, uploadSuccess }

extension EditProfileStatusX on EditProfileStatus {
  bool get isLoading => this == EditProfileStatus.loading;
  bool get isSuccess => this == EditProfileStatus.success;
  bool get isFailure => this == EditProfileStatus.failure;
  bool get isChangeDetail => this == EditProfileStatus.changeDetail;
  bool get isSubmit => this == EditProfileStatus.submit;
  bool get isSubmitSuccess => this == EditProfileStatus.submitSuccess;
  bool get isSubmitFailed => this == EditProfileStatus.submitFailed;
  bool get isUploadStarted => this == EditProfileStatus.uploadStarted;
  bool get isUploadFailed => this == EditProfileStatus.uploadFailed;
  bool get isUploadSuccess => this == EditProfileStatus.uploadSuccess;
}

final class EditProfileState {
  final WaiterProfileReponseModel model;
  final String userId;
  final WaiterProfileEmailField email;
  final WaiterProfileFirstNameField firstName;
  final WaiterProfileLastNameField lastName;
  final WaiterProfileCountryCodeField countryCode;
  final String flag;
  final WaiterProfileMobileNumberField mobile;
  final String image;
  final WaiterGenderModel gender;
  final bool isValid;
  final List<WaiterGenderModel> genderList;
  final EditProfileStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const EditProfileState({
    required this.model,
    this.userId = '',
    this.email = const WaiterProfileEmailField.pure(),
    this.firstName = const WaiterProfileFirstNameField.pure(),
    this.lastName = const WaiterProfileLastNameField.pure(),
    this.countryCode = const WaiterProfileCountryCodeField.pure(),
    this.flag = '',
    this.mobile = const WaiterProfileMobileNumberField.pure(),
    this.image = '',
    required this.gender,
    this.isValid = false,
    this.genderList = const [],
    this.status = EditProfileStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  EditProfileState copyWith({
    WaiterProfileReponseModel? model,
    String? userId,
    WaiterProfileEmailField? email,
    WaiterProfileFirstNameField? firstName,
    WaiterProfileLastNameField? lastName,
    WaiterProfileCountryCodeField? countryCode,
    String? flag,
    WaiterProfileMobileNumberField? mobile,
    String? image,
    WaiterGenderModel? gender,
    bool? isValid,
    List<WaiterGenderModel>? genderList,
    EditProfileStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return EditProfileState(
      model: model ?? this.model,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      countryCode: countryCode ?? this.countryCode,
      flag: flag ?? this.flag,
      mobile: mobile ?? this.mobile,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      isValid: isValid ?? this.isValid,
      genderList: genderList ?? this.genderList,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
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
