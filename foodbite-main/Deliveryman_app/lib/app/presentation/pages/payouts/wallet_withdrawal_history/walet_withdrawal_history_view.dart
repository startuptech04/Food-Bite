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
import 'package:driver/app/core/models/withdrawal_history_model.dart';
import 'package:driver/app/presentation/pages/modals/withdrawal_history_detail_modal/withdrawal_history_detail_modal_view.dart';
import 'package:driver/app/presentation/pages/payouts/wallet_withdrawal_history/bloc/wallet_withdrawal_history_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class WaletWithdrawalHistoryScreen extends StatelessWidget {
  const WaletWithdrawalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => WalletWithdrawalHistoryBloc(), child: const WaletWithdrawalHistoryView());
  }
}

class WaletWithdrawalHistoryView extends StatefulWidget {
  const WaletWithdrawalHistoryView({super.key});

  @override
  State<WaletWithdrawalHistoryView> createState() => _WaletWithdrawalHistoryViewState();
}

class _WaletWithdrawalHistoryViewState extends State<WaletWithdrawalHistoryView> {
  final ScrollController _historyScroll = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<WalletWithdrawalHistoryBloc>().add(WalletWithdrawalHistoryInitialEvent());
    _historyScroll.addListener(() {
      if (_historyScroll.position.pixels == _historyScroll.position.maxScrollExtent) {
        context.read<WalletWithdrawalHistoryBloc>().add(WalletWithdrawalHistoryScrollMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<WalletWithdrawalHistoryBloc, WalletWithdrawalHistoryState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: state.status.isSuccess || state.status.isCustomError
              ? AppBar(
                  scrolledUnderElevation: 0,
                  toolbarHeight: 30,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ElevatedButton.icon(
                              icon: Image.asset(AssetsUrl.imageURL.withdrawalCreated, width: 15, height: 15),
                              label: Text("${translate.pending} (${state.model.createdRequest!})", style: kAppLblMediumFontSemiBold(context, color: state.toggleTransaction == 'created' ? 'primary' : 'regular')),
                              onPressed: () => context.read<WalletWithdrawalHistoryBloc>().add(WalletWithdrawalHistoryToggleEvent(status: 'created')),
                              style: kAppElevatedButtonOutlineStyle(
                                context,
                                disabledColor: Theme.of(context).disabledColor,
                                bgColor: ThemeProvider.transparentColor,
                                foreColor: Theme.of(context).canvasColor,
                                borderColor: state.toggleTransaction == 'created' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                                height: 40,
                              ),
                            ),
                            kAppSpacerHorizontal(width: 15),
                            ElevatedButton.icon(
                              icon: Image.asset(AssetsUrl.imageURL.withdrawalAccepted, width: 15, height: 15),
                              label: Text("${translate.accepted} (${state.model.acceptedRequest!})", style: kAppLblMediumFontSemiBold(context, color: state.toggleTransaction == 'accepted' ? 'primary' : 'regular')),
                              onPressed: () => context.read<WalletWithdrawalHistoryBloc>().add(WalletWithdrawalHistoryToggleEvent(status: 'accepted')),
                              style: kAppElevatedButtonOutlineStyle(
                                context,
                                disabledColor: Theme.of(context).disabledColor,
                                bgColor: ThemeProvider.transparentColor,
                                foreColor: Theme.of(context).canvasColor,
                                borderColor: state.toggleTransaction == 'accepted' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                                height: 40,
                              ),
                            ),
                            kAppSpacerHorizontal(width: 15),
                            ElevatedButton.icon(
                              icon: Image.asset(AssetsUrl.imageURL.withdrawalRejected, width: 15, height: 15),
                              label: Text("${translate.rejected} (${state.model.rejectedRequest!})", style: kAppLblMediumFontSemiBold(context, color: state.toggleTransaction == 'rejected' ? 'primary' : 'regular')),
                              onPressed: () => context.read<WalletWithdrawalHistoryBloc>().add(WalletWithdrawalHistoryToggleEvent(status: 'rejected')),
                              style: kAppElevatedButtonOutlineStyle(
                                context,
                                disabledColor: Theme.of(context).disabledColor,
                                bgColor: ThemeProvider.transparentColor,
                                foreColor: Theme.of(context).canvasColor,
                                borderColor: state.toggleTransaction == 'rejected' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          body: SingleChildScrollView(
            controller: _historyScroll,
            padding: const EdgeInsets.symmetric(vertical: ThemeProvider.scaffoldPadding, horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const WalletWithdrawalHistoryLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const WalletWithdrawalHistoryErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const WalletWithdrawalHistoryEmptyView(),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.transaction_history, style: kAppLblSmallFontRegular(context)),
                      Text("${state.model.results!.length}/${state.model.totalResults!} ${translate.results}", style: kAppLblSmallFontRegular(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.results!.length,
                      (historyIndex) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.toggleTransaction == 'created') ...[
                            state.model.results![historyIndex].status! == 'created' ? WalletWithdrawalHistoryWidget(model: state.model.results![historyIndex]) : const SizedBox(),
                          ] else if (state.toggleTransaction == 'accepted')
                            state.model.results![historyIndex].status! == 'accepted' ? WalletWithdrawalHistoryWidget(model: state.model.results![historyIndex]) : const SizedBox()
                          else if (state.toggleTransaction == 'rejected') ...[
                            state.model.results![historyIndex].status! == 'rejected' ? WalletWithdrawalHistoryWidget(model: state.model.results![historyIndex]) : const SizedBox(),
                          ] else ...[
                            WalletWithdrawalHistoryWidget(model: state.model.results![historyIndex]),
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

class WalletWithdrawalHistoryWidget extends StatelessWidget {
  final WithdrawalHistoryConfigModel model;
  const WalletWithdrawalHistoryWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (BuildContext context) {
            return FractionallySizedBox(heightFactor: 0.7, child: WithdrawalHistoryDetailModalView(model: model));
          },
        );
      },
      child: Container(
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
                children: [
                  if (model.status! == 'created') ...[
                    Image.asset(AssetsUrl.imageURL.withdrawalCreated, height: 20, width: 20),
                  ] else if (model.status! == 'accepted') ...[
                    Image.asset(AssetsUrl.imageURL.withdrawalAccepted, height: 20, width: 20),
                  ] else ...[
                    Image.asset(AssetsUrl.imageURL.withdrawalRejected, height: 20, width: 20),
                  ],
                ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (model.status! == 'created') ...[
                            Text("${translate.pending} (${kAppTrimWord(model.withdrawalMethodDetail!.name!, 15)})", style: kAppLblMediumFontBold(context)),
                          ] else if (model.status! == 'accepted') ...[
                            Text("${translate.accepted} (${kAppTrimWord(model.withdrawalMethodDetail!.name!, 15)})", style: kAppLblMediumFontBold(context)),
                          ] else ...[
                            Text("${translate.rejected} (${kAppTrimWord(model.withdrawalMethodDetail!.name!, 15)})", style: kAppLblMediumFontBold(context)),
                          ],
                        ],
                      ),
                      Text(model.createdAt!, style: kAppLblSmallFontRegular(context)),
                    ],
                  ),
                  Text(kAppPriceFormat(model.amount!), style: kAppLblMediumFontBold(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletWithdrawalHistoryLoadingView extends StatelessWidget {
  const WalletWithdrawalHistoryLoadingView({super.key});

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

class WalletWithdrawalHistoryErrorView extends StatelessWidget {
  const WalletWithdrawalHistoryErrorView({super.key});

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

class WalletWithdrawalHistoryEmptyView extends StatelessWidget {
  const WalletWithdrawalHistoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_withdrawal_history_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_history_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //