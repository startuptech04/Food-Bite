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
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/config/global_settings.dart';
import 'package:vendor/app/core/models/custom_table_order_date_business_insight_model.dart';
import 'package:vendor/app/presentation/pages/business/custom_date_insight/custom_table_order_date_insight/bloc/custom_table_order_date_insight_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class CustomTableOrderDateInsightScreen extends StatelessWidget {
  const CustomTableOrderDateInsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CustomTableOrderDateInsightBloc()..add(CustomTableOrderDateInsightInitialEvent()), child: const CustomTableOrderDateInsightView());
  }
}

class CustomTableOrderDateInsightView extends StatefulWidget {
  const CustomTableOrderDateInsightView({super.key});

  @override
  State<CustomTableOrderDateInsightView> createState() => _CustomTableOrderDateInsightViewState();
}

class _CustomTableOrderDateInsightViewState extends State<CustomTableOrderDateInsightView> {
  TooltipBehavior? _tooltipBehavior;
  final _startDateFocusNode = FocusNode();
  final _endDateFocusNode = FocusNode();

  final TextEditingController _statStartTimeController = TextEditingController();
  final TextEditingController _statEndTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: false);

    _startDateFocusNode.addListener(() {
      if (!_startDateFocusNode.hasFocus) {
        context.read<CustomTableOrderDateInsightBloc>().add(CustomTableOrderDateInsightStartDateUnfocusedEvent());
      }
    });

    _endDateFocusNode.addListener(() {
      if (!_endDateFocusNode.hasFocus) {
        context.read<CustomTableOrderDateInsightBloc>().add(CustomTableOrderDateInsightEndDateUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _startDateFocusNode.dispose();
    _endDateFocusNode.dispose();

    _statStartTimeController.dispose();
    _statEndTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((CustomTableOrderDateInsightBloc bloc) => bloc.state.isValid);
    return BlocConsumer<CustomTableOrderDateInsightBloc, CustomTableOrderDateInsightState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isLoading ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.table_order_insight), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    showCursor: false,
                    focusNode: _startDateFocusNode,
                    controller: _statStartTimeController,
                    decoration: kAppInputDecoration(
                      context,
                      lblText: translate.form_start_date,
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                      errText: state.startDate.displayError != null ? translate.form_required : null,
                    ),
                    style: kAppLblLargeFontMedium(context),
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        cancelText: translate.cancel_lbl,
                        confirmText: translate.ok_lbl,
                        helpText: translate.select_start_date,
                      ).then((value) {
                        if (value != null) {
                          String year = (value.year).toString();
                          String month = (value.month).toString().padLeft(2, '0');
                          String day = (value.day).toString().padLeft(2, '0');
                          String startDate = '$year-$month-$day';
                          DateTime parsedDate = DateTime.parse(startDate);
                          String formattedDate = DateFormat('MMMM, dd yyyy').format(parsedDate);
                          setState(() {
                            _statStartTimeController.text = formattedDate;
                          });
                          if (!context.mounted) return;
                          context.read<CustomTableOrderDateInsightBloc>().add(CustomTableOrderDateInsightStartDateChangedEvent(date: startDate));
                        }
                      });
                    },
                  ),
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    showCursor: false,
                    focusNode: _endDateFocusNode,
                    controller: _statEndTimeController,
                    decoration: kAppInputDecoration(context, lblText: translate.form_end_date, prefixIcon: const Icon(Icons.calendar_month_outlined), errText: state.endDate.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        cancelText: translate.cancel_lbl,
                        confirmText: translate.ok_lbl,
                        helpText: translate.select_end_date,
                      ).then((value) {
                        if (value != null) {
                          String year = (value.year).toString();
                          String month = (value.month).toString().padLeft(2, '0');
                          String day = (value.day).toString().padLeft(2, '0');
                          String endDate = '$year-$month-$day';
                          DateTime parsedDate = DateTime.parse(endDate);
                          String formattedDate = DateFormat('MMMM, dd yyyy').format(parsedDate);
                          setState(() {
                            _statEndTimeController.text = formattedDate;
                          });
                          if (!context.mounted) return;
                          context.read<CustomTableOrderDateInsightBloc>().add(CustomTableOrderDateInsightEndDateChangedEvent(date: endDate));
                        }
                      });
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isValid ? () => context.read<CustomTableOrderDateInsightBloc>().add(CustomTableOrderDateInsightDateSubmitEvent()) : null,
                      style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                      child: state.status.isLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.get_result),
                    ),
                  ),
                  kAppSpacerVertical(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.status.isLoading) ...[
                        const CustomTableOrderDateInsightLoadingView(),
                      ] else if (state.status.isEmpty) ...[
                        const CustomTableOrderDateInsightEmptyView(),
                      ] else if (state.status.isFailure) ...[
                        const CustomTableOrderDateInsightErrorView(),
                      ] else if (state.status.isSuccess) ...[
                        TotalSellAndAverageWidget(totalSales: state.model.totalSold!.totalSold!, averageSales: state.model.totalSold!.averageSold!),
                        kAppSpacerVertical(height: 20),
                        SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          title: ChartTitle(text: translate.business_title, alignment: ChartAlignment.near, textStyle: kAppLblTinyFontBold(context)),
                          primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0), labelStyle: kAppLblTinyFontBold(context)),
                          primaryYAxis: NumericAxis(
                            axisLine: const AxisLine(width: 0),
                            labelFormat: GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}{value}' : '{value}${GlobalSettings.globalCurrencySymbol}',
                            majorTickLines: const MajorTickLines(size: 0),
                            labelStyle: kAppLblTinyFontBold(context),
                          ),
                          series: <ColumnSeries<ChartSampleData, String>>[
                            ColumnSeries<ChartSampleData, String>(
                              dataSource: <ChartSampleData>[for (var item in state.model.chartData!) ChartSampleData(x: item.date, y: item.soldCount, pointColor: Theme.of(context).primaryColor)],
                              xValueMapper: (ChartSampleData sales, _) => sales.x as String,
                              yValueMapper: (ChartSampleData sales, _) => sales.y,
                              pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
                              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: kAppLblTinyFontBold(context)),
                              enableTooltip: false,
                            ),
                          ],
                          tooltipBehavior: _tooltipBehavior,
                        ),
                        kAppSpacerVertical(height: 20),
                        Text(translate.trending_food_items, style: kAppLblSemiBoldFontLarge(context)),
                        kAppSpacerVertical(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(state.model.trendingFoods!.length, (index) => OrdersBusinessInsightFoodInfoWidget(model: state.model.trendingFoods![index])),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrdersBusinessInsightFoodInfoWidget extends StatelessWidget {
  final TrendingCustomDateTableOrderBusinessInsightFoodListConfigModel model;
  const OrdersBusinessInsightFoodInfoWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(20.0),
                  child: CacheNetworkImageWidget(width: 20.0, height: 20.0, imageUrl: model.foodDetails!.image!),
                ),
              ),
              kAppSpacerHorizontal(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.foodDetails!.name!, style: kAppLblMediumFontBold(context)),
                  kAppSpacerVertical(height: 5),
                  Text(
                    GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}${model.foodDetails!.offerPrice!}' : '${model.foodDetails!.offerPrice!}${GlobalSettings.globalCurrencySymbol}',
                    style: kAppLblSmallFontRegular(context),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${model.count!} ${translate.items}', style: kAppLblMediumFontBold(context)),
              kAppSpacerVertical(height: 5),
              Text(translate.sold, style: kAppLblMediumFontBold(context)),
            ],
          ),
        ],
      ),
    );
  }
}

