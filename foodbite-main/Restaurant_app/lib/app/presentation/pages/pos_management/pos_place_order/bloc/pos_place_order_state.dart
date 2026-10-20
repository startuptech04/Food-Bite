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

part of 'pos_place_order_bloc.dart';

enum PosPlaceOrderStatus { loading, initial, empty, success, failure, customError, cartUpdate, cartError, removeDiscount, placingOrder, orderPlaced }

extension PosPlaceOrderStatusX on PosPlaceOrderStatus {
  bool get isLoading => this == PosPlaceOrderStatus.loading;
  bool get isInitial => this == PosPlaceOrderStatus.initial;
  bool get isEmpty => this == PosPlaceOrderStatus.empty;
  bool get isSuccess => this == PosPlaceOrderStatus.success;
  bool get isFailure => this == PosPlaceOrderStatus.failure;
  bool get isCustomError => this == PosPlaceOrderStatus.customError;
  bool get isCartUpdate => this == PosPlaceOrderStatus.cartUpdate;
  bool get isCartError => this == PosPlaceOrderStatus.cartError;
  bool get isRemoveDiscount => this == PosPlaceOrderStatus.removeDiscount;
  bool get isPlacingOrder => this == PosPlaceOrderStatus.placingOrder;
  bool get isOrderPlaced => this == PosPlaceOrderStatus.orderPlaced;
}

final class PosPlaceOrderState {
  final PosOrderSettingModel model;
  final List<PosFoodInCartModel> inCart;
  final String discountType;
  final List<PosDiscountTypeModel> discountTypeList;
  final String customerType;
  final List<PosCustomerTypeModel> customerTypeList;
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
  final PosOrderCustomerFormNameField customerName;
  final PosOrderCustomerFormCountryCodeField customerCountryCode;
  final String flag;
  final PosOrderCustomerFormNumberField customerContact;
  final PosOrderResponseModel orderInfo;
  final bool isValid;
  final PosPlaceOrderStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PosPlaceOrderState({
    required this.model,
    this.inCart = const [],
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
    this.customerName = const PosOrderCustomerFormNameField.pure(),
    this.customerCountryCode = const PosOrderCustomerFormCountryCodeField.pure(),
    this.flag = '',
    this.customerContact = const PosOrderCustomerFormNumberField.pure(),
    required this.orderInfo,
    this.isValid = false,
    this.status = PosPlaceOrderStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  PosPlaceOrderState copyWith({
    PosOrderSettingModel? model,
    List<PosFoodInCartModel>? inCart,
    String? discountType,
    List<PosDiscountTypeModel>? discountTypeList,
    String? customerType,
    List<PosCustomerTypeModel>? customerTypeList,
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
    PosOrderCustomerFormNameField? customerName,
    PosOrderCustomerFormCountryCodeField? customerCountryCode,
    String? flag,
    PosOrderCustomerFormNumberField? customerContact,
    PosOrderResponseModel? orderInfo,
    bool? isValid,
    PosPlaceOrderStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return PosPlaceOrderState(
      model: model ?? this.model,
      inCart: inCart ?? this.inCart,
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
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}

class PosDiscountTypeModel {
  String? label;
  String? value;

  PosDiscountTypeModel({this.label, this.value});

  PosDiscountTypeModel.fromJson(Map<String, dynamic> json) {
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

class PosCustomerTypeModel {
  String? label;
  String? value;

  PosCustomerTypeModel({this.label, this.value});

  PosCustomerTypeModel.fromJson(Map<String, dynamic> json) {
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
