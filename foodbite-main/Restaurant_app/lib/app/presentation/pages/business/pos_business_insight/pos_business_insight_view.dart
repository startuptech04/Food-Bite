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
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/config/global_settings.dart';
import 'package:vendor/app/core/models/pos_business_insight_model.dart';
import 'package:vendor/app/presentation/pages/business/pos_business_insight/bloc/pos_business_insight_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class PosBusinessInsightScreen extends StatelessWidget {
  const PosBusinessInsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => PosBusinessInsightBloc()..add(PosBusinessInsightInitialEvent()), child: const PosBusinessInsightView());
  }
}

class PosBusinessInsightView extends StatefulWidget {
  const PosBusinessInsightView({super.key});

  @override
  State<PosBusinessInsightView> createState() => _PosBusinessInsightViewState();
}

class _PosBusinessInsightViewState extends State<PosBusinessInsightView> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshPosBusinessIndicatorKey = GlobalKey<RefreshIndicatorState>();
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: false);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<PosBusinessInsightBloc, PosBusinessInsightState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          key: _refreshPosBusinessIndicatorKey,
          color: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onRefresh: () async {
            context.read<PosBusinessInsightBloc>().add(PosBusinessInsightInitialEvent());
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const PosBusinessInsightLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const PosBusinessInsightErrorView(),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.chart_orders, style: kAppLblSemiBoldFontLarge(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => context.read<PosBusinessInsightBloc>().add(PosBusinessInsightUnitChangeEvent(unit: 'month')),
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Chip(
                                key: const ObjectKey('month'),
                                label: Text(translate.month),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: state.unit == 'month' ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                ),
                                labelStyle: kAppLblSmallFontMedium(context, color: state.unit == 'month' ? 'primary' : 'regular'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.read<PosBusinessInsightBloc>().add(PosBusinessInsightUnitChangeEvent(unit: 'week')),
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Chip(
                                key: const ObjectKey('week'),
                                label: Text(translate.week),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: state.unit == 'week' ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                ),
                                labelStyle: kAppLblSmallFontMedium(context, color: state.unit == 'week' ? 'primary' : 'regular'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.read<PosBusinessInsightBloc>().add(PosBusinessInsightUnitChangeEvent(unit: 'today')),
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Chip(
                                key: const ObjectKey('today'),
                                label: Text(translate.today),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: state.unit == 'today' ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                ),
                                labelStyle: kAppLblSmallFontMedium(context, color: state.unit == 'today' ? 'primary' : 'regular'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.unit == 'month') ...[
                        PosTotalSellAndAverageWidget(totalSales: state.model.monthTotalSold!.totalSold!, averageSales: state.model.monthTotalSold!.averageSold!),
                      ] else if (state.unit == 'week') ...[
                        PosTotalSellAndAverageWidget(totalSales: state.model.weekTotalSold!.totalSold!, averageSales: state.model.weekTotalSold!.averageSold!),
                      ] else ...[
                        PosTotalSellAndAverageWidget(totalSales: state.model.todayTotalSold!.totalSold!, averageSales: state.model.todayTotalSold!.averageSold!),
                      ],
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.unit == 'month') ...[
                        SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          title: ChartTitle(text: translate.month_business_insight, alignment: ChartAlignment.near, textStyle: kAppLblTinyFontBold(context)),
                          primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0), labelStyle: kAppLblTinyFontBold(context)),
                          primaryYAxis: NumericAxis(
                            axisLine: const AxisLine(width: 0),
                            labelFormat: GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}{value}' : '{value}${GlobalSettings.globalCurrencySymbol}',
                            majorTickLines: const MajorTickLines(size: 0),
                            labelStyle: kAppLblTinyFontBold(context),
                          ),
                          series: <ColumnSeries<ChartSampleData, String>>[
                            ColumnSeries<ChartSampleData, String>(
                              dataSource: <ChartSampleData>[for (var item in state.model.monthChartData!) ChartSampleData(x: item.date, y: item.soldCount, pointColor: Theme.of(context).primaryColor)],
                              xValueMapper: (ChartSampleData sales, _) => sales.x as String,
                              yValueMapper: (ChartSampleData sales, _) => sales.y,
                              pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
                              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: kAppLblTinyFontBold(context)),
                              enableTooltip: false,
                            ),
                          ],
                          tooltipBehavior: _tooltipBehavior,
                        ),
                      ] else if (state.unit == 'week') ...[
                        SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          title: ChartTitle(text: translate.week_business_insight, alignment: ChartAlignment.near, textStyle: kAppLblTinyFontBold(context)),
                          primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0), labelStyle: kAppLblTinyFontBold(context)),
                          primaryYAxis: NumericAxis(
                            axisLine: const AxisLine(width: 0),
                            labelFormat: GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}{value}' : '{value}${GlobalSettings.globalCurrencySymbol}',
                            majorTickLines: const MajorTickLines(size: 0),
                            labelStyle: kAppLblTinyFontBold(context),
                          ),
                          series: <ColumnSeries<ChartSampleData, String>>[
                            ColumnSeries<ChartSampleData, String>(
                              dataSource: <ChartSampleData>[for (var item in state.model.weekChartData!) ChartSampleData(x: item.date, y: item.soldCount, pointColor: Theme.of(context).primaryColor)],
                              xValueMapper: (ChartSampleData sales, _) => sales.x as String,
                              yValueMapper: (ChartSampleData sales, _) => sales.y,
                              pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
                              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: kAppLblTinyFontBold(context)),
                              enableTooltip: false,
                            ),
                          ],
                          tooltipBehavior: _tooltipBehavior,
                        ),
                      ] else ...[
                        SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          title: ChartTitle(text: translate.today_business_insight, alignment: ChartAlignment.near, textStyle: kAppLblTinyFontBold(context)),
                          primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0), labelStyle: kAppLblTinyFontBold(context)),
                          primaryYAxis: NumericAxis(
                            axisLine: const AxisLine(width: 0),
                            labelFormat: GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}{value}' : '{value}${GlobalSettings.globalCurrencySymbol}',
                            majorTickLines: const MajorTickLines(size: 0),
                            labelStyle: kAppLblTinyFontBold(context),
                          ),
                          series: <ColumnSeries<ChartSampleData, String>>[
                            ColumnSeries<ChartSampleData, String>(
                              dataSource: <ChartSampleData>[for (var item in state.model.todayChartData!) ChartSampleData(x: item.hourAndMinute, y: item.soldCount, pointColor: Theme.of(context).primaryColor)],
                              xValueMapper: (ChartSampleData sales, _) => sales.x as String,
                              yValueMapper: (ChartSampleData sales, _) => sales.y,
                              pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
                              dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: kAppLblTinyFontBold(context)),
                              enableTooltip: false,
                            ),
                          ],
                          tooltipBehavior: _tooltipBehavior,
                        ),
                      ],
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.trending_food_items, style: kAppLblSemiBoldFontLarge(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => context.read<PosBusinessInsightBloc>().add(PosBusinessInsightUnitChangeEvent(unit: 'month')),
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Chip(
                                key: const ObjectKey('month'),
                                label: Text(translate.month),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: state.unit == 'month' ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                ),
                                labelStyle: kAppLblSmallFontMedium(context, color: state.unit == 'month' ? 'primary' : 'regular'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.read<PosBusinessInsightBloc>().add(PosBusinessInsightUnitChangeEvent(unit: 'week')),
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Chip(
                                key: const ObjectKey('week'),
                                label: Text(translate.week),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: state.unit == 'week' ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                ),
                                labelStyle: kAppLblSmallFontMedium(context, color: state.unit == 'week' ? 'primary' : 'regular'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.read<PosBusinessInsightBloc>().add(PosBusinessInsightUnitChangeEvent(unit: 'today')),
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Chip(
                                key: const ObjectKey('today'),
                                label: Text(translate.today),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: state.unit == 'today' ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                ),
                                labelStyle: kAppLblSmallFontMedium(context, color: state.unit == 'today' ? 'primary' : 'regular'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.unit == 'month') ...[
                        state.model.monthlyTrendingFoods!.isEmpty
                            ? Center(
                                child: Text(translate.no_result_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(state.model.monthlyTrendingFoods!.length, (index) => PosBusinessInsightFoodInfoWidget(model: state.model.monthlyTrendingFoods![index])),
                              ),
                      ] else if (state.unit == 'week') ...[
                        state.model.weeklyTrendingFoods!.isEmpty
                            ? Center(
                                child: Text(translate.no_result_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(state.model.weeklyTrendingFoods!.length, (index) => PosBusinessInsightFoodInfoWidget(model: state.model.weeklyTrendingFoods![index])),
                              ),
                      ] else ...[
                        state.model.todayTrendingFoods!.isEmpty
                            ? Center(
                                child: Text(translate.no_result_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(state.model.todayTrendingFoods!.length, (index) => PosBusinessInsightFoodInfoWidget(model: state.model.todayTrendingFoods![index])),
                              ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PosBusinessInsightFoodInfoWidget extends StatelessWidget {
  final TrendingPosBusinessInsightFoodListConfigModel model;
  const PosBusinessInsightFoodInfoWidget({super.key, required this.model});

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

class PosTotalSellAndAverageWidget extends StatelessWidget {
  final String totalSales;
  final String averageSales;
  const PosTotalSellAndAverageWidget({super.key, required this.totalSales, required this.averageSales});

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

class PosBusinessInsightLoadingView extends StatelessWidget {
  const PosBusinessInsightLoadingView({super.key});

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

class PosBusinessInsightErrorView extends StatelessWidget {
  const PosBusinessInsightErrorView({super.key});

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