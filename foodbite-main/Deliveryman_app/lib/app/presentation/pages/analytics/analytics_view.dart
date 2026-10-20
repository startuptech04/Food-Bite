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

import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/config/global_settings.dart';
import 'package:driver/app/core/models/deliveryman_insight_model.dart';
import 'package:driver/app/core/models/order_list_response_model.dart';
import 'package:driver/app/core/models/review_list_response_model.dart';
import 'package:driver/app/presentation/pages/analytics/bloc/analytics_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:driver/app/router/app_route_config.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticScreen extends StatelessWidget {
  const AnalyticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnalyticView();
  }
}

class AnalyticView extends StatefulWidget {
  const AnalyticView({super.key});

  @override
  State<AnalyticView> createState() => _AnalyticViewState();
}

class _AnalyticViewState extends State<AnalyticView> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorAnalyticsKey = GlobalKey<RefreshIndicatorState>();
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: false);
    context.read<AnalyticsBloc>().add(AnalyticsInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<AnalyticsBloc, AnalyticsState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false, title: Text(translate.analytics), scrolledUnderElevation: 0),
          body: RefreshIndicator(
            key: _refreshIndicatorAnalyticsKey,
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onRefresh: () async {
              context.read<AnalyticsBloc>().add(AnalyticsInitialEvent());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const AnalyticsLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const AnalyticsErrorView(),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow, borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.bar_chart_rounded, size: 20, color: Theme.of(context).canvasColor),
                                kAppSpacerHorizontal(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(kAppPriceFormat(state.model.totalEarning!), style: kAppLblTinyFontBold(context)),
                                    Text(translate.earning, style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        kAppSpacerHorizontal(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow, borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.electric_bike_outlined, size: 20, color: Theme.of(context).canvasColor),
                                kAppSpacerHorizontal(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${state.model.deliveredOrders!} ${translate.orders}", style: kAppLblTinyFontBold(context)),
                                    Text(translate.delivered, style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        kAppSpacerHorizontal(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow, borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.punch_clock_outlined, size: 20, color: Theme.of(context).canvasColor),
                                kAppSpacerHorizontal(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${state.model.averageDeliveryTimeOfDelivery!} ${translate.min}", style: kAppLblTinyFontBold(context)),
                                    Text(translate.avg_time, style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text(translate.order_stats, style: kAppLblMediumFontBold(context, color: 'regular'))],
                    ),
                    kAppSpacerVertical(height: 20),
                    SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      title: ChartTitle(text: '', alignment: ChartAlignment.near, textStyle: kAppLblTinyFontBold(context)),
                      primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0), labelStyle: kAppLblTinyFontBold(context)),
                      primaryYAxis: NumericAxis(axisLine: const AxisLine(width: 0), labelFormat: '{value} ${translate.orders}', majorTickLines: const MajorTickLines(size: 0), labelStyle: kAppLblTinyFontBold(context)),
                      series: <ColumnSeries<ChartSampleData, String>>[
                        ColumnSeries<ChartSampleData, String>(
                          dataSource: <ChartSampleData>[for (var item in state.model.chartCount!) ChartSampleData(x: kAppOrderStatus(context, item.statusName!), y: item.count!, pointColor: Theme.of(context).primaryColor)],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text(translate.earning_stats, style: kAppLblMediumFontBold(context, color: 'regular'))],
                    ),
                    kAppSpacerVertical(height: 20),
                    SfCircularChart(
                      title: ChartTitle(text: '', textStyle: kAppLblTinyFontBold(context)),
                      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, textStyle: kAppLblTinyFontBold(context)),
                      series: <PieSeries<PieChartModel, String>>[
                        PieSeries<PieChartModel, String>(
                          dataSource: state.earningPieChart,
                          xValueMapper: (PieChartModel data, _) => kAppDDTranslate(context, data.name!),
                          yValueMapper: (PieChartModel data, _) => data.amount,
                          dataLabelMapper: (PieChartModel data, _) =>
                              GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}${data.amount.toString()}' : '${data.amount.toString()}${GlobalSettings.globalCurrencySymbol}',
                          dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontFamily: 'bold')),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    state.model.hourlyPerformanceChart!.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Text(translate.hourly_performance, style: kAppLblMediumFontBold(context, color: 'regular'))],
                              ),
                              kAppSpacerVertical(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(state.model.hourlyPerformanceChart!.length, (index) => AnalyticsHourlyPerformanceWidget(model: state.model.hourlyPerformanceChart![index])),
                              ),
                              kAppSpacerVertical(height: 10),
                            ],
                          )
                        : const SizedBox(),
                    state.model.recentOrders!.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(translate.recent_orders, style: kAppLblMediumFontBold(context, color: 'regular')),
                                  InkWell(
                                    onTap: () => Navigator.of(context).pushNamed(AppRouter.orderListRoute),
                                    child: Text(translate.view_all, style: kAppLblMediumFontBold(context, color: 'primary')),
                                  ),
                                ],
                              ),
                              kAppSpacerVertical(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(state.model.recentOrders!.length, (index) => AnalyticsOrderInfoWidget(findMode: state.model.findMode!, model: state.model.recentOrders![index])),
                              ),
                              kAppSpacerVertical(height: 10),
                            ],
                          )
                        : const SizedBox(),
                    state.model.recentReviews!.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kAppSpacerVertical(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(translate.recent_reviews, style: kAppLblMediumFontBold(context, color: 'regular')),
                                  InkWell(
                                    onTap: () => Navigator.of(context).pushNamed(AppRouter.reviewListRoute),
                                    child: Text(translate.view_all, style: kAppLblMediumFontBold(context, color: 'primary')),
                                  ),
                                ],
                              ),
                              kAppSpacerVertical(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(state.model.recentReviews!.length, (index) => AnalyticsReviewWidget(model: state.model.recentReviews![index])),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ],
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

