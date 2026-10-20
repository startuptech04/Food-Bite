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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/models/api_status_response_model.dart';
import 'package:driver/app/core/models/google_direction_response_model.dart';
import 'package:driver/app/core/models/order_detail_response_model.dart';
import 'package:driver/app/core/models/request/driver_deliver_order_request_model.dart';
import 'package:driver/app/core/models/request/driver_pickup_order_request_model.dart';
import 'package:driver/app/core/models/request/driver_reach_customer_request_model.dart';
import 'package:driver/app/core/models/request/update_geo_location_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/feeds_repository.dart';
import 'package:driver/app/core/repositories/intro_repository.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/services/live_location_service_socket_io.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_detail_event.dart';
part 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final LiveLocationServiceSocket liveLocationServiceSocket = LiveLocationServiceSocket();
  final FeedsRepository _feedsRepository = FeedsRepository();
  final AuthRepository _authRepository = AuthRepository();
  final IntroRepository _introRepository = IntroRepository();
  late BitmapDescriptor driverIcon;
  late BitmapDescriptor restaurantIcon;
  late BitmapDescriptor userIcon;
  StreamSubscription<Position>? _positionSubscription;
  bool _socketConnected = false;
  OrderDetailBloc() : super(OrderDetailState(orderDetail: OrderDetailResponseModel(locale: ''))) {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)), AssetsUrl.iconsURL.driverMarker).then((onValue) {
      driverIcon = onValue;
    });
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)), AssetsUrl.iconsURL.restaurantMarker).then((onValue) {
      restaurantIcon = onValue;
    });
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)), AssetsUrl.iconsURL.userMarker).then((onValue) {
      userIcon = onValue;
    });
    on<OrderDetailInitialEvent>(_onOrderDetailInitialEvent);
    on<OrderDetailDirectionEvent>(_onOrderDetailDirectionEvent);
    on<OrderDetailMapRedirectEvent>(_onOrderDetailMapRedirectEvent);
    on<OrderDetailReachRestaurantEvent>(_onOrderDetailReachRestaurantEvent);
    on<OrderDetailPickupViewToggleEvent>(_onOrderDetailPickupViewToggleEvent);
    on<OrderDetailPickupOrderEvent>(_onOrderDetailPickupOrderEvent);
    on<OrderDetailDriverReachCustomerEvent>(_onOrderDetailDriverReachCustomerEvent);
    on<OrderDetailDeliverOrderEvent>(_onOrderDetailDeliverOrderEvent);
    on<OrderDetailCollectMoneyEvent>(_onOrderDetailCollectMoneyEvent);
    on<OrderDetailVerifyCustomerEvent>(_onOrderDetailVerifyCustomerEvent);
    on<OrderDetailTrackingLocationEvent>(_onOrderDetailTrackingLocationEvent);
    on<OrderDetailLiveLocationEvent>(_onOrderDetailLiveLocationEvent);
  }

  FutureOr<void> _onOrderDetailInitialEvent(OrderDetailInitialEvent event, Emitter<OrderDetailState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "order_detail"}, 'order_detail_screen', 'order_detail_screen');
      final double driverLatitude = await _feedsRepository.driverLatitude();
      final double driverLongitude = await _feedsRepository.driverLongitude();
      final String driverId = await _feedsRepository.driverId();
      if (!_socketConnected) {
        liveLocationServiceSocket.connectToServer(driverId, (data) {});
        _socketConnected = true;
      }
      emit(
        state.copyWith(
          status: OrderDetailStatus.loading,
          latitude: driverLatitude != 0 ? driverLatitude : 0,
          longitude: driverLongitude != 0 ? driverLongitude : 0,
          orderId: event.orderId,
          orderNo: event.orderNo,
          driverId: driverId,
        ),
      );
      DioApiResponse response = await _feedsRepository.getOrderDetails(event.orderId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          final String locale = await _authRepository.getLocale();
          OrderDetailResponseModel data = OrderDetailResponseModel.fromJson(myMap, locale.toString());
          List<String> restaurantStatus = <String>['preparing', 'ready'];
          List<String> orderStatus = <String>['handover'];
          List<String> customerStatus = <String>['ongoing'];
          OrderDetailStatus viewStatus = OrderDetailStatus.restaurantView;
          final Set<Marker> markersLocal = <Marker>{};
          if (restaurantStatus.contains(data.details!.status)) {
            viewStatus = OrderDetailStatus.restaurantView;
            markersLocal.add(
              Marker(
                markerId: MarkerId(driverId),
                position: LatLng(driverLatitude, driverLongitude),
                infoWindow: const InfoWindow(title: 'Your Location'),
                icon: driverIcon,
              ),
            );
            markersLocal.add(
              Marker(
                markerId: MarkerId(data.details!.restaurant!.id!),
                position: LatLng(data.details!.restaurant!.location!.coordinates![1], data.details!.restaurant!.location!.coordinates![0]),
                infoWindow: InfoWindow(title: '${data.details!.restaurant!.name}'),
                icon: restaurantIcon,
              ),
            );

            if (!kIsWeb) {
              add(OrderDetailDirectionEvent(endLat: data.details!.restaurant!.location!.coordinates![1], endLng: data.details!.restaurant!.location!.coordinates![0]));
            }
          } else if (orderStatus.contains(data.details!.status)) {
            viewStatus = OrderDetailStatus.orderView;
          } else if (customerStatus.contains(data.details!.status)) {
            viewStatus = OrderDetailStatus.customerView;
            markersLocal.add(
              Marker(
                markerId: MarkerId(driverId),
                position: LatLng(driverLatitude, driverLongitude),
                infoWindow: const InfoWindow(title: 'Your Location'),
                icon: driverIcon,
              ),
            );
            markersLocal.add(
              Marker(
                markerId: MarkerId(data.details!.user!),
                position: LatLng(data.details!.deliveryAddressRaw!.location!.coordinates![1], data.details!.deliveryAddressRaw!.location!.coordinates![0]),
                infoWindow: InfoWindow(title: data.details!.deliveryAddressRaw!.receiverName!),
                icon: userIcon,
              ),
            );
            if (!kIsWeb) {
              add(OrderDetailDirectionEvent(endLat: data.details!.deliveryAddressRaw!.location!.coordinates![1], endLng: data.details!.deliveryAddressRaw!.location!.coordinates![0]));
            }
          }
          bool havePaid = data.details!.paymentInfo!.paymentWay == 'offline' ? false : true;
          bool verifyOrder = data.orderSettings!.deliveryVerification! == true ? false : true;
          emit(state.copyWith(orderDetail: data, status: viewStatus, markers: markersLocal, orderVerify: verifyOrder, collectMoney: havePaid));
          add(OrderDetailTrackingLocationEvent());
        } else {
          emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailDirectionEvent(OrderDetailDirectionEvent event, Emitter<OrderDetailState> emit) async {
    try {
      final double endLat = event.endLat;
      final double endLng = event.endLng;
      final double driverLatitude = await _feedsRepository.driverLatitude();
      final double driverLongitude = await _feedsRepository.driverLongitude();
      final String driverId = await _feedsRepository.driverId();
      DioApiResponse response = await _feedsRepository.googleDirection(driverLatitude != 0 ? driverLatitude : 0, driverLongitude != 0 ? driverLongitude : 0, endLat, endLng);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        GoogleDirectionResponseModel directionResponse = GoogleDirectionResponseModel.fromJson(myMap);
        if (directionResponse.routes!.isNotEmpty && directionResponse.routes![0].overviewPolyline!.points!.isNotEmpty) {
          final String routeLine = directionResponse.routes![0].overviewPolyline!.points!;
          final Set<Polyline> polyLines = <Polyline>{};
          polyLines.add(Polyline(polylineId: PolylineId(driverId), width: 10, points: convertToLatLng(decodePoly(routeLine)), color: ThemeProvider.primaryColor));
          emit(state.copyWith(polyline: polyLines));
        }
      }
    } catch (e, stacktrace) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    List<double> lList = <double>[];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }
    return lList;
  }

  FutureOr<void> _onOrderDetailMapRedirectEvent(OrderDetailMapRedirectEvent event, Emitter<OrderDetailState> emit) async {
    try {
      final double driverLatitude = await _feedsRepository.driverLatitude();
      final double driverLongitude = await _feedsRepository.driverLongitude();
      final double restLat = state.orderDetail.details!.restaurant!.location!.coordinates![1];
      final double restLng = state.orderDetail.details!.restaurant!.location!.coordinates![0];
      final Uri mapDirection = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$driverLatitude,$driverLongitude &destination=$restLat,$restLng&travelmode=driving&dir_action=navigate');
      if (!await launchUrl(mapDirection)) {}
    } catch (e, stacktrace) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailReachRestaurantEvent(OrderDetailReachRestaurantEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.restaurantReachLoading));
      DioApiResponse response = await _feedsRepository.driverReachRestaurant(state.orderId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: OrderDetailStatus.orderView));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.restaurantReachError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.restaurantReachError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.restaurantReachError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailPickupViewToggleEvent(OrderDetailPickupViewToggleEvent event, Emitter<OrderDetailState> emit) async {
    emit(state.copyWith(pickOrderToggle: event.toggleView, status: OrderDetailStatus.orderView));
  }

  FutureOr<void> _onOrderDetailPickupOrderEvent(OrderDetailPickupOrderEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.driverPickLoading));
      DriverPickupOrderRequestModel param = DriverPickupOrderRequestModel(id: state.orderId, vendorId: state.orderDetail.details!.restaurant!.id!, user: state.orderDetail.details!.user!);
      DioApiResponse response = await _feedsRepository.driverPickupOrder(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          final Set<Marker> markersLocal = <Marker>{};
          markersLocal.add(
            Marker(
              markerId: MarkerId(state.driverId),
              position: LatLng(state.latitude, state.longitude),
              infoWindow: const InfoWindow(title: 'Your Location'),
              icon: driverIcon,
            ),
          );
          markersLocal.add(
            Marker(
              markerId: MarkerId(state.orderDetail.details!.user!),
              position: LatLng(state.orderDetail.details!.deliveryAddressRaw!.location!.coordinates![1], state.orderDetail.details!.deliveryAddressRaw!.location!.coordinates![0]),
              infoWindow: InfoWindow(title: state.orderDetail.details!.deliveryAddressRaw!.receiverName!),
              icon: userIcon,
            ),
          );
          if (!kIsWeb) {
            add(OrderDetailDirectionEvent(endLat: state.orderDetail.details!.deliveryAddressRaw!.location!.coordinates![1], endLng: state.orderDetail.details!.deliveryAddressRaw!.location!.coordinates![0]));
          }
          emit(state.copyWith(status: OrderDetailStatus.customerView, markers: markersLocal));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.restaurantReachError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.restaurantReachError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.driverPickError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailDriverReachCustomerEvent(OrderDetailDriverReachCustomerEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.driverReachCustomerLoading));
      DriverReachCustomerRequestModel param = DriverReachCustomerRequestModel(id: state.orderId, user: state.orderDetail.details!.user!);
      DioApiResponse response = await _feedsRepository.driverReachedCustomer(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(driverReachCustomer: true));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.driverReachCustomerError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.driverReachCustomerError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.driverReachCustomerError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailDeliverOrderEvent(OrderDetailDeliverOrderEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.driverDeliverLoading));
      final String driverId = await _feedsRepository.driverId();
      DriverOrderDeliverRequestModel param = DriverOrderDeliverRequestModel(id: state.orderId, user: state.orderDetail.details!.user!, driver: driverId);
      DioApiResponse response = await _feedsRepository.driverDeliverOrder(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: OrderDetailStatus.deliverSuccess));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.driverDeliverError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.driverDeliverError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.driverDeliverError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailCollectMoneyEvent(OrderDetailCollectMoneyEvent event, Emitter<OrderDetailState> emit) async {
    bool collectMoneyStatus = !state.collectMoney;
    emit(state.copyWith(collectMoney: collectMoneyStatus));
  }

  FutureOr<void> _onOrderDetailVerifyCustomerEvent(OrderDetailVerifyCustomerEvent event, Emitter<OrderDetailState> emit) async {
    emit(state.copyWith(orderVerify: true));
  }

  FutureOr<void> _onOrderDetailTrackingLocationEvent(OrderDetailTrackingLocationEvent event, Emitter<OrderDetailState> emit) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }
    if (permission != LocationPermission.always) {
      final OrderDetailStatus oldStatus = state.status;
      emit(state.copyWith(status: OrderDetailStatus.backgroundLocation));
      emit(state.copyWith(status: oldStatus));
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always) {
      add(OrderDetailLiveLocationEvent());
    }
  }

  FutureOr<void> _onOrderDetailLiveLocationEvent(OrderDetailLiveLocationEvent event, Emitter<OrderDetailState> emit) async {
    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10)).listen((Position position) async {
      final double driverLatitude = await _feedsRepository.driverLatitude();
      final double driverLongitude = await _feedsRepository.driverLongitude();
      double distanceInMeters = Geolocator.distanceBetween(driverLatitude, driverLongitude, position.latitude, position.longitude);
      if (distanceInMeters >= 50) {
        final String driverId = await _feedsRepository.driverId();
        await _introRepository.saveLocation(position.latitude, position.longitude);
        liveLocationServiceSocket.sendLocation(driverId, position.latitude, position.longitude);
        try {
          UpdateGeoLocationRequestModel param = UpdateGeoLocationRequestModel(id: driverId, latitude: position.latitude, longitude: position.longitude);
          DioApiResponse response = await _feedsRepository.updateGeoLocation(param);
          if (response.errorType == NetErrorType.none) {
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } catch (e, stacktrace) {
          emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
          if (!kIsWeb) {
            FirebaseCrashlytics.instance.recordError(e, stacktrace);
          }
        }
      }
    });
  }

  @override
  Future<void> close() {
    liveLocationServiceSocket.disconnect();
    _positionSubscription?.cancel();
    return super.close();
  }
}
