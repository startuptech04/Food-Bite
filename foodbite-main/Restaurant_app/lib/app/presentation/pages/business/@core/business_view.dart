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
import 'package:vendor/gen/l10n/app_localizations.dart';
import 'package:vendor/app/presentation/pages/business/@core/bloc/business_bloc.dart';
import 'package:vendor/app/presentation/pages/business/orders_business_insight/orders_business_insight_view.dart';
import 'package:vendor/app/presentation/pages/business/pos_business_insight/pos_business_insight_view.dart';
import 'package:vendor/app/presentation/pages/business/table_orders_business_insight/table_orders_business_insight_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/router/app_route_config.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BusinessView();
  }
}

class BusinessView extends StatefulWidget {
  const BusinessView({super.key});

  @override
  State<BusinessView> createState() => _BusinessViewState();
}

class _BusinessViewState extends State<BusinessView> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    context.read<BusinessBloc>().add(BusinessInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<BusinessBloc, BusinessState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(translate.business_title),
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
              tabs: [Text(translate.order_insight), Text(translate.pos_insight), Text(translate.table_order_insight)],
            ),
          ),
          body: TabBarView(controller: tabController, physics: const NeverScrollableScrollPhysics(), children: const [OrdersBusinessInsightScreen(), PosBusinessInsightScreen(), TableOrdersBusinessInsightScreen()]),
          floatingActionButton: SizedBox(
            height: 30,
            child: FloatingActionButton.extended(
              heroTag: 'customDateInsightFabButton',
              onPressed: () {
                if (tabController.index == 0) {
                  Navigator.of(context).pushNamed(AppRouter.customOrderInsightRoute);
                } else if (tabController.index == 1) {
                  Navigator.of(context).pushNamed(AppRouter.customPosOrderInsightRoute);
                } else {
                  Navigator.of(context).pushNamed(AppRouter.customTableOrderInsightRoute);
                }
              },
              label: Text(translate.custom),
              icon: const Icon(Icons.calendar_month_outlined),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// DONE //