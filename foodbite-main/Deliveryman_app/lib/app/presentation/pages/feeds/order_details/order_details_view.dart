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

import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/models/delivery_proof_modal_response_model.dart';
import 'package:driver/app/core/models/order_detail_response_model.dart';
import 'package:driver/app/presentation/pages/feeds/order_details/bloc/order_detail_bloc.dart';
import 'package:driver/app/presentation/pages/modals/order_delivery_proof/order_delivery_proof_view.dart';
import 'package:driver/app/presentation/pages/modals/order_pickup_proof/order_pickup_proof_view.dart';
import 'package:driver/app/presentation/pages/modals/order_verify_otp/order_verify_otp_view.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/background_location_dialog.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/router/app_route_config.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:driver/app/presentation/styles/map_style.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final String orderNo;
  const OrderDetailScreen({super.key, required this.orderId, required this.orderNo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailBloc()..add(OrderDetailInitialEvent(orderId: orderId, orderNo: orderNo)),
      child: const OrderDetailView(),
    );
  }
}

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isRestaurantReachError || state.status.isDriverPickError || state.status.isDriverDeliverError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isDeliverSuccess) {
          Navigator.of(context).pop(true);
        } else if (state.status.isBackgroundLocation) {
          showBackgroundLocationPermissionDialog(context).then((value) async {
            if (value) {
              if (!context.mounted) return;
              await openAppSettings();
            }
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("${translate.order_number} : ${state.orderNo}"),
            scrolledUnderElevation: 0,
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.supportChatRoute, arguments: ['orders', state.orderId]),
                label: Text(
                  translate.support,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'semibold', fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
                ),
                icon: Icon(Icons.chat_outlined, color: Theme.of(context).primaryColor, size: 12),
              ),
            ],
          ),

          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state.status.isLoading) {
                  return const OrderDetailLoadingView();
                }

                if (state.status.isFailure) {
                  return const OrderDetailErrorView();
                }

                if (state.status.isBackgroundLocation) {
                  return SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.65);
                }

                if (state.status.isRestaurantView || state.status.isRestaurantReachLoading || state.status.isRestaurantReachError) {
                  return OrderDetailRestaurantView(model: state.orderDetail, latitude: state.latitude, longitude: state.longitude, mapZoomLevel: state.mapZoomLevel, markers: state.markers, polyline: state.polyline);
                }

                if (state.status.isOrderView || state.status.isDriverPickLoading || state.status.isDriverPickError) {
                  return OrderDetailPickupView(model: state.orderDetail, toggleView: state.pickOrderToggle);
                }

                if (state.status.isCustomerView ||
                    state.status.isDriverReachCustomerLoading ||
                    state.status.isDriverReachCustomerError ||
                    state.status.isDriverDeliverLoading ||
                    state.status.isDriverDeliverError ||
                    state.status.isDeliverSuccess) {
                  return OrderDetailCustomerView(
                    model: state.orderDetail,
                    latitude: state.latitude,
                    longitude: state.longitude,
                    mapZoomLevel: state.mapZoomLevel,
                    markers: state.markers,
                    polyline: state.polyline,
                    driverReachCustomer: state.driverReachCustomer,
                    orderVerify: state.orderVerify,
                    collectMoney: state.collectMoney,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.status.isLoading) ...[
                    const Expanded(child: SizedBox()),
                  ] else if (state.status.isBackgroundLocation) ...[
                    const SizedBox.shrink(),
                  ] else if (state.status.isRestaurantView || state.status.isRestaurantReachLoading || state.status.isRestaurantReachError) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.read<OrderDetailBloc>().add(OrderDetailReachRestaurantEvent()),
                        style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40),
                        child: state.status.isRestaurantReachLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.reached_pickup_location),
                      ),
                    ),
                  ] else if (state.status.isOrderView || state.status.isDriverPickLoading || state.status.isDriverPickError) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (state.orderDetail.driverSettings!.deliveryProof!) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPickupProofScreen(orderId: state.orderId))).then((value) {
                              if (!context.mounted) return;
                              DeliveryProofModalResponseModel deliveryProofResponse = DeliveryProofModalResponseModel.fromJson(value);
                              if (deliveryProofResponse.action!) {
                                context.read<OrderDetailBloc>().add(OrderDetailPickupOrderEvent());
                              }
                            });
                          } else {
                            context.read<OrderDetailBloc>().add(OrderDetailPickupOrderEvent());
                          }
                        },
                        style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40),
                        child: state.status.isDriverPickLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.picked_order),
                      ),
                    ),
                  ] else if (state.status.isCustomerView ||
                      state.status.isDriverReachCustomerLoading ||
                      state.status.isDriverReachCustomerError ||
                      state.status.isDriverDeliverLoading ||
                      state.status.isDriverDeliverError ||
                      state.status.isDeliverSuccess) ...[
                    if (state.driverReachCustomer == false) ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.read<OrderDetailBloc>().add(OrderDetailDriverReachCustomerEvent()),
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40),
                          child: state.status.isDriverReachCustomerLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.reached_drop_location),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state.collectMoney && state.orderVerify
                              ? () {
                                  if (state.orderDetail.driverSettings!.deliveryProof!) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDeliveryProofScreen(orderId: state.orderId))).then((value) {
                                      if (!context.mounted) return;
                                      DeliveryProofModalResponseModel deliveryProofResponse = DeliveryProofModalResponseModel.fromJson(value);
                                      if (deliveryProofResponse.action!) {
                                        context.read<OrderDetailBloc>().add(OrderDetailDeliverOrderEvent());
                                      }
                                    });
                                  } else {
                                    context.read<OrderDetailBloc>().add(OrderDetailDeliverOrderEvent());
                                  }
                                }
                              : null,
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40),
                          child: state.status.isDriverDeliverLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.deliver_order),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrderDetailRestaurantView extends StatefulWidget {
  final OrderDetailResponseModel model;
  final double latitude;
  final double longitude;
  final double mapZoomLevel;
  final Set<Marker> markers;
  final Set<Polyline> polyline;
  const OrderDetailRestaurantView({super.key, required this.model, required this.latitude, required this.longitude, required this.mapZoomLevel, required this.markers, required this.polyline});

  @override
  State<OrderDetailRestaurantView> createState() => _OrderDetailRestaurantViewState();
}

