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
import 'package:driver/app/core/models/new_order_list_model.dart';
import 'package:driver/app/core/models/order_notification_local_list_model.dart';
import 'package:driver/app/core/models/request/accept_order_request_model.dart';
import 'package:driver/app/core/models/request/driver_reject_order_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/new_order_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'new_order_event.dart';
part 'new_order_state.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  final NewOrderRepositry _newOrderRepositry = NewOrderRepositry();
  final AuthRepository _authRepository = AuthRepository();
  late BitmapDescriptor driverIcon;
  late BitmapDescriptor restaurantIcon;
  late BitmapDescriptor userIcon;
  NewOrderBloc()
    : super(
        NewOrderState(
          orders: NewOrderListModel(findMode: 'km', orders: [], locale: ''),
        ),
      ) {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)), AssetsUrl.iconsURL.driverMarker).then((onValue) {
      driverIcon = onValue;
    });
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)), AssetsUrl.iconsURL.restaurantMarker).then((onValue) {
      restaurantIcon = onValue;
    });
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)), AssetsUrl.iconsURL.userMarker).then((onValue) {
      userIcon = onValue;
    });
    on<NewOrderInitialEvent>(_onNewOrderInitialEvent);
    on<NewOrderRejectEvent>(_onNewOrderRejectEvent);
    on<NewOrderAcceptEvent>(_onNewOrderAcceptEvent);
  }

  FutureOr<void> _onNewOrderInitialEvent(NewOrderInitialEvent event, Emitter<NewOrderState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "new_order_list"}, 'new_order_list_screen', 'new_order_list_screen');
      final double driverLatitude = await _newOrderRepositry.driverLatitude();
      final double driverLongitude = await _newOrderRepositry.driverLongitude();
      emit(state.copyWith(status: NewOrderStatus.initial, orderFrom: event.orderFrom, driverLatitude: driverLatitude != 0 ? driverLatitude : 0, driverLongitude: driverLongitude != 0 ? driverLongitude : 0));
      if (event.orderFrom == 'online') {
        String savedNotificationBell = '';
        await _newOrderRepositry.getNotificationBell().then((sound) {
          if (sound.isEmpty || sound == '') {
            savedNotificationBell = AssetsUrl.notificationAssetSound.sound1;
          } else {
            savedNotificationBell = sound;
          }
          emit(state.copyWith(status: NewOrderStatus.loading, orderFrom: event.orderFrom, sound: savedNotificationBell));
        });
      } else if (!kIsWeb) {
        await getNotificationList().then((orderList) async {
          if (orderList.isNotEmpty) {
            List<dynamic> jsonList = jsonDecode(jsonEncode(orderList));
            List<OrderNotificationLocalListModel> modelList = jsonList.map((json) => OrderNotificationLocalListModel.fromJson(json)).toList();
            for (var element in modelList) {
              List<String> splitDates = element.createdAt!.split('-');
              if (splitDates.isNotEmpty && splitDates.length == 3) {
                await deleteOlderNotification(element.notificationId!, element.createdAt!);
              }
            }
          }
        });
      }
      final String driverId = await _newOrderRepositry.userId();
      DioApiResponse response = await _newOrderRepositry.getOrderList(driverId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        NewOrderListModel data = NewOrderListModel.fromJson(myMap, locale.toString());
        if (data.success!) {
          final double myLatitude = await _newOrderRepositry.driverLatitude();
          final double myLongitude = await _newOrderRepositry.driverLongitude();
          double metersToMiles(double meters) {
            return meters * 0.000621371;
          }

          double metersToKilometers(double meters) {
            return meters / 1000;
          }

          bool calculateEarning = false;
          if (data.driverInfo != null && data.driverInfo!.type! == 'freelancer' && data.driverSettings != null && data.driverSettings!.earningModel! == 'order') {
            calculateEarning = true;
          }
          String estimateDeliveryTime(double distance) {
            double averageSpeed = 30; // in km/h
            double estimatedTime = distance / averageSpeed;
            int estimatedMinutes = (estimatedTime * 60).round();
            int hours = estimatedMinutes ~/ 60;
            int minutes = estimatedMinutes % 60;
            return '$hours hours $minutes minutes';
          }

          // double totalOrderDistance = 0;
          for (var element in data.orders!) {
            if (element.restaurant != null && element.restaurant!.location != null && element.restaurant!.location!.coordinates!.isNotEmpty) {
              final double restaurantDistance = Geolocator.distanceBetween(
                myLatitude != 0 ? myLatitude : 0,
                myLongitude != 0 ? myLongitude : 0,
                element.restaurant!.location!.coordinates![1],
                element.restaurant!.location!.coordinates![0],
              );
              if (data.findMode == 'km') {
                final String pickupDistance = metersToKilometers(restaurantDistance).toStringAsFixed(2);
                element.pickupDistance = pickupDistance;
              } else {
                final String pickupDistance = metersToMiles(restaurantDistance).toStringAsFixed(2);
                element.pickupDistance = pickupDistance;
              }
              element.restaurantETA = estimateDeliveryTime(metersToKilometers(restaurantDistance));
            }

            if (element.deliveryAddressRaw != null && element.deliveryAddressRaw!.location != null && element.deliveryAddressRaw!.location!.coordinates!.isNotEmpty) {
              final double userDistance = Geolocator.distanceBetween(
                myLatitude != 0 ? myLatitude : 0,
                myLongitude != 0 ? myLongitude : 0,
                element.deliveryAddressRaw!.location!.coordinates![1],
                element.deliveryAddressRaw!.location!.coordinates![0],
              );
              if (data.findMode == 'km') {
                final String dropDistance = metersToKilometers(userDistance).toStringAsFixed(2);
                element.dropDistance = dropDistance;
              } else {
                final String dropDistance = metersToMiles(userDistance).toStringAsFixed(2);
                element.dropDistance = dropDistance;
              }
            }
            double totalOrderDistance = Geolocator.distanceBetween(
              element.restaurant!.location!.coordinates![1],
              element.restaurant!.location!.coordinates![0],
              element.deliveryAddressRaw!.location!.coordinates![1],
              element.deliveryAddressRaw!.location!.coordinates![0],
            );

            if (data.findMode == 'km') {
              totalOrderDistance = metersToKilometers(totalOrderDistance);
            } else {
              totalOrderDistance = metersToMiles(totalOrderDistance);
            }

            double incentive = 0;
            double deliveryTip = double.parse(element.deliveryTip!.toStringAsFixed(2));
            if (data.driverSettings != null && data.driverSettings!.haveIncentive!) {
              int indexOfIncentive = data.incentive!.indexWhere((incentive) => element.grandTotal! >= incentive.orderTotal!);
              if (indexOfIncentive != -1) {
                incentive = data.incentive![indexOfIncentive].incentiveAmount!;
              }
            } else {
              incentive = 0;
            }

            if (calculateEarning == true) {
              if (data.driverSettings != null && data.driverSettings!.earningOnOrder! == 'distance') {
                if (data.driverSettings != null && data.driverSettings!.distanceRadiusForFixed! >= totalOrderDistance) {
                  element.orderEarning = data.driverSettings!.earningFixedDistanceAmount!;
                  element.incentiveAmount = incentive;
                  element.deliveryTipAmount = deliveryTip;
                } else {
                  final double surplusDistance = (totalOrderDistance - data.driverSettings!.distanceRadiusForFixed!);
                  final double surplusCount = (surplusDistance * data.driverSettings!.earningFixedDistanceAmount!);
                  final double canEarnAmount = data.driverSettings!.earningFixedDistanceAmount! + surplusCount;
                  element.orderEarning = canEarnAmount;
                  element.incentiveAmount = incentive;
                  element.deliveryTipAmount = deliveryTip;
                }
              } else {
                double earningAmount = 0;
                if (data.driverSettings != null) {
                  earningAmount = data.driverSettings!.earningAmount!;
                }
                element.orderEarning = earningAmount;
                element.incentiveAmount = incentive;
                element.deliveryTipAmount = deliveryTip;
              }
            } else {
              element.orderEarning = 0.0;
              element.incentiveAmount = incentive;
              element.deliveryTipAmount = deliveryTip;
            }
            final String orderEarningString = double.parse(element.orderEarning.toString()).toStringAsFixed(2);
            final String incentiveEarningString = double.parse(element.incentiveAmount.toString()).toStringAsFixed(2);
            final String deliveryTipEarningString = double.parse(element.deliveryTipAmount.toString()).toStringAsFixed(2);
            element.orderEarning = double.parse(orderEarningString);
            element.incentiveAmount = double.parse(incentiveEarningString);
            element.deliveryTipAmount = double.parse(deliveryTipEarningString);
            if (element.orderEarning! > 0 && data.extraShiftChargePercentage! > 0) {
              double getPercentageAmount(double totalAmount, double percentage) {
                return (totalAmount * percentage) / 100;
              }

              String extraEarningOnShiftAmount = getPercentageAmount(element.orderEarning!, data.extraShiftChargePercentage!).toStringAsFixed(2);
              element.extraEarningOnShift = double.parse(extraEarningOnShiftAmount);
            } else {
              element.extraEarningOnShift = 0;
            }
          }
          final Set<Marker> markersLocal = <Marker>{};

          if (data.orders!.isNotEmpty) {
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
                markerId: MarkerId(data.orders![0].restaurant!.id!),
                position: LatLng(data.orders![0].restaurant!.location!.coordinates![1], data.orders![0].restaurant!.location!.coordinates![0]),
                infoWindow: InfoWindow(title: data.orders![0].restaurant!.name!),
                icon: restaurantIcon,
              ),
            );
            markersLocal.add(
              Marker(
                markerId: MarkerId(data.orders![0].deliveryAddressRaw!.id!),
                position: LatLng(data.orders![0].deliveryAddressRaw!.location!.coordinates![1], data.orders![0].deliveryAddressRaw!.location!.coordinates![0]),
                infoWindow: InfoWindow(title: data.orders![0].deliveryAddressRaw!.receiverName!),
                icon: userIcon,
              ),
            );
          }
          emit(state.copyWith(status: NewOrderStatus.success, orders: data, markers: markersLocal, driverId: driverId));
        } else {
          emit(state.copyWith(status: NewOrderStatus.empty));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: NewOrderStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: NewOrderStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  Future<Database> getDdInstance() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'foodbite_driver_notification.db');
    return openDatabase(path, version: 1);
  }

  Future<List<Map<String, dynamic>>> getNotificationList() async {
    final db = await getDdInstance();
    return await db.query('notification');
  }

  Future<int> updateTableStatus() async {
    final db = await getDdInstance();
    return await db.update('notification', {"status": "read"});
  }

  Future<int> deleteOlderNotification(String notificationId, String createdAt) async {
    final db = await getDdInstance();
    return await db.delete('notification', where: 'notification_id = ? and createdAt = ?', whereArgs: [notificationId, createdAt]);
  }

  FutureOr<void> _onNewOrderRejectEvent(NewOrderRejectEvent event, Emitter<NewOrderState> emit) async {
    try {
      emit(state.copyWith(status: NewOrderStatus.reject));
      DriverRejectOrderRequestModel param = DriverRejectOrderRequestModel(id: state.orders.orders![state.currentPageIndex].id!, reason: event.reasonId);
      DioApiResponse response = await _newOrderRepositry.rejectOrder(param);
      if (response.errorType == NetErrorType.none) {
        if (state.orders.orders!.length == 1) {
          emit(state.copyWith(status: NewOrderStatus.processed));
        } else if ((state.currentPageIndex + 1) < state.orders.orders!.length) {
          final int newOrderIndex = state.currentPageIndex + 1;
          final Set<Marker> markersLocal = <Marker>{};
          state.markers.clear();

          markersLocal.add(
            Marker(
              markerId: MarkerId(state.driverId),
              position: LatLng(state.driverLatitude, state.driverLongitude),
              infoWindow: const InfoWindow(title: 'Your Location'),
              icon: driverIcon,
            ),
          );
          markersLocal.add(
            Marker(
              markerId: MarkerId(state.orders.orders![newOrderIndex].restaurant!.id!),
              position: LatLng(state.orders.orders![newOrderIndex].restaurant!.location!.coordinates![1], state.orders.orders![newOrderIndex].restaurant!.location!.coordinates![0]),
              infoWindow: InfoWindow(title: state.orders.orders![newOrderIndex].restaurant!.name!),
              icon: restaurantIcon,
            ),
          );
          markersLocal.add(
            Marker(
              markerId: MarkerId(state.orders.orders![newOrderIndex].deliveryAddressRaw!.id!),
              position: LatLng(state.orders.orders![newOrderIndex].deliveryAddressRaw!.location!.coordinates![1], state.orders.orders![newOrderIndex].deliveryAddressRaw!.location!.coordinates![0]),
              infoWindow: InfoWindow(title: state.orders.orders![newOrderIndex].deliveryAddressRaw!.receiverName!),
              icon: userIcon,
            ),
          );
          emit(state.copyWith(currentPageIndex: newOrderIndex, status: NewOrderStatus.swipeNext, markers: markersLocal));
        } else if ((state.currentPageIndex + 1) == state.orders.orders!.length) {
          emit(state.copyWith(status: NewOrderStatus.processed));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: NewOrderStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: NewOrderStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onNewOrderAcceptEvent(NewOrderAcceptEvent event, Emitter<NewOrderState> emit) async {
    try {
      emit(state.copyWith(status: NewOrderStatus.accept));
      final String driverId = await _newOrderRepositry.userId();
      AcceptOrderRequestModel param = AcceptOrderRequestModel(id: state.orders.orders![state.currentPageIndex].id!, orderId: state.orders.orders![state.currentPageIndex].orderId!, driver: driverId);
      DioApiResponse response = await _newOrderRepositry.acceptOrder(param);
      if (response.errorType == NetErrorType.none) {
        if (state.orders.orders!.length == 1) {
          emit(state.copyWith(status: NewOrderStatus.processed));
        } else if ((state.currentPageIndex + 1) < state.orders.orders!.length) {
          final int newOrderIndex = state.currentPageIndex + 1;
          final Set<Marker> markersLocal = <Marker>{};
          state.markers.clear();

          markersLocal.add(
            Marker(
              markerId: MarkerId(state.driverId),
              position: LatLng(state.driverLatitude, state.driverLongitude),
              infoWindow: const InfoWindow(title: 'Your Location'),
              icon: driverIcon,
            ),
          );
          markersLocal.add(
            Marker(
              markerId: MarkerId(state.orders.orders![newOrderIndex].restaurant!.id!),
              position: LatLng(state.orders.orders![newOrderIndex].restaurant!.location!.coordinates![1], state.orders.orders![newOrderIndex].restaurant!.location!.coordinates![0]),
              infoWindow: InfoWindow(title: state.orders.orders![newOrderIndex].restaurant!.name!),
              icon: restaurantIcon,
            ),
          );
          markersLocal.add(
            Marker(
              markerId: MarkerId(state.orders.orders![newOrderIndex].deliveryAddressRaw!.id!),
              position: LatLng(state.orders.orders![newOrderIndex].deliveryAddressRaw!.location!.coordinates![1], state.orders.orders![newOrderIndex].deliveryAddressRaw!.location!.coordinates![0]),
              infoWindow: InfoWindow(title: state.orders.orders![newOrderIndex].deliveryAddressRaw!.receiverName!),
              icon: userIcon,
            ),
          );
          emit(state.copyWith(currentPageIndex: newOrderIndex, status: NewOrderStatus.swipeNext, markers: markersLocal));
        } else if ((state.currentPageIndex + 1) == state.orders.orders!.length) {
          emit(state.copyWith(status: NewOrderStatus.processed));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: NewOrderStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: NewOrderStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
