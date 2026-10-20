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

part of 'delivery_addresss_list_bloc.dart';

enum DeliveryAddresssListStatus { loading, empty, success, failure, selected }

extension DeliveryAddresssListStatusX on DeliveryAddresssListStatus {
  bool get isLoading => this == DeliveryAddresssListStatus.loading;
  bool get isEmpty => this == DeliveryAddresssListStatus.empty;
  bool get isSuccess => this == DeliveryAddresssListStatus.success;
  bool get isFailure => this == DeliveryAddresssListStatus.failure;
  bool get isSelected => this == DeliveryAddresssListStatus.selected;
}

final class DeliveryAddresssListState {
  final int selectedIndex;
  final String restaurant;
  final String deliveryAddressId;
  final double latitude;
  final double longitude;
  final DeliveryAddressListFromCheckoutModel addresses;
  final DeliveryAddresssListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DeliveryAddresssListState({
    this.selectedIndex = 0,
    this.restaurant = '',
    this.deliveryAddressId = '',
    this.latitude = 0,
    this.longitude = 0,
    required this.addresses,
    this.status = DeliveryAddresssListStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DeliveryAddresssListState copyWith({
    int? selectedIndex,
    String? restaurant,
    String? deliveryAddressId,
    double? latitude,
    double? longitude,
    DeliveryAddressListFromCheckoutModel? addresses,
    DeliveryAddresssListStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DeliveryAddresssListState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      restaurant: restaurant ?? this.restaurant,
      deliveryAddressId: deliveryAddressId ?? this.deliveryAddressId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addresses: addresses ?? this.addresses,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
