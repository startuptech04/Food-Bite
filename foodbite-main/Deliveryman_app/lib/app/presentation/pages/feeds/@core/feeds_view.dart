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
import 'package:driver/app/core/models/near_me_trending_restaurants_model.dart';
import 'package:driver/app/presentation/pages/feeds/@core/bloc/feeds_bloc.dart';
import 'package:driver/app/presentation/pages/modals/go_online/go_online_view.dart';
import 'package:driver/app/presentation/pages/modals/new_order/new_order_view.dart';
import 'package:driver/app/presentation/pages/modals/offline_reasons/offline_reasons_view.dart';
import 'package:driver/app/presentation/pages/modals/permission_denied/location_permission_denied_view.dart';
import 'package:driver/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/map_style.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/router/app_route_config.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state.status.isNewNotification) {
              context.read<FeedsBloc>().add(FeedsNewOrderNotificationEvent());
            }
          },
        ),
      ],
      child: const FeedView(),
    );
  }
}

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final Completer<GoogleMapController> _googleMapController = Completer<GoogleMapController>();
  final ScrollController bottomSectionController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FeedsBloc>().add(FeedsInitialEvent());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    if (!kIsWeb) {
      final GoogleMapController controller = await _googleMapController.future;
      controller.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      context.read<FeedsBloc>().add(FeedsCheckNotificationEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<FeedsBloc, FeedsState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isDriverBlocked) {
          showErrorDialog(context, translate.your_account_is_blocked, state.extraMessage.toString(), state.statusCode);
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.loginRoute, (Route<dynamic> route) => false);
        } else if (state.status.isDeniedForever) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                content: SizedBox(height: height - 400, width: width - 80, child: const LocationPermissionDeniedDialonScreen()),
              );
            },
          ).then((value) {
            if (!context.mounted) return;
            if (value == true) {
              context.read<FeedsBloc>().add(FeedsLocationOpenSettingEvent());
            }
          });
        } else if (state.status.isNewOrder) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            builder: (BuildContext context) {
              return FractionallySizedBox(heightFactor: 1, child: NewOrderModalScreen(orderFrom: state.orderFrom));
            },
          ).then((value) {
            if (!context.mounted) return;
            if (value != null && value.toString() != '' && value.toString() == 'true') {
              context.read<FeedsBloc>().add(FeedsFetchActiveOrderEvent());
            }
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            leading: state.status.isLoading || state.status.isFetchActiveOrder
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state.response.driverInfo != null && state.response.driverInfo!.activeStatus! == true && state.response.driverInfo!.isBlocked! == false) ...[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: false,
                                enableDrag: false,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (BuildContext context) {
                                  return const FractionallySizedBox(heightFactor: 0.7, child: OfflineReasonScreen());
                                },
                              ).then((value) {
                                if (!context.mounted) return;
                                if (value != null && value.toString().isNotEmpty) {
                                  context.read<FeedsBloc>().add(FeedsGoOfflineEvent(messageId: value));
                                }
                              });
                            },
                            child: Container(
                              height: 20,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(translate.online, style: kAppLblTinyRegularWhite(context)),
                                  Icon(Icons.circle, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ] else if (state.response.driverInfo != null && state.response.driverInfo!.activeStatus! == false && state.response.driverInfo!.isBlocked! == false) ...[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: false,
                                enableDrag: false,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (BuildContext context) {
                                  return const FractionallySizedBox(heightFactor: 0.3, child: GoOnlineScreen());
                                },
                              ).then((value) {
                                if (!context.mounted) return;
                                if (value != null && value.toString() == 'true') {
                                  context.read<FeedsBloc>().add(FeedsGoOnlineEvent());
                                }
                              });
                            },
                            child: Container(
                              height: 20,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(color: Theme.of(context).canvasColor, width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.circle, size: 10, color: Theme.of(context).canvasColor),
                                  Text(translate.offline, style: kAppLblTinyFontRegularChip(context, color: 'regular')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Container(
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.block_flipped, size: 10, color: Theme.of(context).primaryColor),
                                Text(translate.blocked, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
            leadingWidth: 80,
            actions: [
              IconButton(onPressed: () => Navigator.of(context).pushNamed(AppRouter.notificationRoute), icon: const FaIcon(FontAwesomeIcons.bell)),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(heightFactor: 1, child: NewOrderModalScreen(orderFrom: state.orderFrom));
                    },
                  ).then((value) {
                    if (!context.mounted) return;
                    if (value != null && value.toString() != '' && value.toString() == 'true') {
                      context.read<FeedsBloc>().add(FeedsFetchActiveOrderEvent());
                    }
                  });
                },
                icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                  ),
                  child: Stack(
                    children: [
                      !kIsWeb
                          ? GoogleMap(
                              key: GlobalKey(),
                              myLocationEnabled: false,
                              compassEnabled: false,
                              tiltGesturesEnabled: false,
                              indoorViewEnabled: false,
                              trafficEnabled: false,
                              buildingsEnabled: false,
                              style: MapStyleHelper.mapStyles,
                              onMapCreated: (GoogleMapController controller) async {
                                if (!_googleMapController.isCompleted) {
                                  _googleMapController.complete(controller);
                                  if (state.status.isSuccess || state.status.isEmpty) {
                                    CameraPosition nepPos = CameraPosition(target: LatLng(state.latitude, state.longitude), zoom: state.mapZoomLevel);
                                    await controller.animateCamera(CameraUpdate.newCameraPosition(nepPos));
                                  }
                                }
                              },
                              markers: state.markers,
                              polylines: state.polyline,
                              mapType: MapType.normal,
                              scrollGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              zoomGesturesEnabled: true,
                              initialCameraPosition: CameraPosition(zoom: state.mapZoomLevel, tilt: 0, bearing: 30, target: LatLng(state.latitude, state.longitude)),
                            )
                          : const SizedBox(),
                      Positioned.fill(
                        child: Align(alignment: Alignment.topCenter, child: Image.asset(AssetsUrl.gifURL.radarGif, height: 50, width: 50)),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () => state.status.isLoading ? null : context.read<FeedsBloc>().add(FeedsRefreshLocationEvent()),
                            child: Container(
                              height: 30,
                              width: 100,
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(state.status.isLoading ? Icons.adjust_outlined : Icons.refresh_rounded, size: 14, color: Theme.of(context).scaffoldBackgroundColor),
                                  kAppSpacerHorizontal(width: 5),
                                  Text(state.status.isLoading ? translate.fetching : translate.refresh, style: kAppLblTinyRegularWhite(context)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => context.read<FeedsBloc>().add(FeedsRefreshLocationEvent()),
                                  child: Icon(Icons.my_location_outlined, color: Theme.of(context).canvasColor, size: 15),
                                ),
                                InkWell(
                                  onTap: () => context.read<FeedsBloc>().add(FeedsChangeMapZoomLevelEvent(action: 'decrement')),
                                  child: Icon(Icons.remove_circle_outline, color: Theme.of(context).canvasColor, size: 15),
                                ),
                                InkWell(
                                  onTap: () => context.read<FeedsBloc>().add(FeedsChangeMapZoomLevelEvent(action: 'increment')),
                                  child: Icon(Icons.add_circle_outline, color: Theme.of(context).canvasColor, size: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              controller: bottomSectionController,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (state.status.isLoading) ...[
                                    const FeedsLoadingView(),
                                  ] else if (state.response.driverInfo != null) ...[
                                    if (state.response.driverInfo!.activeStatus! == false || state.response.driverInfo!.isBlocked! == true) ...[
                                      FeedsAccountOfflineOrBlockedView(isActiveStatus: state.response.driverInfo!.activeStatus!, isBlocked: state.response.driverInfo!.isBlocked!),
                                    ],
                                  ] else if (state.status.isEmpty) ...[
                                    const FeedsEmptyRestaurantsView(),
                                  ] else ...[
                                    FeedsRestaurantTile(model: state.response),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text("${translate.active_orders} (${state.response.orders!.length.toString()})", style: kAppLblMediumFontBold(context)),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: bottomSectionController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.status.isLoading || state.status.isFetchActiveOrder) ...[
                          const FeedsLoadingView(),
                        ] else if (state.response.orders!.isEmpty) ...[
                          const FeedsEmptyActiveOrdersView(),
                        ] else ...[
                          FeedsActiveOrdersTile(model: state.response),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FeedsRestaurantTile extends StatelessWidget {
  final NearMeTrendingRestaurantsModel model;
  const FeedsRestaurantTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          model.restaurants!.length,
          (index) => Container(
            width: MediaQuery.of(context).size.width / 1.1,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kAppTrimWord(model.restaurants![index].name!, 30), style: kAppLblMediumFontBold(context)),
                      kAppSpacerVertical(height: 5),
                      Text(kAppTrimWord(model.restaurants![index].address!, 70), style: kAppLblTinyFontRegular(context)),
                      kAppSpacerVertical(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, size: 12, color: Theme.of(context).canvasColor),
                          kAppSpacerHorizontal(width: 5),
                          Text("${model.restaurants![index].distance!} ${model.findMode}", style: kAppLblTinyFontRegular(context)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      if (!kIsWeb) {
                        context.read<FeedsBloc>().add(FeedsRestaurantDirectionEvent(restaurantIndex: index));
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                          child: Center(child: Icon(Icons.directions_outlined, size: 13, color: Theme.of(context).scaffoldBackgroundColor)),
                        ),
                        kAppSpacerVertical(height: 5),
                        Text(translate.direction, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedsActiveOrdersTile extends StatelessWidget {
  final NearMeTrendingRestaurantsModel model;
  const FeedsActiveOrdersTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          model.orders!.length,
          (index) => InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.orderDetailRoute, arguments: [model.orders![index].orderId!, model.orders![index].orderInfo!.orderNo!.toString()]).then((value) {
                if (!context.mounted) return;
                if (value != null && value.toString() == 'true') {
                  context.read<FeedsBloc>().add(FeedsFetchActiveOrderEvent());
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${translate.order_number} :", style: kAppLblTinyFontRegular(context)),
                      kAppSpacerHorizontal(width: 10),
                      Text("#${model.orders![index].orderInfo!.orderNo!}", style: kAppLblTinyFontBold(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(AssetsUrl.imageURL.orderPick, height: 25, width: 25),
                      kAppSpacerHorizontal(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate.pickup_order, style: kAppLblTinyFontRegular(context)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Text(model.orders![index].restaurant!.address!, maxLines: 2, style: kAppLblTinyFontBold(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(AssetsUrl.imageURL.orderDrop, height: 25, width: 25),
                      kAppSpacerHorizontal(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate.deliver_order, style: kAppLblTinyFontRegular(context)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Text(model.orders![index].deliveryAddressRaw!.fullAddress!, maxLines: 2, style: kAppLblTinyFontBold(context)),
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
      ),
    );
  }
}

class FeedsEmptyRestaurantsView extends StatelessWidget {
  const FeedsEmptyRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetsUrl.gifURL.offlineGif, height: 60, width: 60),
            kAppSpacerVertical(height: 5),
            Text(translate.no_restaurant_found_on_address, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class FeedsEmptyActiveOrdersView extends StatelessWidget {
  const FeedsEmptyActiveOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AssetsUrl.gifURL.offlineGif, height: 60, width: 60),
          kAppSpacerVertical(height: 5),
          Text(translate.no_active_order_found, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class FeedsLoadingView extends StatelessWidget {
  const FeedsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5,
          (index) => Container(
            width: MediaQuery.of(context).size.width / 1.1,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
        ),
      ),
    );
  }
}

class FeedsAccountOfflineOrBlockedView extends StatelessWidget {
  final bool isActiveStatus;
  final bool isBlocked;
  const FeedsAccountOfflineOrBlockedView({super.key, required this.isActiveStatus, required this.isBlocked});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(isActiveStatus == false ? AssetsUrl.gifURL.offlineGif : AssetsUrl.gifURL.blocked, height: 60, width: 60),
          kAppSpacerVertical(height: 5),
          Text(isActiveStatus == false ? translate.you_are_offline : translate.your_account_is_blocked, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //