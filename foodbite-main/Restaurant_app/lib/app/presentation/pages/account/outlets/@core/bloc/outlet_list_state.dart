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

part of 'outlet_list_bloc.dart';

enum OutletListStatus { loading, success, failure, empty, loadingHideStart, loadingHideSuccess, loadingHideFailed }

extension OutletListStatusX on OutletListStatus {
  bool get isLoading => this == OutletListStatus.loading;
  bool get isSuccess => this == OutletListStatus.success;
  bool get isFailure => this == OutletListStatus.failure;
  bool get isEmpty => this == OutletListStatus.empty;
  bool get isLoadingHideStart => this == OutletListStatus.loadingHideStart;
  bool get isLoadingHideSuccess => this == OutletListStatus.loadingHideSuccess;
  bool get isLoadingHideFailed => this == OutletListStatus.loadingHideFailed;
}

final class OutletListState {
  final OutletListResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final OutletListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OutletListState({required this.model, required this.pageSize, this.currentPage = 0, this.loadMore = false, this.status = OutletListStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  OutletListState copyWith({OutletListResponseModel? model, int? pageSize, int? currentPage, bool? loadMore, OutletListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OutletListState(
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