class AnalyticsHourlyPerformanceWidget extends StatelessWidget {
  final HourlyPerformanceChartModel model;
  const AnalyticsHourlyPerformanceWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate.hour, style: kAppLblTinyFontBold(context)),
              Text("${model.hour!}", style: kAppLblTinyFontRegular(context)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate.deliveries, style: kAppLblTinyFontBold(context)),
              Text("${model.totalDeliveries!}", style: kAppLblTinyFontRegular(context)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate.earnings, style: kAppLblTinyFontBold(context)),
              Text(kAppPriceFormat(model.totalEarnings!), style: kAppLblTinyFontRegular(context)),
            ],
          ),
        ],
      ),
    );
  }
}

class AnalyticsOrderInfoWidget extends StatelessWidget {
  final String findMode;
  final OrderListDetailConfigModel model;
  const AnalyticsOrderInfoWidget({super.key, required this.findMode, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRouter.completedOrderDetailRoute, arguments: [model.order!.id!, model.order!.orderNo!.toString()]),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${translate.order} #${model.order!.orderNo!}", style: kAppLblTinyFontBold(context)),
                    Text(model.createdAt!, style: kAppLblTinyFontRegular(context)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow, borderRadius: BorderRadius.circular(5)),
                      child: Text(kAppOrderStatus(context, model.statusName!), style: kAppLblTinyFontBold(context)),
                    ),
                    Text("${model.distance!} ${findMode == 'km' ? translate.km : translate.miles}", style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                  ],
                ),
              ],
            ),
            kAppSpacerVertical(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu_outlined, color: Theme.of(context).primaryColor, size: 18),
                kAppSpacerHorizontal(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kAppTrimWord(model.restaurant!.name!, 40), style: kAppLblTinyFontBold(context)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(model.restaurant!.address!, maxLines: 2, style: kAppLblTinyFontRegular(context)),
                    ),
                  ],
                ),
              ],
            ),
            kAppSpacerVertical(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on_rounded, color: Theme.of(context).primaryColor, size: 18),
                kAppSpacerHorizontal(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kAppTrimWord(model.order!.receiverName!, 40), style: kAppLblTinyFontBold(context)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(model.deliveryFullAddress!, maxLines: 2, style: kAppLblTinyFontRegular(context)),
                    ),
                  ],
                ),
              ],
            ),
            kAppSpacerVertical(height: 5),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.bonuses, style: kAppLblTinyFontRegular(context)),
                      Text(kAppPriceFormat(model.incentiveAmount!), style: kAppLblTinyFontBold(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.tips, style: kAppLblTinyFontRegular(context)),
                      Text(kAppPriceFormat(model.tipAmount!), style: kAppLblTinyFontBold(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.total_earning, style: kAppLblTinyFontRegular(context)),
                      Text(kAppPriceFormat(model.earning!), style: kAppLblTinyFontBold(context)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsReviewWidget extends StatelessWidget {
  final ReviewConfigModel model;
  const AnalyticsReviewWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: CircleAvatar(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CacheNetworkImageWidget(width: 30.0, height: 30.0, imageUrl: model.userInfo!.image!),
                        ),
                      ),
                    ),
                    kAppSpacerHorizontal(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${model.userInfo!.firstName!} ${model.userInfo!.lastName!}", style: kAppLblMediumFontBold(context)),
                        Text(model.createdAt!, style: kAppLblTinyFontRegular(context)),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(color: ThemeProvider.ratingBgColorLight, borderRadius: BorderRadius.circular(5.0)),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${model.ratingCount} ',
                              style: TextStyle(color: ThemeProvider.ratingTextColorLight, fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
                            ),
                            const WidgetSpan(child: Icon(Icons.star, size: 13, color: ThemeProvider.ratingTextColorLight)),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.check_circle, size: 12, color: Theme.of(context).canvasColor),
                        Text(translate.verified_order, style: kAppLblTinyFontRegular(context)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: model.shortReview!.isNotEmpty ? 5 : 0),
            padding: EdgeInsets.symmetric(vertical: model.shortReview!.isNotEmpty ? 5 : 0),
            child: Text(model.shortReview!, style: kAppLblTinyFontBold(context)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: model.hashtags!
                .map(
                  (hastags) => Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(hastags.name!, maxLines: 2, style: kAppLblTinyFontBold(context)),
                  ),
                )
                .toList(),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: model.images!.isNotEmpty ? 5 : 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (model.images!.length == 1) ...[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 150.0, imageUrl: model.images![0]),
                  ),
                ] else if (model.images!.length == 2) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width / 2.4, height: 150.0, imageUrl: model.images![0]),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width / 2.4, height: 150.0, imageUrl: model.images![1]),
                      ),
                    ],
                  ),
                ] else if (model.images!.length == 3) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width / 2.2, height: 150.0, imageUrl: model.images![0]),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width / 2.6, height: 70.0, imageUrl: model.images![1]),
                          ),
                          kAppSpacerVertical(height: 10),
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width / 2.6, height: 70.0, imageUrl: model.images![2]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsLoadingView extends StatelessWidget {
  const AnalyticsLoadingView({super.key});

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

class AnalyticsErrorView extends StatelessWidget {
  const AnalyticsErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.something_went_wrong_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
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