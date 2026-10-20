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

part of 'food_detail_bloc.dart';

enum FoodDetailStatus { loading, loaded, initial, initialLoaded, success, failure, inProgress }

extension FoodDetailStatusX on FoodDetailStatus {
  bool get isLoading => this == FoodDetailStatus.loading;
  bool get isLoaded => this == FoodDetailStatus.loaded;
  bool get isSuccess => this == FoodDetailStatus.success;
  bool get isFailure => this == FoodDetailStatus.failure;
  bool get isInProgress => this == FoodDetailStatus.inProgress;
  bool get isInitial => this == FoodDetailStatus.initial;
  bool get isInitialLoaded => this == FoodDetailStatus.initialLoaded;
}

final class FoodDetailState {
  final FoodDetailResponseModel model;
  final FoodNameField name;
  final FoodShortDescriptionField shortDescription;
  final FoodImageField image;
  final String stockType;
  final FoodStockField stockNumber;
  final String addons;
  final String addonsName;
  final List<FoodVariationModel> variations;
  final bool isValid;
  final FoodDetailStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodDetailState({
    required this.model,
    this.name = const FoodNameField.pure(),
    this.shortDescription = const FoodShortDescriptionField.pure(),
    this.image = const FoodImageField.pure(),
    this.stockType = 'unlimited',
    this.stockNumber = const FoodStockField.pure(),
    this.addons = '',
    this.addonsName = '',
    this.variations = const [],
    this.isValid = false,
    this.status = FoodDetailStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  FoodDetailState copyWith({
    FoodDetailResponseModel? model,
    FoodNameField? name,
    FoodShortDescriptionField? shortDescription,
    FoodImageField? image,
    String? stockType,
    FoodStockField? stockNumber,
    String? addons,
    String? addonsName,
    List<FoodVariationModel>? variations,
    bool? isValid,
    FoodDetailStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return FoodDetailState(
      model: model ?? this.model,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      image: image ?? this.image,
      stockType: stockType ?? this.stockType,
      stockNumber: stockNumber ?? this.stockNumber,
      addons: addons ?? this.addons,
      addonsName: addonsName ?? this.addonsName,
      variations: variations ?? this.variations,
      isValid: isValid ?? this.isValid,
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
