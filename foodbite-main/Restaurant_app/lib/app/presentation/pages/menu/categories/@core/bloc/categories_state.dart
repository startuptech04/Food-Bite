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

part of 'categories_bloc.dart';

enum CategoriesStatus { loading, success, failure, deleteLoaderStarted, deleteLoaderEnded, deleteLoaderEndedWithError }

extension CategoriesStatusX on CategoriesStatus {
  bool get isLoading => this == CategoriesStatus.loading;
  bool get isSuccess => this == CategoriesStatus.success;
  bool get isFailure => this == CategoriesStatus.failure;
  bool get isDeleteLoaderStarted => this == CategoriesStatus.deleteLoaderStarted;
  bool get isDeleteLoaderEnded => this == CategoriesStatus.deleteLoaderEnded;
  bool get isDeleteLoaderEndedWithError => this == CategoriesStatus.deleteLoaderEndedWithError;
}

final class CategoriesState {
  final String appLocale;
  final CategoriesModel categories;
  final int customPageSize;
  final int customCurrentPage;
  final int mainPageSize;
  final int mainCurrentPage;
  final bool customLoadMore;
  final CategoriesStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CategoriesState({
    this.appLocale = '',
    required this.categories,
    required this.customPageSize,
    required this.mainPageSize,
    this.customCurrentPage = 0,
    this.mainCurrentPage = 0,
    this.customLoadMore = false,
    this.status = CategoriesStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  CategoriesState copyWith({
    String? appLocale,
    CategoriesModel? categories,
    int? customPageSize,
    int? customCurrentPage,
    int? mainPageSize,
    int? mainCurrentPage,
    bool? customLoadMore,
    CategoriesStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return CategoriesState(
      appLocale: appLocale ?? this.appLocale,
      categories: categories ?? this.categories,
      customPageSize: customPageSize ?? this.customPageSize,
      customCurrentPage: customCurrentPage ?? this.customCurrentPage,
      mainPageSize: mainPageSize ?? this.mainPageSize,
      mainCurrentPage: mainCurrentPage ?? this.mainCurrentPage,
      customLoadMore: customLoadMore ?? this.customLoadMore,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
