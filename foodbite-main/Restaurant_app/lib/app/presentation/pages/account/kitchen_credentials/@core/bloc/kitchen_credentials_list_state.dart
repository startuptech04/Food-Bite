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

part of 'kitchen_credentials_list_bloc.dart';

enum KitchenCredentialsListStatus { loading, success, failure, empty, loadingHideStart, loadingHideSuccess, loadingHideFailed }

extension KitchenCredentialsListStatusX on KitchenCredentialsListStatus {
  bool get isLoading => this == KitchenCredentialsListStatus.loading;
  bool get isSuccess => this == KitchenCredentialsListStatus.success;
  bool get isFailure => this == KitchenCredentialsListStatus.failure;
  bool get isEmpty => this == KitchenCredentialsListStatus.empty;
  bool get isLoadingHideStart => this == KitchenCredentialsListStatus.loadingHideStart;
  bool get isLoadingHideSuccess => this == KitchenCredentialsListStatus.loadingHideSuccess;
  bool get isLoadingHideFailed => this == KitchenCredentialsListStatus.loadingHideFailed;
}

final class KitchenCredentialsListState {
  final KitchenOwnerListResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final KitchenCredentialsListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const KitchenCredentialsListState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = KitchenCredentialsListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  KitchenCredentialsListState copyWith({KitchenOwnerListResponseModel? model, int? pageSize, int? currentPage, bool? loadMore, KitchenCredentialsListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return KitchenCredentialsListState(
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
