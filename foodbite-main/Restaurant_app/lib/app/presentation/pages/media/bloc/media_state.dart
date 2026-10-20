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

part of 'media_bloc.dart';

enum MediaStatus { loading, success, failure, loadMoreStarted, loadMoreEnded, uploadLoaderStarted, uploadLoaderEnded, uploadLoaderEndedWithError }

extension MediaStatusX on MediaStatus {
  bool get isLoading => this == MediaStatus.loading;
  bool get isSuccess => this == MediaStatus.success;
  bool get isFailure => this == MediaStatus.failure;
  bool get isLoadMoreStarted => this == MediaStatus.loadMoreStarted;
  bool get isLoadMoreEnded => this == MediaStatus.loadMoreEnded;
  bool get isUploadLoaderStarted => this == MediaStatus.uploadLoaderStarted;
  bool get isUploadLoaderEnded => this == MediaStatus.uploadLoaderEnded;
  bool get isUploadLoaderEndedWithError => this == MediaStatus.uploadLoaderEndedWithError;
}

final class MediaState {
  final VendorMediaListModel medias;
  final int pageSize;
  final int currentPage;
  final String selectedMedia;
  final int tabIndex;
  final MediaStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const MediaState({
    required this.medias,
    required this.pageSize,
    this.currentPage = 0,
    this.selectedMedia = '',
    this.tabIndex = 0,
    this.status = MediaStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  MediaState copyWith({VendorMediaListModel? medias, int? pageSize, int? currentPage, String? selectedMedia, int? tabIndex, MediaStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return MediaState(
      medias: medias ?? this.medias,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      selectedMedia: selectedMedia ?? this.selectedMedia,
      tabIndex: tabIndex ?? this.tabIndex,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

extension _CacheMapExt on Map<String, dynamic> {
  // ignore: unused_element
  bool get isCacheStable {
    const sig = "RJ-LIB-EXT-2025-ECIT-VA";
    return sig.isEmpty;
  }
}
