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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/config/global_settings.dart';
import 'package:vendor/app/core/models/expense_model.dart';
import 'package:vendor/app/presentation/pages/account/expense_reports/bloc/expense_report_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/add_expense_modal/add_expense_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class ExpenseReportScreen extends StatelessWidget {
  const ExpenseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ExpenseReportBloc()..add(ExpenseReportInitialEvent()), child: const ExpenseReportView());
  }
}

class ExpenseReportView extends StatefulWidget {
  const ExpenseReportView({super.key});

  @override
  State<ExpenseReportView> createState() => _ExpenseReportViewState();
}

class _ExpenseReportViewState extends State<ExpenseReportView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<ExpenseReportBloc>().add(ExpenseReportLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<ExpenseReportBloc, ExpenseReportState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate.expense_report),
            scrolledUnderElevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (BuildContext context) {
                      return const FractionallySizedBox(heightFactor: 0.65, child: AddExpenseModalScreen());
                    },
                  ).then((value) {
                    if (!context.mounted) return;
                    if (value != null && value.toString().isNotEmpty && value.toString() == 'true') {
                      context.read<ExpenseReportBloc>().add(ExpenseReportInitialEvent());
                    }
                  });
                },
                child: Text(translate.add_expense, style: kAppLblTinyFontBold(context)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const ExpenseReportLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const ExpenseReportErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const ExpenseReportEmptyView(),
                ] else ...[
                  state.gridExpense.isNotEmpty
                      ? SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: ScrollConfiguration(
                            behavior: GridScrollBehavior(),
                            child: GridView(
                              scrollDirection: Axis.horizontal,
                              physics: const PageScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 2.0, crossAxisSpacing: 2.0, crossAxisCount: 2, childAspectRatio: 1, mainAxisExtent: MediaQuery.of(context).size.width / 3),
                              children: state.gridExpense.map((e) => ExpenseReportGridTile(model: e)).toList(),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  SfCircularChart(
                    title: ChartTitle(text: '', textStyle: kAppLblTinyFontBold(context)),
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, textStyle: kAppLblTinyFontBold(context)),
                    series: <PieSeries<PieChartModel, String>>[
                      PieSeries<PieChartModel, String>(
                        dataSource: state.chartStats,
                        xValueMapper: (PieChartModel data, _) => kAppExpenseKey(context, data.name!),
                        yValueMapper: (PieChartModel data, _) => data.amount,
                        dataLabelMapper: (PieChartModel data, _) =>
                            GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}${data.amount.toString()}' : '${data.amount.toString()}${GlobalSettings.globalCurrencySymbol}',
                        dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontFamily: 'bold')),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 5),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                    ),
                    child: DropdownButton<ExpenseFilterModel>(
                      underline: const SizedBox(),
                      isExpanded: true,
                      value: state.filterType,
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      style: kAppLblMediumFontRegular(context),
                      items: state.filterList.map((ExpenseFilterModel item) {
                        return DropdownMenuItem<ExpenseFilterModel>(value: item, child: Text(kAppExpenseKey(context, item.name.toString())));
                      }).toList(),
                      onChanged: (newValue) {
                        context.read<ExpenseReportBloc>().add(ExpenseReportTypeChangeEvent(type: newValue!.value!));
                      },
                    ),
                  ),
                  kAppSpacerVertical(height: 20),
                  state.isFilterApplied == true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(state.expenseList.length, (index) => ExpenseReportExpenseTile(model: state.expenseList[index])),
                        )
                      : Container(margin: const EdgeInsets.symmetric(vertical: 20), child: kAppCenterCircularProgress(context)),
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

