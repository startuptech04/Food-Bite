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
import 'package:vendor/app/presentation/pages/account/table_orders/table_order_detail/bloc/table_order_detail_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/print_table_order_invoice/print_table_order_invoice_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TableOrderDetailScreen extends StatelessWidget {
  final String orderId;
  const TableOrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TableOrderDetailBloc()..add(TableOrderDetailInitialEvent(orderId: orderId)),
      child: const TableOrderDetailView(),
    );
  }
}

class TableOrderDetailView extends StatefulWidget {
  const TableOrderDetailView({super.key});

  @override
  State<TableOrderDetailView> createState() => _TableOrderDetailViewState();
}

class _TableOrderDetailViewState extends State<TableOrderDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<TableOrderDetailBloc, TableOrderDetailState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate.order_detail),
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return PrintTableOrderInvoiceScreen(orderId: state.orderId);
                      },
                      fullscreenDialog: true,
                    ),
                  );
                },
                icon: const Icon(Icons.print_outlined),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const TableOrderDetailLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const TableOrderDetailErrorView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.order_number.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text("${state.model.details!.orderNo!}", style: kAppLblBoldFont(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.order_ref.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text(state.model.details!.id!.toUpperCase(), style: kAppLblBoldFont(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.payment.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text("${state.model.details!.paymentMode! == 'online' ? translate.online : translate.offline} (${kAppPriceFormat(state.model.details!.grandTotal!)})", style: kAppLblBoldFont(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.date.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text(state.model.details!.createdAt!, style: kAppLblBoldFont(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.customer.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text(
                        state.model.details!.customerType! == 'regular'
                            ? '${state.model.details!.customerName!} (+${state.model.details!.customerCountryCode!} ${state.model.details!.customerMobileNumber})'
                            : translate.guest_customer,
                        style: kAppLblBoldFont(context),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.table_number.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text("${state.model.details!.tableDetail!.tableNumber!}", style: kAppLblBoldFont(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  Text(translate.order_detail, style: kAppLblMediumFontBold(context)),
                  kAppSpacerVertical(height: 10),
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
                                    kAppSpacerVertical(height: 5),
                                    state.model.details!.cartItem![cartIndex].instruction!.isNotEmpty
                                        ? Container(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                            child: Text(
                                              '${translate.form_cooking_instructions} : ${state.model.details!.cartItem![cartIndex].instruction!}',
                                              maxLines: 4,
                                              style: kAppLblTinyFontRegularChip(context, color: 'primary'),
                                            ),
                                          )
                                        : const SizedBox(),
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
                  kAppSpacerVertical(height: 10),
                  Text(translate.order_charges, style: kAppLblMediumFontBold(context)),
                  kAppSpacerVertical(height: 10),
                  BillingInfoTile(name: translate.item_total, priceTag: '+', price: state.model.details!.realTotal!),
                  BillingInfoTile(name: translate.item_discount, priceTag: '-', price: state.model.details!.itemDiscount!),
                  BillingInfoTile(name: translate.sub_total, priceTag: '+', price: state.model.details!.itemTotal!),
                  BillingInfoTile(name: translate.food_service_charge, priceTag: '+', price: state.model.details!.foodServiceCharge!),
                  BillingInfoTile(name: translate.service_charge, priceTag: '+', price: state.model.details!.serviceCharge!),
                  BillingInfoTile(name: translate.extra_service_charge, priceTag: '+', price: state.model.details!.extraCharge!),
                  BillingInfoTile(name: translate.packaging_charge, priceTag: '+', price: state.model.details!.packageCharge!),
                  BillingInfoTile(name: translate.packaging_charge_tax, priceTag: '+', price: state.model.details!.packageChargeTax!),
                  BillingInfoTile(name: translate.waiter_tip, priceTag: '+', price: state.model.details!.waiterTip!),
                  BillingInfoTile(name: translate.form_discount, priceTag: '-', price: state.model.details!.discountCharge!),
                  kAppSpacerVertical(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.grand_total, style: kAppLblMediumFontMedium(context)),
                      Text(kAppPriceFormat(state.model.details!.grandTotal!), style: kAppLblMediumFontBold(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  Text(translate.waiters, style: kAppLblMediumFontBold(context)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.details!.waiters!.length,
                      (waiterIndex) => Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                        ),
                        padding: const EdgeInsets.only(top: 10),
                        margin: const EdgeInsets.only(bottom: 10),
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
                                        Text("${state.model.details!.waiters![waiterIndex].firstName!} ${state.model.details!.waiters![waiterIndex].lastName!}", style: kAppLblMediumFontBold(context)),
                                        kAppSpacerVertical(height: 5),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.8,
                                              child: Text("${translate.email_lbl} : ${state.model.details!.waiters![waiterIndex].email!}", maxLines: 3, style: kAppLblTinyFontRegular(context)),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.8,
                                              child: Text(
                                                '${translate.phone}: +${state.model.details!.waiters![waiterIndex].countryCode!} ${state.model.details!.waiters![waiterIndex].mobile!}',
                                                maxLines: 3,
                                                style: kAppLblTinyFontRegular(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircleAvatar(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: CacheNetworkImageWidget(width: 40.0, height: 40.0, imageUrl: state.model.details!.waiters![waiterIndex].image!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

class TableOrderDetailLoadingView extends StatelessWidget {
  const TableOrderDetailLoadingView({super.key});

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

class TableOrderDetailErrorView extends StatelessWidget {
  const TableOrderDetailErrorView({super.key});

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