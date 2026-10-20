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

part of 'addon_action_bloc.dart';

final class AddonActionState {
  final AddonNameField name;
  final AddonPriceField price;
  final String stockType;
  final AddonStockField stockNumber;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const AddonActionState({
    this.name = const AddonNameField.pure(),
    this.price = const AddonPriceField.pure(),
    this.stockType = 'unlimited',
    this.stockNumber = const AddonStockField.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  AddonActionState copyWith({
    AddonNameField? name,
    AddonPriceField? price,
    String? stockType,
    AddonStockField? stockNumber,
    bool? isValid,
    List<Translations>? translations,
    FormzSubmissionStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return AddonActionState(
      name: name ?? this.name,
      price: price ?? this.price,
      stockType: stockType ?? this.stockType,
      stockNumber: stockNumber ?? this.stockNumber,
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
