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

part of 'payout_method_bloc.dart';

enum PayoutMethodStatus { loading, success, failure, empty, customError, loadingDeleteStart, loadingDeleteSuccess, loadingDeleteFailed, loadingDefaultChangeStart, loadingDefaultChangeFailed, loadingDefaultChangeSuccess }

extension PayoutMethodStatusX on PayoutMethodStatus {
  bool get isLoading => this == PayoutMethodStatus.loading;
  bool get isSuccess => this == PayoutMethodStatus.success;
  bool get isFailure => this == PayoutMethodStatus.failure;
  bool get isEmpty => this == PayoutMethodStatus.empty;
  bool get isCustomError => this == PayoutMethodStatus.customError;
  bool get isLoadingDeleteStart => this == PayoutMethodStatus.loadingDeleteStart;
  bool get isLoadingDeleteSuccess => this == PayoutMethodStatus.loadingDeleteSuccess;
  bool get isLoadingDeleteFailed => this == PayoutMethodStatus.loadingDeleteFailed;
  bool get isLoadingDefaultChangeStart => this == PayoutMethodStatus.loadingDefaultChangeStart;
  bool get isLoadingDefaultChangeFailed => this == PayoutMethodStatus.loadingDefaultChangeFailed;
  bool get isLoadingDefaultChangeSuccess => this == PayoutMethodStatus.loadingDefaultChangeSuccess;
}

final class PayoutMethodState {
  final MyPayoutMethodListModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final PayoutMethodStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PayoutMethodState({required this.model, required this.pageSize, this.currentPage = 0, this.loadMore = false, this.status = PayoutMethodStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  PayoutMethodState copyWith({MyPayoutMethodListModel? model, int? pageSize, int? currentPage, bool? loadMore, PayoutMethodStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return PayoutMethodState(
      model: model ?? this.model,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
