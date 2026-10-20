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
import 'package:driver/app/presentation/pages/modals/cancellation_reasons/cancellation_reason_modal_view.dart';
import 'package:driver/app/presentation/pages/modals/new_order/bloc/new_order_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/map_style.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NewOrderModalScreen extends StatelessWidget {
  final String orderFrom;
  const NewOrderModalScreen({super.key, required this.orderFrom});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewOrderBloc()..add(NewOrderInitialEvent(orderFrom: orderFrom)),
      child: const NewOrderModalView(),
    );
  }
}

class NewOrderModalView extends StatefulWidget {
  const NewOrderModalView({super.key});

  @override
  State<NewOrderModalView> createState() => _NewOrderModalViewState();
}

class _NewOrderModalViewState extends State<NewOrderModalView> {
  final Completer<GoogleMapController> _googleMapController = Completer<GoogleMapController>();
  PageController pageController = PageController(initialPage: 0, viewportFraction: 1);
  final AudioPlayer player = AudioPlayer();

  Future<void> playSound(String sound) async {
    await player.setAsset(sound);
    await player.setVolume(1.0);
    await player.play();
  }

  @override
  void dispose() async {
    super.dispose();
    if (!kIsWeb) {
      final GoogleMapController controller = await _googleMapController.future;
      controller.dispose();
    }
    if (player.playerState.playing) {
      player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<NewOrderBloc, NewOrderState>(
      listener: (context, state) {
        if (state.status.isLoading && state.orderFrom == 'online') {
          playSound(state.sound);
        } else if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop();
          });
        } else if (state.status.isSwipeNext) {
          pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        } else if (state.status.isProcessed) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  kAppSpacerVertical(height: 60),
                  state.status.isSuccess || state.status.isCustomError || state.status.isAccept || state.status.isReject || state.status.isSwipeNext
                      ? Text(
                          state.orders.orders!.length == 1 ? translate.you_have_received_new_order : '${translate.you_have_new_order_one} ${state.orders.orders!.length} ${translate.you_have_new_order_two}',
                          style: kAppLblMediumFontBold(context),
                        )
                      : const Text(''),
                  kAppSpacerVertical(height: 20),
                  if (state.status.isInitial || state.status.isLoading) ...[
                    const NewOrderLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const NewOrderErrorView(),
                  ] else if (state.status.isEmpty) ...[
                    const NewOrderEmptyView(),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: !kIsWeb
                              ? GoogleMap(
                                  key: GlobalKey(),
                                  myLocationEnabled: false,
                                  compassEnabled: false,
                                  tiltGesturesEnabled: false,
                                  indoorViewEnabled: false,
                                  trafficEnabled: false,
                                  buildingsEnabled: false,
                                  style: MapStyleHelper.mapStyles,
                                  onMapCreated: (GoogleMapController controller) {
                                    if (!_googleMapController.isCompleted) {
                                      _googleMapController.complete(controller);
                                    }
                                  },
                                  markers: state.markers,
                                  mapType: MapType.normal,
                                  scrollGesturesEnabled: false,
                                  zoomControlsEnabled: true,
                                  zoomGesturesEnabled: true,
                                  initialCameraPosition: CameraPosition(zoom: 12, tilt: 0, bearing: 30, target: LatLng(state.driverLatitude, state.driverLongitude)),
                                )
                              : const SizedBox(),
                        ),
                        kAppSpacerVertical(height: 20),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: PageView.builder(
                            itemCount: state.orders.orders!.length,
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(state.orders.orders!.length == 1 ? translate.new_order : '${translate.order} (${state.currentPageIndex + 1}/${state.orders.orders!.length})', style: kAppLblMediumFontBold(context)),
                                    ],
                                  ),
                                  kAppSpacerVertical(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        state.orders.driverSettings!.showEarning!
                                            ? Container(
                                                width: MediaQuery.of(context).size.width,
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                decoration: BoxDecoration(
                                                  border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                                                ),
                                                child: state.orders.driverInfo!.type! == 'freelancer' && state.orders.driverSettings!.earningModel! == 'order'
                                                    ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text("${translate.expected_earning} :", style: kAppLblMediumFontRegular(context)),
                                                          kAppSpacerHorizontal(width: 10),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(kAppPriceFormat(state.orders.orders![index].orderEarning!), style: kAppLblMediumFontBold(context)),
                                                              state.orders.orders![index].incentiveAmount! > 0
                                                                  ? Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        kAppSpacerHorizontal(width: 5),
                                                                        Text("+", style: kAppLblMediumFontBold(context, color: 'primary')),
                                                                        kAppSpacerHorizontal(width: 5),
                                                                        Text(kAppPriceFormat(state.orders.orders![index].incentiveAmount!), style: kAppLblMediumFontBold(context, color: 'primary')),
                                                                      ],
                                                                    )
                                                                  : const SizedBox(),
                                                              state.orders.orders![index].deliveryTipAmount! > 0
                                                                  ? Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        kAppSpacerHorizontal(width: 5),
                                                                        Text("+", style: kAppLblMediumFontBold(context, color: 'primary')),
                                                                        kAppSpacerHorizontal(width: 5),
                                                                        Text(kAppPriceFormat(state.orders.orders![index].deliveryTipAmount!), style: kAppLblMediumFontBold(context, color: 'primary')),
                                                                      ],
                                                                    )
                                                                  : const SizedBox(),
                                                              state.orders.orders![index].extraEarningOnShift! > 0
                                                                  ? Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        kAppSpacerHorizontal(width: 5),
                                                                        Text("+", style: kAppLblMediumFontBold(context, color: 'primary')),
                                                                        kAppSpacerHorizontal(width: 5),
                                                                        Text(kAppPriceFormat(state.orders.orders![index].extraEarningOnShift!), style: kAppLblMediumFontBold(context, color: 'primary')),
                                                                      ],
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [Text(translate.will_receive_fixed_salary, style: kAppLblMediumFontRegular(context))],
                                                      ),
                                              )
                                            : const SizedBox(),
                                        state.orders.driverSettings!.showEarning! ? kAppSpacerVertical(height: 10) : const SizedBox(),
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
                                                  children: [
                                                    Text("${translate.pickup} :", style: kAppLblSmallFontRegular(context)),
                                                    kAppSpacerHorizontal(width: 10),
                                                    Text("${state.orders.orders![index].pickupDistance}${state.orders.findMode!}", style: kAppLblSmallFontBold(context)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("${translate.drop} :", style: kAppLblSmallFontRegular(context)),
                                                  kAppSpacerHorizontal(width: 10),
                                                  Text("${state.orders.orders![index].dropDistance}${state.orders.findMode!}", style: kAppLblSmallFontBold(context)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        kAppSpacerVertical(height: 10),
                                      ],
                                    ),
                                  ),
                                  kAppSpacerVertical(height: 20),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(translate.pickup_from, style: kAppLblTinyFontRegular(context)),
                                        kAppSpacerVertical(height: 5),
                                        Text("${translate.order_id} : #${state.orders.orders![index].orderNo!}", style: kAppLblTinyFontRegular(context)),
                                        kAppSpacerVertical(height: 5),
                                        Text(state.orders.orders![index].restaurant!.name!, style: kAppLblMediumFontBold(context)),
                                        kAppSpacerVertical(height: 5),
                                        Text(state.orders.orders![index].restaurant!.address!, maxLines: 3, style: kAppLblTinyFontRegular(context)),
                                        kAppSpacerVertical(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.punch_clock_outlined, size: 10, color: Theme.of(context).canvasColor),
                                            kAppSpacerHorizontal(width: 5),
                                            Text("${state.orders.orders![index].restaurantETA} ${translate.away}", style: kAppLblTinyFontRegular(context)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: AbsorbPointer(
                  absorbing: state.status.isAccept || state.status.isReject ? true : false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.status.isInitial || state.status.isLoading) ...[
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
                      ] else if (state.status.isEmpty || state.status.isFailure) ...[
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40),
                              child: Text(translate.close),
                            ),
                          ),
                        ),
                      ] else if (state.status.isSuccess || state.status.isCustomError || state.status.isAccept || state.status.isReject || state.status.isSwipeNext) ...[
                        if (state.orders.ordersSettings!.driverCanCancelOrder!) ...[
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    enableDrag: false,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return const FractionallySizedBox(heightFactor: 0.7, child: CancellationReasonModalScreen());
                                    },
                                  ).then((value) {
                                    if (!context.mounted) return;
                                    if (value != null && value.toString().isNotEmpty) {
                                      context.read<NewOrderBloc>().add(NewOrderRejectEvent(reasonId: value));
                                    }
                                  });
                                },
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).scaffoldBackgroundColor, foreColor: Theme.of(context).canvasColor, height: 40.0),
                                child: state.status.isReject ? kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.reject_order),
                              ),
                            ),
                          ),
                          kAppSpacerHorizontal(width: 10),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => context.read<NewOrderBloc>().add(NewOrderAcceptEvent()),
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40),
                                child: state.status.isAccept ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.accept_order),
                              ),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => context.read<NewOrderBloc>().add(NewOrderAcceptEvent()),
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40),
                                child: state.status.isAccept ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.accept_order),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NewOrderLoadingView extends StatelessWidget {
  const NewOrderLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonAvatar(
          style: SkeletonAvatarStyle(borderRadius: BorderRadius.circular(10), height: MediaQuery.of(context).size.height * 0.30, width: MediaQuery.of(context).size.width),
        ),
        kAppSpacerVertical(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SkeletonLine(style: SkeletonLineStyle(borderRadius: BorderRadius.circular(10), height: 10, width: 80))],
        ),
        kAppSpacerVertical(height: 20),
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
        kAppSpacerVertical(height: 20),
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

class NewOrderErrorView extends StatelessWidget {
  const NewOrderErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.something_went_wrong_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class NewOrderEmptyView extends StatelessWidget {
  const NewOrderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_matching_record_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_order_found_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //