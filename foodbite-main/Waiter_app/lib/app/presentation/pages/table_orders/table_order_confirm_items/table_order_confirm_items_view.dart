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
import 'package:waiter/app/core/config/assets_url.dart';
import 'package:waiter/app/presentation/pages/table_orders/table_order_confirm_items/bloc/table_order_confirm_item_bloc.dart';
import 'package:waiter/app/presentation/styles/app_style.dart';
import 'package:waiter/app/presentation/styles/error_dialog.dart';
import 'package:waiter/app/presentation/styles/theme.dart';
import 'package:waiter/gen/l10n/app_localizations.dart';

class TableOrderConfirmItemScreen extends StatelessWidget {
  final int tableNumber;
  final String tableId;
  const TableOrderConfirmItemScreen({super.key, required this.tableNumber, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return TableOrderConfirmItemView(tableNumber: tableNumber, tableId: tableId);
  }
}

class TableOrderConfirmItemView extends StatefulWidget {
  final int tableNumber;
  final String tableId;
  const TableOrderConfirmItemView({super.key, required this.tableNumber, required this.tableId});

  @override
  State<TableOrderConfirmItemView> createState() => _TableOrderConfirmItemViewState();
}

class _TableOrderConfirmItemViewState extends State<TableOrderConfirmItemView> {
  @override
  void initState() {
    super.initState();
    context.read<TableOrderConfirmItemBloc>().add(TableOrderConfirmItemInitialEvent(tableNumber: widget.tableNumber, tableId: widget.tableId));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<TableOrderConfirmItemBloc, TableOrderConfirmItemState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCartError || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isEmpty) {
          Navigator.of(context).maybePop();
        } else if (state.status.isOrderPlaced) {
          Navigator.of(context).maybePop();
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isPlacingOrder ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.confirm_order_items), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const TableOrderConfirmItemLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const TableOrderConfirmItemErrorView(),
                  ] else if (state.status.isEmpty) ...[
                    const TableOrderConfirmItemEmptyView(),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.model.items!.isNotEmpty ? Text(translate.current_table_order_items, style: kAppLblMediumFontBold(context)) : const SizedBox(),
                        state.model.items!.isNotEmpty ? kAppSpacerVertical(height: 10) : const SizedBox(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            state.model.items!.length,
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
                                      kAppFoodType(state.model.items![cartIndex].foodInfo!.foodType!, height: 10, width: 10),
                                      kAppSpacerHorizontal(width: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("${state.model.items![cartIndex].quantity!}", style: kAppLblMediumFontSemiBold(context)),
                                              Text(" X ", style: kAppLblMediumFontSemiBold(context)),
                                              Text(kAppTrimWord(state.model.items![cartIndex].foodInfo!.name!, 40), style: kAppLblMediumFontSemiBold(context)),
                                            ],
                                          ),
                                          Container(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                            child: Text(state.model.items![cartIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                          ),
                                          state.model.items![cartIndex].instruction!.isNotEmpty
                                              ? Container(
                                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                                  child: Text("${translate.form_cooking_instruction} : ${state.model.items![cartIndex].instruction!}", maxLines: 4, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(kAppPriceFormat(state.model.items![cartIndex].itemPrice!), style: kAppLblMediumFontSemiBold(context)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        state.model.items!.isNotEmpty ? kAppSpacerVertical(height: 10) : const SizedBox(),
                        Text(translate.new_table_order_items, style: kAppLblMediumFontBold(context)),
                        kAppSpacerVertical(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  state.inCart.length,
                                  (foodIndex) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(kAppTrimWord(state.inCart[foodIndex].name!, 50), style: kAppLblMediumFontBold(context)),
                                              kAppSpacerVertical(height: 5),
                                              state.inCart[foodIndex].discount! <= 0
                                                  ? Text(kAppPriceFormat(state.inCart[foodIndex].price!), style: kAppLblTinyMediumFontSemi(context))
                                                  : Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(kAppPriceFormat(state.inCart[foodIndex].price!), style: kAppLblTinyStrokeFontRegular(context)),
                                                        kAppSpacerHorizontal(width: 5),
                                                        Text(kAppPriceFormat(state.inCart[foodIndex].offerPrice!), style: kAppLblTinyMediumFontSemi(context)),
                                                      ],
                                                    ),
                                              kAppSpacerVertical(height: 5),
                                              state.inCart[foodIndex].optionName!.isNotEmpty
                                                  ? Container(
                                                      padding: const EdgeInsets.only(right: 5),
                                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.8, minWidth: MediaQuery.of(context).size.width / 2.5),
                                                      child: Text(state.inCart[foodIndex].optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                                                    )
                                                  : const SizedBox(),
                                              state.inCart[foodIndex].instruction!.isNotEmpty
                                                  ? Container(
                                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: MediaQuery.of(context).size.width / 2.5),
                                                      child: Text("${translate.form_cooking_instruction} : ${state.inCart[foodIndex].instruction!}", maxLines: 4, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).scaffoldBackgroundColor,
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    InkWell(
                                                      onTap: () =>
                                                          context.read<TableOrderConfirmItemBloc>().add(TableOrderConfirmItemQuantityEvent(id: state.inCart[foodIndex].id!, uuid: state.inCart[foodIndex].uuid!, action: 'decrease')),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 15, left: 5),
                                                        child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                                                      ),
                                                    ),
                                                    Text("${state.inCart[foodIndex].quantity!}", style: kAppLblSmallFontBold(context, color: 'primary')),
                                                    InkWell(
                                                      onTap: () =>
                                                          context.read<TableOrderConfirmItemBloc>().add(TableOrderConfirmItemQuantityEvent(id: state.inCart[foodIndex].id!, uuid: state.inCart[foodIndex].uuid!, action: 'increase')),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15, right: 5),
                                                        child: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              kAppSpacerVertical(height: 5),
                                              Text(kAppPriceFormat(state.inCart[foodIndex].totalPrice!), style: kAppLblTinyMediumFontSemi(context)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: ThemeProvider.scaffoldPadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.read<TableOrderConfirmItemBloc>().add(TableOrderConfirmItemSubmitEvent()),
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isPlacingOrder ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.place_order),
                                ),
                              ),
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

class TableOrderConfirmItemLoadingView extends StatelessWidget {
  const TableOrderConfirmItemLoadingView({super.key});

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
            children: List.generate(2, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                ),
                child: Column(
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 5),
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 5),
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
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
              );
            }),
          ),
        ),
      ],
    );
  }
}

class TableOrderConfirmItemErrorView extends StatelessWidget {
  const TableOrderConfirmItemErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_food_found_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class TableOrderConfirmItemEmptyView extends StatelessWidget {
  const TableOrderConfirmItemEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_food_found_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //