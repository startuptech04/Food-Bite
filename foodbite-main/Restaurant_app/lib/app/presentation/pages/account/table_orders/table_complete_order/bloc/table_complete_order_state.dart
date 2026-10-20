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

part of 'table_complete_order_bloc.dart';

enum TableCompleteOrderStatus { initial, loading, success, failure, empty, customError, removeDiscount, placingOrder, orderPlaced }

extension TableCompleteOrderStatusX on TableCompleteOrderStatus {
  bool get isInitial => this == TableCompleteOrderStatus.initial;
  bool get isLoading => this == TableCompleteOrderStatus.loading;
  bool get isSuccess => this == TableCompleteOrderStatus.success;
  bool get isFailure => this == TableCompleteOrderStatus.failure;
  bool get isEmpty => this == TableCompleteOrderStatus.empty;
  bool get isCustomError => this == TableCompleteOrderStatus.customError;
  bool get isRemoveDiscount => this == TableCompleteOrderStatus.removeDiscount;
  bool get isPlacingOrder => this == TableCompleteOrderStatus.placingOrder;
  bool get isOrderPlaced => this == TableCompleteOrderStatus.orderPlaced;
}

final class TableCompleteOrderState {
  final int tableNumber;
  final String tableId;
  final OngoingTableOrderDetailModel model;
  final String discountType;
  final List<TableOrderDiscountTypeModel> discountTypeList;
  final String customerType;
  final List<TableOrderCustomerTypeModel> customerTypeList;
  final double itemTotal;
  final double realPrice;
  final double itemDiscount;
  final double serviceCharge;
  final String serviceChargeName;
  final double foodServiceCharge;
  final String foodServiceChargeName;
  final double packagingCharges;
  final double packagingChargesTax;
  final double discountAmount;
  final double usedDiscountPrice;
  final double grandTotal;
  final String paymentMode;
  final TableOrderCustomerFormNameField customerName;
  final TableOrderCustomerFormCountryCodeField customerCountryCode;
  final String flag;
  final TableOrderCustomerFormNumberField customerContact;
  final bool isValid;
  final TableOrderResponseModel orderInfo;
  final TableCompleteOrderStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TableCompleteOrderState({
    this.tableNumber = 0,
    this.tableId = '',
    required this.model,
    this.discountType = '',
    this.discountTypeList = const [],
    this.customerType = '',
    this.customerTypeList = const [],
    this.itemTotal = 0,
    this.realPrice = 0,
    this.itemDiscount = 0,
    this.serviceCharge = 0,
    this.serviceChargeName = '',
    this.foodServiceCharge = 0,
    this.foodServiceChargeName = '',
    this.packagingCharges = 0,
    this.packagingChargesTax = 0,
    this.discountAmount = 0,
    this.usedDiscountPrice = 0,
    this.grandTotal = 0,
    this.paymentMode = 'offline',
    this.customerName = const TableOrderCustomerFormNameField.pure(),
    this.customerCountryCode = const TableOrderCustomerFormCountryCodeField.pure(),
    this.flag = '',
    this.customerContact = const TableOrderCustomerFormNumberField.pure(),
    required this.orderInfo,
    this.isValid = false,
    this.status = TableCompleteOrderStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  TableCompleteOrderState copyWith({
    int? tableNumber,
    String? tableId,
    OngoingTableOrderDetailModel? model,
    String? discountType,
    List<TableOrderDiscountTypeModel>? discountTypeList,
    String? customerType,
    List<TableOrderCustomerTypeModel>? customerTypeList,
    double? itemTotal,
    double? realPrice,
    double? itemDiscount,
    double? serviceCharge,
    String? serviceChargeName,
    double? foodServiceCharge,
    String? foodServiceChargeName,
    double? packagingCharges,
    double? packagingChargesTax,
    double? discountAmount,
    double? usedDiscountPrice,
    double? grandTotal,
    String? paymentMode,
    TableOrderCustomerFormNameField? customerName,
    TableOrderCustomerFormCountryCodeField? customerCountryCode,
    String? flag,
    TableOrderCustomerFormNumberField? customerContact,
    TableOrderResponseModel? orderInfo,
    bool? isValid,
    TableCompleteOrderStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return TableCompleteOrderState(
      tableNumber: tableNumber ?? this.tableNumber,
      tableId: tableId ?? this.tableId,
      model: model ?? this.model,
      discountType: discountType ?? this.discountType,
      discountTypeList: discountTypeList ?? this.discountTypeList,
      customerType: customerType ?? this.customerType,
      customerTypeList: customerTypeList ?? this.customerTypeList,
      itemTotal: itemTotal ?? this.itemTotal,
      realPrice: realPrice ?? this.realPrice,
      itemDiscount: itemDiscount ?? this.itemDiscount,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      serviceChargeName: serviceChargeName ?? this.serviceChargeName,
      foodServiceCharge: foodServiceCharge ?? this.foodServiceCharge,
      foodServiceChargeName: foodServiceChargeName ?? this.foodServiceChargeName,
      packagingCharges: packagingCharges ?? this.packagingCharges,
      packagingChargesTax: packagingChargesTax ?? this.packagingChargesTax,
      discountAmount: discountAmount ?? this.discountAmount,
      usedDiscountPrice: usedDiscountPrice ?? this.usedDiscountPrice,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMode: paymentMode ?? this.paymentMode,
      customerName: customerName ?? this.customerName,
      customerCountryCode: customerCountryCode ?? this.customerCountryCode,
      flag: flag ?? this.flag,
      customerContact: customerContact ?? this.customerContact,
      orderInfo: orderInfo ?? this.orderInfo,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class TableOrderDiscountTypeModel {
  String? label;
  String? value;

  TableOrderDiscountTypeModel({this.label, this.value});

  TableOrderDiscountTypeModel.fromJson(Map<String, dynamic> json) {
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

class TableOrderCustomerTypeModel {
  String? label;
  String? value;

  TableOrderCustomerTypeModel({this.label, this.value});

  TableOrderCustomerTypeModel.fromJson(Map<String, dynamic> json) {
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
