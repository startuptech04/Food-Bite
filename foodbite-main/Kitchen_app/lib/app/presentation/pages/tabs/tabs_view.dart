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
import 'package:kitchen/app/core/config/assets_url.dart';
import 'package:kitchen/app/presentation/pages/account/@core/account_view.dart';
import 'package:kitchen/app/presentation/pages/food_list/@core/food_list_view.dart';
import 'package:kitchen/app/presentation/pages/orders/@core/order_list_view.dart';
import 'package:kitchen/app/presentation/pages/tabs/bloc/bottom_tab_navigation_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/router/app_route_config.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

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
    tabController = TabController(initialIndex: widget.tabIndex, length: 3, vsync: this);
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
          length: 3,
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
                onTap: (int index) => context.read<BottomTabNavigationBloc>().add(BottomNavigationTabChange(tabIndex: index)),
                tabs: [
                  Tab(
                    icon: Image.asset(AssetsUrl.iconsURL.bottomTabFood, height: 20, width: 20, color: state.tabIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                    text: translate.food,
                  ),
                  Tab(
                    icon: Image.asset(AssetsUrl.iconsURL.bottomTabOrders, height: 20, width: 20, color: state.tabIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                    text: translate.orders,
                  ),
                  Tab(
                    icon: Image.asset(AssetsUrl.iconsURL.bottomTabAccount, height: 20, width: 20, color: state.tabIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                    text: translate.account,
                  ),
                ],
              ),
            ),
            body: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: tabController, children: const [FoodListScreen(), OrderListScreen(), AccountScreen()]),
          ),
        );
      },
    );
  }
}
// DONE //