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
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/presentation/pages/account/@core/account_view.dart';
import 'package:vendor/app/presentation/pages/business/@core/business_view.dart';
import 'package:vendor/app/presentation/pages/menu/@core/menu_view.dart';
import 'package:vendor/app/presentation/pages/orders/@core/orders_view.dart';
import 'package:vendor/app/presentation/pages/pos_management/@core/pos_management_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';
import 'bloc/bottom_tab_navigation_bloc.dart';

class AppBottomTabScreen extends StatelessWidget {
  final int tabIndex;
  const AppBottomTabScreen({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationView(tabIndex: tabIndex);
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
    context.read<BottomTabNavigationBloc>().add(BottomNavigationTabInitialEvent(tabIndex: widget.tabIndex));
    tabController = TabController(initialIndex: widget.tabIndex, length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<BottomTabNavigationBloc, BottomTabNavigationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return DefaultTabController(
          length: 5,
          initialIndex: state.tabIndex,
          child: Scaffold(
            bottomNavigationBar: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.isSubscriptionExpired
                      ? InkWell(
                          onTap: () => Navigator.of(context).pushNamed(AppRouter.subscriptionPackageRoute),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${translate.renew_your} ${state.subscriptionName} ${translate.expire_package}', maxLines: 1, overflow: TextOverflow.ellipsis, style: kAppLblTinyFontBoldGuest(context)),
                                kAppSpacerVertical(height: 5),
                                Text('${translate.expire_on} ${state.subscriptionExpiredDate}', style: kAppLblTinyFontRegularLight(context)),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  TabBar(
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
                        icon: Image.asset(AssetsUrl.imageURL.bottomTabMenu, height: 20, width: 20, color: state.tabIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                        text: translate.menu_tabs,
                      ),
                      Tab(
                        icon: Image.asset(AssetsUrl.imageURL.bottomTabBusiness, height: 20, width: 20, color: state.tabIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                        text: translate.business_tabs,
                      ),
                      Tab(
                        icon: Image.asset(AssetsUrl.imageURL.bottomTabOrder, height: 20, width: 20, color: state.tabIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                        text: translate.orders,
                      ),
                      Tab(
                        icon: Image.asset(AssetsUrl.imageURL.bottomTabPos, height: 20, width: 20, color: state.tabIndex == 3 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                        text: translate.pos_tabs,
                      ),
                      Tab(
                        icon: Image.asset(AssetsUrl.imageURL.bottomTabAccount, height: 20, width: 20, color: state.tabIndex == 4 ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                        text: translate.more_tabs,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: tabController, children: const [MenuScreen(), BusinessScreen(), OrderListScreen(), POSManagementScreen(), AccountScreen()]),
          ),
        );
      },
    );
  }
}
// DONE //