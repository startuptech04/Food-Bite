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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/navigation_back_response_model.dart';
import 'package:vendor/app/presentation/pages/modals/cancellation_reasons/cancellation_reasons_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/find_driver_for_order/find_driver_for_order_view.dart';
import 'package:vendor/app/presentation/pages/modals/order_complaints_modal/order_complaints_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/order_help_modal/order_help_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/order_verification_modal/order_verification_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_driver/select_driver_modal_view.dart';
import 'package:vendor/app/presentation/pages/orders/order_detail/bloc/order_detail_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class OrderDetailScreen extends StatelessWidget {
  final String id;
  final int orderNo;
  const OrderDetailScreen({super.key, required this.id, required this.orderNo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailBloc()..add(OrderDetailInitialEvent(id: id, orderNo: orderNo)),
      child: const OrderDetailView(),
    );
  }
}

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isRejectOrderSuccess) {
          showSuccessDialog(context, translate.order_rejected).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isAcceptOrderSuccess) {
          showSuccessDialog(context, translate.order_accepted).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isReadyOrderSuccess) {
          showSuccessDialog(context, translate.order_ready).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isHandoverOrderSuccess) {
          showSuccessDialog(context, translate.order_handover).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isCallCustomer || state.status.isCallDeliveryman || state.status.isRejectOrder || state.status.isAcceptOrder || state.status.isReadyOrder || state.status.isHandoverOrder ? true : false,
          child: Scaffold(
            appBar: AppBar(
              title: Text(translate.order_detail),
              scrolledUnderElevation: 0,
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed(AppRouter.supportChatRoute, arguments: ['orders', state.orderId]),
                  label: Text(
                    translate.support,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'semibold'),
                  ),
                  icon: Icon(Icons.chat_outlined, color: Theme.of(context).primaryColor, size: 12),
                  iconAlignment: IconAlignment.start,
                ),
                IconButton(
                  onPressed: () {
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
                          child: OrderHelpModalScreen(orderId: state.orderId, orderNo: state.orderNo),
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
                                  return OrderComplaintsModalScreen(orderId: state.orderId);
                                },
                              ),
                            );
                          }
                        }
                      }
                    });
                  },
                  icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const OrderDetailLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const OrderDetailErrorView(),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(translate.order_number.toUpperCase(), style: kAppLblBoldFont(context)),
                        Text('${state.model.detail!.orderNo!}', style: kAppLblBoldFont(context)),
                      ],
                    ),
                    kAppSpacerVertical(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(translate.order_ref.toUpperCase(), style: kAppLblBoldFont(context)),
                        Text(state.model.detail!.id!.toUpperCase(), style: kAppLblBoldFont(context)),
                      ],
                    ),
                    kAppSpacerVertical(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(translate.payment.toUpperCase(), style: kAppLblBoldFont(context)),
                        Text('${state.model.detail!.paymentInfo!.name!} (${kAppPriceFormat(state.model.detail!.grandTotal!)})', style: kAppLblBoldFont(context)),
                      ],
                    ),
                    kAppSpacerVertical(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${translate.date} ${state.model.detail!.scheduleOrder! ? translate.schedule : ''}'.toUpperCase(), style: kAppLblBoldFont(context)),
                        Text(
                          '${state.model.detail!.scheduleOrder! ? state.model.detail!.scheduleDate! : state.model.detail!.createdAt!} ${translate.at} ${state.model.detail!.scheduleOrder! ? state.model.detail!.scheduleTime! : state.model.detail!.orderAt!}',
                          style: kAppLblBoldFont(context),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(translate.receiver.toUpperCase(), style: kAppLblBoldFont(context)),
                        Text(
                          state.model.detail!.orderTo! == 'homedelivery' ? '${state.model.detail!.receiverName!} (+${state.model.detail!.countryCode!} ${state.model.detail!.receiverContact})' : translate.self_pickup,
                          style: kAppLblBoldFont(context),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 10),
                    Text(translate.order_detail, style: kAppLblMediumFontBold(context)),
                    kAppSpacerVertical(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.model.detail!.cartItem!.length,
                        (cartIndex) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  kAppFoodType(state.model.detail!.cartItem![cartIndex].foodType!, height: 10, width: 10),
                                  kAppSpacerHorizontal(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('${state.model.detail!.cartItem![cartIndex].quantity!}', style: kAppLblMediumFontSemiBold(context)),
                                          Text(' X ', style: kAppLblMediumFontSemiBold(context)),
                                          Text(kAppTrimWord(state.model.detail!.cartItem![cartIndex].name!, 40), style: kAppLblMediumFontSemiBold(context)),
                                        ],
                                      ),
                                      Container(
                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                        child: Text(state.model.detail!.cartItem![cartIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                      ),
                                      state.model.detail!.cartItem![cartIndex].instruction!.isNotEmpty
                                          ? Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                              child: Text(
                                                '${translate.form_cooking_instructions}: ${state.model.detail!.cartItem![cartIndex].instruction!}',
                                                maxLines: 4,
                                                style: kAppLblTinyFontRegularChip(context, color: 'primary'),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                              Text(kAppPriceFormat(state.model.detail!.cartItem![cartIndex].totalPrice!), style: kAppLblMediumFontSemiBold(context)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    state.model.detail!.cookingInstruction!.isNotEmpty ? kAppSpacerVertical(height: 10) : const SizedBox(),
                    state.model.detail!.cookingInstruction!.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate.form_cooking_instructions.toUpperCase(), style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    state.model.detail!.cookingInstruction!,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: kAppLblTinyFontRegularChip(context, color: 'primary'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    kAppSpacerVertical(height: 10),
                    state.model.detail!.orderTo! == 'homedelivery' ? kAppSpacerVertical(height: 10) : const SizedBox(),
                    state.model.detail!.orderTo! == 'homedelivery'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate.deliver_to.toUpperCase(), style: kAppLblBoldFont(context)),
                              Text(
                                '${kAppAddressTitle(context, state.model.detail!.deliveryAddressRaw!.title!)} - ${state.model.detail!.deliveryAddressRaw!.flatHouse!}, ${state.model.detail!.deliveryAddressRaw!.locality!}, ${state.model.detail!.deliveryAddressRaw!.landmark!}',
                                style: kAppLblBoldFont(context),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    kAppSpacerVertical(height: 10),
                    Text(translate.order_charges, style: kAppLblMediumFontBold(context)),
                    kAppSpacerVertical(height: 10),
                    BillingInfoTile(name: translate.item_total, priceTag: '+', price: state.model.detail!.realTotal!),
                    BillingInfoTile(name: translate.item_discount, priceTag: '-', price: state.model.detail!.itemDiscount!),
                    BillingInfoTile(name: translate.sub_total, priceTag: '+', price: state.model.detail!.itemTotal!),
                    BillingInfoTile(name: translate.food_service_charge, priceTag: '+', price: state.model.detail!.foodServiceCharge!),
                    BillingInfoTile(name: translate.service_charge, priceTag: '+', price: state.model.detail!.serviceCharge!),
                    BillingInfoTile(name: translate.extra_service_charge, priceTag: '+', price: state.model.detail!.extraCharge!),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(translate.delivery_charge, style: kAppLblTinyFontRegularChip(context, color: 'regular')),
                          Text(state.model.detail!.deliveryCharge! > 0 ? '(+) ${state.model.detail!.deliveryCharge!}' : translate.free, style: kAppLblTinyFontBold(context)),
                        ],
                      ),
                    ),
                    BillingInfoTile(name: translate.delivery_partner_tip, priceTag: '+', price: state.model.detail!.deliveryTip!),
                    BillingInfoTile(name: translate.packaging_charge, priceTag: '+', price: state.model.detail!.packageCharge!),
                    BillingInfoTile(name: translate.packaging_charge_tax, priceTag: '+', price: state.model.detail!.packageChargeTax!),
                    BillingInfoTile(name: translate.coupon_discount, priceTag: '-', price: state.model.detail!.couponDiscountCharge!),
                    BillingInfoTile(name: translate.wallet_money, priceTag: '-', price: state.model.detail!.walletAmount!),
                    kAppSpacerVertical(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(translate.grand_total, style: kAppLblMediumFontMedium(context)),
                        Text(kAppPriceFormat(state.model.detail!.grandTotal!), style: kAppLblMediumFontBold(context)),
                      ],
                    ),
                    kAppSpacerVertical(height: 10),
                    Text(translate.customer_information, style: kAppLblMediumFontBold(context)),
                    kAppSpacerVertical(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40.0,
                                  width: 40.0,
                                  child: CircleAvatar(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CacheNetworkImageWidget(width: 40.0, height: 40.0, imageUrl: state.model.detail!.userInfo!.image!),
                                    ),
                                  ),
                                ),
                                kAppSpacerHorizontal(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${state.model.detail!.userInfo!.firstName!} ${state.model.detail!.userInfo!.lastName!}', style: kAppLblMediumFontBold(context)),
                                    Text('+${state.model.detail!.userInfo!.countryCode!} ${state.model.detail!.userInfo!.contactNumber!}', style: kAppLblTinyFontRegular(context)),
                                    Text(state.model.detail!.userInfo!.contactEmail!, style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          state.model.restaurantConfig!.canInitiateCall! || state.model.restaurantConfig!.canInitiateChat!
                              ? Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      state.model.restaurantConfig!.canInitiateCall!
                                          ? Expanded(
                                              child: GestureDetector(
                                                onTap: () => context.read<OrderDetailBloc>().add(OrderDetailCallCustomerEvent()),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: 30,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      state.status.isCallCustomer
                                                          ? SizedBox(height: 15.0, width: 15.0, child: CircularProgressIndicator(color: Theme.of(context).primaryColor, strokeWidth: 3))
                                                          : Icon(Icons.call, size: 10, color: Theme.of(context).canvasColor),
                                                      kAppSpacerHorizontal(width: 5),
                                                      Text(translate.call, style: kAppLblTinyFontRegular(context)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      state.model.restaurantConfig!.canInitiateChat!
                                          ? Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  final String id = state.model.detail!.userInfo!.id!;
                                                  final String name = '${state.model.detail!.userInfo!.firstName!} ${state.model.detail!.userInfo!.lastName!}';
                                                  Navigator.of(context).pushNamed(AppRouter.chatMessageRoute, arguments: [name, id]);
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).primaryColor,
                                                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5.0)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.chat_outlined, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                                      kAppSpacerHorizontal(width: 5),
                                                      Text(translate.message, style: kAppLblTinyRegularWhite(context)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    state.model.detail!.driverInfo!.id!.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kAppSpacerVertical(height: 10),
                              Text(translate.deliveryman_information, style: kAppLblMediumFontBold(context)),
                              kAppSpacerVertical(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 40.0,
                                            width: 40.0,
                                            child: CircleAvatar(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(50),
                                                child: CacheNetworkImageWidget(width: 40.0, height: 40.0, imageUrl: state.model.detail!.driverInfo!.image!),
                                              ),
                                            ),
                                          ),
                                          kAppSpacerHorizontal(width: 10),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${state.model.detail!.driverInfo!.firstName!} ${state.model.detail!.driverInfo!.lastName!}', style: kAppLblMediumFontBold(context)),
                                              Text('+${state.model.detail!.driverInfo!.countryCode!} ${state.model.detail!.driverInfo!.contactNumber!}', style: kAppLblTinyFontRegular(context)),
                                              Text(state.model.detail!.driverInfo!.contactEmail!, style: kAppLblTinyFontRegular(context)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    state.model.restaurantConfig!.canInitiateCall! || state.model.restaurantConfig!.canInitiateChat!
                                        ? Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                state.model.restaurantConfig!.canInitiateCall!
                                                    ? Expanded(
                                                        child: GestureDetector(
                                                          onTap: () => context.read<OrderDetailBloc>().add(OrderDetailCallDeliverymanEvent()),
                                                          child: SizedBox(
                                                            width: double.infinity,
                                                            height: 30,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                state.status.isCallDeliveryman
                                                                    ? SizedBox(height: 15.0, width: 15.0, child: CircularProgressIndicator(color: Theme.of(context).primaryColor, strokeWidth: 3))
                                                                    : Icon(Icons.call, size: 10, color: Theme.of(context).canvasColor),
                                                                kAppSpacerHorizontal(width: 5),
                                                                Text(translate.call, style: kAppLblTinyFontRegular(context)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                state.model.restaurantConfig!.canInitiateChat!
                                                    ? Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            final String id = state.model.detail!.driverInfo!.id!;
                                                            final String name = '${state.model.detail!.driverInfo!.firstName!} ${state.model.detail!.driverInfo!.lastName!}';
                                                            Navigator.of(context).pushNamed(AppRouter.chatMessageRoute, arguments: [name, id]);
                                                          },
                                                          child: Container(
                                                            width: double.infinity,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context).primaryColor,
                                                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5.0)),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.chat_outlined, size: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                                                kAppSpacerHorizontal(width: 5),
                                                                Text(translate.message, style: kAppLblTinyRegularWhite(context)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              kAppSpacerVertical(height: 20),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: SizedBox(
                      height: state.bottomHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.model.detail!.status! == 'created' && state.model.detail!.instantOrder!) ...[
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
                                            onTap: () => context.read<OrderDetailBloc>().add(OrderDetailPreparationTimeChangeEvent(action: 'decrease')),
                                            child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text('${state.model.detail!.preparationTime!} ${translate.mins}', textAlign: TextAlign.center, style: kAppLblMediumFontSemiBold(context)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => context.read<OrderDetailBloc>().add(OrderDetailPreparationTimeChangeEvent(action: 'increase')),
                                            child: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else if (state.model.detail!.status! == 'accepted' && state.model.detail!.scheduleOrder!) ...[
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
                                            onTap: () => context.read<OrderDetailBloc>().add(OrderDetailPreparationTimeChangeEvent(action: 'decrease')),
                                            child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text('${state.model.detail!.preparationTime!} ${translate.mins}', textAlign: TextAlign.center, style: kAppLblMediumFontSemiBold(context)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => context.read<OrderDetailBloc>().add(OrderDetailPreparationTimeChangeEvent(action: 'increase')),
                                            child: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  kAppSpacerVertical(height: 10),
                                ],
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.model.detail!.status! == 'created') ...[
                                  state.model.orderSettings!.restaurantCanCancelOrder!
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
                                                      context.read<OrderDetailBloc>().add(OrderDetailRejectOrderEvent(reasonId: value.toString()));
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
                                                child: state.status.isRejectOrder
                                                    ? kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                                    : Text(translate.reject, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.8,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (state.model.detail!.instantOrder! == false) {
                                                    showConfirmDialog(
                                                      context,
                                                      translate.alert_confirm_schedule_order_title,
                                                      translate.alert_confirm_schedule_order_sub_title,
                                                      translate.cancel_lbl,
                                                      translate.alert_confirm_accept,
                                                    ).then((value) {
                                                      if (!context.mounted) return;
                                                      if (value == true || value.toString() == 'true') {
                                                        context.read<OrderDetailBloc>().add(OrderDetailAcceptOrderEvent(driverId: ''));
                                                      }
                                                    });
                                                  } else if (state.model.restaurantConfig!.driverPickup! == true && state.model.detail!.orderTo! == 'homedelivery') {
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
                                                            context.read<OrderDetailBloc>().add(OrderDetailAcceptOrderEvent(driverId: value.toString()));
                                                          }
                                                        });
                                                  } else {
                                                    context.read<OrderDetailBloc>().add(OrderDetailAcceptOrderEvent(driverId: ''));
                                                  }
                                                },
                                                style: kAppElevatedButtonStyle(
                                                  context,
                                                  disabledColor: Theme.of(context).disabledColor,
                                                  bgColor: Theme.of(context).primaryColor,
                                                  foreColor: Theme.of(context).scaffoldBackgroundColor,
                                                  height: 40.0,
                                                ),
                                                child: state.status.isAcceptOrder
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
                                              if (state.model.detail!.instantOrder! == false) {
                                                showConfirmDialog(context, translate.alert_confirm_schedule_order_title, translate.alert_confirm_schedule_order_sub_title, translate.cancel_lbl, translate.alert_confirm_accept).then(
                                                  (value) {
                                                    if (!context.mounted) return;
                                                    if (value == true || value.toString() == 'true') {
                                                      context.read<OrderDetailBloc>().add(OrderDetailAcceptOrderEvent(driverId: ''));
                                                    }
                                                  },
                                                );
                                              } else if (state.model.restaurantConfig!.driverPickup! == true && state.model.detail!.orderTo! == 'homedelivery') {
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
                                                        context.read<OrderDetailBloc>().add(OrderDetailAcceptOrderEvent(driverId: value.toString()));
                                                      }
                                                    });
                                              } else {
                                                context.read<OrderDetailBloc>().add(OrderDetailAcceptOrderEvent(driverId: ''));
                                              }
                                            },
                                            style: kAppElevatedButtonStyle(
                                              context,
                                              disabledColor: Theme.of(context).disabledColor,
                                              bgColor: Theme.of(context).primaryColor,
                                              foreColor: Theme.of(context).scaffoldBackgroundColor,
                                              height: 40.0,
                                            ),
                                            child: state.status.isAcceptOrder
                                                ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                                : Text(translate.accept_order, style: kAppLblTinyFontRegularLight(context)),
                                          ),
                                        ),
                                ] else if (state.model.detail!.status! == 'accepted') ...[
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (state.model.restaurantConfig!.driverPickup! == true && state.model.detail!.orderTo == 'homedelivery') {
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
                                                  context.read<OrderDetailBloc>().add(OrderDetailAcceptScheduleOrderEvent(driverId: value.toString()));
                                                }
                                              });
                                        } else {
                                          context.read<OrderDetailBloc>().add(OrderDetailAcceptScheduleOrderEvent(driverId: ''));
                                        }
                                      },
                                      style: kAppElevatedButtonStyle(
                                        context,
                                        disabledColor: Theme.of(context).disabledColor,
                                        bgColor: Theme.of(context).primaryColor,
                                        foreColor: Theme.of(context).scaffoldBackgroundColor,
                                        height: 40.0,
                                      ),
                                      child: state.status.isAcceptOrder
                                          ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                          : Text(translate.prepare_schedule_order, style: kAppLblTinyFontRegularLight(context)),
                                    ),
                                  ),
                                ] else if (state.model.detail!.status! == 'preparing') ...[
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => context.read<OrderDetailBloc>().add(OrderDetailReadyEvent()),
                                      style: kAppElevatedButtonStyle(
                                        context,
                                        disabledColor: Theme.of(context).disabledColor,
                                        bgColor: Theme.of(context).primaryColor,
                                        foreColor: Theme.of(context).scaffoldBackgroundColor,
                                        height: 40.0,
                                      ),
                                      child: state.status.isReadyOrder
                                          ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                          : Text(translate.order_ready, style: kAppLblTinyFontRegularLight(context)),
                                    ),
                                  ),
                                ] else if (state.model.detail!.status! == 'ready') ...[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (state.model.detail!.driverInfo!.id!.isEmpty && state.model.detail!.driverInfo!.firstName!.isEmpty && state.model.detail!.orderTo == 'homedelivery') ...[
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
                                                          return FindDriverForOrderScreen(orderId: state.orderId);
                                                        },
                                                        fullscreenDialog: true,
                                                      ),
                                                    )
                                                    .then((value) {
                                                      if (!context.mounted) return;
                                                      if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                                                        Navigator.of(context).pop();
                                                      }
                                                    });
                                              },
                                              style: kAppElevatedButtonStyle(
                                                context,
                                                disabledColor: Theme.of(context).disabledColor,
                                                bgColor: Theme.of(context).primaryColor,
                                                foreColor: Theme.of(context).scaffoldBackgroundColor,
                                                height: 40.0,
                                              ),
                                              child: Text(translate.find_deliveryman, style: kAppLblTinyFontRegularLight(context)),
                                            ),
                                          ),
                                        ),
                                      ] else if (state.model.detail!.driverInfo!.id!.isNotEmpty && state.model.detail!.driverInfo!.firstName!.isNotEmpty && state.model.detail!.orderTo == 'homedelivery') ...[
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
                                              ClipOval(child: CacheNetworkImageWidget(width: 25.0, height: 25.0, imageUrl: state.model.detail!.driverInfo!.image!)),
                                              kAppSpacerHorizontal(width: 5),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${state.model.detail!.driverInfo!.firstName!} ${state.model.detail!.driverInfo!.lastName!} (${translate.deliveryman})', style: kAppLblMediumFontBold(context)),
                                                  Text(translate.deliveryman_waiting_for_ready_order, style: kAppLblTinyFontRegular(context)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else if (state.model.detail!.orderTo == 'selfpickup') ...[
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
                                              ClipOval(child: CacheNetworkImageWidget(width: 25.0, height: 25.0, imageUrl: state.model.detail!.userInfo!.image!)),
                                              kAppSpacerHorizontal(width: 5),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${state.model.detail!.userInfo!.firstName!} ${state.model.detail!.userInfo!.lastName!} (${translate.customer})', style: kAppLblMediumFontBold(context)),
                                                  Text(translate.customer_waiting_for_ready_order, style: kAppLblTinyFontRegular(context)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (state.model.detail!.orderTo! == 'homedelivery' && state.model.detail!.driverInfo!.id!.isNotEmpty) ...[
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (state.model.orderSettings!.deliveryVerification!) {
                                            Navigator.of(context)
                                                .push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) {
                                                      return OrderVerificationModalScreen(
                                                        orderId: state.orderId,
                                                        orderTo: state.model.detail!.orderTo!,
                                                        customerOrderPin: state.model.detail!.customerOrderPin!,
                                                        driverOrderPin: state.model.detail!.driverOrderPin!,
                                                        paymentMode: state.model.detail!.paymentInfo!.paymentWay!,
                                                        grandTotal: state.model.detail!.grandTotal!,
                                                      );
                                                    },
                                                    fullscreenDialog: true,
                                                  ),
                                                )
                                                .then((value) {
                                                  if (!context.mounted) return;
                                                  if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                                                    context.read<OrderDetailBloc>().add(OrderDetailHandoverOrderEvent());
                                                  }
                                                });
                                          } else if (state.model.detail!.paymentInfo!.paymentWay! == 'offline' && state.model.detail!.orderTo! == 'selfpickup') {
                                            showConfirmDialog(
                                              context,
                                              '${translate.alert_collect_cash_title} - ${kAppPriceFormat(state.model.detail!.grandTotal!)}',
                                              translate.alert_collect_cash_sub_title,
                                              translate.cancel_lbl,
                                              translate.collect_cash_btn,
                                            ).then((value) {
                                              if (!context.mounted) return;
                                              if (value) {
                                                context.read<OrderDetailBloc>().add(OrderDetailHandoverOrderEvent());
                                              }
                                            });
                                          } else {
                                            context.read<OrderDetailBloc>().add(OrderDetailHandoverOrderEvent());
                                          }
                                        },
                                        style: kAppElevatedButtonStyle(
                                          context,
                                          disabledColor: Theme.of(context).disabledColor,
                                          bgColor: Theme.of(context).primaryColor,
                                          foreColor: Theme.of(context).scaffoldBackgroundColor,
                                          height: 40.0,
                                        ),
                                        child: state.status.isHandoverOrder
                                            ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                            : Text(state.model.detail!.orderTo == 'homedelivery' ? translate.handover_to_deliveryman : translate.deliver_to_customer, style: kAppLblTinyFontRegularLight(context)),
                                      ),
                                    ),
                                  ] else if (state.model.detail!.orderTo! == 'selfpickup') ...[
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (state.model.orderSettings!.deliveryVerification!) {
                                            Navigator.of(context)
                                                .push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) {
                                                      return OrderVerificationModalScreen(
                                                        orderId: state.orderId,
                                                        orderTo: state.model.detail!.orderTo!,
                                                        customerOrderPin: state.model.detail!.customerOrderPin!,
                                                        driverOrderPin: state.model.detail!.driverOrderPin!,
                                                        paymentMode: state.model.detail!.paymentInfo!.paymentWay!,
                                                        grandTotal: state.model.detail!.grandTotal!,
                                                      );
                                                    },
                                                    fullscreenDialog: true,
                                                  ),
                                                )
                                                .then((value) {
                                                  if (!context.mounted) return;
                                                  if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                                                    context.read<OrderDetailBloc>().add(OrderDetailHandoverOrderEvent());
                                                  }
                                                });
                                          } else if (state.model.detail!.paymentInfo!.paymentWay! == 'offline' && state.model.detail!.orderTo! == 'selfpickup') {
                                            showConfirmDialog(
                                              context,
                                              '${translate.alert_collect_cash_title} - ${kAppPriceFormat(state.model.detail!.grandTotal!)}',
                                              translate.alert_collect_cash_sub_title,
                                              translate.cancel_lbl,
                                              translate.collect_cash_btn,
                                            ).then((value) {
                                              if (!context.mounted) return;
                                              if (value) {
                                                context.read<OrderDetailBloc>().add(OrderDetailHandoverOrderEvent());
                                              }
                                            });
                                          } else {
                                            context.read<OrderDetailBloc>().add(OrderDetailHandoverOrderEvent());
                                          }
                                        },
                                        style: kAppElevatedButtonStyle(
                                          context,
                                          disabledColor: Theme.of(context).disabledColor,
                                          bgColor: Theme.of(context).primaryColor,
                                          foreColor: Theme.of(context).scaffoldBackgroundColor,
                                          height: 40.0,
                                        ),
                                        child: state.status.isHandoverOrder
                                            ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                            : Text(state.model.detail!.orderTo == 'homedelivery' ? translate.handover_to_deliveryman : translate.deliver_to_customer, style: kAppLblTinyFontRegularLight(context)),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class OrderDetailLoadingView extends StatelessWidget {
  const OrderDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 5),
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 50, width: double.infinity, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(width: 80, height: 30, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                              const SizedBox(width: 10),
                              SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SkeletonAvatar(style: SkeletonAvatarStyle(width: 80, height: 80, borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class OrderDetailErrorView extends StatelessWidget {
  const OrderDetailErrorView({super.key});

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

class BillingInfoTile extends StatelessWidget {
  final String name;
  final String priceTag;
  final double price;
  const BillingInfoTile({super.key, required this.name, required this.priceTag, required this.price});

  @override
  Widget build(BuildContext context) {
    return price > 0
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(name, style: kAppLblTinyFontRegularChip(context, color: 'regular')),
                Text('($priceTag) ${kAppPriceFormat(price)}', style: kAppLblTinyFontBold(context)),
              ],
            ),
          )
        : const SizedBox();
  }
}
// DONE //