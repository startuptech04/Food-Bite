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

part of 'food_subscriptions_info_bloc.dart';

enum FoodSubscriptionsInfoStatus { loading, success, failure }

extension FoodSubscriptionsInfoStatusX on FoodSubscriptionsInfoStatus {
  bool get isLoading => this == FoodSubscriptionsInfoStatus.loading;
  bool get isSuccess => this == FoodSubscriptionsInfoStatus.success;
  bool get isFailure => this == FoodSubscriptionsInfoStatus.failure;
}

final class FoodSubscriptionsInfoState {
  final String id;
  final bool isAuthorized;
  final SubscriptionTiffinPackageInfoModel info;
  final FoodSubscriptionsInfoStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const FoodSubscriptionsInfoState({this.id = '', this.isAuthorized = false, required this.info, this.status = FoodSubscriptionsInfoStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  FoodSubscriptionsInfoState copyWith({String? id, bool? isAuthorized, SubscriptionTiffinPackageInfoModel? info, FoodSubscriptionsInfoStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return FoodSubscriptionsInfoState(
      id: id ?? this.id,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      info: info ?? this.info,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
