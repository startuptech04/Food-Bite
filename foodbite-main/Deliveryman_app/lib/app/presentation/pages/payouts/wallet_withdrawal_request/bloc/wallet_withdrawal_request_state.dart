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

part of 'wallet_withdrawal_request_bloc.dart';

enum WalletWithdrawalRequestStatus { loading, success, failure, customError, submit, submitSuccess }

extension WalletWithdrawalRequestStatusX on WalletWithdrawalRequestStatus {
  bool get isLoading => this == WalletWithdrawalRequestStatus.loading;
  bool get isSuccess => this == WalletWithdrawalRequestStatus.success;
  bool get isFailure => this == WalletWithdrawalRequestStatus.failure;
  bool get isCustomError => this == WalletWithdrawalRequestStatus.customError;
  bool get isSubmit => this == WalletWithdrawalRequestStatus.submit;
  bool get isSubmitSuccess => this == WalletWithdrawalRequestStatus.submitSuccess;
}

final class WalletWithdrawalRequestState {
  final WalletWithdrawalDetailModel model;
  final WalletPayoutMethodConfigModel selectedMethod;
  final List<PayoutFormElementConfigModel> formElementList;
  final String amount;
  final bool isSubmitted;
  final WalletWithdrawalRequestStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const WalletWithdrawalRequestState({
    required this.model,
    required this.selectedMethod,
    this.formElementList = const [],
    this.amount = '',
    this.isSubmitted = false,
    this.status = WalletWithdrawalRequestStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  WalletWithdrawalRequestState copyWith({
    WalletWithdrawalDetailModel? model,
    WalletPayoutMethodConfigModel? selectedMethod,
    List<PayoutFormElementConfigModel>? formElementList,
    String? amount,
    bool? isSubmitted,
    WalletWithdrawalRequestStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return WalletWithdrawalRequestState(
      model: model ?? this.model,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      formElementList: formElementList ?? this.formElementList,
      amount: amount ?? this.amount,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
