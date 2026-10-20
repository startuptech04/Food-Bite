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

enum RegisterRequestStatus {
  loading,
  fetched,
  basicFetched,
  locationChange,
  initial,
  submit,
  submitSuccess,
  payment,
  paymentSuccess,
  makePayment,
  failure,
  backPage,
  uploadStarted,
  uploadSuccess,
  uploadFailed,
  changeDetailFromModal,
  customError,
  localityFetching,
  localityFetched,
  localityFailed,
}

extension RegisterRequestStatusX on RegisterRequestStatus {
  bool get isLoading => this == RegisterRequestStatus.loading;
  bool get isFetched => this == RegisterRequestStatus.fetched;
  bool get isBasicFetched => this == RegisterRequestStatus.basicFetched;
  bool get isLocationChange => this == RegisterRequestStatus.locationChange;
  bool get isInitial => this == RegisterRequestStatus.initial;
  bool get isSubmit => this == RegisterRequestStatus.submit;
  bool get isSubmitSuccess => this == RegisterRequestStatus.submitSuccess;
  bool get isPayment => this == RegisterRequestStatus.payment;
  bool get isPaymentSuccess => this == RegisterRequestStatus.paymentSuccess;
  bool get isMakePayment => this == RegisterRequestStatus.makePayment;
  bool get isFailure => this == RegisterRequestStatus.failure;
  bool get isBackPage => this == RegisterRequestStatus.backPage;
  bool get isUploadStarted => this == RegisterRequestStatus.uploadStarted;
  bool get isUploadSuccess => this == RegisterRequestStatus.uploadSuccess;
  bool get isUploadFailed => this == RegisterRequestStatus.uploadFailed;
  bool get isChangeDetailFromModal => this == RegisterRequestStatus.changeDetailFromModal;
  bool get isCustomError => this == RegisterRequestStatus.customError;
  bool get isLocalityFetching => this == RegisterRequestStatus.localityFetching;
  bool get isLocalityFetched => this == RegisterRequestStatus.localityFetched;
  bool get isLocalityFailed => this == RegisterRequestStatus.localityFailed;
}

