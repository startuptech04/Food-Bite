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
import 'package:vendor/app/core/models/completed_table_order_list_model.dart';
import 'package:vendor/app/presentation/pages/account/table_orders/@core/bloc/table_order_list_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/billing_summary_modal/billing_summary_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TableOrderListScreen extends StatelessWidget {
  const TableOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TableOrderListBloc()..add(TableOrderListInitialEvent()), child: const TableOrderListView());
  }
}

class TableOrderListView extends StatefulWidget {
  const TableOrderListView({super.key});

  @override
  State<TableOrderListView> createState() => _TableOrderListViewState();
}

class _TableOrderListViewState extends State<TableOrderListView> {
  final GlobalKey<RefreshIndicatorState> _refreshTableOrdersIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollMoreTableOrders = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollMoreTableOrders.addListener(() {
      if (_scrollMoreTableOrders.position.pixels == _scrollMoreTableOrders.position.maxScrollExtent) {
        context.read<TableOrderListBloc>().add(TableOrderListFetchMoreCompletedOrderEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<TableOrderListBloc, TableOrderListState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate.table_order_list),
            scrolledUnderElevation: 0,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.tableListRoute),
                child: Text(translate.add_table, style: kAppLblTinyFontBold(context)),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    state.tabList!.length,
                    (index) => GestureDetector(
                      onTap: () => context.read<TableOrderListBloc>().add(TableOrderListTabChangeEvent(key: state.tabList![index].key!)),
                      child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Chip(
                          key: ObjectKey(index),
                          label: Text(kAppDDTranslate(context, state.tabList![index].label!)),
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: state.activeTab == state.tabList![index].key ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                          ),
                          labelStyle: kAppLblSmallFontMedium(context, color: state.activeTab == state.tabList![index].key ? 'primary' : 'regular'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: RefreshIndicator(
            key: _refreshTableOrdersIndicatorKey,
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onRefresh: () async {
              context.read<TableOrderListBloc>().add(TableOrderListPullRefreshEvent());
            },
            child: SingleChildScrollView(
              controller: _scrollMoreTableOrders,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.activeTab == 'ongoing') ...[
                    if (state.status.isLoading) ...[
                      const TableOrderListOngoingOrderLoadingView(),
                    ] else if (state.status.isFailure) ...[
                      const TableOrderListOngoingOrderErrorView(),
                    ] else if (state.status.isEmpty) ...[
                      const TableOrderListOngoingOrderEmptyView(),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 50),
                          scrollDirection: Axis.vertical,
                          key: UniqueKey(),
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: state.ongoingOrder.tables![index].occupied!
                                  ? () {
                                      Navigator.of(context).pushNamed(AppRouter.completeTableOrderRoute, arguments: [state.ongoingOrder.tables![index].tableNumber!, state.ongoingOrder.tables![index].id!]).then((value) {
                                        if (!context.mounted) return;
                                        context.read<TableOrderListBloc>().add(TableOrderListRefreshTableEvent());
                                      });
                                    }
                                  : () {
                                      showErrorDialog(context, translate.no_orders, state.extraMessage.toString(), 0);
                                    },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 5,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(color: state.ongoingOrder.tables![index].occupied! ? Theme.of(context).primaryColor : ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                  child: Container(
                                    decoration: BoxDecoration(color: state.ongoingOrder.tables![index].occupied! ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor),
                                    child: Center(
                                      child: Text("${state.ongoingOrder.tables![index].tableNumber!}", style: state.ongoingOrder.tables![index].occupied! ? kAppLblTinyFontBoldGuest(context) : kAppLblTinyFontBold(context)),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: state.ongoingOrder.tables!.length,
                        ),
                      ),
                    ],
                  ] else if (state.activeTab == 'completed') ...[
                    if (state.status.isLoading) ...[
                      const TableOrderListCompletedOrderLoadingView(),
                    ] else if (state.status.isFailure) ...[
                      const TableOrderListOngoingOrderErrorView(),
                    ] else if (state.status.isEmpty) ...[
                      const TableOrderListOngoingOrderEmptyView(),
                    ] else ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(state.completedOrders.orders!.length, (index) => TableOrderListCompletedOrderInfoWidget(model: state.completedOrders.orders![index])),
                      ),
                      kAppSpacerVertical(height: 20),
                      state.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                      kAppSpacerVertical(height: 20),
                    ],
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

class TableOrderListCompletedOrderInfoWidget extends StatelessWidget {
  final CompletedTableOrderConfigModel model;
  const TableOrderListCompletedOrderInfoWidget({super.key, required this.model});

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
            onTap: () => Navigator.of(context).pushNamed(AppRouter.tableOrderDetailRoute, arguments: [model.id!]),
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
                      Text("${translate.order_number} : ${model.orderNo!}", style: kAppLblTinyFontRegular(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("${model.createdAt}", style: kAppLblTinyFontRegular(context))],
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(model.customerType == 'guest' ? translate.guest_customer : "${model.customerName}", style: kAppLblTinyFontRegular(context)),
                      Text("${translate.table_number} : ${model.tableDetail!.tableNumber!}", style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRouter.tableOrderDetailRoute, arguments: [model.id!]),
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
                                    Text("${model.cartItem![cartIndex].quantity!}", style: kAppLblTinyFontBold(context)),
                                    Text(" X ", style: kAppLblTinyFontBold(context)),
                                    Text(kAppTrimWord(model.cartItem![cartIndex].name!, 40), style: kAppLblTinyFontBold(context)),
                                  ],
                                ),
                                model.cartItem![cartIndex].optionName!.isNotEmpty
                                    ? Container(
                                        padding: const EdgeInsets.only(right: 5),
                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.8, minWidth: MediaQuery.of(context).size.width / 2.5),
                                        child: Text(model.cartItem![cartIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                      )
                                    : const SizedBox(),
                                kAppSpacerVertical(height: 5),
                                model.cartItem![cartIndex].instruction!.isNotEmpty
                                    ? Container(
                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                        child: Text("${translate.form_cooking_instructions} : ${model.cartItem![cartIndex].instruction!}", maxLines: 4, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
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
                  onTap: () => Navigator.of(context).pushNamed(AppRouter.tableOrderDetailRoute, arguments: [model.id!]),
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
                            paymentStatus: model.paymentMode! == 'online' || model.status == true ? translate.paid : translate.unpaid,
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

class TableOrderListOngoingOrderLoadingView extends StatelessWidget {
  const TableOrderListOngoingOrderLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 50),
            scrollDirection: Axis.vertical,
            key: UniqueKey(),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: MediaQuery.of(context).size.width / 5,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                    child: const Center(child: SkeletonAvatar(style: SkeletonAvatarStyle(width: 5, height: 5))),
                  ),
                ),
              );
            },
            itemCount: 20,
          ),
        ],
      ),
    );
  }
}

class TableOrderListOngoingOrderErrorView extends StatelessWidget {
  const TableOrderListOngoingOrderErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
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

class TableOrderListOngoingOrderEmptyView extends StatelessWidget {
  const TableOrderListOngoingOrderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
      child: Center(
        child: Column(
          children: [
            kAppSpacerVertical(height: 20),
            Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
            kAppSpacerVertical(height: 20),
            Text(translate.no_record_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
            kAppSpacerVertical(height: 5),
            Text(translate.no_record_found_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class TableOrderListCompletedOrderLoadingView extends StatelessWidget {
  const TableOrderListCompletedOrderLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
      child: Column(
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
      ),
    );
  }
}
// DONE //