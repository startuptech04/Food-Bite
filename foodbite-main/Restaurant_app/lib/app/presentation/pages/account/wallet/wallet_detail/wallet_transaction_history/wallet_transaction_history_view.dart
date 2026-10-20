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
import 'package:vendor/app/core/models/wallet_transaction_list_model.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/wallet_transaction_history/bloc/wallet_transaction_history_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class WalletTransactionHistoryScreen extends StatelessWidget {
  const WalletTransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => WalletTransactionHistoryBloc(), child: const WalletTransactionHistoryView());
  }
}

class WalletTransactionHistoryView extends StatefulWidget {
  const WalletTransactionHistoryView({super.key});

  @override
  State<WalletTransactionHistoryView> createState() => _WalletTransactionHistoryViewState();
}

class _WalletTransactionHistoryViewState extends State<WalletTransactionHistoryView> {
  final ScrollController _transactionScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<WalletTransactionHistoryBloc>().add(WalletTransactionHistoryInitialEvent());
    _transactionScroll.addListener(() {
      if (_transactionScroll.position.pixels == _transactionScroll.position.maxScrollExtent) {
        context.read<WalletTransactionHistoryBloc>().add(WalletTransactionHistoryScrollMoreTransactionEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<WalletTransactionHistoryBloc, WalletTransactionHistoryState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: state.status.isSuccess || state.status.isCustomError
              ? AppBar(
                  toolbarHeight: 30,
                  automaticallyImplyLeading: false,
                  scrolledUnderElevation: 0,
                  titleSpacing: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Image.asset(AssetsUrl.imageURL.moneyDeposite, width: 15, height: 15),
                              label: Text(translate.deposite, style: kAppLblMediumFontSemiBold(context, color: state.toggleTransaction == 'deposite' ? 'primary' : 'regular')),
                              onPressed: () => context.read<WalletTransactionHistoryBloc>().add(WalletTransactionHistoryToggleTransactionEvent(transaction: 'deposite')),
                              style: kAppElevatedButtonOutlineStyle(
                                context,
                                disabledColor: Theme.of(context).disabledColor,
                                bgColor: ThemeProvider.transparentColor,
                                foreColor: Theme.of(context).canvasColor,
                                borderColor: state.toggleTransaction == 'deposite' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                                height: 40,
                              ),
                            ),
                          ),
                          kAppSpacerHorizontal(width: 15),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Image.asset(AssetsUrl.imageURL.moneyWithdrawal, width: 15, height: 15),
                              label: Text(translate.withdrawal, style: kAppLblMediumFontSemiBold(context, color: state.toggleTransaction == 'withdrawal' ? 'primary' : 'regular')),
                              onPressed: () => context.read<WalletTransactionHistoryBloc>().add(WalletTransactionHistoryToggleTransactionEvent(transaction: 'withdrawal')),
                              style: kAppElevatedButtonOutlineStyle(
                                context,
                                disabledColor: Theme.of(context).disabledColor,
                                bgColor: ThemeProvider.transparentColor,
                                foreColor: Theme.of(context).canvasColor,
                                borderColor: state.toggleTransaction == 'withdrawal' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
          body: SingleChildScrollView(
            controller: _transactionScroll,
            padding: const EdgeInsets.symmetric(vertical: ThemeProvider.scaffoldPadding, horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const WalletTransactionHistoryLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const WalletTransactionHistoryErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const WalletTransactionHistoryEmptyView(),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.transaction_history, style: kAppLblSmallFontRegular(context)),
                      Text("${state.model.transaction!.length}/${state.model.totalResults!} ${translate.results}", style: kAppLblSmallFontRegular(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.transaction!.length,
                      (walletIndex) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.toggleTransaction == 'withdrawal') ...[
                            state.model.transaction![walletIndex].type! == 'withdrawal' ? WalletTransactionWidget(model: state.model, walletIndex: walletIndex) : const SizedBox(),
                          ] else if (state.toggleTransaction == 'deposite')
                            state.model.transaction![walletIndex].type! == 'deposite' ? WalletTransactionWidget(model: state.model, walletIndex: walletIndex) : const SizedBox()
                          else ...[
                            WalletTransactionWidget(model: state.model, walletIndex: walletIndex),
                          ],
                        ],
                      ),
                    ),
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
}

class WalletTransactionWidget extends StatelessWidget {
  final WalletTransactionListModel model;
  final int walletIndex;
  const WalletTransactionWidget({super.key, required this.model, required this.walletIndex});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 8.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Image.asset(model.transaction![walletIndex].type == 'deposite' ? AssetsUrl.imageURL.moneyDeposite : AssetsUrl.imageURL.moneyWithdrawal, height: 20, width: 20)],
            ),
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
                    Text(model.transaction![walletIndex].type == 'deposite' ? translate.deposite : translate.withdrawal, style: kAppLblMediumFontBold(context)),
                    Text(model.transaction![walletIndex].createdAt!, style: kAppLblSmallFontRegular(context)),
                  ],
                ),
                Text(kAppPriceFormat(model.transaction![walletIndex].amount!), style: kAppLblMediumFontBold(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WalletTransactionHistoryLoadingView extends StatelessWidget {
  const WalletTransactionHistoryLoadingView({super.key});

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

class WalletTransactionHistoryErrorView extends StatelessWidget {
  const WalletTransactionHistoryErrorView({super.key});

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

class WalletTransactionHistoryEmptyView extends StatelessWidget {
  const WalletTransactionHistoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_transaction_history_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_transaction_history_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //