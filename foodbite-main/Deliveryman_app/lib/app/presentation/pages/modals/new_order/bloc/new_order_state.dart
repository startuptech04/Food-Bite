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

part of 'new_order_bloc.dart';

enum NewOrderStatus { initial, loading, success, failure, empty, accept, reject, customError, processed, swipeNext }

extension PayoutsStatusX on NewOrderStatus {
  bool get isInitial => this == NewOrderStatus.initial;
  bool get isLoading => this == NewOrderStatus.loading;
  bool get isSuccess => this == NewOrderStatus.success;
  bool get isFailure => this == NewOrderStatus.failure;
  bool get isEmpty => this == NewOrderStatus.empty;
  bool get isAccept => this == NewOrderStatus.accept;
  bool get isReject => this == NewOrderStatus.reject;
  bool get isCustomError => this == NewOrderStatus.customError;
  bool get isProcessed => this == NewOrderStatus.processed;
  bool get isSwipeNext => this == NewOrderStatus.swipeNext;
}

final class NewOrderState {
  final String driverId;
  final NewOrderListModel orders;
  final String orderId;
  final NewOrderStatus status;
  final String sound;
  final String orderFrom;
  final int currentPageIndex;
  final double driverLatitude;
  final double driverLongitude;
  final Set<Marker> markers;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const NewOrderState({
    this.driverId = '',
    required this.orders,
    this.orderId = '',
    this.status = NewOrderStatus.initial,
    this.sound = 'assets/sounds/alert1.mp3',
    this.orderFrom = '',
    this.currentPageIndex = 0,
    this.driverLatitude = 0,
    this.driverLongitude = 0,
    this.markers = const <Marker>{},
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  NewOrderState copyWith({
    String? driverId,
    NewOrderListModel? orders,
    String? orderId,
    NewOrderStatus? status,
    String? sound,
    String? orderFrom,
    int? currentPageIndex,
    double? driverLatitude,
    double? driverLongitude,
    Set<Marker>? markers,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return NewOrderState(
      driverId: driverId ?? this.driverId,
      orders: orders ?? this.orders,
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      sound: sound ?? this.sound,
      orderFrom: orderFrom ?? this.orderFrom,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      driverLatitude: driverLatitude ?? this.driverLatitude,
      driverLongitude: driverLongitude ?? this.driverLongitude,
      markers: markers ?? this.markers,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
