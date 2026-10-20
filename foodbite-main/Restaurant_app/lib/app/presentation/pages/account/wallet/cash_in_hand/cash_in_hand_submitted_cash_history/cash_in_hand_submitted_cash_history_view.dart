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
import 'package:vendor/app/core/models/submitted_cash_in_hand_history_model.dart';
import 'package:vendor/app/presentation/pages/account/wallet/cash_in_hand/cash_in_hand_submitted_cash_history/bloc/cash_in_hand_submitted_cash_history_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class CashInHandSubmittedCashHistoryScreen extends StatelessWidget {
  const CashInHandSubmittedCashHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CashInHandSubmittedCashHistoryBloc(), child: const CashInHandSubmittedCashHistoryView());
  }
}

class CashInHandSubmittedCashHistoryView extends StatefulWidget {
  const CashInHandSubmittedCashHistoryView({super.key});

  @override
  State<CashInHandSubmittedCashHistoryView> createState() => _CashInHandSubmittedCashHistoryViewState();
}

class _CashInHandSubmittedCashHistoryViewState extends State<CashInHandSubmittedCashHistoryView> with AutomaticKeepAliveClientMixin {
  final ScrollController _historyScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CashInHandSubmittedCashHistoryBloc>().add(CashInHandSubmittedCashHistoryInitialEvent());
    _historyScroll.addListener(() {
      if (_historyScroll.position.pixels == _historyScroll.position.maxScrollExtent) {
        context.read<CashInHandSubmittedCashHistoryBloc>().add(CashInHandSubmittedCashHistoryScrollMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<CashInHandSubmittedCashHistoryBloc, CashInHandSubmittedCashHistoryState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            controller: _historyScroll,
            padding: const EdgeInsets.symmetric(vertical: ThemeProvider.scaffoldPadding, horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const CashInHandSubmittedCashHistoryLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const CashInHandSubmittedCashHistoryErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const CashInHandSubmittedCashHistoryEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(state.model.collected!.length, (historyIndex) => CashInHandSubmittedCashHistoryWidget(model: state.model.collected![historyIndex])),
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

class CashInHandSubmittedCashHistoryWidget extends StatelessWidget {
  final SubmittedCashInHandConfigModel model;
  const CashInHandSubmittedCashHistoryWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        minVerticalPadding: 0,
        leading: Image.asset(AssetsUrl.imageURL.moneyWithdrawal, height: 20, width: 20),
        title: Text("${translate.submitted_cash} : ${kAppPriceFormat(model.cashCollected!)}", style: kAppLblMediumFontBold(context)),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${translate.wallet_credit_amount} : ${kAppPriceFormat(model.walletAmount!)}", style: kAppLblSmallFontRegular(context)),
            Text("${translate.method} : ${model.method!}", maxLines: 2, style: kAppLblSmallFontRegular(context)),
            Text("${translate.reference} : ${model.reference!}", maxLines: 2, style: kAppLblSmallFontRegular(context)),
          ],
        ),
        trailing: Text(model.createdAt!, style: kAppLblSmallFontRegular(context)),
      ),
    );
  }
}

class CashInHandSubmittedCashHistoryLoadingView extends StatelessWidget {
  const CashInHandSubmittedCashHistoryLoadingView({super.key});

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

class CashInHandSubmittedCashHistoryEmptyView extends StatelessWidget {
  const CashInHandSubmittedCashHistoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_submited_cash_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_history_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class CashInHandSubmittedCashHistoryErrorView extends StatelessWidget {
  const CashInHandSubmittedCashHistoryErrorView({super.key});

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
// DONE //