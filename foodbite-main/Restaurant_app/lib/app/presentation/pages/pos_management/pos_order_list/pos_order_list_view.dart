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
import 'package:vendor/app/core/models/pos_order_list_model.dart';
import 'package:vendor/app/presentation/pages/modals/billing_summary_modal/billing_summary_modal_view.dart';
import 'package:vendor/app/presentation/pages/pos_management/pos_order_list/bloc/pos_order_list_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class PosOrderListScreen extends StatelessWidget {
  const PosOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => PosOrderListBloc()..add(PosOrderListInitialEvent()), child: const PosOrderListView());
  }
}

class PosOrderListView extends StatefulWidget {
  const PosOrderListView({super.key});

  @override
  State<PosOrderListView> createState() => _PosOrderListViewState();
}

class _PosOrderListViewState extends State<PosOrderListView> {
  final GlobalKey<RefreshIndicatorState> _refreshPosOrdersIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollMorePosOrders = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollMorePosOrders.addListener(() {
      if (_scrollMorePosOrders.position.pixels == _scrollMorePosOrders.position.maxScrollExtent) {
        context.read<PosOrderListBloc>().add(PosOrderListScrollMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<PosOrderListBloc, PosOrderListState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.pos_order_list), scrolledUnderElevation: 0),
          body: RefreshIndicator(
            key: _refreshPosOrdersIndicatorKey,
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onRefresh: () async {
              context.read<PosOrderListBloc>().add(PosOrderListPullRefreshEvent());
            },
            child: SingleChildScrollView(
              controller: _scrollMorePosOrders,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const PosOrderListLoadingView(),
                  ] else if (state.status.isEmpty) ...[
                    const PosOrderListEmptyView(),
                  ] else if (state.status.isFailure) ...[
                    const PosOrderListErrorView(),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(state.model.orders!.length, (index) => PosOrderListInfoTileWidget(model: state.model.orders![index])),
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

class PosOrderListInfoTileWidget extends StatelessWidget {
  final PosOrderConfigModel model;
  const PosOrderListInfoTileWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5),
          bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRouter.posOrderDetailRoute, arguments: [model.id!]),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${translate.order_number}: ${model.orderNo!}', style: kAppLblTinyFontRegular(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text('${model.createdAt}', style: kAppLblTinyFontRegular(context))],
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(model.customerType == 'guest' ? translate.guest_customer : "${model.customerName}", style: kAppLblTinyFontRegular(context)),
                      Text(model.tableOrder == true ? translate.table_order : translate.pos_order, style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRouter.posOrderDetailRoute, arguments: [model.id!]),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  model.cartItem!.length,
                  (cartIndex) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kAppFoodType(model.cartItem![cartIndex].foodType!, height: 10, width: 10),
                            kAppSpacerHorizontal(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('${model.cartItem![cartIndex].quantity!}', style: kAppLblTinyFontBold(context)),
                                    Text(' X ', style: kAppLblTinyFontBold(context)),
                                    Text(kAppTrimWord(model.cartItem![cartIndex].name!, 40), style: kAppLblTinyFontBold(context)),
                                  ],
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                  child: Text(model.cartItem![cartIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                ),
                                model.cartItem![cartIndex].instruction!.isNotEmpty
                                    ? Container(
                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                        child: Text('${translate.form_cooking_instructions}: ${model.cartItem![cartIndex].instruction!}', maxLines: 4, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        Text(kAppPriceFormat(model.cartItem![cartIndex].totalPrice!), style: kAppLblTinyFontBold(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(AppRouter.posOrderDetailRoute, arguments: [model.id!]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text(translate.total_bill, style: kAppLblTinyFontRegular(context))],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.7,
                          child: BillingSummaryModalScreen(
                            paymentStatus: model.paymentMode! == 'online' || model.status == 'completed' ? translate.paid : translate.unpaid,
                            paymentName: model.paymentMode! == 'online' ? translate.online : translate.offline,
                            realTotal: model.realTotal!,
                            itemTotal: model.itemTotal!,
                            itemDiscount: model.itemDiscount!,
                            couponDiscount: model.discountCharge!,
                            walletAmount: 0,
                            serviceCharge: model.serviceCharge!,
                            foodServiceCharge: model.foodServiceCharge!,
                            deliveryTip: 0,
                            extraCharge: model.extraCharge!,
                            deliveryCharge: 0,
                            packagingCharges: model.packageCharge!,
                            packagingChargesTax: model.packageChargeTax!,
                            waiterCharge: model.waiterTip!,
                            grandTotal: model.grandTotal!,
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(kAppPriceFormat(model.grandTotal!), style: kAppLblTinyFontBold(context)),
                      kAppSpacerHorizontal(width: 5),
                      Icon(Icons.info_outline_rounded, size: 12, color: Theme.of(context).canvasColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PosOrderListLoadingView extends StatelessWidget {
  const PosOrderListLoadingView({super.key});

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

class PosOrderListEmptyView extends StatelessWidget {
  const PosOrderListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
      child: Center(
        child: Column(
          children: [
            kAppSpacerVertical(height: 20),
            Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
            kAppSpacerVertical(height: 20),
            Text(translate.no_order_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
            kAppSpacerVertical(height: 5),
            Text(translate.no_order_found_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class PosOrderListErrorView extends StatelessWidget {
  const PosOrderListErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
      child: Center(
        child: Column(
          children: [
            kAppSpacerVertical(height: 20),
            Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
            kAppSpacerVertical(height: 20),
            Text(translate.error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}
// DONE //