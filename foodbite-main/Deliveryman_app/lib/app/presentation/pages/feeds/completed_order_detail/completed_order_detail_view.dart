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

import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/models/order_detail_response_model.dart';
import 'package:driver/app/presentation/pages/feeds/completed_order_detail/bloc/completed_order_detail_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/router/app_route_config.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class CompletedOrderDetailScreen extends StatelessWidget {
  final String id;
  final String orderNo;
  const CompletedOrderDetailScreen({super.key, required this.id, required this.orderNo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompletedOrderDetailBloc()..add(CompletedOrderDetailInitialEvent(id: id, orderNo: orderNo)),
      child: const CompletedOrderDetailView(),
    );
  }
}

class CompletedOrderDetailView extends StatelessWidget {
  const CompletedOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<CompletedOrderDetailBloc, CompletedOrderDetailState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
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
                iconAlignment: IconAlignment.start,
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.status.isLoading) ...[
                const CompletedOrderDetailLoadingView(),
              ] else if (state.status.isFailure) ...[
                const CompletedOrderDetailErrorView(),
              ] else ...[
                CompletedOrderDetailResponseWidget(model: state.orderDetail),
              ],
            ],
          ),
        );
      },
    );
  }
}

class CompletedOrderDetailResponseWidget extends StatelessWidget {
  final OrderDetailResponseModel model;
  const CompletedOrderDetailResponseWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(left: ThemeProvider.scaffoldPadding, right: ThemeProvider.scaffoldPadding, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu_outlined, color: Theme.of(context).primaryColor, size: 18),
              kAppSpacerHorizontal(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kAppTrimWord(model.details!.restaurant!.name!, 40), style: kAppLblTinyFontBold(context)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(model.details!.restaurant!.address!, maxLines: 2, style: kAppLblTinyFontRegular(context)),
                  ),
                ],
              ),
            ],
          ),
          kAppSpacerVertical(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.location_on_rounded, color: Theme.of(context).primaryColor, size: 18),
              kAppSpacerHorizontal(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kAppTrimWord(model.details!.receiverName!, 40), style: kAppLblTinyFontBold(context)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(model.details!.deliveryFullAddress!, maxLines: 2, style: kAppLblTinyFontRegular(context)),
                  ),
                ],
              ),
            ],
          ),
          kAppSpacerVertical(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              model.details!.cartItem!.length,
              (cartIndex) => Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        kAppFoodType(model.details!.cartItem![cartIndex].foodType!, height: 10, width: 10),
                        kAppSpacerHorizontal(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${model.details!.cartItem![cartIndex].quantity!}", style: kAppLblMediumFontSemiBold(context)),
                                Text(" X ", style: kAppLblMediumFontSemiBold(context)),
                                Text(kAppTrimWord(model.details!.cartItem![cartIndex].name!, 40), style: kAppLblMediumFontSemiBold(context)),
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
                    Text(kAppPriceFormat(model.details!.cartItem![cartIndex].totalPrice!), style: kAppLblMediumFontSemiBold(context)),
                  ],
                ),
              ),
            ),
          ),
          kAppSpacerVertical(height: 20),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.bonuses, style: kAppLblTinyFontRegular(context)),
                    Text(kAppPriceFormat(model.details!.orderExtraDetail!.incentiveAmount!), style: kAppLblTinyFontBold(context)),
                  ],
                ),
                kAppSpacerVertical(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.tips, style: kAppLblTinyFontRegular(context)),
                    Text(kAppPriceFormat(model.details!.orderExtraDetail!.tipAmount!), style: kAppLblTinyFontBold(context)),
                  ],
                ),
                kAppSpacerVertical(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.total_earning, style: kAppLblTinyFontRegular(context)),
                    Text(kAppPriceFormat(model.details!.orderExtraDetail!.earning!), style: kAppLblTinyFontBold(context)),
                  ],
                ),
              ],
            ),
          ),
          kAppSpacerVertical(height: 20),
        ],
      ),
    );
  }
}

class CompletedOrderDetailLoadingView extends StatelessWidget {
  const CompletedOrderDetailLoadingView({super.key});

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

class CompletedOrderDetailErrorView extends StatelessWidget {
  const CompletedOrderDetailErrorView({super.key});

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
