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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:formz/formz.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/ongoing_table_order_detail_model.dart';
import 'package:vendor/app/core/models/request/complete_table_order_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/table_order_response_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/table_order_repository.dart';
import 'package:vendor/app/core/validations/table_order_customer_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_complete_order_event.dart';
part 'table_complete_order_state.dart';

class TableCompleteOrderBloc extends Bloc<TableCompleteOrderEvent, TableCompleteOrderState> {
  final TableOrderRepository _tableOrderRepository = TableOrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TableCompleteOrderBloc()
    : super(
        TableCompleteOrderState(
          orderInfo: TableOrderResponseModel(id: '', success: false),
          model: OngoingTableOrderDetailModel(items: [], success: false, locale: ''),
        ),
      ) {
    on<TableCompleteOrderInitialEvent>(_onTableCompleteOrderInitialEvent);
    on<TableCompleteOrderRemovePriceEvent>(_onTableCompleteOrderRemovePriceEvent);
    on<TableCompleteOrderDeleteItemEvent>(_onTableCompleteOrderDeleteItemEvent);
    on<TableCompleteOrderDiscountTypeChangedEvent>(_onTableCompleteOrderDiscountTypeChangedEvent);
    on<TableCompleteOrderDiscountChangedEvent>(_onTableCompleteOrderDiscountChangedEvent);
    on<TableCompleteOrderCustomerTypeChangeEvent>(_onTableCompleteOrderCustomerTypeChangeEvent);
    on<TableCompleteOrderPaymentModelChangeEvent>(_onTableCompleteOrderPaymentModelChangeEvent);
    on<TableCompleteOrderCustomerNameUnfocusedEvent>(_onTableCompleteOrderCustomerNameUnfocusedEvent);
    on<TableCompleteOrderCustomerNumberUnfocusedEvent>(_onTableCompleteOrderCustomerNumberUnfocusedEvent);
    on<TableCompleteOrderCustomerNameChangedEvent>(_onTableCompleteOrderCustomerNameChangedEvent);
    on<TableCompleteOrderCustomerCountryCodeChangedEvent>(_onTableCompleteOrderCustomerCountryCodeChangedEvent);
    on<TableCompleteOrderCustomerNumberChangedEvent>(_onTableCompleteOrderCustomerNumberChangedEvent);
    on<TableCompleteOrderCompleteOrderEvent>(_onTableCompleteOrderCompleteOrderEvent);
  }