final class RegisterRequestState {
  final int currentPageIndex;
  final RegisterRequestBasicDetailModel model;
  final RegisterRequestNameField nameField;
  final RegisterRequestShortDescriptionField shortDescriptionField;
  final RegisterRequestAddressField addressField;
  final RegisterRequestCuisineField cuisineField;
  final RegisterRequestTypeField typeField;
  final RegisterRequestFacilitiesField facilitiesField;
  final RegisterRequestMinOrderAmountField minOrderAmountField;
  final RegisterRequestDishPriceForTwoField dishPriceForTwoField;
  final RegisterRequestFoodLicenseField licenseField;
  final RegisterRequestDeliveryTimeField deliveryTimeField;
  final RegisterRequestEmailField emailField;
  final RegisterRequestPasswordField passwordField;
  final RegisterRequestFirstNameField firstNameField;
  final RegisterRequestLastNameField lastNameField;
  final RegisterRequestCountryCodeField countryCodeField;
  final String flag;
  final RegisterRequestMobileNumberField mobileNumberField;
  final RegisterRequestLatitudeField latitudeField;
  final RegisterRequestLongitudeField longitudeField;
  final RegisterRequestCoverField coverField;
  final RegisterRequestLogoField logoField;
  final HomeDeliverySupportModel homeDelivery;
  final List<HomeDeliverySupportModel> homeDeliveryList;
  final TakeAwaySupportModel takeAway;
  final List<TakeAwaySupportModel> takeAwayList;
  final ScheduleOrderSupportModel scheduleOrder;
  final List<ScheduleOrderSupportModel> scheduleOrderList;
  final RegisterRequestCitiesModel selectedCity;
  final List<RegisterRequestCitiesModel> cityList;
  final LocalitiesFromCityModel selectedLocality;
  final List<LocalitiesFromCityModel> localityList;
  final RegisterRequestLicenseModel selectedLicense;
  final List<RegisterRequestLicenseModel> licenseList;
  final List<FormElementConfigModel> formField;
  final String cuisineNames;
  final String cuisineIds;
  final String typeName;
  final String typeIds;
  final String facilitiesName;
  final String facilitiesIds;
  final bool isValid;
  final bool isFormSubmitted;
  final String uploadingImageTag;
  final String formUploadingImageUUID;
  final String businessModel;
  final String selectedPackage;
  final bool haveTrial;
  final int trialPeriod;
  final double payAmount;
  final String paymentId;
  final List<RegisterRequestFormTranslations> translations;
  final String paymentURL;
  final String socialFacebook;
  final String socialInstagram;
  final String socialX;
  final String socialYoutube;
  final String socialLinkedIn;
  final String socialPinterest;
  final RegisterRequestStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const RegisterRequestState({
    this.currentPageIndex = 0,
    required this.model,
    this.nameField = const RegisterRequestNameField.pure(),
    this.shortDescriptionField = const RegisterRequestShortDescriptionField.pure(),
    this.addressField = const RegisterRequestAddressField.pure(),
    this.cuisineField = const RegisterRequestCuisineField.pure(),
    this.typeField = const RegisterRequestTypeField.pure(),
    this.facilitiesField = const RegisterRequestFacilitiesField.pure(),
    this.minOrderAmountField = const RegisterRequestMinOrderAmountField.pure(),
    this.dishPriceForTwoField = const RegisterRequestDishPriceForTwoField.pure(),
    this.licenseField = const RegisterRequestFoodLicenseField.pure(),
    this.deliveryTimeField = const RegisterRequestDeliveryTimeField.pure(),
    this.emailField = const RegisterRequestEmailField.pure(),
    this.passwordField = const RegisterRequestPasswordField.pure(),
    this.firstNameField = const RegisterRequestFirstNameField.pure(),
    this.lastNameField = const RegisterRequestLastNameField.pure(),
    this.countryCodeField = const RegisterRequestCountryCodeField.pure(),
    this.flag = '',
    this.mobileNumberField = const RegisterRequestMobileNumberField.pure(),
    this.latitudeField = const RegisterRequestLatitudeField.pure(),
    this.longitudeField = const RegisterRequestLongitudeField.pure(),
    this.coverField = const RegisterRequestCoverField.pure(),
    this.logoField = const RegisterRequestLogoField.pure(),
    required this.homeDelivery,
    this.homeDeliveryList = const [],
    required this.takeAway,
    this.takeAwayList = const [],
    required this.scheduleOrder,
    this.scheduleOrderList = const [],
    required this.selectedCity,
    this.cityList = const [],
    required this.selectedLocality,
    this.localityList = const [],
    required this.selectedLicense,
    this.licenseList = const [],
    this.formField = const [],
    this.cuisineNames = '',
    this.cuisineIds = '',
    this.typeName = '',
    this.typeIds = '',
    this.facilitiesName = '',
    this.facilitiesIds = '',
    this.isValid = false,
    this.isFormSubmitted = false,
    this.uploadingImageTag = 'logo',
    this.formUploadingImageUUID = '',
    this.businessModel = 'commission',
    this.selectedPackage = '',
    this.haveTrial = false,
    this.trialPeriod = 0,
    this.payAmount = 0.0,
    this.paymentId = '',
    this.translations = const [],
    this.paymentURL = '',
    this.socialFacebook = '',
    this.socialInstagram = '',
    this.socialX = '',
    this.socialYoutube = '',
    this.socialLinkedIn = '',
    this.socialPinterest = '',
    this.status = RegisterRequestStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  RegisterRequestState copyWith({
    int? currentPageIndex,
    RegisterRequestBasicDetailModel? model,
    RegisterRequestNameField? nameField,
    RegisterRequestShortDescriptionField? shortDescriptionField,
    RegisterRequestAddressField? addressField,
    RegisterRequestCuisineField? cuisineField,
    RegisterRequestTypeField? typeField,
    RegisterRequestFacilitiesField? facilitiesField,
    RegisterRequestMinOrderAmountField? minOrderAmountField,
    RegisterRequestDishPriceForTwoField? dishPriceForTwoField,
    RegisterRequestFoodLicenseField? licenseField,
    RegisterRequestDeliveryTimeField? deliveryTimeField,
    RegisterRequestEmailField? emailField,
    RegisterRequestPasswordField? passwordField,
    RegisterRequestFirstNameField? firstNameField,
    RegisterRequestLastNameField? lastNameField,
    RegisterRequestCountryCodeField? countryCodeField,
    String? flag,
    RegisterRequestMobileNumberField? mobileNumberField,
    RegisterRequestLatitudeField? latitudeField,
    RegisterRequestLongitudeField? longitudeField,
    RegisterRequestCoverField? coverField,
    RegisterRequestLogoField? logoField,
    HomeDeliverySupportModel? homeDelivery,
    List<HomeDeliverySupportModel>? homeDeliveryList,
    TakeAwaySupportModel? takeAway,
    List<TakeAwaySupportModel>? takeAwayList,
    ScheduleOrderSupportModel? scheduleOrder,
    List<ScheduleOrderSupportModel>? scheduleOrderList,
    RegisterRequestCitiesModel? selectedCity,
    List<RegisterRequestCitiesModel>? cityList,
    LocalitiesFromCityModel? selectedLocality,
    List<LocalitiesFromCityModel>? localityList,
    RegisterRequestLicenseModel? selectedLicense,
    List<RegisterRequestLicenseModel>? licenseList,
    List<FormElementConfigModel>? formField,
    String? cuisineNames,
    String? cuisineIds,
    String? typeName,
    String? typeIds,
    String? facilitiesName,
    String? facilitiesIds,
    bool? isValid,
    bool? isFormSubmitted,
    String? uploadingImageTag,
    String? formUploadingImageUUID,
    String? businessModel,
    String? selectedPackage,
    bool? haveTrial,
    int? trialPeriod,
    double? payAmount,
    String? paymentId,
    List<RegisterRequestFormTranslations>? translations,
    String? paymentURL,
    String? socialFacebook,
    String? socialInstagram,
    String? socialX,
    String? socialYoutube,
    String? socialLinkedIn,
    String? socialPinterest,
    RegisterRequestStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return RegisterRequestState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      model: model ?? this.model,
      nameField: nameField ?? this.nameField,
      shortDescriptionField: shortDescriptionField ?? this.shortDescriptionField,
      addressField: addressField ?? this.addressField,
      cuisineField: cuisineField ?? this.cuisineField,
      typeField: typeField ?? this.typeField,
      facilitiesField: facilitiesField ?? this.facilitiesField,
      minOrderAmountField: minOrderAmountField ?? this.minOrderAmountField,
      dishPriceForTwoField: dishPriceForTwoField ?? this.dishPriceForTwoField,
      licenseField: licenseField ?? this.licenseField,
      deliveryTimeField: deliveryTimeField ?? this.deliveryTimeField,
      emailField: emailField ?? this.emailField,
      passwordField: passwordField ?? this.passwordField,
      firstNameField: firstNameField ?? this.firstNameField,
      lastNameField: lastNameField ?? this.lastNameField,
      countryCodeField: countryCodeField ?? this.countryCodeField,
      flag: flag ?? this.flag,
      mobileNumberField: mobileNumberField ?? this.mobileNumberField,
      latitudeField: latitudeField ?? this.latitudeField,
      longitudeField: longitudeField ?? this.longitudeField,
      coverField: coverField ?? this.coverField,
      logoField: logoField ?? this.logoField,
      homeDelivery: homeDelivery ?? this.homeDelivery,
      homeDeliveryList: homeDeliveryList ?? this.homeDeliveryList,
      takeAway: takeAway ?? this.takeAway,
      takeAwayList: takeAwayList ?? this.takeAwayList,
      scheduleOrder: scheduleOrder ?? this.scheduleOrder,
      scheduleOrderList: scheduleOrderList ?? this.scheduleOrderList,
      selectedCity: selectedCity ?? this.selectedCity,
      cityList: cityList ?? this.cityList,
      selectedLocality: selectedLocality ?? this.selectedLocality,
      localityList: localityList ?? this.localityList,
      selectedLicense: selectedLicense ?? this.selectedLicense,
      licenseList: licenseList ?? this.licenseList,
      formField: formField ?? this.formField,
      cuisineNames: cuisineNames ?? this.cuisineNames,
      cuisineIds: cuisineIds ?? this.cuisineIds,
      typeName: typeName ?? this.typeName,
      typeIds: typeIds ?? this.typeIds,
      facilitiesName: facilitiesName ?? this.facilitiesName,
      facilitiesIds: facilitiesIds ?? this.facilitiesIds,
      isValid: isValid ?? this.isValid,
      isFormSubmitted: isFormSubmitted ?? this.isFormSubmitted,
      uploadingImageTag: uploadingImageTag ?? this.uploadingImageTag,
      formUploadingImageUUID: formUploadingImageUUID ?? this.formUploadingImageUUID,
      businessModel: businessModel ?? this.businessModel,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      haveTrial: haveTrial ?? this.haveTrial,
      trialPeriod: trialPeriod ?? this.trialPeriod,
      payAmount: payAmount ?? this.payAmount,
      paymentId: paymentId ?? this.paymentId,
      translations: translations ?? this.translations,
      paymentURL: paymentURL ?? this.paymentURL,
      socialFacebook: socialFacebook ?? this.socialFacebook,
      socialInstagram: socialInstagram ?? this.socialInstagram,
      socialX: socialX ?? this.socialX,
      socialYoutube: socialYoutube ?? this.socialYoutube,
      socialLinkedIn: socialLinkedIn ?? this.socialLinkedIn,
      socialPinterest: socialPinterest ?? this.socialPinterest,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class HomeDeliverySupportModel {
  bool? value;
  String? label;

  HomeDeliverySupportModel({this.value, this.label});

  HomeDeliverySupportModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    return data;
  }
}

class TakeAwaySupportModel {
  bool? value;
  String? label;

  TakeAwaySupportModel({this.value, this.label});

  TakeAwaySupportModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    return data;
  }
}

class ScheduleOrderSupportModel {
  bool? value;
  String? label;

  ScheduleOrderSupportModel({this.value, this.label});

  ScheduleOrderSupportModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
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
