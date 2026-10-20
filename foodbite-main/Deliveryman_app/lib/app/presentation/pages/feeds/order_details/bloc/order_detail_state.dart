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

part of 'order_detail_bloc.dart';

enum OrderDetailStatus {
  loading,
  failure,
  backgroundLocation,
  restaurantView,
  restaurantReachLoading,
  restaurantReachError,
  orderView,
  customerView,
  driverPickLoading,
  driverPickError,
  driverReachCustomerLoading,
  driverReachCustomerError,
  driverDeliverLoading,
  driverDeliverError,
  deliverSuccess,
}

extension OrderDetailStatusX on OrderDetailStatus {
  bool get isLoading => this == OrderDetailStatus.loading;
  bool get isFailure => this == OrderDetailStatus.failure;
  bool get isBackgroundLocation => this == OrderDetailStatus.backgroundLocation;
  bool get isRestaurantView => this == OrderDetailStatus.restaurantView;
  bool get isRestaurantReachLoading => this == OrderDetailStatus.restaurantReachLoading;
  bool get isRestaurantReachError => this == OrderDetailStatus.restaurantReachError;
  bool get isOrderView => this == OrderDetailStatus.orderView;
  bool get isCustomerView => this == OrderDetailStatus.customerView;
  bool get isDriverPickLoading => this == OrderDetailStatus.driverPickLoading;
  bool get isDriverPickError => this == OrderDetailStatus.driverPickError;
  bool get isDriverReachCustomerLoading => this == OrderDetailStatus.driverReachCustomerLoading;
  bool get isDriverReachCustomerError => this == OrderDetailStatus.driverReachCustomerError;
  bool get isDriverDeliverLoading => this == OrderDetailStatus.driverDeliverLoading;
  bool get isDriverDeliverError => this == OrderDetailStatus.driverDeliverError;
  bool get isDeliverSuccess => this == OrderDetailStatus.deliverSuccess;
}

final class OrderDetailState {
  final String orderId;
  final String orderNo;
  final OrderDetailResponseModel orderDetail;
  final String driverId;
  final String appTitle;
  final double latitude;
  final double longitude;
  final double mapZoomLevel;
  final Set<Marker> markers;
  final Set<Polyline> polyline;
  final OrderDetailStatus status;
  final String pickOrderToggle;
  final bool driverReachCustomer;
  final bool orderVerify;
  final bool collectMoney;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderDetailState({
    this.orderId = '',
    this.orderNo = '',
    required this.orderDetail,
    this.driverId = '',
    this.appTitle = '',
    this.latitude = 0,
    this.longitude = 0,
    this.mapZoomLevel = 13,
    this.markers = const <Marker>{},
    this.polyline = const <Polyline>{},
    this.status = OrderDetailStatus.loading,
    this.pickOrderToggle = 'order',
    this.driverReachCustomer = true,
    this.orderVerify = false,
    this.collectMoney = false,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  OrderDetailState copyWith({
    String? orderId,
    String? orderNo,
    OrderDetailResponseModel? orderDetail,
    String? driverId,
    String? appTitle,
    double? latitude,
    double? longitude,
    double? mapZoomLevel,
    Set<Marker>? markers,
    Set<Polyline>? polyline,
    OrderDetailStatus? status,
    String? pickOrderToggle,
    bool? driverReachCustomer,
    bool? orderVerify,
    bool? collectMoney,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return OrderDetailState(
      orderId: orderId ?? this.orderId,
      orderNo: orderNo ?? this.orderNo,
      orderDetail: orderDetail ?? this.orderDetail,
      driverId: driverId ?? this.driverId,
      appTitle: appTitle ?? this.appTitle,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mapZoomLevel: mapZoomLevel ?? this.mapZoomLevel,
      markers: markers ?? this.markers,
      polyline: polyline ?? this.polyline,
      status: status ?? this.status,
      pickOrderToggle: pickOrderToggle ?? this.pickOrderToggle,
      driverReachCustomer: driverReachCustomer ?? this.driverReachCustomer,
      orderVerify: orderVerify ?? this.orderVerify,
      collectMoney: collectMoney ?? this.collectMoney,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
