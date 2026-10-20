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

part of 'register_request_bloc.dart';

enum RegisterRequestStatus { loading, fetched, basicFetched, initial, submit, submitSuccess, failure, uploadStarted, uploadSuccess, uploadFailed, customError, localityFetching, localityFetched, localityFailed }

extension RegisterRequestStatusX on RegisterRequestStatus {
  bool get isLoading => this == RegisterRequestStatus.loading;
  bool get isFetched => this == RegisterRequestStatus.fetched;
  bool get isBasicFetched => this == RegisterRequestStatus.basicFetched;
  bool get isInitial => this == RegisterRequestStatus.initial;
  bool get isSubmit => this == RegisterRequestStatus.submit;
  bool get isSubmitSuccess => this == RegisterRequestStatus.submitSuccess;
  bool get isFailure => this == RegisterRequestStatus.failure;
  bool get isUploadStarted => this == RegisterRequestStatus.uploadStarted;
  bool get isUploadSuccess => this == RegisterRequestStatus.uploadSuccess;
  bool get isUploadFailed => this == RegisterRequestStatus.uploadFailed;
  bool get isCustomError => this == RegisterRequestStatus.customError;
  bool get isLocalityFetching => this == RegisterRequestStatus.localityFetching;
  bool get isLocalityFetched => this == RegisterRequestStatus.localityFetched;
  bool get isLocalityFailed => this == RegisterRequestStatus.localityFailed;
}

