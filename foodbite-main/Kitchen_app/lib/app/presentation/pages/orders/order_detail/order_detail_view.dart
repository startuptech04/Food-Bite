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
import 'package:kitchen/app/presentation/pages/orders/order_detail/bloc/order_detail_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/error_dialog.dart';
import 'package:kitchen/app/presentation/styles/success_dialog.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

class OrderDetailScreen extends StatelessWidget {
  final String id;
  const OrderDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailBloc()..add(OrderDetailInitialEvent(id: id)),
      child: OrderDetailView(id: id),
    );
  }
}

class OrderDetailView extends StatelessWidget {
  final String id;
  const OrderDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isAcceptOrderSuccess) {
          showSuccessDialog(context, translate.order_preparing).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isCompleteOrderSuccess) {
          showSuccessDialog(context, translate.order_completed).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isAcceptOrder || state.status.isCompleteOrder ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.order_detail), scrolledUnderElevation: 0),
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
                        if (state.model.detail!.orderFrom! == 'regular_order') ...[
                          Text(translate.regular_order_no.toUpperCase(), style: kAppLblBoldFont(context)),
                          Text("${state.model.detail!.regularOrderInfo!.orderNo!}", style: kAppLblBoldFont(context)),
                        ] else if (state.model.detail!.orderFrom! == 'pos_order') ...[
                          Text(translate.pos_order_no.toUpperCase(), style: kAppLblBoldFont(context)),
                          Text("${state.model.detail!.posOrderInfo!.orderNo!}", style: kAppLblBoldFont(context)),
                        ] else if (state.model.detail!.orderFrom! == 'table_order') ...[
                          Text("${translate.table_order}: ${translate.table_no}".toUpperCase(), style: kAppLblBoldFont(context)),
                          Text("${state.model.detail!.tableOrder!.tableNumber!}", style: kAppLblBoldFont(context)),
                        ],
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
                        Text(translate.date.toUpperCase(), style: kAppLblBoldFont(context)),
                        Text(state.model.detail!.createdAt!, style: kAppLblBoldFont(context)),
                      ],
                    ),
                    kAppSpacerVertical(height: 10),
                    Text(translate.order_details, style: kAppLblMediumFontBold(context)),
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
                                          Text("${state.model.detail!.cartItem![cartIndex].quantity!}", style: kAppLblMediumFontSemiBold(context)),
                                          Text(" X ", style: kAppLblMediumFontSemiBold(context)),
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
                                              child: Text("${translate.cooking_instruction} : ${state.model.detail!.cartItem![cartIndex].instruction!}", maxLines: 4, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
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
                                Text(translate.cooking_instruction.toUpperCase(), style: kAppLblTinyFontRegularChip(context, color: 'primary')),
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
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: SizedBox(
                      height: state.model.detail!.status! == 'new' || state.model.detail!.status! == 'preparing' ? 60 : 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (state.model.detail!.status! == 'new') ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.read<OrderDetailBloc>().add(OrderDetailPrepareOrderEvent()),
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 40.0,
                                  ),
                                  child: state.status.isAcceptOrder
                                      ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                      : Text(translate.prepare_order, style: kAppLblTinyFontRegularLight(context)),
                                ),
                              ),
                            ] else if (state.model.detail!.status! == 'preparing') ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.read<OrderDetailBloc>().add(OrderDetailCompleteOrderEvent()),
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 40.0,
                                  ),
                                  child: state.status.isCompleteOrder
                                      ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                      : Text(translate.complete_order, style: kAppLblTinyFontRegularLight(context)),
                                ),
                              ),
                            ],
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
          Text(translate.server_bug_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //