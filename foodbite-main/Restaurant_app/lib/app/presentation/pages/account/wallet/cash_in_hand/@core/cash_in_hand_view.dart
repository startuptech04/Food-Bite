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
import 'package:vendor/app/presentation/pages/account/wallet/cash_in_hand/@core/bloc/cash_in_hand_bloc.dart';
import 'package:vendor/app/presentation/pages/account/wallet/cash_in_hand/cash_in_hand_history/cash_in_hand_history_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/cash_in_hand/cash_in_hand_submitted_cash_history/cash_in_hand_submitted_cash_history_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/cash_in_hand/pos_and_table_order_commission/pos_and_table_order_commission_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class CashInHandScreen extends StatelessWidget {
  const CashInHandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CashInHandBloc()..add(CashInHandInitialEvent()), child: const CashInHandView());
  }
}

class CashInHandView extends StatefulWidget {
  const CashInHandView({super.key});

  @override
  State<CashInHandView> createState() => _CashInHandViewState();
}

class _CashInHandViewState extends State<CashInHandView> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<CashInHandBloc, CashInHandState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate.cash_in_hand),
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
              tabs: [Text(translate.cash_in_hand_history), Text(translate.submitted_cash_history), Text(translate.pos_table_order_commission)],
            ),
          ),
          body: TabBarView(controller: tabController, physics: const NeverScrollableScrollPhysics(), children: const [CashInHandHistoryScreen(), CashInHandSubmittedCashHistoryScreen(), PosAndTableOrderCommissionScreen()]),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// DONE //