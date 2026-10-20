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

part of 'manage_payout_method_bloc.dart';

enum ManagePayoutMethodStatus { loading, success, failure, empty, changeDetail, submit, submitSuccess, submitFailed, update, updateSuccess, updateFailed, customError }

extension ManagePayoutMethodStatusX on ManagePayoutMethodStatus {
  bool get isLoading => this == ManagePayoutMethodStatus.loading;
  bool get isSuccess => this == ManagePayoutMethodStatus.success;
  bool get isFailure => this == ManagePayoutMethodStatus.failure;
  bool get isEmpty => this == ManagePayoutMethodStatus.empty;
  bool get isChangeDetail => this == ManagePayoutMethodStatus.changeDetail;
  bool get isSubmit => this == ManagePayoutMethodStatus.submit;
  bool get isSubmitSuccess => this == ManagePayoutMethodStatus.submitSuccess;
  bool get isSubmitFailed => this == ManagePayoutMethodStatus.submitFailed;
  bool get isUpdate => this == ManagePayoutMethodStatus.update;
  bool get isUpdateSuccess => this == ManagePayoutMethodStatus.updateSuccess;
  bool get isUpdateFailed => this == ManagePayoutMethodStatus.updateFailed;
  bool get isCustomError => this == ManagePayoutMethodStatus.customError;
}

final class ManagePayoutMethodState {
  final bool isNew;
  final String methodId;
  final String payoutId;
  final String flag;
  final String countryCode;
  final List<PayoutMethodConfigModel> methods;
  final List<FormElementConfigModel> formField;
  final PayoutMethodDetailModel detail;
  final bool isFormSubmitted;
  final ManagePayoutMethodStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ManagePayoutMethodState({
    this.isNew = false,
    this.methodId = '',
    this.payoutId = '',
    this.flag = '',
    this.countryCode = '',
    this.methods = const [],
    this.formField = const [],
    required this.detail,
    this.isFormSubmitted = false,
    this.status = ManagePayoutMethodStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ManagePayoutMethodState copyWith({
    bool? isNew,
    String? methodId,
    String? payoutId,
    String? flag,
    String? countryCode,
    List<PayoutMethodConfigModel>? methods,
    List<FormElementConfigModel>? formField,
    PayoutMethodDetailModel? detail,
    bool? isFormSubmitted,
    ManagePayoutMethodStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ManagePayoutMethodState(
      isNew: isNew ?? this.isNew,
      methodId: methodId ?? this.methodId,
      payoutId: payoutId ?? this.payoutId,
      flag: flag ?? this.flag,
      countryCode: countryCode ?? this.countryCode,
      methods: methods ?? this.methods,
      formField: formField ?? this.formField,
      detail: detail ?? this.detail,
      isFormSubmitted: isFormSubmitted ?? this.isFormSubmitted,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class FormElementConfigModel {
  bool? isRequired;
  String? fieldType;
  String? fieldName;
  String? placeholder;
  String? value;
  String? extraValue;

  FormElementConfigModel({this.isRequired, this.fieldType, this.fieldName, this.placeholder, this.value, this.extraValue});

  FormElementConfigModel.fromJson(Map<String, dynamic> json) {
    isRequired = json['isRequired'];
    fieldType = json['fieldType'];
    fieldName = json['fieldName'];
    placeholder = json['placeholder'];
    value = json['value'];
    extraValue = json['extraValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRequired'] = isRequired;
    data['fieldType'] = fieldType;
    data['fieldName'] = fieldName;
    data['placeholder'] = placeholder;
    data['value'] = value;
    data['extraValue'] = extraValue;
    return data;
  }
}
