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

part of 'expense_report_bloc.dart';

enum ExpenseReportStatus { loading, success, failure, empty }

extension ExpenseReportStatusX on ExpenseReportStatus {
  bool get isLoading => this == ExpenseReportStatus.loading;
  bool get isSuccess => this == ExpenseReportStatus.success;
  bool get isFailure => this == ExpenseReportStatus.failure;
  bool get isEmpty => this == ExpenseReportStatus.empty;
}

final class ExpenseReportState {
  final ExpenseInitialResponeModel initial;
  final List<ExpenseModel> expenseList;
  final List<PieChartModel> chartStats;
  final List<GridExpenseModel> gridExpense;
  final ExpenseFilterModel filterType;
  final List<ExpenseFilterModel> filterList;
  final int totalResults;
  final int pageSize;
  final int currentPage;
  final bool isFilterApplied;
  final bool loadMore;
  final ExpenseReportStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ExpenseReportState({
    required this.initial,
    this.expenseList = const [],
    this.chartStats = const [],
    this.gridExpense = const [],
    required this.filterType,
    this.filterList = const [],
    this.totalResults = 0,
    required this.pageSize,
    this.currentPage = 0,
    this.isFilterApplied = false,
    this.loadMore = false,
    this.status = ExpenseReportStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ExpenseReportState copyWith({
    ExpenseInitialResponeModel? initial,
    List<ExpenseModel>? expenseList,
    List<PieChartModel>? chartStats,
    List<GridExpenseModel>? gridExpense,
    ExpenseFilterModel? filterType,
    List<ExpenseFilterModel>? filterList,
    int? totalResults,
    int? pageSize,
    int? currentPage,
    bool? isFilterApplied,
    bool? loadMore,
    ExpenseReportStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ExpenseReportState(
      initial: initial ?? this.initial,
      expenseList: expenseList ?? this.expenseList,
      chartStats: chartStats ?? this.chartStats,
      gridExpense: gridExpense ?? this.gridExpense,
      filterType: filterType ?? this.filterType,
      filterList: filterList ?? this.filterList,
      totalResults: totalResults ?? this.totalResults,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
      loadMore: loadMore ?? this.loadMore,
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

class ExpenseFilterModel {
  String? name;
  String? value;

  ExpenseFilterModel({this.name, this.value});

  ExpenseFilterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class GridExpenseModel {
  String? name;
  double? amount;
  int? count;

  GridExpenseModel({this.name, this.amount, this.count});

  GridExpenseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    data['count'] = count;
    return data;
  }
}
