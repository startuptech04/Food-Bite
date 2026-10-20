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

part of 'select_delivery_time_modal_bloc.dart';

enum SelectDeliveryTimeModalStatus { loading, fetched, initial, submit, failure }

extension SelectDeliveryTimeModalStatusX on SelectDeliveryTimeModalStatus {
  bool get isLoading => this == SelectDeliveryTimeModalStatus.loading;
  bool get isFetched => this == SelectDeliveryTimeModalStatus.fetched;
  bool get isInitial => this == SelectDeliveryTimeModalStatus.initial;
  bool get isSubmit => this == SelectDeliveryTimeModalStatus.submit;
  bool get isFailure => this == SelectDeliveryTimeModalStatus.failure;
}

final class SelectDeliveryTimeModalState {
  final DeliveryTimeFromField from;
  final DeliveryTimeToField to;
  final DeliveryTimeTimeModel time;
  final List<DeliveryTimeTimeModel> timeList;
  final bool isValid;
  final SelectDeliveryTimeModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SelectDeliveryTimeModalState({
    this.from = const DeliveryTimeFromField.pure(),
    this.to = const DeliveryTimeToField.pure(),
    required this.time,
    this.timeList = const [],
    this.isValid = false,
    this.status = SelectDeliveryTimeModalStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  SelectDeliveryTimeModalState copyWith({
    DeliveryTimeFromField? from,
    DeliveryTimeToField? to,
    DeliveryTimeTimeModel? time,
    List<DeliveryTimeTimeModel>? timeList,
    bool? isValid,
    SelectDeliveryTimeModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return SelectDeliveryTimeModalState(
      from: from ?? this.from,
      to: to ?? this.to,
      time: time ?? this.time,
      timeList: timeList ?? this.timeList,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class DeliveryTimeTimeModel {
  String? label;
  String? value;

  DeliveryTimeTimeModel({this.label, this.value});

  DeliveryTimeTimeModel.fromJson(Map<String, dynamic> json) {
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
