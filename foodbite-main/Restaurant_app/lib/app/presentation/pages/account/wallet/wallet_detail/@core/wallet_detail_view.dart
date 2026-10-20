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
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/@core/bloc/wallet_detail_bloc.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/payout_method/@core/payout_method_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/wallet_transaction_history/wallet_transaction_history_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/wallet_withdrawal_history/wallet_withdrawal_history_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/wallet_withdrawal_request/wallet_withdrawal_request_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class WalletDetailScreen extends StatelessWidget {
  const WalletDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => WalletDetailBloc()..add(WalletDetailInitialEvent()), child: const WalletDetailView());
  }
}

class WalletDetailView extends StatefulWidget {
  const WalletDetailView({super.key});

  @override
  State<WalletDetailView> createState() => _WalletDetailViewState();
}

class _WalletDetailViewState extends State<WalletDetailView> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<WalletDetailBloc, WalletDetailState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate.wallet_detail),
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
              tabs: [Text(translate.withdrawal), Text(translate.withdrawal_history), Text(translate.transaction_history), Text(translate.payout_accounts)],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [WalletWithdrawalRequestScreen(), WalletWithdrawalHistoryScreen(), WalletTransactionHistoryScreen(), PayoutMethodScreen()],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// DONE //