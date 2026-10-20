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

part of 'table_list_bloc.dart';

enum TableListStatus { loading, success, failure, empty, customError }

extension TableListStatusX on TableListStatus {
  bool get isLoading => this == TableListStatus.loading;
  bool get isSuccess => this == TableListStatus.success;
  bool get isFailure => this == TableListStatus.failure;
  bool get isEmpty => this == TableListStatus.empty;
  bool get isCustomError => this == TableListStatus.customError;
}

final class TableListState {
  final TableListResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final TableListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TableListState({required this.model, required this.pageSize, this.currentPage = 0, this.loadMore = false, this.status = TableListStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  TableListState copyWith({TableListResponseModel? model, int? pageSize, int? currentPage, bool? loadMore, TableListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return TableListState(
      model: model ?? this.model,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
