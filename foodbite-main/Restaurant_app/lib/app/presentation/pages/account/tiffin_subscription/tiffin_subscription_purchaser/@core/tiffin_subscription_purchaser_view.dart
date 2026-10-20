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
import 'package:vendor/app/presentation/pages/account/tiffin_subscription/tiffin_subscription_purchaser/@core/bloc/tiffin_subscription_purchaser_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TiffinSubscriptionPurchaserScreen extends StatelessWidget {
  final String tiffinId;
  const TiffinSubscriptionPurchaserScreen({super.key, required this.tiffinId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TiffinSubscriptionPurchaserBloc()..add(TiffinSubscriptionPurchaserInitialEvent(tiffinId: tiffinId)),
      child: const TiffinSubscriptionPurchaserView(),
    );
  }
}

class TiffinSubscriptionPurchaserView extends StatefulWidget {
  const TiffinSubscriptionPurchaserView({super.key});

  @override
  State<TiffinSubscriptionPurchaserView> createState() => _TiffinSubscriptionPurchaserViewState();
}

class _TiffinSubscriptionPurchaserViewState extends State<TiffinSubscriptionPurchaserView> {
  final GlobalKey<RefreshIndicatorState> _refreshHistoryIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollMoreHistory = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollMoreHistory.addListener(() {
      if (_scrollMoreHistory.position.pixels == _scrollMoreHistory.position.maxScrollExtent) {
        context.read<TiffinSubscriptionPurchaserBloc>().add(TiffinSubscriptionPurchaserLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<TiffinSubscriptionPurchaserBloc, TiffinSubscriptionPurchaserState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.all_purchased), scrolledUnderElevation: 0),
          body: RefreshIndicator(
            key: _refreshHistoryIndicatorKey,
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onRefresh: () async {
              context.read<TiffinSubscriptionPurchaserBloc>().add(TiffinSubscriptionPurchaserPullRefreshEvent());
            },
            child: SingleChildScrollView(
              controller: _scrollMoreHistory,
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const TiffinSubscriptionPurchaseLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const TiffinSubscriptionPurchaseErrorView(),
                  ] else if (state.status.isEmpty) ...[
                    const TiffinSubscriptionPurchaseEmptyView(),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.model.results!.length,
                        (index) => GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(AppRouter.tiffinSubscriptionPurchaseHistoryDetailRoute, arguments: [state.model.results![index].id!]),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Theme.of(context).disabledColor, width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${translate.id} : ${state.model.results![index].id}", style: kAppLblTinyFontRegular(context)),
                                    Text("${state.model.results![index].startDate} - ${state.model.results![index].orderAt!}", style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                                kAppSpacerVertical(height: 10),
                                Text(state.model.results![index].orderTo == 'homedelivery' ? translate.home_delivery : translate.self_pickup, style: kAppLblTinyFontBold(context)),
                                kAppSpacerVertical(height: 10),
                                Text("${state.model.results![index].userInfo!.firstName!} ${state.model.results![index].userInfo!.lastName!}", style: kAppLblTinyFontBold(context)),
                                Text("${state.model.results![index].userInfo!.countryCode!} ${state.model.results![index].userInfo!.contactNumber!}", style: kAppLblTinyFontRegular(context)),
                                kAppSpacerVertical(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(kAppPriceFormat(state.model.results![index].grandTotal!), style: kAppLblTinyFontBold(context)),
                                        Text("(${state.model.results![index].paymentInfo!.name!})", style: kAppLblTinyFontRegular(context)),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow, borderRadius: BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (state.model.results![index].status! == 'created') ...[
                                            Text(translate.order_status_created, style: kAppLblTinyFontBold(context)),
                                          ] else if (state.model.results![index].status! == 'cancelled') ...[
                                            Text(translate.order_status_cancelled, style: kAppLblTinyFontBold(context)),
                                          ] else if (state.model.results![index].status! == 'completed') ...[
                                            Text(translate.order_status_completed, style: kAppLblTinyFontBold(context)),
                                          ] else if (state.model.results![index].status! == 'refunded') ...[
                                            Text(translate.order_status_refunded, style: kAppLblTinyFontBold(context)),
                                          ] else if (state.model.results![index].status! == 'partially_refunded') ...[
                                            Text(translate.order_status_partially_refunded, style: kAppLblTinyFontBold(context)),
                                          ] else if (state.model.results![index].status! == 'pending_payments') ...[
                                            Text(translate.order_status_pending_payments, style: kAppLblTinyFontBold(context)),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
          ),
        );
      },
    );
  }
}

class TiffinSubscriptionPurchaseLoadingView extends StatelessWidget {
  const TiffinSubscriptionPurchaseLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonListTile(
                hasSubtitle: true,
                padding: const EdgeInsets.all(0),
                leadingStyle: const SkeletonAvatarStyle(width: 25, height: 25),
                titleStyle: SkeletonLineStyle(height: 10, randomLength: false, borderRadius: BorderRadius.circular(16)),
                subtitleStyle: SkeletonLineStyle(height: 10, randomLength: true, borderRadius: BorderRadius.circular(16)),
              ),
              kAppSpacerVertical(height: 20),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  spacing: 6,
                  padding: const EdgeInsets.all(0),
                  lineStyle: SkeletonLineStyle(height: 10, randomLength: false, borderRadius: BorderRadius.circular(16)),
                ),
              ),
              kAppSpacerVertical(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 3.5, borderRadius: BorderRadius.circular(8)),
                  ),
                  SkeletonLine(
                    style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 3.5, borderRadius: BorderRadius.circular(8)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TiffinSubscriptionPurchaseErrorView extends StatelessWidget {
  const TiffinSubscriptionPurchaseErrorView({super.key});

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

class TiffinSubscriptionPurchaseEmptyView extends StatelessWidget {
  const TiffinSubscriptionPurchaseEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_tiffin_package_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_tiffin_package_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //