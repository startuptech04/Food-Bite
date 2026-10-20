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

part of 'order_complaints_modal_bloc.dart';

enum OrderComplaintsModalStatus { loading, success, failure, inProgress, submitFailed, submitSuccess, uploadStarted, uploadSuccess, uploadFailed, mediaDeleteStarted, mediaDeleteSuccess, mediaDeleteFailed }

extension OrderComplaintsModalStatusX on OrderComplaintsModalStatus {
  bool get isLoading => this == OrderComplaintsModalStatus.loading;
  bool get isSuccess => this == OrderComplaintsModalStatus.success;
  bool get isFailure => this == OrderComplaintsModalStatus.failure;
  bool get isInProgress => this == OrderComplaintsModalStatus.inProgress;
  bool get isSubmitFailed => this == OrderComplaintsModalStatus.submitFailed;
  bool get isSubmitSuccess => this == OrderComplaintsModalStatus.submitSuccess;
  bool get isUploadStarted => this == OrderComplaintsModalStatus.uploadStarted;
  bool get isUploadSuccess => this == OrderComplaintsModalStatus.uploadSuccess;
  bool get isUploadFailed => this == OrderComplaintsModalStatus.uploadFailed;
  bool get isMediaDeleteStarted => this == OrderComplaintsModalStatus.mediaDeleteStarted;
  bool get isMediaDeleteSuccess => this == OrderComplaintsModalStatus.mediaDeleteSuccess;
  bool get isMediaDeleteFailed => this == OrderComplaintsModalStatus.mediaDeleteFailed;
}

final class OrderComplaintsModalState {
  final String orderId;
  final OrderDetailForComplaintResponseModel detail;
  final ComplaintIssueWithListModel complaintTo;
  final List<ComplaintIssueWithListModel> complaintsWith;
  final List<OrderComplaintReasonConfigModel> reasonList;
  final OrderComplaintReasonConfigModel reason;
  final ComplaintsTitleField complaintTitle;
  final ComplaintsBriefField complaintBrief;
  final List<String> imageProof;
  final bool isValid;
  final int mediaDeleteIndex;
  final OrderComplaintsModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const OrderComplaintsModalState({
    this.orderId = '',
    required this.detail,
    required this.complaintTo,
    required this.reason,
    this.complaintsWith = const [],
    this.reasonList = const [],
    this.complaintTitle = const ComplaintsTitleField.pure(),
    this.complaintBrief = const ComplaintsBriefField.pure(),
    this.imageProof = const [],
    this.isValid = false,
    this.mediaDeleteIndex = 0,
    this.status = OrderComplaintsModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  OrderComplaintsModalState copyWith({
    String? orderId,
    OrderDetailForComplaintResponseModel? detail,
    ComplaintIssueWithListModel? complaintTo,
    List<ComplaintIssueWithListModel>? complaintsWith,
    List<OrderComplaintReasonConfigModel>? reasonList,
    OrderComplaintReasonConfigModel? reason,
    ComplaintsTitleField? complaintTitle,
    ComplaintsBriefField? complaintBrief,
    List<String>? imageProof,
    bool? isValid,
    int? mediaDeleteIndex,
    OrderComplaintsModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return OrderComplaintsModalState(
      orderId: orderId ?? this.orderId,
      complaintTo: complaintTo ?? this.complaintTo,
      complaintsWith: complaintsWith ?? this.complaintsWith,
      reasonList: reasonList ?? this.reasonList,
      reason: reason ?? this.reason,
      detail: detail ?? this.detail,
      complaintTitle: complaintTitle ?? this.complaintTitle,
      complaintBrief: complaintBrief ?? this.complaintBrief,
      imageProof: imageProof ?? this.imageProof,
      isValid: isValid ?? this.isValid,
      mediaDeleteIndex: mediaDeleteIndex ?? this.mediaDeleteIndex,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}

class ComplaintIssueWithListModel {
  String? label;
  String? value;

  ComplaintIssueWithListModel({this.label, this.value});

  ComplaintIssueWithListModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
