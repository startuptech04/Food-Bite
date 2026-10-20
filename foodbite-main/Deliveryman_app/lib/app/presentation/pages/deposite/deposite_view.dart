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
import 'package:driver/app/core/models/cash_in_hand_model.dart';
import 'package:driver/app/presentation/pages/deposite/bloc/deposite_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class DepositeScreen extends StatelessWidget {
  const DepositeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DepositeView();
  }
}

class DepositeView extends StatefulWidget {
  const DepositeView({super.key});

  @override
  State<DepositeView> createState() => _DepositeViewState();
}

class _DepositeViewState extends State<DepositeView> {
  @override
  void initState() {
    super.initState();
    context.read<DepositeBloc>().add(DepositeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<DepositeBloc, DepositeState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            title: Text(translate.deposite),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                child: Column(
                  children: [
                    if (state.status.isLoading) ...[
                      const DepositeLoadingView(),
                    ] else if (state.status.isFailure) ...[
                      const DepositeErrorView(),
                    ] else ...[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(AssetsUrl.imageURL.cashInHandImage, height: 35.0, width: 35.0, color: Theme.of(context).colorScheme.secondary),
                            kAppSpacerHorizontal(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate.cash_in_hand, style: kAppLblTinyFontRegularLight(context)),
                                kAppSpacerVertical(height: 5),
                                Text(kAppPriceFormat(state.model.cashInHandAmount!), style: kAppLblTinyFontBoldGuest(context)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      kAppSpacerVertical(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Image.asset(AssetsUrl.imageURL.moneyDeposite, width: 15, height: 15),
                              label: Text(translate.history, style: kAppLblMediumFontSemiBold(context, color: state.toggleTransaction == 'in-hand' ? 'primary' : 'regular')),
                              onPressed: () => context.read<DepositeBloc>().add(DepositeToggleEvent(toggle: 'in-hand')),
                              style: kAppElevatedButtonOutlineStyle(
                                context,
                                disabledColor: Theme.of(context).disabledColor,
                                bgColor: ThemeProvider.transparentColor,
                                foreColor: Theme.of(context).canvasColor,
                                borderColor: state.toggleTransaction == 'in-hand' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                                height: 40,
                              ),
                            ),
                          ),
                          kAppSpacerHorizontal(width: 15),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Image.asset(AssetsUrl.imageURL.moneyWithdrawal, width: 15, height: 15),
                              label: Text(translate.submitted, style: kAppLblMediumFontSemiBold(context, color: state.toggleTransaction == 'submitted' ? 'primary' : 'regular')),
                              onPressed: () => context.read<DepositeBloc>().add(DepositeToggleEvent(toggle: 'submitted')),
                              style: kAppElevatedButtonOutlineStyle(
                                context,
                                disabledColor: Theme.of(context).disabledColor,
                                bgColor: ThemeProvider.transparentColor,
                                foreColor: Theme.of(context).canvasColor,
                                borderColor: state.toggleTransaction == 'submitted' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          body: state.toggleTransaction == 'in-hand'
              ? DepositeCashInHandHistoryView(model: state.model, status: state.status, loadMore: state.loadMoreHistory)
              : DepositeCollectedCashView(model: state.model, status: state.status, loadMore: state.loadMoreCollected),
        );
      },
    );
  }
}

class DepositeCashInHandHistoryView extends StatefulWidget {
  final CashInHandModel model;
  final DepositeStatus status;
  final bool loadMore;
  const DepositeCashInHandHistoryView({super.key, required this.model, required this.status, required this.loadMore});

  @override
  State<DepositeCashInHandHistoryView> createState() => _DepositeCashInHandHistoryViewState();
}

class _DepositeCashInHandHistoryViewState extends State<DepositeCashInHandHistoryView> {
  final ScrollController _historyScroll = ScrollController();
  @override
  void initState() {
    super.initState();
    _historyScroll.addListener(() {
      if (_historyScroll.position.pixels == _historyScroll.position.maxScrollExtent) {
        context.read<DepositeBloc>().add(DepositeHistoryLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _historyScroll,
      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.status.isLoading) ...[
              const DepositeHistoryAndCollectionLoadingView(),
            ] else if (widget.status.isFailure) ...[
              const DepositeHistoryAndCollectionErrorView(),
            ] else if (widget.status.isSuccess && widget.model.history!.isEmpty) ...[
              const DepositeHistoryEmptyView(),
            ] else ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(widget.model.history!.length, (historyIndex) => DepositeCashInHandHistoryDetailWidget(model: widget.model.history![historyIndex])),
              ),
              kAppSpacerVertical(height: 20),
              widget.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
              kAppSpacerVertical(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class DepositeCollectedCashView extends StatefulWidget {
  final CashInHandModel model;
  final DepositeStatus status;
  final bool loadMore;
  const DepositeCollectedCashView({super.key, required this.model, required this.status, required this.loadMore});

  @override
  State<DepositeCollectedCashView> createState() => _DepositeCollectedCashViewState();
}

class _DepositeCollectedCashViewState extends State<DepositeCollectedCashView> {
  final ScrollController _collectedScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _collectedScroll.addListener(() {
      if (_collectedScroll.position.pixels == _collectedScroll.position.maxScrollExtent) {
        context.read<DepositeBloc>().add(DepositeCollectedCashLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _collectedScroll,
      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.status.isLoading) ...[
              const DepositeHistoryAndCollectionLoadingView(),
            ] else if (widget.status.isFailure) ...[
              const DepositeHistoryAndCollectionErrorView(),
            ] else if (widget.status.isSuccess && widget.model.collected!.isEmpty) ...[
              const DepositeCollectedCashEmptyView(),
            ] else ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(widget.model.collected!.length, (historyIndex) => DepositeCashInHandSubmittedCashHistoryWidget(model: widget.model.collected![historyIndex])),
              ),
              kAppSpacerVertical(height: 20),
              widget.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
              kAppSpacerVertical(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class DepositeLoadingView extends StatelessWidget {
  const DepositeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 120.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(height: 80.0, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
          ),
          kAppSpacerVertical(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SkeletonLine(style: SkeletonLineStyle(height: 10, width: 64, borderRadius: BorderRadius.circular(8))),
              SkeletonLine(style: SkeletonLineStyle(height: 10, width: 64, borderRadius: BorderRadius.circular(8))),
            ],
          ),
        ],
      ),
    );
  }
}

class DepositeErrorView extends StatelessWidget {
  const DepositeErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(translate.oops_title, style: kAppLblLargeFontBold(context)),
        kAppSpacerVertical(height: 5),
        Text(translate.no_result_found_error, style: kAppLblSmallFontMedium(context)),
      ],
    );
  }
}

class DepositeHistoryAndCollectionLoadingView extends StatelessWidget {
  const DepositeHistoryAndCollectionLoadingView({super.key});

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

class DepositeHistoryAndCollectionErrorView extends StatelessWidget {
  const DepositeHistoryAndCollectionErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.something_went_wrong_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class DepositeHistoryEmptyView extends StatelessWidget {
  const DepositeHistoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_cash_in_hand_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_history_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class DepositeCollectedCashEmptyView extends StatelessWidget {
  const DepositeCollectedCashEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_submitted_cash_in_hand_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_history_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class DepositeCashInHandHistoryDetailWidget extends StatelessWidget {
  final CashInHandHistoryConfigModel model;
  const DepositeCashInHandHistoryDetailWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 8.6,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [Image.asset(AssetsUrl.imageURL.moneyDeposite, height: 20, width: 20)]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${translate.order_no} : ${model.orderInfo!.orderNo!}", style: kAppLblMediumFontBold(context)),
                    Text(model.createdAt!, style: kAppLblSmallFontRegular(context)),
                  ],
                ),
                Text(kAppPriceFormat(model.orderInfo!.grandTotal!), style: kAppLblMediumFontBold(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DepositeCashInHandSubmittedCashHistoryWidget extends StatelessWidget {
  final CollectedCashConfigModel model;
  const DepositeCashInHandSubmittedCashHistoryWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 8.6,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [Image.asset(AssetsUrl.imageURL.moneyWithdrawal, height: 20, width: 20)]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${translate.submitted_cash} : ${kAppPriceFormat(model.cashCollected!)}", style: kAppLblMediumFontBold(context)),
                Text("${translate.method} : ${model.method!}", maxLines: 2, style: kAppLblSmallFontRegular(context)),
                Text("${translate.reference} : ${model.reference!}", maxLines: 2, style: kAppLblSmallFontRegular(context)),
                Text(model.createdAt!, style: kAppLblSmallFontRegular(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// DONE //