  FutureOr<void> _onTableCompleteOrderInitialEvent(TableCompleteOrderInitialEvent event, Emitter<TableCompleteOrderState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "complete_table_order"}, 'complete_table_order_screen', 'complete_table_order_screen');
      emit(state.copyWith(status: TableCompleteOrderStatus.loading, tableNumber: event.tableNumber, tableId: event.tableId));
      DioApiResponse response = await _tableOrderRepository.onGoingTableOrderDetail(event.tableId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          OngoingTableOrderDetailModel data = OngoingTableOrderDetailModel.fromJson(myMap, locale.toString());
          for (var element in data.items!) {
            double offerPrice = 0;
            double price = element.foodInfo!.price!;
            if (element.foodInfo!.taxationEnable!) {
              double taxPercentage = 0;
              for (var taxConfig in element.foodtaxations!) {
                taxPercentage = (taxPercentage + taxConfig.taxAmount!);
              }
              if (taxPercentage > 0) {
                double basePrice = price;
                String finalPriceString = (basePrice + (taxPercentage / 100) * basePrice).toStringAsFixed(2);
                double finalPrice = double.parse(finalPriceString);
                price = finalPrice;
              }
            }
            for (var savedAddon in element.addons!) {
              price = price + savedAddon.price!;
            }
            for (var savedVariation in element.variations!) {
              for (var selectedOption in savedVariation.selected!) {
                for (var foodVariation in element.foodInfo!.foodVariations!) {
                  for (var foodOptions in foodVariation.options!) {
                    if (savedVariation.variation! == foodVariation.title! && selectedOption == foodOptions.name!) {
                      price = price + foodOptions.price!;
                    }
                  }
                }
              }
            }

            double discount = element.foodInfo!.discount!;
            double itemDiscountAmount = 0;
            if (discount > 0) {
              if (element.foodInfo!.discountType! == '%') {
                String discountValue = (double.parse(price.toString()) - (double.parse(price.toString()) * double.parse(discount.toString()) / 100)).toStringAsFixed(2);
                offerPrice = double.parse(discountValue);
                String itemDiscountAmountString = (double.parse(price.toString()) - double.parse(discountValue)).toStringAsFixed(2);
                itemDiscountAmount = double.parse(itemDiscountAmountString);
              } else {
                String discountValue = (double.parse(price.toString()) - double.parse(discount.toString())).toStringAsFixed(2);
                offerPrice = double.parse(discountValue);
                String itemDiscountAmountString = (double.parse(discount.toString())).toStringAsFixed(2);
                itemDiscountAmount = double.parse(itemDiscountAmountString);
              }
            } else {
              offerPrice = double.parse(price.toString());
            }
            String finalRealPrice = (price * element.quantity!).toStringAsFixed(2);
            element.realPrice = double.parse(finalRealPrice);
            String finalOfferPrice = (offerPrice * element.quantity!).toStringAsFixed(2);
            element.itemPrice = double.parse(finalOfferPrice);
            String finalDiscountPrice = (itemDiscountAmount * element.quantity!).toStringAsFixed(2);
            element.discountPrice = double.parse(finalDiscountPrice);

            List<String> optionNameList = <String>[];
            optionNameList.clear();
            for (var addon in element.addons!) {
              optionNameList.add(addon.name!);
            }
            for (var variation in element.variations!) {
              for (var selected in variation.selected!) {
                optionNameList.add(selected);
              }
            }
            element.optionName = optionNameList.join(',');
          }

          double realTotal = 0;
          double itemTotal = 0;
          double itemDiscount = 0;
          for (var element in data.items!) {
            String countRealTotal = (double.parse(realTotal.toString()) + double.parse(element.realPrice.toString())).toStringAsFixed(2);
            realTotal = double.parse(countRealTotal);
            String countTotal = (double.parse(itemTotal.toString()) + double.parse(element.itemPrice.toString())).toStringAsFixed(2);
            itemTotal = double.parse(countTotal);
            String countDiscountTotal = (double.parse(itemDiscount.toString()) + double.parse(element.discountPrice.toString())).toStringAsFixed(2);
            itemDiscount = double.parse(countDiscountTotal);
          }

          String defaultCountryCode = '';
          String flag = '';
          await _accountRepository.getDefaultCountryCode().then((value) {
            if (value != '' && value.isNotEmpty) {
              try {
                Map<String, dynamic>? myMap = jsonDecode(value) as Map<String, dynamic>;
                AppDefaultCountryCodeConfigModel countryCodeData = AppDefaultCountryCodeConfigModel.fromJson(myMap);
                defaultCountryCode = countryCodeData.dialCode!;
                flag = countryCodeData.flag!;
              } catch (e, stacktrace) {
                if (!kIsWeb) {
                  FirebaseCrashlytics.instance.recordError(e, stacktrace);
                }
              }
            }
          });

          const name = TableOrderCustomerFormNameField.dirty('none');
          const number = TableOrderCustomerFormNumberField.dirty('none');
          final countryCode = TableOrderCustomerFormCountryCodeField.dirty(defaultCountryCode);
          emit(
            state.copyWith(
              customerName: name.isValid ? name : const TableOrderCustomerFormNameField.pure(''),
              customerCountryCode: countryCode.isValid ? countryCode : const TableOrderCustomerFormCountryCodeField.pure(),
              flag: flag,
              customerContact: number.isValid ? number : const TableOrderCustomerFormNumberField.pure(''),
              status: TableCompleteOrderStatus.initial,
              isValid: Formz.validate([name, number, countryCode]),
            ),
          );

          List<TableOrderDiscountTypeModel> discountTypeList = <TableOrderDiscountTypeModel>[];
          discountTypeList.clear();
          TableOrderDiscountTypeModel percent = TableOrderDiscountTypeModel(label: 'dd_percent_price', value: 'per');
          TableOrderDiscountTypeModel amount = TableOrderDiscountTypeModel(label: 'dd_amount_price', value: 'amount');
          discountTypeList.add(percent);
          discountTypeList.add(amount);

          List<TableOrderCustomerTypeModel> customerTypeList = <TableOrderCustomerTypeModel>[];
          customerTypeList.clear();
          TableOrderCustomerTypeModel guestCustomer = TableOrderCustomerTypeModel(label: 'dd_guest_customer', value: 'guest');
          TableOrderCustomerTypeModel regularCustomer = TableOrderCustomerTypeModel(label: 'dd_regular_customer', value: 'regular');
          customerTypeList.add(guestCustomer);
          customerTypeList.add(regularCustomer);

          emit(state.copyWith(model: data, itemTotal: itemTotal, realPrice: realTotal, itemDiscount: itemDiscount));
          emit(
            state.copyWith(
              grandTotal: calculateGrandTotal(),
              foodServiceCharge: calculateFoodTax(),
              foodServiceChargeName: data.business!.foodTaxName!,
              serviceCharge: calculateServiceCharges(),
              serviceChargeName: data.business!.additionalServiceName!,
              packagingCharges: calculatePackagingCharges(),
              packagingChargesTax: calculatePackageTaxCharges(),
              discountTypeList: discountTypeList,
              discountType: 'per',
              customerTypeList: customerTypeList,
              customerType: 'guest',
            ),
          );
          emit(state.copyWith(status: TableCompleteOrderStatus.success));
        } else {
          emit(state.copyWith(status: TableCompleteOrderStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableCompleteOrderStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableCompleteOrderStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  double calculateGrandTotal() {
    double grandTotal = 0.0;
    final double itemTotal = double.parse(state.itemTotal.toString());
    final double taxCharge = double.parse(calculateFoodTax().toString());
    final double serviceCharge = double.parse(calculateServiceCharges().toString());
    final double packagingCharges = double.parse(calculatePackagingCharges().toString());
    final double packagingChargesTax = double.parse(calculatePackageTaxCharges().toString());
    final double discount = double.parse(state.discountAmount.toString());
    String total = (itemTotal + taxCharge + serviceCharge + packagingCharges + packagingChargesTax).toStringAsFixed(2);
    double subTotal = double.parse(total);
    String grandCount = (subTotal - discount).toStringAsFixed(2);
    grandTotal = double.parse(grandCount);
    return grandTotal;
  }

  double calculateFoodTax() {
    double taxCharge = 0.0;
    if (state.model.business!.includeTaxOnFood!) {
      if (state.model.business!.foodTaxType! == 'per') {
        double percentage(numFirst, per) {
          return (numFirst / 100) * per;
        }

        String total = (double.parse(percentage(state.itemTotal, state.model.business!.foodTaxAmount!).toString())).toStringAsFixed(2);
        taxCharge = double.parse(total);
      } else {
        taxCharge = state.model.business!.foodTaxAmount!;
      }
    }
    return taxCharge;
  }

  double calculateServiceCharges() {
    double serviceCharge = 0.0;
    if (state.model.business!.additionalServiceCharge!) {
      serviceCharge = state.model.business!.additionalServiceAmount!;
    }
    return serviceCharge;
  }

  double calculatePackagingCharges() {
    double packagingCharges = 0.0;
    if (state.model.packaging!.havePackagingCharges!) {
      packagingCharges = state.model.packaging!.packagingCharges!;
    }
    return packagingCharges;
  }

  double calculatePackageTaxCharges() {
    double packagingChargesTax = 0.0;
    if (state.model.packaging!.havePackagingCharges!) {
      if (state.model.packaging!.includePackagesChargesInTax!) {
        double percentage(numFirst, per) {
          return (numFirst / 100) * per;
        }

        String total = (double.parse(percentage(state.model.packaging!.packagingCharges!, state.model.packaging!.packagingChargesTax!).toString())).toStringAsFixed(2);
        packagingChargesTax = double.parse(total);
      }
    }
    return packagingChargesTax;
  }

  FutureOr<void> _onTableCompleteOrderRemovePriceEvent(TableCompleteOrderRemovePriceEvent event, Emitter<TableCompleteOrderState> emit) async {
    if (event.priceName == 'foodServiceCharge') {
      state.model.business!.foodTaxAmount = 0;
    } else if (event.priceName == 'serviceCharge') {
      state.model.business!.additionalServiceAmount = 0;
    } else if (event.priceName == 'packageCharge') {
      state.model.packaging!.packagingCharges = 0;
    } else if (event.priceName == 'packageChargeTax') {
      state.model.packaging!.packagingChargesTax = 0;
    } else if (event.priceName == 'discount') {
      emit(state.copyWith(discountAmount: 0, status: TableCompleteOrderStatus.removeDiscount));
    }
    emit(state.copyWith(model: state.model));
    emit(
      state.copyWith(
        status: TableCompleteOrderStatus.success,
        grandTotal: calculateGrandTotal(),
        foodServiceCharge: calculateFoodTax(),
        serviceCharge: calculateServiceCharges(),
        packagingCharges: calculatePackagingCharges(),
        packagingChargesTax: calculatePackageTaxCharges(),
      ),
    );
  }

  FutureOr<void> _onTableCompleteOrderDeleteItemEvent(TableCompleteOrderDeleteItemEvent event, Emitter<TableCompleteOrderState> emit) async {
    try {
      final int indexOfItemId = state.model.items!.indexWhere((element) => element.id! == event.itemId);
      if (indexOfItemId != -1) {
        DioApiResponse response = await _tableOrderRepository.deleteTableOrderCartItem(event.itemId);
        if (response.errorType == NetErrorType.none) {
          state.model.items!.removeAt(indexOfItemId);
          emit(state.copyWith(model: state.model));
          double realTotal = 0;
          double itemTotal = 0;
          double itemDiscount = 0;
          for (var element in state.model.items!) {
            String countRealTotal = (double.parse(realTotal.toString()) + double.parse(element.realPrice.toString())).toStringAsFixed(2);
            realTotal = double.parse(countRealTotal);
            String countTotal = (double.parse(itemTotal.toString()) + double.parse(element.itemPrice.toString())).toStringAsFixed(2);
            itemTotal = double.parse(countTotal);
            String countDiscountTotal = (double.parse(itemDiscount.toString()) + double.parse(element.discountPrice.toString())).toStringAsFixed(2);
            itemDiscount = double.parse(countDiscountTotal);
          }
          emit(state.copyWith(itemTotal: itemTotal, realPrice: realTotal, itemDiscount: itemDiscount));
          emit(
            state.copyWith(
              grandTotal: calculateGrandTotal(),
              foodServiceCharge: calculateFoodTax(),
              serviceCharge: calculateServiceCharges(),
              packagingCharges: calculatePackagingCharges(),
              packagingChargesTax: calculatePackageTaxCharges(),
              status: TableCompleteOrderStatus.success,
            ),
          );
          if (state.model.items!.isEmpty) {
            emit(state.copyWith(status: TableCompleteOrderStatus.empty));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: TableCompleteOrderStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableCompleteOrderStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableCompleteOrderDiscountTypeChangedEvent(TableCompleteOrderDiscountTypeChangedEvent event, Emitter<TableCompleteOrderState> emit) async {
    emit(state.copyWith(discountType: event.value));
    double discountAmount = 0;
    if (state.discountType == 'amount') {
      discountAmount = state.usedDiscountPrice;
    } else if (state.discountType == 'per') {
      double percentage(numFirst, per) {
        return (numFirst / 100) * per;
      }

      String discountString = (double.parse(percentage(state.itemTotal, state.usedDiscountPrice).toString())).toStringAsFixed(2);
      discountAmount = double.parse(discountString);
    }
    emit(state.copyWith(discountAmount: discountAmount));
    emit(state.copyWith(grandTotal: calculateGrandTotal(), foodServiceCharge: calculateFoodTax(), serviceCharge: calculateServiceCharges(), status: TableCompleteOrderStatus.success));
  }

  FutureOr<void> _onTableCompleteOrderDiscountChangedEvent(TableCompleteOrderDiscountChangedEvent event, Emitter<TableCompleteOrderState> emit) async {
    if (event.discount.isNotEmpty) {
      emit(state.copyWith(usedDiscountPrice: double.parse(event.discount)));
      double discountAmount = 0;
      if (state.discountType == 'amount') {
        discountAmount = state.usedDiscountPrice;
      } else if (state.discountType == 'per') {
        double percentage(numFirst, per) {
          return (numFirst / 100) * per;
        }

        String discountString = (double.parse(percentage(state.itemTotal, state.usedDiscountPrice).toString())).toStringAsFixed(2);
        discountAmount = double.parse(discountString);
      }
      emit(state.copyWith(discountAmount: discountAmount));
      emit(state.copyWith(grandTotal: calculateGrandTotal(), foodServiceCharge: calculateFoodTax(), serviceCharge: calculateServiceCharges(), status: TableCompleteOrderStatus.success));
    } else {
      emit(state.copyWith(discountAmount: 0, usedDiscountPrice: 0));
      emit(state.copyWith(grandTotal: calculateGrandTotal(), foodServiceCharge: calculateFoodTax(), serviceCharge: calculateServiceCharges(), status: TableCompleteOrderStatus.success));
    }
  }

  FutureOr<void> _onTableCompleteOrderCustomerTypeChangeEvent(TableCompleteOrderCustomerTypeChangeEvent event, Emitter<TableCompleteOrderState> emit) async {
    if (event.value == 'regular') {
      const customerName = TableOrderCustomerFormNameField.dirty('');
      const customerMobileNumber = TableOrderCustomerFormNumberField.dirty('');
      final customerCountryCode = TableOrderCustomerFormCountryCodeField.dirty(state.customerCountryCode.value);
      emit(
        state.copyWith(
          customerName: customerName.isValid ? customerName : const TableOrderCustomerFormNameField.pure(''),
          customerCountryCode: customerCountryCode.isValid ? customerCountryCode : const TableOrderCustomerFormCountryCodeField.pure(''),
          customerContact: customerMobileNumber.isValid ? customerMobileNumber : const TableOrderCustomerFormNumberField.pure(''),
          status: TableCompleteOrderStatus.initial,
          isValid: Formz.validate([customerName, customerMobileNumber, customerCountryCode]),
        ),
      );
    } else if (event.value == 'guest') {
      const customerName = TableOrderCustomerFormNameField.dirty('none');
      const customerMobileNumber = TableOrderCustomerFormNumberField.dirty('none');
      final customerCountryCode = TableOrderCustomerFormCountryCodeField.dirty(state.customerCountryCode.value);
      emit(
        state.copyWith(
          customerName: customerName.isValid ? customerName : const TableOrderCustomerFormNameField.pure(''),
          customerCountryCode: customerCountryCode.isValid ? customerCountryCode : const TableOrderCustomerFormCountryCodeField.pure(''),
          customerContact: customerMobileNumber.isValid ? customerMobileNumber : const TableOrderCustomerFormNumberField.pure(''),
          status: TableCompleteOrderStatus.initial,
          isValid: Formz.validate([customerName, customerMobileNumber, customerCountryCode]),
        ),
      );
    }
    emit(state.copyWith(customerType: event.value, status: TableCompleteOrderStatus.success));
  }

  FutureOr<void> _onTableCompleteOrderPaymentModelChangeEvent(TableCompleteOrderPaymentModelChangeEvent event, Emitter<TableCompleteOrderState> emit) async {
    emit(state.copyWith(paymentMode: event.payment, status: TableCompleteOrderStatus.success));
  }

  FutureOr<void> _onTableCompleteOrderCustomerNameUnfocusedEvent(TableCompleteOrderCustomerNameUnfocusedEvent event, Emitter<TableCompleteOrderState> emit) async {
    final name = TableOrderCustomerFormNameField.dirty(state.customerName.value);
    emit(state.copyWith(customerName: name, status: TableCompleteOrderStatus.initial, isValid: Formz.validate([name, state.customerContact, state.customerCountryCode])));
  }

  FutureOr<void> _onTableCompleteOrderCustomerNumberUnfocusedEvent(TableCompleteOrderCustomerNumberUnfocusedEvent event, Emitter<TableCompleteOrderState> emit) async {
    final number = TableOrderCustomerFormNumberField.dirty(state.customerContact.value);
    emit(state.copyWith(customerContact: number, status: TableCompleteOrderStatus.initial, isValid: Formz.validate([number, state.customerName, state.customerCountryCode])));
  }

  FutureOr<void> _onTableCompleteOrderCustomerNameChangedEvent(TableCompleteOrderCustomerNameChangedEvent event, Emitter<TableCompleteOrderState> emit) async {
    final name = TableOrderCustomerFormNameField.dirty(event.name);
    emit(
      state.copyWith(
        customerName: name.isValid ? name : TableOrderCustomerFormNameField.pure(event.name),
        status: TableCompleteOrderStatus.initial,
        isValid: Formz.validate([name, state.customerContact, state.customerCountryCode]),
      ),
    );
  }

  FutureOr<void> _onTableCompleteOrderCustomerCountryCodeChangedEvent(TableCompleteOrderCustomerCountryCodeChangedEvent event, Emitter<TableCompleteOrderState> emit) async {
    final countryCode = TableOrderCustomerFormCountryCodeField.dirty(event.countryCode);
    emit(state.copyWith(customerCountryCode: countryCode, flag: event.flag, status: TableCompleteOrderStatus.initial, isValid: Formz.validate([countryCode, state.customerName, state.customerContact])));
  }

  FutureOr<void> _onTableCompleteOrderCustomerNumberChangedEvent(TableCompleteOrderCustomerNumberChangedEvent event, Emitter<TableCompleteOrderState> emit) async {
    final number = TableOrderCustomerFormNumberField.dirty(event.number);
    emit(
      state.copyWith(
        customerContact: number.isValid ? number : TableOrderCustomerFormNumberField.pure(event.number),
        status: TableCompleteOrderStatus.initial,
        isValid: Formz.validate([number, state.customerName, state.customerCountryCode]),
      ),
    );
  }

  FutureOr<void> _onTableCompleteOrderCompleteOrderEvent(TableCompleteOrderCompleteOrderEvent event, Emitter<TableCompleteOrderState> emit) async {
    try {
      final customerName = TableOrderCustomerFormNameField.dirty(state.customerName.value);
      final customerNumber = TableOrderCustomerFormNumberField.dirty(state.customerContact.value);
      final customerCountryCode = TableOrderCustomerFormCountryCodeField.dirty(state.customerCountryCode.value);
      emit(
        state.copyWith(
          customerName: customerName,
          customerContact: customerNumber,
          customerCountryCode: customerCountryCode,
          status: TableCompleteOrderStatus.initial,
          isValid: Formz.validate([customerName, customerNumber, customerCountryCode]),
        ),
      );
      if (state.isValid && state.customerName.value.isNotEmpty && state.customerContact.value.isNotEmpty && state.customerCountryCode.value.isNotEmpty) {
        emit(state.copyWith(status: TableCompleteOrderStatus.placingOrder));
        CompleteTableOrderRequestModel param = CompleteTableOrderRequestModel(
          restaurant: await _tableOrderRepository.getVendorId(),
          tableId: state.tableId,
          paymentMode: state.paymentMode,
          customerType: state.customerType,
          customerName: state.customerName.value.toString(),
          customerCountryCode: state.customerCountryCode.value.toString(),
          customerMobileNumber: state.customerContact.value.toString(),
          discountType: state.discountType,
          discountAmount: state.usedDiscountPrice,
          foodServiceCharge: state.foodServiceCharge,
          serviceCharge: state.serviceCharge,
          packageCharge: state.packagingCharges,
          packageChargeTax: state.packagingChargesTax,
          extraCharge: 0,
        );
        DioApiResponse response = await _tableOrderRepository.completeTableOrder(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          TableOrderResponseModel orderResponse = TableOrderResponseModel.fromJson(myMap);
          emit(state.copyWith(status: TableCompleteOrderStatus.orderPlaced, orderInfo: orderResponse));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: TableCompleteOrderStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableCompleteOrderStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