class TotalSellAndAverageWidget extends StatelessWidget {
  final String totalSales;
  final String averageSales;
  const TotalSellAndAverageWidget({super.key, required this.totalSales, required this.averageSales});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.bar_chart_rounded, size: 34, color: Theme.of(context).canvasColor),
                kAppSpacerHorizontal(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kAppPriceFormatString(totalSales), style: kAppLblMediumFontBold(context)),
                    Text(translate.total_sales, style: kAppLblTinyMediumFontSemi(context)),
                  ],
                ),
              ],
            ),
          ),
        ),
        kAppSpacerHorizontal(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.show_chart_rounded, size: 34, color: Theme.of(context).canvasColor),
                kAppSpacerHorizontal(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kAppPriceFormatString(averageSales), style: kAppLblMediumFontBold(context)),
                    Text(translate.avg_sales, style: kAppLblTinyMediumFontSemi(context)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTableOrderDateInsightLoadingView extends StatelessWidget {
  const CustomTableOrderDateInsightLoadingView({super.key});

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

class CustomTableOrderDateInsightErrorView extends StatelessWidget {
  const CustomTableOrderDateInsightErrorView({super.key});

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

class CustomTableOrderDateInsightEmptyView extends StatelessWidget {
  const CustomTableOrderDateInsightEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_result_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
        ],
      ),
    );
  }
}

class ChartSampleData {
  ChartSampleData({this.x, this.y, this.xValue, this.yValue, this.secondSeriesYValue, this.thirdSeriesYValue, this.pointColor, this.size, this.text, this.open, this.close, this.low, this.high, this.volume});

  final dynamic x;

  final num? y;

  final dynamic xValue;

  final num? yValue;

  final num? secondSeriesYValue;

  final num? thirdSeriesYValue;

  final Color? pointColor;

  final num? size;

  final String? text;

  final num? open;

  final num? close;

  final num? low;

  final num? high;

  final num? volume;
}
// DONE //