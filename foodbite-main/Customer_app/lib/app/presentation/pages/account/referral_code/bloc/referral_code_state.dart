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

part of 'referral_code_bloc.dart';

enum ReferralCodeStatus { loading, success, failure, unAuthorized }

extension ReferralCodeStatusX on ReferralCodeStatus {
  bool get isLoading => this == ReferralCodeStatus.loading;
  bool get isSuccess => this == ReferralCodeStatus.success;
  bool get isFailure => this == ReferralCodeStatus.failure;
  bool get isUnAuthorizd => this == ReferralCodeStatus.unAuthorized;
}

final class ReferralCodeState {
  final String title;
  final String subTitle;
  final String referralCode;
  final ReferralCodeResponseModel model;
  final ReferralCodeStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const ReferralCodeState({this.title = '', this.subTitle = '', this.referralCode = '', required this.model, this.status = ReferralCodeStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  ReferralCodeState copyWith({String? title, String? subTitle, String? referralCode, ReferralCodeResponseModel? model, ReferralCodeStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return ReferralCodeState(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      referralCode: referralCode ?? this.referralCode,
      model: model ?? this.model,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