class _OrderDetailRestaurantViewState extends State<OrderDetailRestaurantView> {
  final Completer<GoogleMapController> _googleMapController = Completer<GoogleMapController>();

  @override
  Future<void> dispose() async {
    super.dispose();
    if (!kIsWeb) {
      final GoogleMapController controller = await _googleMapController.future;
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
            ),
            child: Stack(
              children: [
                !kIsWeb
                    ? GoogleMap(
                        key: GlobalKey(),
                        myLocationEnabled: true,
                        compassEnabled: true,
                        tiltGesturesEnabled: false,
                        indoorViewEnabled: false,
                        trafficEnabled: false,
                        buildingsEnabled: false,
                        style: MapStyleHelper.mapStyles,
                        onMapCreated: (GoogleMapController controller) async {
                          if (!_googleMapController.isCompleted) {
                            _googleMapController.complete(controller);
                            CameraPosition nepPos = CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: widget.mapZoomLevel);
                            await controller.animateCamera(CameraUpdate.newCameraPosition(nepPos));
                          }
                        },
                        markers: widget.markers,
                        polylines: widget.polyline,
                        mapType: MapType.normal,
                        scrollGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        initialCameraPosition: CameraPosition(zoom: widget.mapZoomLevel, tilt: 0, bearing: 30, target: LatLng(widget.latitude, widget.longitude)),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(kAppTrimWord(widget.model.details!.restaurant!.name!, 35), style: kAppLblMediumFontBold(context)),
                                    kAppSpacerVertical(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 1.8,
                                      child: Text(widget.model.details!.restaurant!.address!, maxLines: 3, style: kAppLblTinyFontRegular(context)),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: CacheNetworkImageWidget(width: 40, height: 60.0, imageUrl: widget.model.details!.restaurant!.cover!),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (widget.model.driverSettings!.canInitiateCall!) ...[
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      final Uri numberLaunchUri = Uri(scheme: 'tel', path: '${widget.model.details!.countryCode!}${widget.model.details!.receiverContact!}');
                                      launchUrl(numberLaunchUri);
                                    },
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.call, size: 10, color: Theme.of(context).canvasColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.call, style: kAppLblTinyFontRegular(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () => context.read<OrderDetailBloc>().add(OrderDetailMapRedirectEvent()),
                                    child: Container(
                                      width: double.infinity,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.directions_outlined, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.go_to_map, style: kAppLblTinyRegularWhite(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Expanded(
                                  child: InkWell(
                                    onTap: () => context.read<OrderDetailBloc>().add(OrderDetailMapRedirectEvent()),
                                    child: Container(
                                      width: double.infinity,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.directions_outlined, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.go_to_map, style: kAppLblTinyRegularWhite(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  kAppSpacerVertical(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AssetsUrl.iconsURL.billItemTotalIcon, height: 15, width: 15, color: Theme.of(context).canvasColor),
                              kAppSpacerHorizontal(width: 5),
                              Text("${translate.order_number} :", style: kAppLblMediumFontRegular(context)),
                              kAppSpacerHorizontal(width: 5),
                              Text("#${widget.model.details!.orderNo!}", style: kAppLblMediumFontBold(context)),
                            ],
                          ),
                        ),
                        kAppSpacerVertical(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AssetsUrl.imageURL.checkoutDelivery, height: 15, width: 15, color: Theme.of(context).canvasColor),
                              kAppSpacerHorizontal(width: 5),
                              Text("${translate.customer} :", style: kAppLblMediumFontRegular(context)),
                              kAppSpacerHorizontal(width: 5),
                              Text(widget.model.details!.receiverName!, style: kAppLblMediumFontBold(context)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailPickupView extends StatelessWidget {
  final OrderDetailResponseModel model;
  final String toggleView;
  const OrderDetailPickupView({super.key, required this.model, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AssetsUrl.iconsURL.timeTag, height: 15, width: 15, color: Theme.of(context).canvasColor),
                kAppSpacerHorizontal(width: 10),
                Text(translate.pick_order_now, style: kAppLblMediumFontBold(context)),
              ],
            ),
          ),
          kAppSpacerVertical(height: 10),
          Text(translate.order_number, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text("${model.details!.orderNo!}", style: kAppLblLargeFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.order_ref, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(model.details!.id!.toUpperCase(), style: kAppLblLargeFontBold(context)),
          kAppSpacerVertical(height: 30),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context.read<OrderDetailBloc>().add(OrderDetailPickupViewToggleEvent(toggleView: 'order')),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate.order_details, style: kAppLblMediumFontBold(context)),
                              Text(model.details!.restaurant!.name!, style: kAppLblTinyFontRegular(context)),
                            ],
                          ),
                          Icon(toggleView == 'order' ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20, color: Theme.of(context).canvasColor),
                        ],
                      ),
                    ),
                  ),
                ),
                toggleView == 'order'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                model.details!.cartItem!.length,
                                (cartIndex) => Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          kAppFoodType(model.details!.cartItem![cartIndex].foodType!, height: 10, width: 10),
                                          kAppSpacerHorizontal(width: 5),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("${model.details!.cartItem![cartIndex].quantity!}", style: kAppLblTinyFontBold(context)),
                                                  Text(" X ", style: kAppLblTinyFontBold(context)),
                                                  Text(kAppTrimWord(model.details!.cartItem![cartIndex].name!, 40), style: kAppLblTinyFontBold(context)),
                                                ],
                                              ),
                                              Container(
                                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                                child: Text(model.details!.cartItem![cartIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          kAppSpacerVertical(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context.read<OrderDetailBloc>().add(OrderDetailPickupViewToggleEvent(toggleView: 'customer')),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(translate.drop_up_detail, style: kAppLblMediumFontBold(context)),
                          Icon(toggleView == 'customer' ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20, color: Theme.of(context).canvasColor),
                        ],
                      ),
                    ),
                  ),
                ),
                toggleView == 'customer'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.user, size: 10, color: Theme.of(context).canvasColor),
                                kAppSpacerHorizontal(width: 10),
                                Text(model.details!.deliveryAddressRaw!.receiverName!, style: kAppLblMediumFontBold(context)),
                              ],
                            ),
                            kAppSpacerVertical(height: 5),
                            Text("${model.details!.deliveryAddressRaw!.flatHouse!}, ${model.details!.deliveryAddressRaw!.locality!}, ${model.details!.deliveryAddressRaw!.landmark!}", style: kAppLblSmallFontMedium(context)),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          kAppSpacerVertical(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context.read<OrderDetailBloc>().add(OrderDetailPickupViewToggleEvent(toggleView: 'restaurant')),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(translate.restaurant_details, style: kAppLblMediumFontBold(context)),
                          Icon(toggleView == 'restaurant' ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20, color: Theme.of(context).canvasColor),
                        ],
                      ),
                    ),
                  ),
                ),
                toggleView == 'restaurant'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.shop, size: 10, color: Theme.of(context).canvasColor),
                                kAppSpacerHorizontal(width: 10),
                                Text(model.details!.restaurant!.name!, style: kAppLblMediumFontBold(context)),
                              ],
                            ),
                            kAppSpacerVertical(height: 5),
                            Text(model.details!.restaurant!.address!, style: kAppLblSmallFontMedium(context)),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          kAppSpacerVertical(height: 10),
          Text(model.orderSettings!.deliveryVerification! ? '${translate.otp_to_restaurant} - ${model.details!.driverOrderPin}' : '', style: kAppLblMediumFontBold(context)),
        ],
      ),
    );
  }
}

