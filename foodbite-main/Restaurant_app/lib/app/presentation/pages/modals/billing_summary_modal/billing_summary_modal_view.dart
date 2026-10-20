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
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class BillingSummaryModalScreen extends StatelessWidget {
  final String paymentStatus;
  final String paymentName;
  final double realTotal;
  final double itemTotal;
  final double itemDiscount;
  final double couponDiscount;
  final double walletAmount;
  final double serviceCharge;
  final double foodServiceCharge;
  final double deliveryTip;
  final double extraCharge;
  final double deliveryCharge;
  final double packagingCharges;
  final double packagingChargesTax;
  final double waiterCharge;
  final double grandTotal;
  const BillingSummaryModalScreen({
    super.key,
    required this.paymentStatus,
    required this.paymentName,
    required this.realTotal,
    required this.itemTotal,
    required this.itemDiscount,
    required this.couponDiscount,
    required this.walletAmount,
    required this.serviceCharge,
    required this.foodServiceCharge,
    required this.deliveryTip,
    required this.extraCharge,
    required this.deliveryCharge,
    required this.packagingCharges,
    required this.packagingChargesTax,
    required this.waiterCharge,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Text(translate.bill_summary),
        actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                ),
                child: Column(
                  children: [
                    BillingInfoTile(name: translate.item_total, icon: AssetsUrl.iconsURL.billItemTotalIcon, priceTag: '+', price: realTotal),
                    BillingInfoTile(name: translate.item_discount, icon: AssetsUrl.iconsURL.billDiscountIcon, priceTag: '-', price: itemDiscount),
                    BillingInfoTile(name: translate.sub_total, icon: AssetsUrl.iconsURL.billItemTotalIcon, priceTag: '+', price: itemTotal),
                    BillingInfoTile(name: translate.food_service_charge, icon: AssetsUrl.iconsURL.billTaxIcon, priceTag: '+', price: foodServiceCharge),
                    BillingInfoTile(name: translate.service_charge, icon: AssetsUrl.iconsURL.billTaxIcon, priceTag: '+', price: serviceCharge),
                    BillingInfoTile(name: translate.extra_service_charge, icon: AssetsUrl.iconsURL.billTaxIcon, priceTag: '+', price: extraCharge),
                    BillingInfoTile(name: translate.delivery_charge, icon: AssetsUrl.iconsURL.billDeliveryIcon, priceTag: '+', price: deliveryCharge),
                    BillingInfoTile(name: translate.delivery_partner_tip, icon: AssetsUrl.iconsURL.billDeliveryIcon, priceTag: '+', price: deliveryTip),
                    BillingInfoTile(name: translate.packaging_charge, icon: AssetsUrl.iconsURL.billPackageIcon, priceTag: '+', price: packagingCharges),
                    BillingInfoTile(name: translate.packaging_charge_tax, icon: AssetsUrl.iconsURL.billTaxIcon, priceTag: '+', price: packagingChargesTax),
                    BillingInfoTile(name: translate.waiter_tip, icon: AssetsUrl.iconsURL.billDiscountIcon, priceTag: '+', price: waiterCharge),
                    BillingInfoTile(name: translate.coupon_discount, icon: AssetsUrl.iconsURL.billDiscountIcon, priceTag: '-', price: couponDiscount),
                    BillingInfoTile(name: translate.wallet_money, icon: AssetsUrl.iconsURL.billDiscountIcon, priceTag: '-', price: walletAmount),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.only(bottom: 5, top: 10),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate.status, style: kAppLblMediumFontMedium(context)),
                              Text(paymentStatus, style: kAppLblMediumFontBold(context)),
                            ],
                          ),
                          kAppSpacerVertical(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate.payment, style: kAppLblMediumFontMedium(context)),
                              Text(paymentName, style: kAppLblMediumFontBold(context)),
                            ],
                          ),
                          kAppSpacerVertical(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate.grand_total, style: kAppLblMediumFontMedium(context)),
                              Text(kAppPriceFormat(grandTotal), style: kAppLblMediumFontBold(context)),
                            ],
                          ),
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
    );
  }
}

class BillingInfoTile extends StatelessWidget {
  final String name;
  final String icon;
  final String priceTag;
  final double price;
  const BillingInfoTile({super.key, required this.name, required this.icon, required this.priceTag, required this.price});

  @override
  Widget build(BuildContext context) {
    return price > 0
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(icon, height: 12, width: 12, color: Theme.of(context).canvasColor),
                    kAppSpacerHorizontal(width: 10),
                    Text(name, style: kAppLblTinyFontRegular(context)),
                  ],
                ),
                Text('($priceTag) ${kAppPriceFormat(price)}', style: kAppLblTinyFontBold(context)),
              ],
            ),
          )
        : const SizedBox();
  }
}
// DONE //