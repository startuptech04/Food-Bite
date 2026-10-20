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
import 'package:kitchen/app/core/config/assets_url.dart';
import 'package:kitchen/app/core/models/order_list_model.dart';
import 'package:kitchen/app/presentation/pages/orders/@core/bloc/order_list_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/error_dialog.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/app/router/app_route_config.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderListView();
  }
}

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshOrdersIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollMoreOrders = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OrderListBloc>().add(OrderListInitialEvent());
    _scrollMoreOrders.addListener(() {
      if (_scrollMoreOrders.position.pixels == _scrollMoreOrders.position.maxScrollExtent) {
        context.read<OrderListBloc>().add(OrderListLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<OrderListBloc, OrderListState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isOrderChange ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(translate.orders),
              actions: state.status.isLoading ? [] : [IconButton(onPressed: () => context.read<OrderListBloc>().add(OrderListPullRefreshEvent()), icon: const Icon(Icons.refresh_outlined, size: 15))],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: state.status.isLoading
                    ? Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            10,
                            (index) => Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: const SkeletonAvatar(style: SkeletonAvatarStyle(width: 60, height: 5)),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            state.tabList!.length,
                            (index) => GestureDetector(
                              onTap: () => context.read<OrderListBloc>().add(OrderListTabChangeEvent(key: state.tabList![index].key!)),
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Chip(
                                  key: ObjectKey(index),
                                  label: Text(kAppTabTranslate(context, state.tabList![index].label!, state.tabList![index].countNumber!)),
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
              key: _refreshOrdersIndicatorKey,
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onRefresh: () async {
                context.read<OrderListBloc>().add(OrderListPullRefreshEvent());
              },
              child: SingleChildScrollView(
                controller: _scrollMoreOrders,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.status.isLoading || state.status.isChangeTabs) ...[
                      const OrderListLoadingView(),
                    ] else if (state.status.isEmpty) ...[
                      OrderListEmptyView(orderTitle: state.activeTab),
                    ] else if (state.status.isFailure) ...[
                      const OrderListErrorView(),
                    ] else ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          state.orderList.orders!.length,
                          (orderIndex) => OrderListDetailTile(status: state.status, orderChangeId: state.orderChangeId, newOrderStatus: state.newOrderStatus, model: state.orderList.orders![orderIndex], index: orderIndex),
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
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class OrderListDetailTile extends StatelessWidget {
  final OrderListStatus status;
  final String orderChangeId;
  final String newOrderStatus;
  final int index;
  final OrdersConfigModel model;
  const OrderListDetailTile({super.key, required this.model, required this.status, required this.orderChangeId, required this.newOrderStatus, required this.index});

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
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.orderDetailRoute, arguments: [model.id!]).then((value) {
                if (!context.mounted) return;
                if (value != null && value.toString() != 'null' && value.toString().isNotEmpty) {
                  context.read<OrderListBloc>().add(OrderListPullRefreshEvent());
                }
              });
            },
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (model.orderFrom! == 'regular_order') ...[
                            Text("${translate.regular_order}: #${model.regularOrderInfo!.orderNo!}", style: kAppLblTinyFontRegular(context)),
                          ] else if (model.orderFrom! == 'pos_order') ...[
                            Text("${translate.pos_order}: #${model.posOrderInfo!.orderNo!}", style: kAppLblTinyFontRegular(context)),
                          ] else if (model.orderFrom! == 'table_order') ...[
                            Text("${translate.table_order}: ${translate.table_no}: ${model.tableOrder!.tableNumber!}", style: kAppLblTinyFontRegular(context)),
                          ],
                        ],
                      ),
                      Text("${model.createdAt}", style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          model.cookingInstruction!.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRouter.orderDetailRoute, arguments: [model.id!]).then((value) {
                      if (!context.mounted) return;
                      if (value != null && value.toString() != 'null' && value.toString().isNotEmpty) {
                        context.read<OrderListBloc>().add(OrderListPullRefreshEvent());
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(AssetsUrl.imageURL.foodInstruction, height: 12, width: 12, color: Theme.of(context).primaryColor),
                        kAppSpacerHorizontal(width: 5),
                        Text(kAppTrimWord(model.cookingInstruction!, 60), style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.orderDetailRoute, arguments: [model.id!]).then((value) {
                if (!context.mounted) return;
                if (value != null && value.toString() != 'null' && value.toString().isNotEmpty) {
                  context.read<OrderListBloc>().add(OrderListPullRefreshEvent());
                }
              });
            },
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
                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                  child: Text(model.cartItem![cartIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                ),
                                model.cartItem![cartIndex].instruction!.isNotEmpty
                                    ? Container(
                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                        child: Text("${translate.cooking_instruction} : ${model.cartItem![cartIndex].instruction!}", maxLines: 4, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (model.status! == 'new') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<OrderListBloc>().add(OrderListPreparingOrderEvent(orderIndex: index)),
                    style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                    child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'prepareSchedule'
                        ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                        : Text(translate.prepare_order, style: kAppLblTinyFontRegularLight(context)),
                  ),
                ),
              ] else if (model.status! == 'preparing') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<OrderListBloc>().add(OrderListCompleteOrderEvent(orderIndex: index)),
                    style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                    child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'completeOrder'
                        ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                        : Text(translate.complete_order, style: kAppLblTinyFontRegularLight(context)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class OrderListLoadingView extends StatelessWidget {
  const OrderListLoadingView({super.key});

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

class OrderListEmptyView extends StatelessWidget {
  final String orderTitle;
  const OrderListEmptyView({super.key, required this.orderTitle});

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
            Text(translate.no_order_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
            kAppSpacerVertical(height: 5),
            Text("${translate.no_order_error_one} $orderTitle ${translate.no_order_error_two}", textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class OrderListErrorView extends StatelessWidget {
  const OrderListErrorView({super.key});

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
            Text(translate.server_bug_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}
// DONE //