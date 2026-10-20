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
import 'package:vendor/app/presentation/pages/account/coupons/dining_coupon/@core/dining_coupon_list_view.dart';
import 'package:vendor/app/presentation/pages/account/coupons/order_coupon/@core/order_coupon_list_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class CouponsListTabScreen extends StatefulWidget {
  const CouponsListTabScreen({super.key});

  @override
  State<CouponsListTabScreen> createState() => _CouponsListTabViewState();
}

class _CouponsListTabViewState extends State<CouponsListTabScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate.coupon_management),
        scrolledUnderElevation: 0,
        bottom: TabBar(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).hintColor,
          indicatorColor: Theme.of(context).primaryColor,
          labelStyle: kAppStyleTabTitleStyle(context),
          unselectedLabelStyle: kAppStyleTabTitleStyle(context),
          labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          tabs: [Text(translate.order_coupon), Text(translate.dining_coupon)],
        ),
      ),
      body: TabBarView(controller: tabController, physics: const NeverScrollableScrollPhysics(), children: const [OrderCouponListScreen(), DiningCouponListScreen()]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// DONE //