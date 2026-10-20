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

part of 'manage_outlet_bloc.dart';

enum ManageOutletStatus { loading, fetched, basicFetched, locationChange, initial, submit, submitSuccess, failure, changeDetailFromModal, customError }

extension ManageOutletStatusX on ManageOutletStatus {
  bool get isLoading => this == ManageOutletStatus.loading;
  bool get isFetched => this == ManageOutletStatus.fetched;
  bool get isBasicFetched => this == ManageOutletStatus.basicFetched;
  bool get isLocationChange => this == ManageOutletStatus.locationChange;
  bool get isInitial => this == ManageOutletStatus.initial;
  bool get isSubmit => this == ManageOutletStatus.submit;
  bool get isSubmitSuccess => this == ManageOutletStatus.submitSuccess;
  bool get isFailure => this == ManageOutletStatus.failure;
  bool get isChangeDetailFromModal => this == ManageOutletStatus.changeDetailFromModal;
  bool get isCustomError => this == ManageOutletStatus.customError;
}

final class ManageOutletState {
  final bool isNew;
  final String outletId;
  final NewOutletBasicDetailModel basicDetail;
  final OutletDetailResponseModel outletDetail;
  final OutletNameField nameField;
  final OutletShortDescriptionField shortDescriptionField;
  final OutletAddressField addressField;
  final OutletCuisineField cuisineField;
  final OutletTypeField typeField;
  final OutletFacilitiesField facilitiesField;
  final OutletMinOrderAmountField minOrderAmountField;
  final OutletDishPriceForTwoField dishPriceForTwoField;
  final OutletFoodLicenseField licenseField;
  final OutletDeliveryTimeField deliveryTimeField;
  final OutletEmailField emailField;
  final OutletPasswordField passwordField;
  final OutletFirstNameField firstNameField;
  final OutletLastNameField lastNameField;
  final OutletCountryCodeField countryCodeField;
  final String flag;
  final OutletMobileNumberField mobileNumberField;
  final OutletLatitudeField latitudeField;
  final OutletLongitudeField longitudeField;
  final OutletCoverField coverField;
  final OutletLogoField logoField;
  final HomeDeliverySupportModel homeDelivery;
  final List<HomeDeliverySupportModel> homeDeliveryList;
  final TakeAwaySupportModel takeAway;
  final List<TakeAwaySupportModel> takeAwayList;
  final ScheduleOrderSupportModel scheduleOrder;
  final List<ScheduleOrderSupportModel> scheduleOrderList;
  final OutletCitiesResponseModel selectedCity;
  final List<OutletCitiesResponseModel> cityList;
  final OutletLocalitiesResponseModel selectedLocality;
  final List<OutletLocalitiesResponseModel> localityList;
  final OutletLicenseResponseModel selectedLicense;
  final List<OutletLicenseResponseModel> licenseList;
  final String cuisineNames;
  final String cuisineIds;
  final String typeName;
  final String typeIds;
  final String facilitiesName;
  final String facilitiesIds;
  final String socialFacebook;
  final String socialInstagram;
  final String socialX;
  final String socialYoutube;
  final String socialLinkedIn;
  final String socialPinterest;
  final bool isValid;
  final ManageOutletStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ManageOutletState({
    this.isNew = false,
    this.outletId = '',
    required this.basicDetail,
    required this.outletDetail,
    this.nameField = const OutletNameField.pure(),
    this.shortDescriptionField = const OutletShortDescriptionField.pure(),
    this.addressField = const OutletAddressField.pure(),
    this.cuisineField = const OutletCuisineField.pure(),
    this.typeField = const OutletTypeField.pure(),
    this.facilitiesField = const OutletFacilitiesField.pure(),
    this.minOrderAmountField = const OutletMinOrderAmountField.pure(),
    this.dishPriceForTwoField = const OutletDishPriceForTwoField.pure(),
    this.licenseField = const OutletFoodLicenseField.pure(),
    this.deliveryTimeField = const OutletDeliveryTimeField.pure(),
    this.emailField = const OutletEmailField.pure(),
    this.passwordField = const OutletPasswordField.pure(),
    this.firstNameField = const OutletFirstNameField.pure(),
    this.lastNameField = const OutletLastNameField.pure(),
    this.countryCodeField = const OutletCountryCodeField.pure(),
    this.flag = '',
    this.mobileNumberField = const OutletMobileNumberField.pure(),
    this.latitudeField = const OutletLatitudeField.pure(),
    this.longitudeField = const OutletLongitudeField.pure(),
    this.coverField = const OutletCoverField.pure(),
    this.logoField = const OutletLogoField.pure(),
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
    this.cuisineNames = '',
    this.cuisineIds = '',
    this.typeName = '',
    this.typeIds = '',
    this.facilitiesName = '',
    this.facilitiesIds = '',
    this.socialFacebook = '',
    this.socialInstagram = '',
    this.socialX = '',
    this.socialYoutube = '',
    this.socialLinkedIn = '',
    this.socialPinterest = '',
    this.isValid = false,
    this.status = ManageOutletStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ManageOutletState copyWith({
    bool? isNew,
    String? outletId,
    NewOutletBasicDetailModel? basicDetail,
    OutletDetailResponseModel? outletDetail,
    OutletNameField? nameField,
    OutletShortDescriptionField? shortDescriptionField,
    OutletAddressField? addressField,
    OutletCuisineField? cuisineField,
    OutletTypeField? typeField,
    OutletFacilitiesField? facilitiesField,
    OutletMinOrderAmountField? minOrderAmountField,
    OutletDishPriceForTwoField? dishPriceForTwoField,
    OutletFoodLicenseField? licenseField,
    OutletDeliveryTimeField? deliveryTimeField,
    OutletEmailField? emailField,
    OutletPasswordField? passwordField,
    OutletFirstNameField? firstNameField,
    OutletLastNameField? lastNameField,
    OutletCountryCodeField? countryCodeField,
    String? flag,
    OutletMobileNumberField? mobileNumberField,
    OutletLatitudeField? latitudeField,
    OutletLongitudeField? longitudeField,
    OutletCoverField? coverField,
    OutletLogoField? logoField,
    HomeDeliverySupportModel? homeDelivery,
    List<HomeDeliverySupportModel>? homeDeliveryList,
    TakeAwaySupportModel? takeAway,
    List<TakeAwaySupportModel>? takeAwayList,
    ScheduleOrderSupportModel? scheduleOrder,
    List<ScheduleOrderSupportModel>? scheduleOrderList,
    OutletCitiesResponseModel? selectedCity,
    List<OutletCitiesResponseModel>? cityList,
    OutletLocalitiesResponseModel? selectedLocality,
    List<OutletLocalitiesResponseModel>? localityList,
    OutletLicenseResponseModel? selectedLicense,
    List<OutletLicenseResponseModel>? licenseList,
    String? cuisineNames,
    String? cuisineIds,
    String? typeName,
    String? typeIds,
    String? facilitiesName,
    String? facilitiesIds,
    String? socialFacebook,
    String? socialInstagram,
    String? socialX,
    String? socialYoutube,
    String? socialLinkedIn,
    String? socialPinterest,
    bool? isValid,
    ManageOutletStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ManageOutletState(
      isNew: isNew ?? this.isNew,
      outletId: outletId ?? this.outletId,
      basicDetail: basicDetail ?? this.basicDetail,
      outletDetail: outletDetail ?? this.outletDetail,
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
      cuisineNames: cuisineNames ?? this.cuisineNames,
      cuisineIds: cuisineIds ?? this.cuisineIds,
      typeName: typeName ?? this.typeName,
      typeIds: typeIds ?? this.typeIds,
      facilitiesName: facilitiesName ?? this.facilitiesName,
      facilitiesIds: facilitiesIds ?? this.facilitiesIds,
      socialFacebook: socialFacebook ?? this.socialFacebook,
      socialInstagram: socialInstagram ?? this.socialInstagram,
      socialX: socialX ?? this.socialX,
      socialYoutube: socialYoutube ?? this.socialYoutube,
      socialLinkedIn: socialLinkedIn ?? this.socialLinkedIn,
      socialPinterest: socialPinterest ?? this.socialPinterest,
      isValid: isValid ?? this.isValid,
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
