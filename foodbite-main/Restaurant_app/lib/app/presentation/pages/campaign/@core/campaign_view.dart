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
import 'package:vendor/app/presentation/pages/campaign/@core/bloc/campaign_bloc.dart';

import 'package:vendor/app/presentation/pages/campaign/dining_campaign/dining_campaign_view.dart';
import 'package:vendor/app/presentation/pages/campaign/food_campaign/@core/food_campaign_view.dart';
import 'package:vendor/app/presentation/pages/campaign/restaurant_campaign/restaurant_campaign_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CampaignBloc()..add(CampaignInitialEvent()), child: const CampaignView());
  }
}

class CampaignView extends StatefulWidget {
  const CampaignView({super.key});

  @override
  State<CampaignView> createState() => _CampaignViewState();
}

class _CampaignViewState extends State<CampaignView> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController campaignTabController;
  @override
  void initState() {
    super.initState();
    campaignTabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<CampaignBloc, CampaignState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate.campaign_title),
            scrolledUnderElevation: 0,
            bottom: TabBar(
              controller: campaignTabController,
              physics: const NeverScrollableScrollPhysics(),
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Theme.of(context).hintColor,
              indicatorColor: Theme.of(context).primaryColor,
              labelStyle: kAppStyleTabTitleStyle(context),
              unselectedLabelStyle: kAppStyleTabTitleStyle(context),
              labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              tabs: [Text(translate.restaurant_campaign), Text(translate.dining_campaign), Text(translate.food_campaign)],
            ),
          ),
          body: TabBarView(controller: campaignTabController, physics: const NeverScrollableScrollPhysics(), children: const [RestaurantCampaignListScreen(), DiningCampaignScreen(), FoodCampaignListScreen()]),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// DONE //