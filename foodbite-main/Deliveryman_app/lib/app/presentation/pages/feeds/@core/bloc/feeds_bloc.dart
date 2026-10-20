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
import 'package:driver/app/core/models/google_direction_response_model.dart';
import 'package:driver/app/core/models/near_me_trending_restaurants_model.dart';
import 'package:driver/app/core/models/order_notification_local_list_model.dart';
import 'package:driver/app/core/models/request/near_me_trending_restaurants_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/feeds_repository.dart';
import 'package:driver/app/core/repositories/intro_repository.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'feeds_event.dart';
part 'feeds_state.dart';

class FeedsBloc extends Bloc<FeedsEvent, FeedsState> {
  final AuthRepository _authRepository = AuthRepository();
  final FeedsRepository _feedsRepository = FeedsRepository();
  final IntroRepository _introRepository = IntroRepository();
  late BitmapDescriptor driverIcon;
  late BitmapDescriptor restaurantIcon;
  FeedsBloc()
    : super(
        FeedsState(
          response: NearMeTrendingRestaurantsModel(restaurants: [], findMode: 'km', radius: 20, success: false, orders: [], locale: ''),
        ),
      ) {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)), AssetsUrl.iconsURL.driverMarker).then((onValue) {
      driverIcon = onValue;
    });
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)), AssetsUrl.iconsURL.restaurantMarker).then((onValue) {
      restaurantIcon = onValue;
    });

    on<FeedsInitialEvent>(_onFeedsInitialEvent);
    on<FeedsGoOfflineEvent>(_onFeedsGoOfflineEvent);
    on<FeedsGoOnlineEvent>(_onFeedsGoOnlineEvent);
    on<FeedsRefreshLocationEvent>(_onFeedsRefreshLocationEvent);
    on<FeedsLocationOpenSettingEvent>(_onFeedsLocationOpenSettingEvent);
    on<FeedsChangeMapZoomLevelEvent>(_onFeedsChangeMapZoomLevelEvent);
    on<FeedsNewOrderNotificationEvent>(_onFeedsNewOrderNotificationEvent);
    on<FeedsCheckNotificationEvent>(_onFeedsCheckNotificationEvent);
    on<FeedsFetchActiveOrderEvent>(_onFeedsFetchActiveOrderEvent);
    on<FeedsRestaurantDirectionEvent>(_onFeedsRestaurantDirectionEvent);
  }

  FutureOr<void> _onFeedsInitialEvent(FeedsInitialEvent event, Emitter<FeedsState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "orders_feed"}, 'orders_feed_screen', 'orders_feed_screen');
      emit(state.copyWith(status: FeedsStatus.loading));
      await Permission.location.status.then((value) async {
        if (value.isPermanentlyDenied) {
          emit(state.copyWith(status: FeedsStatus.deniedForever));
        } else {
          try {
            await _determinePosition()
                .then((value) async {
                  await _introRepository.saveLocation(value.latitude, value.longitude);
                  final Set<Marker> markersLocal = <Marker>{};
                  final String driverId = await _feedsRepository.driverId();
                  NearMeTrendingRestaurantsRequestModel param = NearMeTrendingRestaurantsRequestModel(driverId: driverId, latitude: value.latitude, longitude: value.longitude);
                  DioApiResponse response = await _feedsRepository.getTrendingRestaurants(param);
                  if (response.errorType == NetErrorType.none) {
                    final String locale = await _authRepository.getLocale();
                    Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
                    NearMeTrendingRestaurantsModel data = NearMeTrendingRestaurantsModel.fromJson(myMap, locale.toString());
                    markersLocal.add(
                      Marker(
                        markerId: MarkerId(driverId),
                        position: LatLng(value.latitude, value.longitude),
                        infoWindow: const InfoWindow(title: 'Your Location'),
                        icon: driverIcon,
                      ),
                    );
                    for (var element in data.restaurants!) {
                      markersLocal.add(
                        Marker(
                          markerId: MarkerId('${element.id}'),
                          position: LatLng(element.location!.coordinates![1], element.location!.coordinates![0]),
                          infoWindow: InfoWindow(title: '${element.name}'),
                          icon: restaurantIcon,
                        ),
                      );
                    }
                    emit(
                      state.copyWith(status: data.restaurants!.isNotEmpty ? FeedsStatus.success : FeedsStatus.empty, response: data, latitude: value.latitude, longitude: value.longitude, mapZoomLevel: 12, markers: markersLocal),
                    );
                  } else {
                    Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
                    ServerErrorModel data = ServerErrorModel.fromJson(myMap);
                    emit(state.copyWith(status: FeedsStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
                  }
                })
                .catchError((error, stacktrace) {
                  emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: error.toString(), extraMessage: ''));
                  if (!kIsWeb) {
                    FirebaseCrashlytics.instance.recordError(error, stacktrace);
                  }
                });
          } catch (e, stacktrace) {
            emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
            if (!kIsWeb) {
              FirebaseCrashlytics.instance.recordError(e, stacktrace);
            }
          }
        }
      });
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FeedsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFeedsGoOfflineEvent(FeedsGoOfflineEvent event, Emitter<FeedsState> emit) async {
    try {
      final String driverId = await _feedsRepository.driverId();
      DioApiResponse response = await _feedsRepository.goOffline(driverId, event.messageId);
      if (response.errorType == NetErrorType.none) {
        state.response.driverInfo!.activeStatus = false;
        emit(state.copyWith(response: state.response, status: FeedsStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FeedsStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFeedsGoOnlineEvent(FeedsGoOnlineEvent event, Emitter<FeedsState> emit) async {
    try {
      final String driverId = await _feedsRepository.driverId();
      DioApiResponse response = await _feedsRepository.goOnline(driverId);
      if (response.errorType == NetErrorType.none) {
        state.response.driverInfo!.activeStatus = true;
        emit(state.copyWith(response: state.response, status: FeedsStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FeedsStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFeedsRefreshLocationEvent(FeedsRefreshLocationEvent event, Emitter<FeedsState> emit) async {
    try {
      emit(state.copyWith(status: FeedsStatus.loading));
      await Permission.location.status.then((value) async {
        if (value.isPermanentlyDenied) {
          emit(state.copyWith(status: FeedsStatus.deniedForever));
        } else {
          try {
            await _determinePosition()
                .then((value) async {
                  await _introRepository.saveLocation(value.latitude, value.longitude);
                  final String driverId = await _feedsRepository.driverId();
                  NearMeTrendingRestaurantsRequestModel param = NearMeTrendingRestaurantsRequestModel(driverId: driverId, latitude: value.latitude, longitude: value.longitude);
                  DioApiResponse response = await _feedsRepository.getTrendingRestaurants(param);
                  if (response.errorType == NetErrorType.none) {
                    final String locale = await _authRepository.getLocale();
                    Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
                    NearMeTrendingRestaurantsModel data = NearMeTrendingRestaurantsModel.fromJson(myMap, locale.toString());
                    final Set<Marker> markersLocal = <Marker>{};
                    markersLocal.add(
                      Marker(
                        markerId: MarkerId(driverId),
                        position: LatLng(value.latitude, value.longitude),
                        infoWindow: const InfoWindow(title: 'Your Location'),
                        icon: driverIcon,
                      ),
                    );
                    for (var element in data.restaurants!) {
                      markersLocal.add(
                        Marker(
                          markerId: MarkerId('${element.id}'),
                          position: LatLng(element.location!.coordinates![1], element.location!.coordinates![0]),
                          infoWindow: InfoWindow(title: '${element.name}'),
                          icon: restaurantIcon,
                        ),
                      );
                    }
                    emit(
                      state.copyWith(status: data.restaurants!.isNotEmpty ? FeedsStatus.success : FeedsStatus.empty, response: data, latitude: value.latitude, longitude: value.longitude, mapZoomLevel: 12, markers: markersLocal),
                    );
                  } else {
                    Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
                    ServerErrorModel data = ServerErrorModel.fromJson(myMap);
                    emit(state.copyWith(status: FeedsStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
                  }
                })
                .catchError((error, stacktrace) {
                  emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: error.toString(), extraMessage: ''));
                  if (!kIsWeb) {
                    FirebaseCrashlytics.instance.recordError(error, stacktrace);
                  }
                });
          } catch (e, stacktrace) {
            emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
            if (!kIsWeb) {
              FirebaseCrashlytics.instance.recordError(e, stacktrace);
            }
          }
        }
      });
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  FutureOr<void> _onFeedsLocationOpenSettingEvent(FeedsLocationOpenSettingEvent event, Emitter<FeedsState> emit) async {
    await Geolocator.openLocationSettings();
  }

  FutureOr<void> _onFeedsChangeMapZoomLevelEvent(FeedsChangeMapZoomLevelEvent event, Emitter<FeedsState> emit) async {
    if (event.action == 'increment') {
      emit(state.copyWith(mapZoomLevel: state.mapZoomLevel + 1, status: FeedsStatus.success));
    } else {
      if (state.mapZoomLevel >= 3) {
        emit(state.copyWith(mapZoomLevel: state.mapZoomLevel - 1, status: FeedsStatus.success));
      }
    }
  }

  FutureOr<void> _onFeedsNewOrderNotificationEvent(FeedsNewOrderNotificationEvent event, Emitter<FeedsState> emit) async {
    emit(state.copyWith(status: FeedsStatus.newOrder, orderFrom: 'online'));
  }

  FutureOr<void> _onFeedsCheckNotificationEvent(FeedsCheckNotificationEvent event, Emitter<FeedsState> emit) async {
    if (!kIsWeb) {
      try {
        //// Test //
        // emit(state.copyWith(status: FeedsStatus.newOrder, orderFrom: 'background'));
        //// Test //
        // // Live //
        await getNotificationList().then((orderList) {
          if (orderList.isNotEmpty) {
            List<dynamic> jsonList = jsonDecode(jsonEncode(orderList));
            List<OrderNotificationLocalListModel> modelList = jsonList.map((json) => OrderNotificationLocalListModel.fromJson(json)).toList();
            //// Live ////
            final int findNewOrderNotification = modelList.indexWhere((element) => element.status == 'new');
            if (findNewOrderNotification != -1) {
              emit(state.copyWith(status: FeedsStatus.newOrder, orderFrom: 'background'));
            }
            //// Live ////
          }
        });
        // Live //
      } catch (e, stacktrace) {
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
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

  FutureOr<void> _onFeedsFetchActiveOrderEvent(FeedsFetchActiveOrderEvent event, Emitter<FeedsState> emit) async {
    try {
      emit(state.copyWith(status: FeedsStatus.fetchActiveOrder));
      final String driverId = await _feedsRepository.driverId();
      DioApiResponse response = await _feedsRepository.getActiveOrder(driverId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        var orders = (jsonDecode(response.body) as List).map((value) => ActiveOrdersConfigModel.fromJson(value, locale.toString())).toList();
        state.response.orders = [...orders];
        emit(state.copyWith(status: FeedsStatus.success, response: state.response));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FeedsStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFeedsRestaurantDirectionEvent(FeedsRestaurantDirectionEvent event, Emitter<FeedsState> emit) async {
    try {
      final String restaurantId = state.response.restaurants![event.restaurantIndex].id!;
      final double restLat = state.response.restaurants![event.restaurantIndex].location!.coordinates![1];
      final double restLng = state.response.restaurants![event.restaurantIndex].location!.coordinates![0];
      final double driverLatitude = await _feedsRepository.driverLatitude();
      final double driverLongitude = await _feedsRepository.driverLongitude();
      DioApiResponse response = await _feedsRepository.googleDirection(driverLatitude != 0 ? driverLatitude : 0, driverLongitude != 0 ? driverLongitude : 0, restLat, restLng);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        GoogleDirectionResponseModel directionResponse = GoogleDirectionResponseModel.fromJson(myMap);
        if (directionResponse.routes!.isNotEmpty && directionResponse.routes![0].overviewPolyline!.points!.isNotEmpty) {
          final String routeLine = directionResponse.routes![0].overviewPolyline!.points!;
          final Set<Polyline> polyLines = <Polyline>{};
          polyLines.add(Polyline(polylineId: PolylineId(restaurantId), width: 10, points: convertToLatLng(decodePoly(routeLine)), color: ThemeProvider.primaryColor));
          emit(state.copyWith(polyline: polyLines, status: FeedsStatus.success));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FeedsStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FeedsStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
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
}