final class RegisterRequestState {
  final RegisterRequestBasicDetailModel model;
  final RegisterRequestEmailField emailField;
  final RegisterRequestPasswordField passwordField;
  final RegisterRequestFirstNameField firstNameField;
  final RegisterRequestLastNameField lastNameField;
  final RegisterRequestCountryCodeField countryCodeField;
  final String flag;
  final RegisterRequestMobileNumberField mobileNumberField;
  final RegisterRequestCoverField coverImageField;
  final RegisterRequestIndentityProofField indentityProofField;
  final RegisterRequestAgeField ageField;
  final RegisterRequestDOBField dobField;
  final RegisterRequestIdentityNumberField identityNumberField;
  final RegisterRequestDrivingLicenseField drivingLicenseField;
  final RegisterRequestCitiesModel selectedCity;
  final List<RegisterRequestCitiesModel> cityList;
  final LocalitiesFromCityModel selectedLocality;
  final List<LocalitiesFromCityModel> localityList;
  final RegisterRequestLatitudeField latitudeField;
  final RegisterRequestLongitudeField longitudeField;
  final RegisterRequestVehicleModel selectedVehicle;
  final List<RegisterRequestVehicleModel> vehicleList;
  final RegisterRequestIdentityTypeModel identityType;
  final List<RegisterRequestIdentityTypeModel> identityTypeList;
  final RegisterRequestJobTypeModel jobType;
  final List<RegisterRequestJobTypeModel> jobTypeList;
  final List<FormElementConfigModel> formField;
  final bool isValid;
  final bool isFormSubmitted;
  final String uploadingImageTag;
  final String formUploadingImageUUID;
  final RegisterRequestStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const RegisterRequestState({
    required this.model,
    this.emailField = const RegisterRequestEmailField.pure(),
    this.passwordField = const RegisterRequestPasswordField.pure(),
    this.firstNameField = const RegisterRequestFirstNameField.pure(),
    this.lastNameField = const RegisterRequestLastNameField.pure(),
    this.countryCodeField = const RegisterRequestCountryCodeField.pure(),
    this.flag = '',
    this.mobileNumberField = const RegisterRequestMobileNumberField.pure(),
    this.coverImageField = const RegisterRequestCoverField.pure(),
    this.indentityProofField = const RegisterRequestIndentityProofField.pure(),
    this.ageField = const RegisterRequestAgeField.pure(),
    this.dobField = const RegisterRequestDOBField.pure(),
    this.identityNumberField = const RegisterRequestIdentityNumberField.pure(),
    this.drivingLicenseField = const RegisterRequestDrivingLicenseField.pure(),
    required this.selectedCity,
    this.cityList = const [],
    required this.selectedLocality,
    this.localityList = const [],
    this.latitudeField = const RegisterRequestLatitudeField.pure(),
    this.longitudeField = const RegisterRequestLongitudeField.pure(),
    required this.selectedVehicle,
    this.vehicleList = const [],
    required this.identityType,
    this.identityTypeList = const [],
    required this.jobType,
    this.jobTypeList = const [],
    this.formField = const [],
    this.isValid = false,
    this.isFormSubmitted = false,
    this.uploadingImageTag = 'cover',
    this.formUploadingImageUUID = '',
    this.status = RegisterRequestStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  RegisterRequestState copyWith({
    RegisterRequestBasicDetailModel? model,
    RegisterRequestEmailField? emailField,
    RegisterRequestPasswordField? passwordField,
    RegisterRequestFirstNameField? firstNameField,
    RegisterRequestLastNameField? lastNameField,
    RegisterRequestCountryCodeField? countryCodeField,
    String? flag,
    RegisterRequestMobileNumberField? mobileNumberField,
    RegisterRequestCoverField? coverImageField,
    RegisterRequestIndentityProofField? indentityProofField,
    RegisterRequestAgeField? ageField,
    RegisterRequestDOBField? dobField,
    RegisterRequestIdentityNumberField? identityNumberField,
    RegisterRequestDrivingLicenseField? drivingLicenseField,
    RegisterRequestCitiesModel? selectedCity,
    List<RegisterRequestCitiesModel>? cityList,
    LocalitiesFromCityModel? selectedLocality,
    List<LocalitiesFromCityModel>? localityList,
    RegisterRequestLatitudeField? latitudeField,
    RegisterRequestLongitudeField? longitudeField,
    RegisterRequestVehicleModel? selectedVehicle,
    List<RegisterRequestVehicleModel>? vehicleList,
    RegisterRequestIdentityTypeModel? identityType,
    List<RegisterRequestIdentityTypeModel>? identityTypeList,
    RegisterRequestJobTypeModel? jobType,
    List<RegisterRequestJobTypeModel>? jobTypeList,
    List<FormElementConfigModel>? formField,
    bool? isValid,
    bool? isFormSubmitted,
    String? uploadingImageTag,
    String? formUploadingImageUUID,
    RegisterRequestStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return RegisterRequestState(
      model: model ?? this.model,
      emailField: emailField ?? this.emailField,
      passwordField: passwordField ?? this.passwordField,
      firstNameField: firstNameField ?? this.firstNameField,
      lastNameField: lastNameField ?? this.lastNameField,
      countryCodeField: countryCodeField ?? this.countryCodeField,
      flag: flag ?? this.flag,
      mobileNumberField: mobileNumberField ?? this.mobileNumberField,
      coverImageField: coverImageField ?? this.coverImageField,
      indentityProofField: indentityProofField ?? this.indentityProofField,
      ageField: ageField ?? this.ageField,
      dobField: dobField ?? this.dobField,
      identityNumberField: identityNumberField ?? this.identityNumberField,
      drivingLicenseField: drivingLicenseField ?? this.drivingLicenseField,
      selectedCity: selectedCity ?? this.selectedCity,
      cityList: cityList ?? this.cityList,
      selectedLocality: selectedLocality ?? this.selectedLocality,
      localityList: localityList ?? this.localityList,
      latitudeField: latitudeField ?? this.latitudeField,
      longitudeField: longitudeField ?? this.longitudeField,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      vehicleList: vehicleList ?? this.vehicleList,
      identityType: identityType ?? this.identityType,
      identityTypeList: identityTypeList ?? this.identityTypeList,
      jobType: jobType ?? this.jobType,
      jobTypeList: jobTypeList ?? this.jobTypeList,
      formField: formField ?? this.formField,
      isValid: isValid ?? this.isValid,
      isFormSubmitted: isFormSubmitted ?? this.isFormSubmitted,
      uploadingImageTag: uploadingImageTag ?? this.uploadingImageTag,
      formUploadingImageUUID: formUploadingImageUUID ?? this.formUploadingImageUUID,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class RegisterRequestIdentityTypeModel {
  String? label;
  String? value;

  RegisterRequestIdentityTypeModel({this.label, this.value});

  RegisterRequestIdentityTypeModel.fromJson(Map<String, dynamic> json) {
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

class RegisterRequestJobTypeModel {
  String? label;
  String? value;

  RegisterRequestJobTypeModel({this.label, this.value});

  RegisterRequestJobTypeModel.fromJson(Map<String, dynamic> json) {
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

class FormElementConfigModel {
  String? uuid;
  bool? isRequired;
  String? type;
  String? title;
  String? placeholder;
  String? value;
  String? extraValue;
  List<FormElementItemConfigModel>? items;

  FormElementConfigModel({this.uuid, this.isRequired, this.type, this.title, this.placeholder, this.items, this.value, this.extraValue});

  FormElementConfigModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    if (json['isRequired'] != null && (json['isRequired'] == true || json['isRequired'] == 'true')) {
      isRequired = true;
    } else {
      isRequired = false;
    }
    type = json['type'];
    title = json['title'];
    placeholder = json['placeholder'];
    if (json['items'] != null) {
      items = <FormElementItemConfigModel>[];
      json['items'].forEach((v) {
        items!.add(FormElementItemConfigModel.fromJson(v));
      });
    }
    value = json['value'];
    extraValue = json['extraValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['isRequired'] = isRequired;
    data['type'] = type;
    data['title'] = title;
    data['placeholder'] = placeholder;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['value'] = value;
    data['extraValue'] = extraValue;
    return data;
  }
}

class FormElementItemConfigModel {
  String? name;
  bool? value;

  FormElementItemConfigModel({this.name, this.value});

  FormElementItemConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}
