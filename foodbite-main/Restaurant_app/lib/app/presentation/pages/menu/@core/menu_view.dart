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
import 'package:vendor/app/presentation/pages/menu/@core/bloc/menu_bloc.dart';
import 'package:vendor/app/presentation/pages/menu/addons/@core/addons_view.dart';
import 'package:vendor/app/presentation/pages/menu/categories/@core/categories_view.dart';
import 'package:vendor/app/presentation/pages/menu/foods/@core/foods_view.dart';
import 'package:vendor/app/presentation/pages/menu/sub_categories/@core/sub_categories_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/router/app_route_config.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MenuView();
  }
}

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    context.read<MenuBloc>().add(MenuInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<MenuBloc, MenuState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(translate.menu_title),
            scrolledUnderElevation: 0,
            actions: <Widget>[
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.searchMenuRoute, arguments: [state.customCategory]),
                icon: Icon(Icons.search_outlined, color: Theme.of(context).iconTheme.color),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.mediaFileListRoute),
                icon: Icon(Icons.image_outlined, color: Theme.of(context).iconTheme.color),
              ),
            ],
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
              tabs: [Text(translate.menu_food_tab_head), Text(translate.menu_addon_tab_head), Text(translate.menu_category_tab_head), Text(translate.menu_sub_category_tab_head)],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              FoodListScreen(customCategory: state.customCategory),
              const AddonsListScreen(),
              CategoryListScreen(customCategory: state.customCategory),
              SubCategoriesListScreen(customCategory: state.customCategory),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// DONE //