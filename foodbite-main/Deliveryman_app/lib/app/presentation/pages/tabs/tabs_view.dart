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
import 'package:driver/app/presentation/pages/account/@core/account_view.dart';
import 'package:driver/app/presentation/pages/analytics/analytics_view.dart';
import 'package:driver/app/presentation/pages/deposite/deposite_view.dart';
import 'package:driver/app/presentation/pages/feeds/@core/feeds_view.dart';
import 'package:driver/app/presentation/pages/payouts/@core/payouts_view.dart';
import 'package:driver/app/presentation/pages/tabs/bloc/bottom_tab_navigation_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/router/app_route_config.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBottomTabScreen extends StatelessWidget {
  final int tabIndex;
  const AppBottomTabScreen({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomTabNavigationBloc()..add(BottomNavigationTabInitialEvent(tabIndex: tabIndex)),
      child: BottomNavigationView(tabIndex: tabIndex),
    );
  }
}

class BottomNavigationView extends StatefulWidget {
  final int tabIndex;
  const BottomNavigationView({super.key, required this.tabIndex});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: widget.tabIndex, length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<BottomTabNavigationBloc, BottomTabNavigationState>(
      listener: (context, state) {
        if (state.canActivate == false) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.loginRoute, (Route<dynamic> route) => false);
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 5,
          initialIndex: state.tabIndex,
          child: Scaffold(
            bottomNavigationBar: SafeArea(
              child: TabBar(
                controller: tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).hintColor,
                indicatorColor: Theme.of(context).primaryColor,
                labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                labelStyle: kAppLblMediumFontMedium(context),
                dividerColor: ThemeProvider.transparentColor,
                onTap: (int index) => context.read<BottomTabNavigationBloc>().add(BottomNavigationTabChange(tabIndex: index)),
                tabs: [
                  Tab(
                    icon: Image.asset(AssetsUrl.iconsURL.bottomTabFeed, height: 20, width: 20, color: state.tabIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                    text: translate.feeds,
                  ),
                  Tab(
                    icon: Image.asset(AssetsUrl.iconsURL.bottomTabPayout, height: 20, width: 20, color: state.tabIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                    text: translate.payout,
                  ),
                  Tab(
                    icon: Image.asset(AssetsUrl.iconsURL.bottomTabDeposite, height: 20, width: 20, color: state.tabIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                    text: translate.deposite,
                  ),
                  Tab(
                    icon: Image.asset(AssetsUrl.iconsURL.bottomTabAnalytics, height: 20, width: 20, color: state.tabIndex == 3 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                    text: translate.analytics,
                  ),
                  Tab(
                    icon: Image.asset(AssetsUrl.iconsURL.bottomTabAccount, height: 20, width: 20, color: state.tabIndex == 4 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                    text: translate.account,
                  ),
                ],
              ),
            ),
            body: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: tabController, children: const [FeedScreen(), PayoutScreen(), DepositeScreen(), AnalyticScreen(), AccountScreen()]),
          ),
        );
      },
    );
  }
}
// DONE //