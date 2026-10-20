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

part of 'manage_food_action_bloc.dart';

enum ManageFoodActionStatus { loading, loaded, initial, initialLoaded, success, failure, selected, inProgress }

extension ManageFoodActionStatusX on ManageFoodActionStatus {
  bool get isLoading => this == ManageFoodActionStatus.loading;
  bool get isLoaded => this == ManageFoodActionStatus.loaded;
  bool get isSuccess => this == ManageFoodActionStatus.success;
  bool get isFailure => this == ManageFoodActionStatus.failure;
  bool get isSelected => this == ManageFoodActionStatus.selected;
  bool get isInProgress => this == ManageFoodActionStatus.inProgress;
  bool get isInitial => this == ManageFoodActionStatus.initial;
  bool get isInitialLoaded => this == ManageFoodActionStatus.initialLoaded;
}

final class ManageFoodActionState {
  final String restaurant;
  final FoodNameField name;
  final FoodShortDescriptionField shortDescription;
  final FoodImageField image;
  final bool ownCategory;
  final FoodCategoryField category;
  final String categoryName;
  final String subCategory;
  final String subCategoryName;
  final FoodPriceField price;
  final String discount;
  final String discountType;
  final String foodType;
  final String purchaseLimit;
  final String addons;
  final String addonsName;
  final String startTime;
  final String endTime;
  final List<FoodVariationModel> variations;
  final bool isValid;
  final FoodInfoModel foodInfo;
  final bool taxationEnable;
  final String foodTaxNameList;
  final FoodTaxationField foodTaxIds;
  final String stockType;
  final FoodStockField stockNumber;
  final String locale;
  final ManageFoodActionStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ManageFoodActionState({
    this.restaurant = '',
    this.name = const FoodNameField.pure(),
    this.shortDescription = const FoodShortDescriptionField.pure(),
    this.image = const FoodImageField.pure(),
    this.ownCategory = false,
    this.category = const FoodCategoryField.pure(),
    this.categoryName = '',
    this.subCategory = '',
    this.subCategoryName = '',
    this.price = const FoodPriceField.pure(),
    this.discount = '',
    this.discountType = '%',
    this.foodType = 'none',
    this.purchaseLimit = '',
    this.addons = '',
    this.addonsName = '',
    this.startTime = '',
    this.endTime = '',
    this.variations = const [],
    this.isValid = false,
    required this.foodInfo,
    this.taxationEnable = false,
    this.foodTaxNameList = '',
    this.foodTaxIds = const FoodTaxationField.dirty(),
    this.stockType = 'unlimited',
    this.stockNumber = const FoodStockField.pure(),
    this.locale = 'en',
    this.status = ManageFoodActionStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ManageFoodActionState copyWith({
    String? restaurant,
    FoodNameField? name,
    FoodShortDescriptionField? shortDescription,
    FoodImageField? image,
    bool? ownCategory,
    FoodCategoryField? category,
    String? categoryName,
    String? subCategory,
    String? subCategoryName,
    FoodPriceField? price,
    String? discount,
    String? discountType,
    String? foodType,
    String? purchaseLimit,
    String? addons,
    String? addonsName,
    String? startTime,
    String? endTime,
    List<FoodVariationModel>? variations,
    bool? isValid,
    FoodInfoModel? foodInfo,
    bool? taxationEnable,
    String? foodTaxNameList,
    FoodTaxationField? foodTaxIds,
    String? stockType,
    FoodStockField? stockNumber,
    String? locale,
    ManageFoodActionStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ManageFoodActionState(
      restaurant: restaurant ?? this.restaurant,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      image: image ?? this.image,
      ownCategory: ownCategory ?? this.ownCategory,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      subCategory: subCategory ?? this.subCategory,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      foodType: foodType ?? this.foodType,
      purchaseLimit: purchaseLimit ?? this.purchaseLimit,
      addons: addons ?? this.addons,
      addonsName: addonsName ?? this.addonsName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      variations: variations ?? this.variations,
      isValid: isValid ?? this.isValid,
      foodInfo: foodInfo ?? this.foodInfo,
      taxationEnable: taxationEnable ?? this.taxationEnable,
      foodTaxNameList: foodTaxNameList ?? this.foodTaxNameList,
      foodTaxIds: foodTaxIds ?? this.foodTaxIds,
      stockType: stockType ?? this.stockType,
      stockNumber: stockNumber ?? this.stockNumber,
      locale: locale ?? this.locale,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class StockTypeModel {
  String? label;
  String? value;

  StockTypeModel({this.label, this.value});

  StockTypeModel.fromJson(Map<String, dynamic> json) {
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
