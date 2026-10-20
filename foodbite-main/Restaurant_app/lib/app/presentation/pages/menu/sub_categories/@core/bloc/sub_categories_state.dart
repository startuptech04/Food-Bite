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

part of 'sub_categories_bloc.dart';

enum SubCategoriesStatus { loading, success, failure, deleteLoaderStarted, deleteLoaderEnded, deleteLoaderEndedWithError }

extension SubCategoriesStatusX on SubCategoriesStatus {
  bool get isLoading => this == SubCategoriesStatus.loading;
  bool get isSuccess => this == SubCategoriesStatus.success;
  bool get isFailure => this == SubCategoriesStatus.failure;
  bool get isDeleteLoaderStarted => this == SubCategoriesStatus.deleteLoaderStarted;
  bool get isDeleteLoaderEnded => this == SubCategoriesStatus.deleteLoaderEnded;
  bool get isDeleteLoaderEndedWithError => this == SubCategoriesStatus.deleteLoaderEndedWithError;
}

final class SubCategoriesState {
  final String appLocale;
  final SubCategoriesModel categories;
  final int customPageSize;
  final int customCurrentPage;
  final int mainPageSize;
  final int mainCurrentPage;
  final bool customLoadMore;
  final SubCategoriesStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SubCategoriesState({
    this.appLocale = '',
    required this.categories,
    required this.customPageSize,
    required this.mainPageSize,
    this.customCurrentPage = 0,
    this.mainCurrentPage = 0,
    this.customLoadMore = false,
    this.status = SubCategoriesStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  SubCategoriesState copyWith({
    String? appLocale,
    SubCategoriesModel? categories,
    int? customPageSize,
    int? customCurrentPage,
    int? mainPageSize,
    int? mainCurrentPage,
    bool? customLoadMore,
    SubCategoriesStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return SubCategoriesState(
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
