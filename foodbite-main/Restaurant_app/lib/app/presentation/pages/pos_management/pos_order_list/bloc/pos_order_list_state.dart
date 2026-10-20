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

part of 'pos_order_list_bloc.dart';

enum PosOrderListStatus { loading, success, failure, customError, empty }

extension PosOrderListStatusX on PosOrderListStatus {
  bool get isLoading => this == PosOrderListStatus.loading;
  bool get isSuccess => this == PosOrderListStatus.success;
  bool get isFailure => this == PosOrderListStatus.failure;
  bool get isCustomError => this == PosOrderListStatus.customError;
  bool get isEmpty => this == PosOrderListStatus.empty;
}

final class PosOrderListState {
  final PosOrderListModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final PosOrderListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const PosOrderListState({required this.model, required this.pageSize, this.currentPage = 0, this.loadMore = false, this.status = PosOrderListStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  PosOrderListState copyWith({PosOrderListModel? model, int? pageSize, int? currentPage, bool? loadMore, PosOrderListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return PosOrderListState(
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
