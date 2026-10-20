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

import 'package:driver/app/presentation/pages/payouts/@core/bloc/payouts_bloc.dart';
import 'package:driver/app/presentation/pages/payouts/payout_method/@core/payout_method_view.dart';
import 'package:driver/app/presentation/pages/payouts/wallet_transaction_history/wallet_transaction_history_view.dart';
import 'package:driver/app/presentation/pages/payouts/wallet_withdrawal_history/walet_withdrawal_history_view.dart';
import 'package:driver/app/presentation/pages/payouts/wallet_withdrawal_request/wallet_withdrawal_request_view.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PayoutScreen extends StatelessWidget {
  const PayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PayoutView();
  }
}

class PayoutView extends StatefulWidget {
  const PayoutView({super.key});

  @override
  State<PayoutView> createState() => _PayoutViewState();
}

class _PayoutViewState extends State<PayoutView> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    context.read<PayoutsBloc>().add(PayoutsInitialEvent());
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<PayoutsBloc, PayoutsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            title: Text(translate.payouts),
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
              tabs: [Text(translate.withdrawal), Text(translate.withdrawal_history), Text(translate.transaction_history), Text(translate.payout_accounts)],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [WalletWithdrawalRequestScreen(), WaletWithdrawalHistoryScreen(), WalletTransactionHistoryScreen(), PayoutMethodScreen()],
          ),
        );
      },
    );
  }
}
// DONE //