class OrderDetailCustomerView extends StatefulWidget {
  final OrderDetailResponseModel model;
  final double latitude;
  final double longitude;
  final double mapZoomLevel;
  final Set<Marker> markers;
  final Set<Polyline> polyline;
  final bool driverReachCustomer;
  final bool orderVerify;
  final bool collectMoney;
  const OrderDetailCustomerView({
    super.key,
    required this.model,
    required this.latitude,
    required this.longitude,
    required this.mapZoomLevel,
    required this.markers,
    required this.polyline,
    required this.driverReachCustomer,
    required this.orderVerify,
    required this.collectMoney,
  });

  @override
  State<OrderDetailCustomerView> createState() => _OrderDetailCustomerViewState();
}

class _OrderDetailCustomerViewState extends State<OrderDetailCustomerView> {
  final Completer<GoogleMapController> _googleMapController = Completer<GoogleMapController>();

  @override
  Future<void> dispose() async {
    super.dispose();
    if (!kIsWeb) {
      final GoogleMapController controller = await _googleMapController.future;
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
            ),
            child: Stack(
              children: [
                !kIsWeb
                    ? GoogleMap(
                        key: GlobalKey(),
                        myLocationEnabled: true,
                        compassEnabled: true,
                        tiltGesturesEnabled: false,
                        indoorViewEnabled: false,
                        trafficEnabled: false,
                        buildingsEnabled: false,
                        style: MapStyleHelper.mapStyles,
                        onMapCreated: (GoogleMapController controller) async {
                          if (!_googleMapController.isCompleted) {
                            _googleMapController.complete(controller);
                            CameraPosition nepPos = CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: widget.mapZoomLevel);
                            await controller.animateCamera(CameraUpdate.newCameraPosition(nepPos));
                          }
                        },
                        markers: widget.markers,
                        polylines: widget.polyline,
                        mapType: MapType.normal,
                        scrollGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        initialCameraPosition: CameraPosition(zoom: widget.mapZoomLevel, tilt: 0, bearing: 30, target: LatLng(widget.latitude, widget.longitude)),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.model.details!.paymentInfo!.paymentWay! == 'offline') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${translate.collect_money} ${kAppPriceFormat(widget.model.details!.grandTotal!)}", style: kAppLblMediumFontBold(context)),
                                    Text("${translate.order_number} : ${widget.model.details!.orderNo!}", style: kAppLblSmallFontMedium(context)),
                                  ],
                                ),
                                IconButton(onPressed: () => context.read<OrderDetailBloc>().add(OrderDetailCollectMoneyEvent()), icon: Icon(widget.collectMoney ? Icons.check_box : Icons.check_box_outline_blank)),
                              ],
                            ),
                          ] else ...[
                            Text(translate.paid_online, style: kAppLblMediumFontBold(context)),
                            Text("${translate.order_number} : ${widget.model.details!.orderNo!}", style: kAppLblSmallFontMedium(context)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  widget.model.orderSettings!.deliveryVerification!
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(translate.verify_order_with_customer, style: kAppLblMediumFontBold(context)),
                                    Text(translate.ask_customer_for_otp, style: kAppLblSmallFontMedium(context)),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderVerifyOtpScreen(orderId: widget.model.details!.id!, customerPin: widget.model.details!.customerOrderPin!),
                                      ),
                                    ).then((value) {
                                      if (!context.mounted) return;
                                      if (value != null && value.toString() == 'true') {
                                        context.read<OrderDetailBloc>().add(OrderDetailVerifyCustomerEvent());
                                      }
                                    });
                                  },
                                  child: Text(widget.orderVerify ? translate.verified : translate.verify, style: kAppLblSmallFontMedium(context)),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.model.details!.deliveryAddressRaw!.receiverName!, style: kAppLblMediumFontBold(context)),
                                    kAppSpacerVertical(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 1.8,
                                      child: Text(
                                        '${widget.model.details!.deliveryAddressRaw!.flatHouse!}, ${widget.model.details!.deliveryAddressRaw!.locality!}, ${widget.model.details!.deliveryAddressRaw!.landmark!}',
                                        maxLines: 3,
                                        style: kAppLblTinyFontRegular(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: widget.model.driverSettings!.canInitiateCall!
                                    ? InkWell(
                                        onTap: () {
                                          final Uri numberLaunchUri = Uri(scheme: 'tel', path: '${widget.model.details!.countryCode!}${widget.model.details!.receiverContact!}');
                                          launchUrl(numberLaunchUri);
                                        },
                                        child: SizedBox(width: 30, height: 30, child: Icon(Icons.call, size: 20, color: Theme.of(context).canvasColor)),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (widget.model.driverSettings!.canInitiateChat!) ...[
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).pushNamed(AppRouter.messagesRoute, arguments: [widget.model.details!.user!, widget.model.details!.receiverName!]),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.chat_rounded, size: 10, color: Theme.of(context).canvasColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.message, style: kAppLblTinyFontRegular(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () => context.read<OrderDetailBloc>().add(OrderDetailMapRedirectEvent()),
                                    child: Container(
                                      width: double.infinity,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.directions_outlined, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.go_to_map, style: kAppLblTinyRegularWhite(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Expanded(
                                  child: InkWell(
                                    onTap: () => context.read<OrderDetailBloc>().add(OrderDetailMapRedirectEvent()),
                                    child: Container(
                                      width: double.infinity,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.directions_outlined, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.go_to_map, style: kAppLblTinyRegularWhite(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AssetsUrl.iconsURL.billItemTotalIcon, height: 15, width: 15, color: Theme.of(context).canvasColor),
                              kAppSpacerHorizontal(width: 5),
                              Text("${translate.order_number} :", style: kAppLblMediumFontRegular(context)),
                              kAppSpacerHorizontal(width: 5),
                              Text("#${widget.model.details!.orderNo!}", style: kAppLblMediumFontBold(context)),
                            ],
                          ),
                        ),
                        kAppSpacerVertical(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AssetsUrl.imageURL.checkoutDelivery, height: 15, width: 15, color: Theme.of(context).canvasColor),
                              kAppSpacerHorizontal(width: 5),
                              Text("${translate.pickup} :", style: kAppLblMediumFontRegular(context)),
                              kAppSpacerHorizontal(width: 5),
                              Text(widget.model.details!.restaurant!.name!, style: kAppLblMediumFontBold(context)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.driverReachCustomer
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(translate.order_details, style: kAppLblMediumFontBold(context)),
                                          Text(widget.model.details!.restaurant!.name!, style: kAppLblTinyFontRegular(context)),
                                        ],
                                      ),
                                      Icon(Icons.keyboard_arrow_down, size: 20, color: Theme.of(context).canvasColor),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(
                                        widget.model.details!.cartItem!.length,
                                        (cartIndex) => Container(
                                          margin: const EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  kAppFoodType(widget.model.details!.cartItem![cartIndex].foodType!, height: 10, width: 10),
                                                  kAppSpacerHorizontal(width: 5),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text("${widget.model.details!.cartItem![cartIndex].quantity!}", style: kAppLblTinyFontBold(context)),
                                                          Text(" X ", style: kAppLblTinyFontBold(context)),
                                                          Text(kAppTrimWord(widget.model.details!.cartItem![cartIndex].name!, 40), style: kAppLblTinyFontBold(context)),
                                                        ],
                                                      ),
                                                      Container(
                                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                                        child: Text(widget.model.details!.cartItem![cartIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  widget.model.details!.deliveryInstructionInfo!.id!.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15, width: 15, child: CacheNetworkImageWidget(width: 15, height: 15, imageUrl: widget.model.details!.deliveryInstructionInfo!.image!)),
                                kAppSpacerHorizontal(width: 5),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  child: Text(widget.model.details!.deliveryInstructionInfo!.name!, maxLines: 2, style: kAppLblMediumFontRegular(context)),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailLoadingView extends StatelessWidget {
  const OrderDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonAvatar(
          style: SkeletonAvatarStyle(borderRadius: BorderRadius.circular(10), height: MediaQuery.of(context).size.height * 0.30, width: MediaQuery.of(context).size.width),
        ),
        kAppSpacerVertical(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SkeletonLine(style: SkeletonLineStyle(borderRadius: BorderRadius.circular(10), height: 10, width: 80))],
        ),
        kAppSpacerVertical(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [SkeletonLine(style: SkeletonLineStyle(borderRadius: BorderRadius.circular(10), height: 10, width: 80))],
                ),
              ),
              kAppSpacerVertical(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [SkeletonLine(style: SkeletonLineStyle(borderRadius: BorderRadius.circular(10), height: 10, width: 80))],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [SkeletonLine(style: SkeletonLineStyle(borderRadius: BorderRadius.circular(10), height: 10, width: 80))],
                    ),
                  ),
                ],
              ),
              kAppSpacerVertical(height: 10),
            ],
          ),
        ),
        kAppSpacerVertical(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
          ),
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
              ),
              kAppSpacerVertical(height: 5),
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.2, borderRadius: BorderRadius.circular(8)),
              ),
              kAppSpacerVertical(height: 5),
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2.8, borderRadius: BorderRadius.circular(8)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderDetailErrorView extends StatelessWidget {
  const OrderDetailErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 10),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 10),
          Text(translate.something_went_wrong_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //