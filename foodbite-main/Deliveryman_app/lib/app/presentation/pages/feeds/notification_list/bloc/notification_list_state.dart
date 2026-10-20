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

part of 'notification_list_bloc.dart';

enum NotificationListStatus { loading, success, empty, failure, customError }

extension NotificationListStatusX on NotificationListStatus {
  bool get isLoading => this == NotificationListStatus.loading;
  bool get isSuccess => this == NotificationListStatus.success;
  bool get isEmpty => this == NotificationListStatus.empty;
  bool get isFailure => this == NotificationListStatus.failure;
  bool get isCustomError => this == NotificationListStatus.customError;
}

final class NotificationListState {
  final NotificationListResponseModel response;
  final String user;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final NotificationListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const NotificationListState({
    required this.response,
    this.user = '',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = NotificationListStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  NotificationListState copyWith({
    NotificationListResponseModel? response,
    String? user,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    NotificationListStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return NotificationListState(
      response: response ?? this.response,
      user: user ?? this.user,
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
