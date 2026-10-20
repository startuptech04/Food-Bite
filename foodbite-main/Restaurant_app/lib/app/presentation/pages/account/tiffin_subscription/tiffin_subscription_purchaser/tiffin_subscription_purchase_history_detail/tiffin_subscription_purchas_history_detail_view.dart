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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/presentation/pages/account/tiffin_subscription/tiffin_subscription_purchaser/tiffin_subscription_purchase_history_detail/bloc/tiffin_subscription_purchase_history_detail_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TiffinSubscriptionPurchasHistoryDetailScreen extends StatelessWidget {
  final String purchaseId;
  const TiffinSubscriptionPurchasHistoryDetailScreen({super.key, required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TiffinSubscriptionPurchaseHistoryDetailBloc()..add(TiffinSubscriptionPurchaseHistoryDetailInitialEvent(purchaseId: purchaseId)),
      child: const TiffinSubscriptionPurchasHistoryDetailView(),
    );
  }
}

class TiffinSubscriptionPurchasHistoryDetailView extends StatelessWidget {
  const TiffinSubscriptionPurchasHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<TiffinSubscriptionPurchaseHistoryDetailBloc, TiffinSubscriptionPurchaseHistoryDetailState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate.purchase_detail),
            scrolledUnderElevation: 0,
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.supportChatRoute, arguments: ['tiffin_subscription', state.purchaseId]),
                label: Text(
                  translate.support,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'semibold'),
                ),
                icon: Icon(Icons.chat_outlined, color: Theme.of(context).primaryColor, size: 12),
                iconAlignment: IconAlignment.start,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const TiffinSubscriptionPurchaseHistoryDetailLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const TiffinSubscriptionPurchaseHistoryDetailErrorView(),
                ] else ...[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                    ),
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: CircleAvatar(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CacheNetworkImageWidget(width: 30.0, height: 30.0, imageUrl: state.model.details!.userInfo!.image!),
                                  ),
                                ),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${state.model.details!.userInfo!.firstName!} ${state.model.details!.userInfo!.lastName}", style: kAppLblTinyFontBold(context)),
                                  Text("+${state.model.details!.userInfo!.countryCode!} ${state.model.details!.userInfo!.contactNumber!}", style: kAppLblTinyFontRegular(context)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        state.model.settings!.canInitiateCall! || state.model.settings!.canInitiateChat!
                            ? Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    state.model.settings!.canInitiateCall!
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () => context.read<TiffinSubscriptionPurchaseHistoryDetailBloc>().add(TiffinSubscriptionPurchaseHistoryDetailCallEvent()),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 30,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    state.status.isCallCustomer
                                                        ? Container(
                                                            height: 15,
                                                            width: 15,
                                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                                            child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                                          )
                                                        : Icon(Icons.call, size: 10, color: Theme.of(context).canvasColor),
                                                    kAppSpacerHorizontal(width: 5),
                                                    Text(translate.call, style: kAppLblTinyFontRegular(context)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    state.model.settings!.canInitiateChat!
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                final String id = state.model.details!.userInfo!.id!;
                                                final String name = '${state.model.details!.userInfo!.firstName!} ${state.model.details!.userInfo!.lastName!}';
                                                Navigator.of(context).pushNamed(AppRouter.chatMessageRoute, arguments: [name, id]);
                                              },
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
                                                    Icon(Icons.chat_outlined, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                                    kAppSpacerHorizontal(width: 5),
                                                    Text(translate.message, style: kAppLblTinyRegularWhite(context)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  kAppSpacerVertical(height: 10),
                  Text(translate.purchase_charge, style: kAppLblMediumFontBold(context)),
                  kAppSpacerVertical(height: 10),
                  BillingInfoTile(name: translate.item_total, priceTag: '+', price: state.model.details!.itemTotal!),
                  BillingInfoTile(name: translate.food_service_charge, priceTag: '+', price: state.model.details!.foodServiceCharge!),
                  BillingInfoTile(name: translate.service_charge, priceTag: '+', price: state.model.details!.serviceCharge!),
                  BillingInfoTile(name: translate.extra_service_charge, priceTag: '+', price: state.model.details!.extraCharge!),
                  BillingInfoTile(name: translate.packaging_charge, priceTag: '+', price: state.model.details!.packageCharge!),
                  BillingInfoTile(name: translate.packaging_charge_tax, priceTag: '+', price: state.model.details!.packageChargeTax!),
                  kAppSpacerVertical(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.grand_total, style: kAppLblMediumFontMedium(context)),
                      Text(kAppPriceFormat(state.model.details!.grandTotal!), style: kAppLblMediumFontBold(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Text(translate.purchase_detail, style: kAppLblMediumFontBold(context)),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.purchase_id.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text(state.model.details!.id!.toUpperCase(), style: kAppLblBoldFont(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.payment.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text("${state.model.details!.paymentInfo!.name!} (${kAppPriceFormat(state.model.details!.grandTotal!)})", style: kAppLblBoldFont(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${translate.date} : ".toUpperCase(), style: kAppLblBoldFont(context)),
                      Text("${state.model.details!.startDate!} - ${state.model.details!.slot!}", style: kAppLblBoldFont(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.receiver.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text(
                        state.model.details!.orderTo! == 'homedelivery' ? '${state.model.details!.receiverName!} (+${state.model.details!.countryCode!} ${state.model.details!.receiverContact})' : translate.self_pickup,
                        style: kAppLblBoldFont(context),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  state.model.details!.orderTo! == 'homedelivery' ? kAppSpacerVertical(height: 10) : const SizedBox(),
                  state.model.details!.orderTo! == 'homedelivery'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.deliver_to.toUpperCase(), style: kAppLblBoldFont(context)),
                            Text(
                              '${kAppAddressTitle(context, state.model.details!.deliveryAddress!.title!)} - ${state.model.details!.deliveryAddress!.flatHouse!}, ${state.model.details!.deliveryAddress!.locality!}, ${state.model.details!.deliveryAddress!.landmark!}',
                              style: kAppLblBoldFont(context),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  state.model.details!.cookingInstruction!.isNotEmpty ? kAppSpacerVertical(height: 10) : const SizedBox(),
                  state.model.details!.cookingInstruction!.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.form_cooking_instructions.toUpperCase(), style: kAppLblBoldFont(context)),
                            Text(state.model.details!.cookingInstruction!, style: kAppLblBoldFont(context)),
                          ],
                        )
                      : const SizedBox(),
                  state.model.details!.deliveryInstructionInfo!.name!.isNotEmpty ? kAppSpacerVertical(height: 10) : const SizedBox(),
                  state.model.details!.deliveryInstructionInfo!.name!.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.delivery_instruction.toUpperCase(), style: kAppLblBoldFont(context)),
                            Text(state.model.details!.deliveryInstructionInfo!.name!, style: kAppLblBoldFont(context)),
                          ],
                        )
                      : const SizedBox(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.details!.cartItem!.length,
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
                                kAppFoodType(state.model.details!.cartItem![cartIndex].foodType!, height: 10, width: 10),
                                kAppSpacerHorizontal(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${state.model.details!.cartItem![cartIndex].quantity!}", style: kAppLblMediumFontSemiBold(context)),
                                        Text(" X ", style: kAppLblMediumFontSemiBold(context)),
                                        Text(kAppTrimWord(state.model.details!.cartItem![cartIndex].name!, 40), style: kAppLblMediumFontSemiBold(context)),
                                      ],
                                    ),
                                    Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                      child: Text(state.model.details!.cartItem![cartIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(kAppPriceFormat(state.model.details!.cartItem![cartIndex].totalPrice!), style: kAppLblMediumFontSemiBold(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class TiffinSubscriptionPurchaseHistoryDetailLoadingView extends StatelessWidget {
  const TiffinSubscriptionPurchaseHistoryDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 5),
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 50, width: double.infinity, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(width: 80, height: 30, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                              const SizedBox(width: 10),
                              SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SkeletonAvatar(style: SkeletonAvatarStyle(width: 80, height: 80, borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class TiffinSubscriptionPurchaseHistoryDetailErrorView extends StatelessWidget {
  const TiffinSubscriptionPurchaseHistoryDetailErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class BillingInfoTile extends StatelessWidget {
  final String name;
  final String priceTag;
  final double price;
  const BillingInfoTile({super.key, required this.name, required this.priceTag, required this.price});

  @override
  Widget build(BuildContext context) {
    return price > 0
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(name, style: kAppLblTinyFontRegularChip(context, color: 'regular')),
                Text("($priceTag) ${kAppPriceFormat(price)}", style: kAppLblTinyFontBold(context)),
              ],
            ),
          )
        : const SizedBox();
  }
}
// DONE //