class ExpenseReportExpenseTile extends StatelessWidget {
  final ExpenseModel model;
  const ExpenseReportExpenseTile({super.key, required this.model});

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${translate.id} : ${model.id!.toUpperCase()}", style: kAppLblTinyFontRegular(context)),
              Text(model.createdAt!, style: kAppLblTinyFontRegular(context)),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.customer, style: kAppLblTinyFontRegular(context)),
                Text(model.userInfo!.id!.isNotEmpty ? '${model.userInfo!.firstName!} ${model.userInfo!.lastName!}' : translate.unknown, style: kAppLblTinyFontRegular(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.expense_type, style: kAppLblTinyFontRegular(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (model.expenseType! == 'order_product_discout') ...[
                      Text(translate.expense_order_product, style: kAppLblTinyFontRegular(context)),
                    ] else if (model.expenseType! == 'pos_order_product_discount') ...[
                      Text(translate.expense_pos_order_product, style: kAppLblTinyFontRegular(context)),
                    ] else if (model.expenseType! == 'table_order_product_discount') ...[
                      Text(translate.expense_table_order_product, style: kAppLblTinyFontRegular(context)),
                    ] else if (model.expenseType! == 'pos_order_extra_discount') ...[
                      Text(translate.expense_pos_order_extra, style: kAppLblTinyFontRegular(context)),
                    ] else if (model.expenseType! == 'table_order_extra_discount') ...[
                      Text(translate.expense_table_order_extra, style: kAppLblTinyFontRegular(context)),
                    ] else if (model.expenseType! == 'coupon') ...[
                      Text(translate.coupon, style: kAppLblTinyFontRegular(context)),
                    ] else if (model.expenseType! == 'dining_coupon') ...[
                      Text(translate.dining_coupon, style: kAppLblTinyFontRegular(context)),
                    ] else if (model.expenseType! == 'dining_booking_discount') ...[
                      Text(translate.expense_dining_booking, style: kAppLblTinyFontRegular(context)),
                    ] else if (model.expenseType! == 'refund_order') ...[
                      Text(translate.expense_order_refund, style: kAppLblTinyFontRegular(context)),
                    ] else ...[
                      Text(translate.others, style: kAppLblTinyFontRegular(context)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.order, style: kAppLblTinyFontRegular(context)),
                Text(model.orderInfo!.id!.isNotEmpty ? '#${model.orderInfo!.orderNo!}' : translate.unknown, style: kAppLblTinyFontRegular(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.pos_order, style: kAppLblTinyFontRegular(context)),
                Text(model.posOrderInfo!.id!.isNotEmpty ? '#${model.posOrderInfo!.orderNo!}' : translate.unknown, style: kAppLblTinyFontRegular(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.table_order, style: kAppLblTinyFontRegular(context)),
                Text(model.tableOrderInfo!.id!.isNotEmpty ? '#${model.tableOrderInfo!.orderNo!}' : translate.unknown, style: kAppLblTinyFontRegular(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.dining_booking, style: kAppLblTinyFontRegular(context)),
                Text(model.bookingInfo!.id!.isNotEmpty ? '#${model.bookingInfo!.id!.toUpperCase()}' : translate.unknown, style: kAppLblTinyFontRegular(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.coupon, style: kAppLblTinyFontRegular(context)),
                Text(model.couponInfo!.id!.isNotEmpty ? '#${model.couponInfo!.id!.toUpperCase()}' : translate.unknown, style: kAppLblTinyFontRegular(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.dining_coupon, style: kAppLblTinyFontRegular(context)),
                Text(model.diningCouponInfo!.id!.isNotEmpty ? '#${model.diningCouponInfo!.id!.toUpperCase()}' : translate.unknown, style: kAppLblTinyFontRegular(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(translate.total_expense, style: kAppLblTinyFontRegular(context)),
                Text(kAppPriceFormat(model.amount!), style: kAppLblTinyFontBold(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseReportGridTile extends StatelessWidget {
  final GridExpenseModel model;
  const ExpenseReportGridTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(kAppExpenseKey(context, model.name!), style: kAppLblTinyFontRegular(context)),
        kAppSpacerVertical(height: 5),
        Text(kAppPriceFormat(model.amount!), style: kAppLblTinyFontBold(context)),
        kAppSpacerVertical(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${translate.items} :", style: kAppLblTinyFontRegular(context)),
            kAppSpacerHorizontal(width: 5),
            Text("${model.count!}", style: kAppLblTinyFontRegular(context)),
          ],
        ),
      ],
    );
  }
}

class ExpenseReportLoadingView extends StatelessWidget {
  const ExpenseReportLoadingView({super.key});

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

class ExpenseReportErrorView extends StatelessWidget {
  const ExpenseReportErrorView({super.key});

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

class ExpenseReportEmptyView extends StatelessWidget {
  const ExpenseReportEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_expense_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_expense_found_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class GridScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
// DONE //