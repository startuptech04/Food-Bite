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

import 'package:driver/app/core/models/order_list_response_model.dart';
import 'package:driver/app/core/models/review_list_response_model.dart';

class DeliverymanInsightModel {
  int? deliveredOrders;
  double? totalEarning;
  double? averageDeliveryTimeOfDelivery;
  List<OrderChartCountModel>? chartCount;
  OrderEarningChartDataModel? earningChartData;
  List<HourlyPerformanceChartModel>? hourlyPerformanceChart;
  List<OrderListDetailConfigModel>? recentOrders;
  List<ReviewConfigModel>? recentReviews;
  String? findMode;
  bool? success;
  final String locale;

  DeliverymanInsightModel({
    this.deliveredOrders,
    this.totalEarning,
    this.averageDeliveryTimeOfDelivery,
    this.chartCount,
    this.earningChartData,
    this.hourlyPerformanceChart,
    this.recentOrders,
    this.recentReviews,
    this.findMode,
    this.success,
    required this.locale,
  });

  DeliverymanInsightModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['deliveredOrders'] != null && json['deliveredOrders'] != '') {
      deliveredOrders = int.parse(json['deliveredOrders'].toString());
    } else {
      deliveredOrders = 0;
    }
    if (json['totalEarning'] != null && json['totalEarning'] != '') {
      totalEarning = double.parse(json['totalEarning'].toString());
    } else {
      totalEarning = 0;
    }
    if (json['averageDeliveryTimeOfDelivery'] != null && json['averageDeliveryTimeOfDelivery'] != '') {
      averageDeliveryTimeOfDelivery = double.parse(json['averageDeliveryTimeOfDelivery'].toString());
    } else {
      averageDeliveryTimeOfDelivery = 0;
    }
    if (json['chartCount'] != null) {
      chartCount = <OrderChartCountModel>[];
      json['chartCount'].forEach((v) {
        chartCount!.add(OrderChartCountModel.fromJson(v));
      });
    } else {
      chartCount = [];
    }
    earningChartData = json['earningChartData'] != null ? OrderEarningChartDataModel.fromJson(json['earningChartData']) : null;
    if (json['hourlyPerformanceChart'] != null) {
      hourlyPerformanceChart = <HourlyPerformanceChartModel>[];
      json['hourlyPerformanceChart'].forEach((v) {
        hourlyPerformanceChart!.add(HourlyPerformanceChartModel.fromJson(v));
      });
    } else {
      hourlyPerformanceChart = [];
    }
    if (json['recentOrders'] != null) {
      recentOrders = <OrderListDetailConfigModel>[];
      json['recentOrders'].forEach((v) {
        recentOrders!.add(OrderListDetailConfigModel.fromJson(v, locale));
      });
    } else {
      recentOrders = [];
    }
    if (json['recentReviews'] != null) {
      recentReviews = <ReviewConfigModel>[];
      json['recentReviews'].forEach((v) {
        recentReviews!.add(ReviewConfigModel.fromJson(v, locale));
      });
    } else {
      recentReviews = [];
    }
    findMode = json['findMode'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deliveredOrders'] = deliveredOrders;
    data['totalEarning'] = totalEarning;
    data['averageDeliveryTimeOfDelivery'] = averageDeliveryTimeOfDelivery;
    if (chartCount != null) {
      data['chartCount'] = chartCount!.map((v) => v.toJson()).toList();
    }
    if (earningChartData != null) {
      data['earningChartData'] = earningChartData!.toJson();
    }
    if (hourlyPerformanceChart != null) {
      data['hourlyPerformanceChart'] = hourlyPerformanceChart!.map((v) => v.toJson()).toList();
    }
    if (recentOrders != null) {
      data['recentOrders'] = recentOrders!.map((v) => v.toJson()).toList();
    }
    if (recentReviews != null) {
      data['recentReviews'] = recentReviews!.map((v) => v.toJson()).toList();
    }
    data['findMode'] = findMode;
    data['success'] = success;
    return data;
  }
}

class OrderChartCountModel {
  int? count;
  String? status;
  String? statusName;

  OrderChartCountModel({this.count, this.status, this.statusName});
  OrderChartCountModel.fromJson(Map<String, dynamic> json) {
    if (json['count'] != null && json['count'] != '') {
      count = int.parse(json['count'].toString());
    } else {
      count = 0;
    }
    status = json['status'];

    if (json['status'] != null && json['status'] != '') {
      statusName = json['status'];
    } else {
      statusName = 'New Order';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['status'] = status;
    data['statusName'] = statusName;
    return data;
  }
}

class OrderEarningChartDataModel {
  double? totalEarnings;
  double? totalTips;
  double? totalBonuses;
  double? totalExtraShiftEarning;

  OrderEarningChartDataModel({this.totalEarnings, this.totalTips, this.totalBonuses});

  OrderEarningChartDataModel.fromJson(Map<String, dynamic> json) {
    if (json['totalEarnings'] != null && json['totalEarnings'] != '') {
      totalEarnings = double.parse(json['totalEarnings'].toString());
    } else {
      totalEarnings = 0;
    }
    if (json['totalTips'] != null && json['totalTips'] != '') {
      totalTips = double.parse(json['totalTips'].toString());
    } else {
      totalTips = 0;
    }
    if (json['totalBonuses'] != null && json['totalBonuses'] != '') {
      totalBonuses = double.parse(json['totalBonuses'].toString());
    } else {
      totalBonuses = 0;
    }
    if (json['totalExtraShiftEarning'] != null && json['totalExtraShiftEarning'] != '') {
      totalExtraShiftEarning = double.parse(json['totalExtraShiftEarning'].toString());
    } else {
      totalExtraShiftEarning = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalEarnings'] = totalEarnings;
    data['totalTips'] = totalTips;
    data['totalBonuses'] = totalBonuses;
    data['totalExtraShiftEarning'] = totalExtraShiftEarning;
    return data;
  }
}

class HourlyPerformanceChartModel {
  double? totalDeliveries;
  double? hour;
  double? totalEarnings;

  HourlyPerformanceChartModel({this.totalDeliveries, this.hour, this.totalEarnings});

  HourlyPerformanceChartModel.fromJson(Map<String, dynamic> json) {
    if (json['totalDeliveries'] != null && json['totalDeliveries'] != '') {
      totalDeliveries = double.parse(json['totalDeliveries'].toString());
    } else {
      totalDeliveries = 0;
    }
    if (json['hour'] != null && json['hour'] != '') {
      hour = double.parse(json['hour'].toString());
    } else {
      hour = 0;
    }
    if (json['totalEarnings'] != null && json['totalEarnings'] != '') {
      totalEarnings = double.parse(json['totalEarnings'].toString());
    } else {
      totalEarnings = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalDeliveries'] = totalDeliveries;
    data['hour'] = hour;
    data['totalEarnings'] = totalEarnings;
    return data;
  }
}
