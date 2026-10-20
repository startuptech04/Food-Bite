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
import 'package:waiter/app/core/config/assets_url.dart';
import 'package:waiter/app/presentation/pages/table_orders/@core/bloc/table_order_bloc.dart';
import 'package:waiter/app/presentation/styles/app_style.dart';
import 'package:waiter/app/presentation/styles/error_dialog.dart';
import 'package:waiter/app/presentation/styles/theme.dart';
import 'package:waiter/app/router/app_route_config.dart';
import 'package:waiter/gen/l10n/app_localizations.dart';

class TableOrderScreen extends StatelessWidget {
  const TableOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TableOrderBloc()..add(TableOrderInitialEvent()), child: const TableOrderView());
  }
}

class TableOrderView extends StatelessWidget {
  const TableOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<TableOrderBloc, TableOrderState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false, title: Text(translate.dine_in_table), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const TableOrderLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const TableOrderErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const TableOrderEmptyView(),
                ] else ...[
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 50),
                    scrollDirection: Axis.vertical,
                    key: UniqueKey(),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(AppRouter.tableOrderDashboardRoute, arguments: [state.model.tables![index].tableNumber!, state.model.tables![index].id!]),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: state.model.tables![index].occupied! ? Theme.of(context).primaryColor : ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            child: Container(
                              decoration: BoxDecoration(color: state.model.tables![index].occupied! ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor),
                              child: Center(child: Text("${state.model.tables![index].tableNumber!}", style: state.model.tables![index].occupied! ? kAppLblTinyFontBoldGuest(context) : kAppLblTinyFontBold(context))),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: state.model.tables!.length,
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

class TableOrderLoadingView extends StatelessWidget {
  const TableOrderLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 50),
          scrollDirection: Axis.vertical,
          key: UniqueKey(),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: MediaQuery.of(context).size.width / 5,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                  child: const Center(child: SkeletonAvatar(style: SkeletonAvatarStyle(width: 5, height: 5))),
                ),
              ),
            );
          },
          itemCount: 20,
        ),
      ],
    );
  }
}

class TableOrderErrorView extends StatelessWidget {
  const TableOrderErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.opps_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class TableOrderEmptyView extends StatelessWidget {
  const TableOrderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_matching_record_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_reason_found_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //