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

part of 'edit_restaurant_bloc.dart';

enum EditRestaurantStatus { loading, fetched, initial, submit, submitSuccess, failure, changeDetailFromModal, customError }

extension EditRestaurantStatusX on EditRestaurantStatus {
  bool get isLoading => this == EditRestaurantStatus.loading;
  bool get isFetched => this == EditRestaurantStatus.fetched;
  bool get isInitial => this == EditRestaurantStatus.initial;
  bool get isSubmit => this == EditRestaurantStatus.submit;
  bool get isSubmitSuccess => this == EditRestaurantStatus.submitSuccess;
  bool get isFailure => this == EditRestaurantStatus.failure;
  bool get isChangeDetailFromModal => this == EditRestaurantStatus.changeDetailFromModal;
  bool get isCustomError => this == EditRestaurantStatus.customError;
}

final class EditRestaurantState {
  final VendorDetailForUpdateResponseModel model;
  final String logo;
  final String cover;
  final RestaurantEditNameField name;
  final RestaurantEditShortDescriptionField shortDescription;
  final RestaurantEditAddressField address;
  final RestaurantEditCuisineField cuisineNameField;
  final RestaurantEditTypeField restaurantTypeField;
  final RestaurantEditFacilitiesField restaurantFacilitiesField;
  final RestaurantEditMinOrderAmountField minOrderAmount;
  final RestaurantEditDishPriceForTwoField dishPriceForTwo;
  final RestaurantEditFoodLicenseField foodLicense;
  final RestaurantEditDeliveryTimeField deliveryTime;
  final String cuisineNames;
  final String cuisineIds;
  final String typeName;
  final String typeIds;
  final String facilitiesName;
  final String facilitiesIds;
  final HomeDeliverySupportModel homeDelivery;
  final List<HomeDeliverySupportModel> homeDeliveryList;
  final TakeAwaySupportModel takeAway;
  final List<TakeAwaySupportModel> takeAwayList;
  final ScheduleOrderSupportModel scheduleOrder;
  final List<ScheduleOrderSupportModel> scheduleOrderList;
  final RestaurantFoodLicenseConfigModel license;
  final List<RestaurantFoodLicenseConfigModel> licenseList;
  final String socialFacebook;
  final String socialInstagram;
  final String socialX;
  final String socialYoutube;
  final String socialLinkedIn;
  final String socialPinterest;
  final bool isValid;
  final EditRestaurantStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const EditRestaurantState({
    required this.model,
    this.logo = '',
    this.cover = '',
    this.name = const RestaurantEditNameField.pure(),
    this.shortDescription = const RestaurantEditShortDescriptionField.pure(),
    this.address = const RestaurantEditAddressField.pure(),
    this.cuisineNameField = const RestaurantEditCuisineField.pure(),
    this.restaurantTypeField = const RestaurantEditTypeField.pure(),
    this.restaurantFacilitiesField = const RestaurantEditFacilitiesField.pure(),
    this.minOrderAmount = const RestaurantEditMinOrderAmountField.pure(),
    this.dishPriceForTwo = const RestaurantEditDishPriceForTwoField.pure(),
    this.foodLicense = const RestaurantEditFoodLicenseField.pure(),
    this.deliveryTime = const RestaurantEditDeliveryTimeField.pure(),
    this.cuisineNames = '',
    this.cuisineIds = '',
    this.typeName = '',
    this.typeIds = '',
    this.facilitiesName = '',
    this.facilitiesIds = '',
    required this.homeDelivery,
    this.homeDeliveryList = const [],
    required this.takeAway,
    this.takeAwayList = const [],
    required this.scheduleOrder,
    this.scheduleOrderList = const [],
    required this.license,
    this.licenseList = const [],
    this.socialFacebook = '',
    this.socialInstagram = '',
    this.socialX = '',
    this.socialYoutube = '',
    this.socialLinkedIn = '',
    this.socialPinterest = '',
    this.isValid = false,
    this.status = EditRestaurantStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  EditRestaurantState copyWith({
    VendorDetailForUpdateResponseModel? model,
    String? logo,
    String? cover,
    RestaurantEditNameField? name,
    RestaurantEditShortDescriptionField? shortDescription,
    RestaurantEditAddressField? address,
    RestaurantEditCuisineField? cuisineNameField,
    RestaurantEditTypeField? restaurantTypeField,
    RestaurantEditFacilitiesField? restaurantFacilitiesField,
    RestaurantEditMinOrderAmountField? minOrderAmount,
    RestaurantEditDishPriceForTwoField? dishPriceForTwo,
    RestaurantEditFoodLicenseField? foodLicense,
    RestaurantEditDeliveryTimeField? deliveryTime,
    String? cuisineNames,
    String? cuisineIds,
    String? typeName,
    String? typeIds,
    String? facilitiesName,
    String? facilitiesIds,
    HomeDeliverySupportModel? homeDelivery,
    List<HomeDeliverySupportModel>? homeDeliveryList,
    TakeAwaySupportModel? takeAway,
    List<TakeAwaySupportModel>? takeAwayList,
    ScheduleOrderSupportModel? scheduleOrder,
    List<ScheduleOrderSupportModel>? scheduleOrderList,
    RestaurantFoodLicenseConfigModel? license,
    List<RestaurantFoodLicenseConfigModel>? licenseList,
    String? socialFacebook,
    String? socialInstagram,
    String? socialX,
    String? socialYoutube,
    String? socialLinkedIn,
    String? socialPinterest,
    bool? isValid,
    EditRestaurantStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return EditRestaurantState(
      model: model ?? this.model,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      cover: cover ?? this.cover,
      shortDescription: shortDescription ?? this.shortDescription,
      address: address ?? this.address,
      cuisineNameField: cuisineNameField ?? this.cuisineNameField,
      restaurantTypeField: restaurantTypeField ?? this.restaurantTypeField,
      restaurantFacilitiesField: restaurantFacilitiesField ?? this.restaurantFacilitiesField,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      dishPriceForTwo: dishPriceForTwo ?? this.dishPriceForTwo,
      foodLicense: foodLicense ?? this.foodLicense,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      cuisineNames: cuisineNames ?? this.cuisineNames,
      cuisineIds: cuisineIds ?? this.cuisineIds,
      typeName: typeName ?? this.typeName,
      typeIds: typeIds ?? this.typeIds,
      facilitiesName: facilitiesName ?? this.facilitiesName,
      facilitiesIds: facilitiesIds ?? this.facilitiesIds,
      homeDelivery: homeDelivery ?? this.homeDelivery,
      homeDeliveryList: homeDeliveryList ?? this.homeDeliveryList,
      takeAway: takeAway ?? this.takeAway,
      takeAwayList: takeAwayList ?? this.takeAwayList,
      scheduleOrder: scheduleOrder ?? this.scheduleOrder,
      scheduleOrderList: scheduleOrderList ?? this.scheduleOrderList,
      license: license ?? this.license,
      licenseList: licenseList ?? this.licenseList,
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
