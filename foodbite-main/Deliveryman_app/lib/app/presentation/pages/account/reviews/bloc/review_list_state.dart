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

part of 'review_list_bloc.dart';

enum ReviewListStatus { loading, success, failure, empty }

extension ReviewListStatusX on ReviewListStatus {
  bool get isLoading => this == ReviewListStatus.loading;
  bool get isSuccess => this == ReviewListStatus.success;
  bool get isFailure => this == ReviewListStatus.failure;
  bool get isEmpty => this == ReviewListStatus.empty;
}

final class ReviewListState {
  final ReviewListResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final ReviewListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ReviewListState({required this.model, required this.pageSize, this.currentPage = 0, this.loadMore = false, this.status = ReviewListStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  ReviewListState copyWith({ReviewListResponseModel? model, int? pageSize, int? currentPage, bool? loadMore, ReviewListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return ReviewListState(
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
