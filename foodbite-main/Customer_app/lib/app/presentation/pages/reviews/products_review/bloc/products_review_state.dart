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

part of 'products_review_bloc.dart';

enum ProductsReviewStatus { loading, empty, success, failure, customError }

extension ProductsReviewStatusX on ProductsReviewStatus {
  bool get isLoading => this == ProductsReviewStatus.loading;
  bool get isEmpty => this == ProductsReviewStatus.empty;
  bool get isSuccess => this == ProductsReviewStatus.success;
  bool get isFailure => this == ProductsReviewStatus.failure;
  bool get isCustomError => this == ProductsReviewStatus.customError;
}

final class ProductsReviewState {
  final String id;
  final String name;
  final String ratings;
  final FoodReviewsResponseModel detail;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final ProductsReviewStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const ProductsReviewState({
    this.id = '',
    this.name = '',
    this.ratings = '0.0',
    required this.detail,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = ProductsReviewStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  ProductsReviewState copyWith({
    String? id,
    String? name,
    String? ratings,
    FoodReviewsResponseModel? detail,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    ProductsReviewStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return ProductsReviewState(
      id: id ?? this.id,
      name: name ?? this.name,
      ratings: ratings ?? this.ratings,
      detail: detail ?? this.detail,
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
