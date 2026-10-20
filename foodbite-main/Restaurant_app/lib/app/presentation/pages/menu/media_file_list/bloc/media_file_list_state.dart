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

part of 'media_file_list_bloc.dart';

enum MediaFileListStatus { loading, success, failure, empty }

extension MediaFileListStatusX on MediaFileListStatus {
  bool get isLoading => this == MediaFileListStatus.loading;
  bool get isSuccess => this == MediaFileListStatus.success;
  bool get isFailure => this == MediaFileListStatus.failure;
  bool get isEmpty => this == MediaFileListStatus.empty;
}

final class MediaFileListState {
  final VendorMediaListModel medias;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final MediaFileListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const MediaFileListState({
    required this.medias,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = MediaFileListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  MediaFileListState copyWith({VendorMediaListModel? medias, int? pageSize, int? currentPage, bool? loadMore, MediaFileListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return MediaFileListState(
      medias: medias ?? this.medias,
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
