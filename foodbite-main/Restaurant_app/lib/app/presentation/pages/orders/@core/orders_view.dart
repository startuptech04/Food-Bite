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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/navigation_back_response_model.dart';
import 'package:vendor/app/core/models/order_list_model.dart';
import 'package:vendor/app/presentation/pages/modals/billing_summary_modal/billing_summary_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/cancellation_reasons/cancellation_reasons_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/find_driver_for_order/find_driver_for_order_view.dart';
import 'package:vendor/app/presentation/pages/modals/order_complaints_modal/order_complaints_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/order_help_modal/order_help_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/order_verification_modal/order_verification_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_driver/select_driver_modal_view.dart';
import 'package:vendor/app/presentation/pages/orders/@core/bloc/orders_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

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
    context.read<OrdersBloc>().add(OrdersInitialEvent());
    _scrollMoreOrders.addListener(() {
      if (_scrollMoreOrders.position.pixels == _scrollMoreOrders.position.maxScrollExtent) {
        context.read<OrdersBloc>().add(OrderLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isOrderChange ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              leadingWidth: 90,
              leading: state.status.isLoading
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (state.orderList.restaurantInfo!.status! == true && state.orderList.restaurantInfo!.temporaryClosed! == false) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showConfirmDialog(context, translate.alert_restaurant_close_title, translate.alert_restaurant_close_sub_title, translate.cancel_lbl, translate.alert_confirm_close_temp).then((value) {
                                  if (!context.mounted) return;
                                  if (value) {
                                    context.read<OrdersBloc>().add(OrderCloseTemporaryEvent());
                                  }
                                });
                              },
                              child: Container(
                                height: 20,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(translate.online, style: kAppLblTinyRegularWhite(context)),
                                    Icon(Icons.circle, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else if (state.orderList.restaurantInfo!.status! == true && state.orderList.restaurantInfo!.temporaryClosed! == true) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.read<OrdersBloc>().add(ReOpenRestaurantEvent());
                              },
                              child: Container(
                                height: 20,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(color: Theme.of(context).canvasColor, width: 1.5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.circle, size: 10, color: Theme.of(context).canvasColor),
                                    Text(translate.offline, style: kAppLblTinyFontRegularChip(context, color: 'regular')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: Container(
                              height: 20,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.block_flipped, size: 10, color: Theme.of(context).primaryColor),
                                  Text(translate.account_blocked, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
              title: Text(translate.orders),
              actions: state.status.isLoading ? [] : [IconButton(onPressed: () => context.read<OrdersBloc>().add(OrderPullRefreshEvent()), icon: const Icon(Icons.refresh_outlined, size: 15))],
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
                              onTap: () => context.read<OrdersBloc>().add(OrdersTabChangeEvent(key: state.tabList![index].key!)),
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
                context.read<OrdersBloc>().add(OrderPullRefreshEvent());
              },
              child: SingleChildScrollView(
                controller: _scrollMoreOrders,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.status.isLoading || state.status.isChangeTabs) ...[
                      const OrdersLoadingView(),
                    ] else if (state.status.isEmpty) ...[
                      OrdersEmptyView(orderTitle: state.activeTab),
                    ] else if (state.status.isFailure) ...[
                      const OrdersErrorView(),
                    ] else ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          state.orderList.orders!.length,
                          (orderIndex) => OrderDetailTile(
                            status: state.status,
                            orderChangeId: state.orderChangeId,
                            newOrderStatus: state.newOrderStatus,
                            driverPickup: state.orderList.restaurantConfig!.driverPickup!,
                            canCancleOrder: state.orderList.orderSettings!.restaurantCanCancelOrder!,
                            nearDriver: state.orderList.nearDriver!,
                            index: orderIndex,
                            model: state.orderList.orders![orderIndex],
                            verifyOTP: state.orderList.orderSettings!.deliveryVerification!,
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
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class OrderDetailTile extends StatelessWidget {
  final OrdersStatus status;
  final String orderChangeId;
  final String newOrderStatus;
  final bool canCancleOrder;
  final bool driverPickup;
  final int nearDriver;
  final int index;
  final OrdersConfigModel model;
  final bool verifyOTP;
  const OrderDetailTile({
    super.key,
    required this.status,
    required this.orderChangeId,
    required this.newOrderStatus,
    required this.driverPickup,
    required this.canCancleOrder,
    required this.nearDriver,
    required this.index,
    required this.model,
    required this.verifyOTP,
  });

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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRouter.orderDetailRoute, arguments: [model.id!, model.orderNo!]).then((value) {
                          if (!context.mounted) return;
                          if (value != null && value.toString() != 'null' && value.toString().isNotEmpty) {
                            context.read<OrdersBloc>().add(OrderPullRefreshEvent());
                          }
                        });
                      },
                      child: Text('${translate.order_number} : ${model.orderNo!}', style: kAppLblTinyFontRegular(context)),
                    ),
                    GestureDetector(
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
                              child: OrderHelpModalScreen(orderId: model.id!, orderNo: model.orderNo!),
                            );
                          },
                        ).then((value) {
                          if (!context.mounted) return;
                          if (value != null && value.toString() != '' && value.toString().isNotEmpty) {
                            NavigationBackResponseModel backResponse = NavigationBackResponseModel.fromJson(value);
                            if (backResponse.action!.isNotEmpty && backResponse.action! != 'none') {
                              if (backResponse.action! == 'navigate' && backResponse.value! == 'complaints') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) {
                                      return OrderComplaintsModalScreen(orderId: model.id!);
                                    },
                                  ),
                                );
                              }
                            }
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(model.instantOrder! ? '${model.createdAt} ${model.orderAt}' : '${model.scheduleDate} ${model.scheduleTime}', style: kAppLblTinyFontRegular(context)),
                          kAppSpacerHorizontal(width: 5),
                          FaIcon(FontAwesomeIcons.ellipsisVertical, size: 10, color: Theme.of(context).canvasColor),
                        ],
                      ),
                    ),
                  ],
                ),
                kAppSpacerVertical(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRouter.orderDetailRoute, arguments: [model.id!, model.orderNo!]).then((value) {
                          if (!context.mounted) return;
                          if (value != null && value.toString() != 'null' && value.toString().isNotEmpty) {
                            context.read<OrdersBloc>().add(OrderPullRefreshEvent());
                          }
                        });
                      },
                      child: Text("${model.userOrderCount} ${translate.order_by} ${model.userInfo!.firstName} ${model.userInfo!.lastName}", style: kAppLblTinyFontRegular(context)),
                    ),
                    GestureDetector(
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
                              child: OrderHelpModalScreen(orderId: model.id!, orderNo: model.orderNo!),
                            );
                          },
                        );
                      },
                      child: Text(model.instantOrder! ? translate.instant_order : translate.schedule_order, style: kAppLblTinyFontRegular(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          model.cookingInstruction!.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRouter.orderDetailRoute, arguments: [model.id!, model.orderNo!]).then((value) {
                      if (!context.mounted) return;
                      if (value != null && value.toString() != 'null' && value.toString().isNotEmpty) {
                        context.read<OrdersBloc>().add(OrderPullRefreshEvent());
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
              Navigator.of(context).pushNamed(AppRouter.orderDetailRoute, arguments: [model.id!, model.orderNo!]).then((value) {
                if (!context.mounted) return;
                if (value != null && value.toString() != 'null' && value.toString().isNotEmpty) {
                  context.read<OrdersBloc>().add(OrderPullRefreshEvent());
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
                                        child: Text('${translate.form_cooking_instructions} : ${model.cartItem![cartIndex].instruction!}', maxLines: 4, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.total_bill, style: kAppLblTinyFontRegular(context)),
                    kAppSpacerHorizontal(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                      ),
                      child: Text(model.paymentMode! == 'online' || model.status == 'delivered' ? translate.paid : translate.unpaid, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                    ),
                  ],
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
                            paymentStatus: model.paymentMode! == 'online' || model.status == 'delivered' ? translate.paid : translate.unpaid,
                            paymentName: model.paymentInfo!.name!,
                            realTotal: model.realTotal!,
                            itemTotal: model.itemTotal!,
                            itemDiscount: model.itemDiscount!,
                            couponDiscount: model.couponDiscountCharge!,
                            walletAmount: model.walletAmount!,
                            serviceCharge: model.serviceCharge!,
                            foodServiceCharge: model.foodServiceCharge!,
                            deliveryTip: model.deliveryTip!,
                            extraCharge: model.extraCharge!,
                            deliveryCharge: model.deliveryCharge!,
                            packagingCharges: model.packageCharge!,
                            packagingChargesTax: model.packageChargeTax!,
                            waiterCharge: 0,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (model.status! == 'created' && model.instantOrder!) ...[
                OrdersPreparationTimeTile(index: index, preparationTime: model.preparationTime!),
              ] else if (model.status! == 'accepted' && model.scheduleOrder!) ...[
                OrdersPreparationTimeTile(index: index, preparationTime: model.preparationTime!),
              ] else ...[
                kAppSpacerVertical(height: 10),
              ],
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (model.status! == 'created') ...[
                canCancleOrder
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  enableDrag: false,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  builder: (BuildContext context) {
                                    return const FractionallySizedBox(heightFactor: 0.7, child: CancellationReasonModalScreen());
                                  },
                                ).then((value) {
                                  if (!context.mounted) return;
                                  if (value != null && value.toString().isNotEmpty) {
                                    context.read<OrdersBloc>().add(OrdersRejectEvent(orderIndex: index, reasonId: value.toString()));
                                  }
                                });
                              },
                              style: kAppElevatedButtonOutlineStyle(
                                context,
                                disabledColor: Theme.of(context).disabledColor,
                                bgColor: ThemeProvider.transparentColor,
                                foreColor: Theme.of(context).canvasColor,
                                borderColor: Theme.of(context).primaryColor,
                                height: 40.0,
                              ),
                              child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'reject'
                                  ? kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                  : Text(translate.reject, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: ElevatedButton(
                              onPressed: () {
                                if (model.instantOrder! == false) {
                                  showConfirmDialog(context, translate.alert_confirm_schedule_order_title, translate.alert_confirm_schedule_order_sub_title, translate.cancel_lbl, translate.alert_confirm_accept).then((value) {
                                    if (!context.mounted) return;
                                    if (value == true || value.toString() == 'true') {
                                      context.read<OrdersBloc>().add(OrdersAcceptNewOrderEvent(orderIndex: index, driverId: ''));
                                    }
                                  });
                                } else if (driverPickup == true && model.orderTo == 'homedelivery') {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return const SelectDriverModalScreen();
                                          },
                                          fullscreenDialog: true,
                                        ),
                                      )
                                      .then((value) {
                                        if (!context.mounted) return;
                                        if (value != null && value != '' && value.toString().isNotEmpty) {
                                          context.read<OrdersBloc>().add(OrdersAcceptNewOrderEvent(orderIndex: index, driverId: value.toString()));
                                        }
                                      });
                                } else {
                                  context.read<OrdersBloc>().add(OrdersAcceptNewOrderEvent(orderIndex: index, driverId: ''));
                                }
                              },
                              style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                              child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'accept'
                                  ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                  : Text(translate.accept_order, style: kAppLblTinyFontRegularLight(context)),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (model.instantOrder! == false) {
                              showConfirmDialog(context, translate.alert_confirm_schedule_order_title, translate.alert_confirm_schedule_order_sub_title, translate.cancel_lbl, translate.alert_confirm_accept).then((value) {
                                if (!context.mounted) return;
                                if (value == true || value.toString() == 'true') {
                                  context.read<OrdersBloc>().add(OrdersAcceptNewOrderEvent(orderIndex: index, driverId: ''));
                                }
                              });
                            } else if (driverPickup == true && model.orderTo == 'homedelivery') {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return const SelectDriverModalScreen();
                                      },
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((value) {
                                    if (!context.mounted) return;
                                    if (value != null && value != '' && value.toString().isNotEmpty) {
                                      context.read<OrdersBloc>().add(OrdersAcceptNewOrderEvent(orderIndex: index, driverId: value.toString()));
                                    }
                                  });
                            } else {
                              context.read<OrdersBloc>().add(OrdersAcceptNewOrderEvent(orderIndex: index, driverId: ''));
                            }
                          },
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                          child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'accept'
                              ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                              : Text(translate.accept_order, style: kAppLblTinyFontRegularLight(context)),
                        ),
                      ),
              ] else if (model.status! == 'accepted') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (driverPickup == true && model.orderTo == 'homedelivery') {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const SelectDriverModalScreen();
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              if (value != null && value != '' && value.toString().isNotEmpty) {
                                context.read<OrdersBloc>().add(OrdersAcceptScheduleOrderEvent(orderIndex: index, driverId: value.toString()));
                              }
                            });
                      } else {
                        context.read<OrdersBloc>().add(OrdersAcceptScheduleOrderEvent(orderIndex: index, driverId: ''));
                      }
                    },
                    style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                    child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'prepareSchedule'
                        ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                        : Text(translate.prepare_schedule_order, style: kAppLblTinyFontRegularLight(context)),
                  ),
                ),
              ] else if (model.status! == 'preparing') ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (model.driverInfo!.id!.isEmpty && model.driverInfo!.firstName!.isEmpty && model.orderTo == 'homedelivery') ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AssetsUrl.iconsURL.billDeliveryIcon, height: 20, width: 20, color: Theme.of(context).canvasColor),
                            kAppSpacerHorizontal(width: 5),
                            Text('$nearDriver ${translate.riders_nearby}', style: kAppLblSmallFontMedium(context)),
                          ],
                        ),
                      ),
                    ] else if (model.driverInfo!.id!.isNotEmpty && model.driverInfo!.firstName!.isNotEmpty && model.orderTo == 'homedelivery') ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(child: CacheNetworkImageWidget(width: 25.0, height: 25.0, imageUrl: model.driverInfo!.image!)),
                            kAppSpacerHorizontal(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${model.driverInfo!.firstName!} ${model.driverInfo!.lastName!} (${translate.deliveryman})', style: kAppLblMediumFontBold(context)),
                                Text(translate.deliveryman_waiting_for_ready_order, style: kAppLblTinyFontRegular(context)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ] else if (model.orderTo == 'selfpickup') ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(child: CacheNetworkImageWidget(width: 25.0, height: 25.0, imageUrl: model.userInfo!.image!)),
                            kAppSpacerHorizontal(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${model.userInfo!.firstName!} ${model.userInfo!.lastName!} (${translate.customer})', style: kAppLblMediumFontBold(context)),
                                Text(translate.customer_waiting_for_ready_order, style: kAppLblTinyFontRegular(context)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<OrdersBloc>().add(OrderReadyEvent(orderIndex: index)),
                    style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                    child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'readyOrder'
                        ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                        : Text(translate.order_ready, style: kAppLblTinyFontRegularLight(context)),
                  ),
                ),
              ] else if (model.status! == 'ready') ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (model.driverInfo!.id!.isEmpty && model.driverInfo!.firstName!.isEmpty && model.orderTo == 'homedelivery') ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return FindDriverForOrderScreen(orderId: model.id!);
                                      },
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((value) {
                                    if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {}
                                  });
                            },
                            style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                            child: Text(translate.find_deliveryman, style: kAppLblTinyFontRegularLight(context)),
                          ),
                        ),
                      ),
                    ] else if (model.driverInfo!.id!.isNotEmpty && model.driverInfo!.firstName!.isNotEmpty && model.orderTo == 'homedelivery') ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(child: CacheNetworkImageWidget(width: 25.0, height: 25.0, imageUrl: model.driverInfo!.image!)),
                            kAppSpacerHorizontal(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${model.driverInfo!.firstName!} ${model.driverInfo!.lastName!} (${translate.deliveryman})', style: kAppLblMediumFontBold(context)),
                                Text(translate.deliveryman_waiting_for_ready_order, style: kAppLblTinyFontRegular(context)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ] else if (model.orderTo == 'selfpickup') ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(child: CacheNetworkImageWidget(width: 25.0, height: 25.0, imageUrl: model.userInfo!.image!)),
                            kAppSpacerHorizontal(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${model.userInfo!.firstName!} ${model.userInfo!.lastName!} (${translate.customer})', style: kAppLblMediumFontBold(context)),
                                Text(translate.customer_waiting_for_ready_order, style: kAppLblTinyFontRegular(context)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                if (model.orderTo == 'homedelivery' && model.driverInfo!.id!.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (verifyOTP) {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return OrderVerificationModalScreen(
                                      orderId: model.id!,
                                      orderTo: model.orderTo!,
                                      customerOrderPin: model.customerOrderPin!,
                                      driverOrderPin: model.driverOrderPin!,
                                      paymentMode: model.paymentMode!,
                                      grandTotal: model.grandTotal!,
                                    );
                                  },
                                  fullscreenDialog: true,
                                ),
                              )
                              .then((value) {
                                if (!context.mounted) return;
                                if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                                  context.read<OrdersBloc>().add(OrderHandOverEvent(orderIndex: index));
                                }
                              });
                        } else if (model.paymentMode! == 'offline' && model.orderTo! == 'selfpickup') {
                          showConfirmDialog(context, '${translate.alert_collect_cash_title} - ${kAppPriceFormat(model.grandTotal!)}', translate.alert_collect_cash_sub_title, translate.cancel_lbl, translate.collect_cash_btn).then((
                            value,
                          ) {
                            if (!context.mounted) return;
                            if (value) {
                              context.read<OrdersBloc>().add(OrderHandOverEvent(orderIndex: index));
                            }
                          });
                        } else {
                          context.read<OrdersBloc>().add(OrderHandOverEvent(orderIndex: index));
                        }
                      },
                      style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                      child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'handoverOrder'
                          ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                          : Text(model.orderTo == 'homedelivery' ? translate.handover_to_deliveryman : translate.deliver_to_customer, style: kAppLblTinyFontRegularLight(context)),
                    ),
                  ),
                ] else if (model.orderTo == 'selfpickup') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (verifyOTP) {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return OrderVerificationModalScreen(
                                      orderId: model.id!,
                                      orderTo: model.orderTo!,
                                      customerOrderPin: model.customerOrderPin!,
                                      driverOrderPin: model.driverOrderPin!,
                                      paymentMode: model.paymentMode!,
                                      grandTotal: model.grandTotal!,
                                    );
                                  },
                                  fullscreenDialog: true,
                                ),
                              )
                              .then((value) {
                                if (!context.mounted) return;
                                if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                                  context.read<OrdersBloc>().add(OrderHandOverEvent(orderIndex: index));
                                }
                              });
                        } else if (model.paymentMode! == 'offline' && model.orderTo! == 'selfpickup') {
                          showConfirmDialog(context, '${translate.alert_collect_cash_title} - ${kAppPriceFormat(model.grandTotal!)}', translate.alert_collect_cash_sub_title, translate.cancel_lbl, translate.collect_cash_btn).then((
                            value,
                          ) {
                            if (!context.mounted) return;
                            if (value) {
                              context.read<OrdersBloc>().add(OrderHandOverEvent(orderIndex: index));
                            }
                          });
                        } else {
                          context.read<OrdersBloc>().add(OrderHandOverEvent(orderIndex: index));
                        }
                      },
                      style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                      child: status.isOrderChange && orderChangeId == model.id! && newOrderStatus == 'handoverOrder'
                          ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                          : Text(model.orderTo == 'homedelivery' ? translate.handover_to_deliveryman : translate.deliver_to_customer, style: kAppLblTinyFontRegularLight(context)),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class OrdersPreparationTimeTile extends StatelessWidget {
  final int index;
  final int preparationTime;
  const OrdersPreparationTimeTile({super.key, required this.index, required this.preparationTime});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translate.set_food_prepare_time, style: kAppLblTinyFontRegular(context)),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => context.read<OrdersBloc>().add(OrdersPreparationTimeChangeEvent(orderIndex: index, action: 'decrease')),
                  child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text('$preparationTime ${translate.mins}', textAlign: TextAlign.center, style: kAppLblMediumFontSemiBold(context)),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => context.read<OrdersBloc>().add(OrdersPreparationTimeChangeEvent(orderIndex: index, action: 'increase')),
                  child: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrdersLoadingView extends StatelessWidget {
  const OrdersLoadingView({super.key});

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

class OrdersEmptyView extends StatelessWidget {
  final String orderTitle;
  const OrdersEmptyView({super.key, required this.orderTitle});

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
            Text('${translate.no_order_found_one_title} $orderTitle ${translate.no_order_found_two_title}', textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class OrdersErrorView extends StatelessWidget {
  const OrdersErrorView({super.key});

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