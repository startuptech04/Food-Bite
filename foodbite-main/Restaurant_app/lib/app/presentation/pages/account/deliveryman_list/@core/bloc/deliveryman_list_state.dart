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

part of 'deliveryman_list_bloc.dart';

enum DeliverymanListStatus { loading, success, failure, empty, loadingBlockedStart, loadingBlockedSuccess, loadingBlockedFailed, loadingHideStart, loadingHideSuccess, loadingHideFailed }

extension DeliverymanListStatusX on DeliverymanListStatus {
  bool get isLoading => this == DeliverymanListStatus.loading;
  bool get isSuccess => this == DeliverymanListStatus.success;
  bool get isFailure => this == DeliverymanListStatus.failure;
  bool get isEmpty => this == DeliverymanListStatus.empty;
  bool get isLoadingBlockedStart => this == DeliverymanListStatus.loadingBlockedStart;
  bool get isLoadingBlockedSuccess => this == DeliverymanListStatus.loadingBlockedSuccess;
  bool get isLoadingBlockedFailed => this == DeliverymanListStatus.loadingBlockedFailed;
  bool get isLoadingHideStart => this == DeliverymanListStatus.loadingHideStart;
  bool get isLoadingHideSuccess => this == DeliverymanListStatus.loadingHideSuccess;
  bool get isLoadingHideFailed => this == DeliverymanListStatus.loadingHideFailed;
}

final class DeliverymanListState {
  final DeliverymanListResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final DeliverymanListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DeliverymanListState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = DeliverymanListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DeliverymanListState copyWith({DeliverymanListResponseModel? model, int? pageSize, int? currentPage, bool? loadMore, DeliverymanListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return DeliverymanListState(
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
