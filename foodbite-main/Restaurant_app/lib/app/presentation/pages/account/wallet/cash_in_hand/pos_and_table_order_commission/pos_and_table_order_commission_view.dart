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
import 'package:vendor/app/core/models/pos_and_table_order_commission_history_list_model.dart';
import 'package:vendor/app/presentation/pages/account/wallet/cash_in_hand/pos_and_table_order_commission/bloc/pos_and_table_order_commission_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class PosAndTableOrderCommissionScreen extends StatelessWidget {
  const PosAndTableOrderCommissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => PosAndTableOrderCommissionBloc()..add(PosAndTableOrderCommissionInitialEvent()), child: const PosAndTableOrderCommissionView());
  }
}

class PosAndTableOrderCommissionView extends StatefulWidget {
  const PosAndTableOrderCommissionView({super.key});

  @override
  State<PosAndTableOrderCommissionView> createState() => _PosAndTableOrderCommissionViewState();
}

class _PosAndTableOrderCommissionViewState extends State<PosAndTableOrderCommissionView> with AutomaticKeepAliveClientMixin {
  final ScrollController _commissionScroll = ScrollController();
  @override
  void initState() {
    super.initState();
    _commissionScroll.addListener(() {
      if (_commissionScroll.position.pixels == _commissionScroll.position.maxScrollExtent) {
        context.read<PosAndTableOrderCommissionBloc>().add(PosAndTableOrderCommissionLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<PosAndTableOrderCommissionBloc, PosAndTableOrderCommissionState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            controller: _commissionScroll,
            padding: const EdgeInsets.symmetric(vertical: ThemeProvider.scaffoldPadding, horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const PosAndTableOrderCommissionLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const PosAndTableOrderCommissionErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const PosAndTableOrderCommissionEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(state.model.history!.length, (historyIndex) => PosAndTableOrderCommissionInfoTile(model: state.model.history![historyIndex])),
                  ),
                  kAppSpacerVertical(height: 20),
                  state.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  kAppSpacerVertical(height: 20),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PosAndTableOrderCommissionInfoTile extends StatelessWidget {
  final PosAndTableOrderCommissionHistoryConfigModel model;
  const PosAndTableOrderCommissionInfoTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        if (model.posOrderInfo!.id!.isNotEmpty) {
          Navigator.of(context).pushNamed(AppRouter.posOrderDetailRoute, arguments: [model.posOrderInfo!.id!]);
        } else {
          Navigator.of(context).pushNamed(AppRouter.tableOrderDetailRoute, arguments: [model.tableOrderInfo!.id!]);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          minVerticalPadding: 0,
          leading: Image.asset(AssetsUrl.imageURL.moneyWithdrawal, height: 20, width: 20),
          title: Text("${translate.order_no} : ${model.posOrderInfo!.id!.isNotEmpty ? model.posOrderInfo!.orderNo! : model.tableOrderInfo!.orderNo!}", style: kAppLblMediumFontBold(context)),
          subtitle: Text(model.posOrderInfo!.id!.isNotEmpty ? translate.pos_order : translate.table_order, style: kAppLblSmallFontRegular(context)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(model.createdAt!, style: kAppLblSmallFontRegular(context)),
              Text(kAppPriceFormat(model.totalCommision!), style: kAppLblMediumFontBold(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class PosAndTableOrderCommissionLoadingView extends StatelessWidget {
  const PosAndTableOrderCommissionLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
          ),
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
              ),
              kAppSpacerVertical(height: 5),
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.2, borderRadius: BorderRadius.circular(8)),
              ),
              kAppSpacerVertical(height: 5),
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2.8, borderRadius: BorderRadius.circular(8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PosAndTableOrderCommissionErrorView extends StatelessWidget {
  const PosAndTableOrderCommissionErrorView({super.key});

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

class PosAndTableOrderCommissionEmptyView extends StatelessWidget {
  const PosAndTableOrderCommissionEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_pos_table_order_commission_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_history_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //