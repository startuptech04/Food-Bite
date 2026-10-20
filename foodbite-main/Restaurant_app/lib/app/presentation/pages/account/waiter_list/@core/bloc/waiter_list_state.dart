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

part of 'waiter_list_bloc.dart';

enum WaiterListStatus { loading, success, failure, empty, loadingHideStart, loadingHideSuccess, loadingHideFailed }

extension WaiterListStatusX on WaiterListStatus {
  bool get isLoading => this == WaiterListStatus.loading;
  bool get isSuccess => this == WaiterListStatus.success;
  bool get isFailure => this == WaiterListStatus.failure;
  bool get isEmpty => this == WaiterListStatus.empty;
  bool get isLoadingHideStart => this == WaiterListStatus.loadingHideStart;
  bool get isLoadingHideSuccess => this == WaiterListStatus.loadingHideSuccess;
  bool get isLoadingHideFailed => this == WaiterListStatus.loadingHideFailed;
}

final class WaiterListState {
  final WaiterListResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final WaiterListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const WaiterListState({required this.model, required this.pageSize, this.currentPage = 0, this.loadMore = false, this.status = WaiterListStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  WaiterListState copyWith({WaiterListResponseModel? model, int? pageSize, int? currentPage, bool? loadMore, WaiterListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return WaiterListState(
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
