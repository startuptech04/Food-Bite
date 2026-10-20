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

part of 'analytics_bloc.dart';

enum AnalyticsStatus { loading, success, failure }

extension AnalyticsStatusX on AnalyticsStatus {
  bool get isLoading => this == AnalyticsStatus.loading;
  bool get isSuccess => this == AnalyticsStatus.success;
  bool get isFailure => this == AnalyticsStatus.failure;
}

final class AnalyticsState {
  final DeliverymanInsightModel model;
  final List<PieChartModel> earningPieChart;
  final AnalyticsStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const AnalyticsState({required this.model, this.earningPieChart = const [], this.status = AnalyticsStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  AnalyticsState copyWith({DeliverymanInsightModel? model, List<PieChartModel>? earningPieChart, AnalyticsStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return AnalyticsState(
      model: model ?? this.model,
      earningPieChart: earningPieChart ?? this.earningPieChart,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class PieChartModel {
  String? name;
  double? amount;

  PieChartModel({this.name, this.amount});

  PieChartModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }
}
