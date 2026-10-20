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

part of 'addons_bloc.dart';

enum AddonStatus { loading, success, failure, deleteLoaderStarted, deleteLoaderEnded, deleteLoaderEndedWithError }

extension AddonStatusX on AddonStatus {
  bool get isLoading => this == AddonStatus.loading;
  bool get isSuccess => this == AddonStatus.success;
  bool get isFailure => this == AddonStatus.failure;
  bool get isDeleteLoaderStarted => this == AddonStatus.deleteLoaderStarted;
  bool get isDeleteLoaderEnded => this == AddonStatus.deleteLoaderEnded;
  bool get isDeleteLoaderEndedWithError => this == AddonStatus.deleteLoaderEndedWithError;
}

final class AddonsState {
  final String appLocale;
  final AddonListModel addons;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final AddonStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const AddonsState({
    this.appLocale = '',
    required this.addons,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = AddonStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  AddonsState copyWith({String? appLocale, AddonListModel? addons, int? pageSize, int? currentPage, bool? loadMore, AddonStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return AddonsState(
      appLocale: appLocale ?? this.appLocale,
      addons: addons ?? this.addons,
      pageSize: pageSize ?? this.pageSize,
      loadMore: loadMore ?? this.loadMore,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
