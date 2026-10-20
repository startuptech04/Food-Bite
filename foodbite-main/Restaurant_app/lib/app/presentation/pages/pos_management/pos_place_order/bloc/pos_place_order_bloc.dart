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
import 'package:vendor/app/core/models/pos_food_in_cart_model.dart';
import 'package:vendor/app/core/models/pos_order_response_model.dart';
import 'package:vendor/app/core/models/pos_order_setting_model.dart';
import 'package:vendor/app/core/models/request/pos_place_order_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/pos_repository.dart';
import 'package:vendor/app/core/validations/pos_order_customer_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'pos_place_order_event.dart';
part 'pos_place_order_state.dart';

class PosPlaceOrderBloc extends Bloc<PosPlaceOrderEvent, PosPlaceOrderState> {
  final PosRepository _posRepository = PosRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PosPlaceOrderBloc()
    : super(
        PosPlaceOrderState(
          model: PosOrderSettingModel(),
          orderInfo: PosOrderResponseModel(id: '', success: false),
        ),
      ) {
    on<PosPlaceOrderInitialEvent>(_onPosPlaceOrderInitialEvent);
    on<PosPlaceOrderQuantityEvent>(_onPosPlaceOrderQuantityEvent);
    on<PosPlaceOrderRemovePriceEvent>(_onPosPlaceOrderRemovePriceEvent);
    on<PosPlaceOrderDiscountTypeChangedEvent>(_onPosPlaceOrderDiscountTypeChangedEvent);
    on<PosPlaceOrderDiscountChangedEvent>(_onPosPlaceOrderDiscountChangedEvent);
    on<PosPlaceOrderCustomerTypeChangeEvent>(_onPosPlaceOrderCustomerTypeChangeEvent);
    on<PosPlaceOrderPaymentModelChangeEvent>(_onPosPlaceOrderPaymentModelChangeEvent);
    on<PosPlaceOrderCustomerNameUnfocusedEvent>(_onPosPlaceOrderCustomerNameUnfocusedEvent);
    on<PosPlaceOrderCustomerNumberUnfocusedEvent>(_onPosPlaceOrderCustomerNumberUnfocusedEvent);
    on<PosPlaceOrderCustomerNameChangedEvent>(_onPosPlaceOrderCustomerNameChangedEvent);
    on<PosPlaceOrderCustomerCountryCodeChangedEvent>(_onPosPlaceOrderCustomerCountryCodeChangedEvent);
    on<PosPlaceOrderCustomerNumberChangedEvent>(_onPosPlaceOrderCustomerNumberChangedEvent);
    on<PosPlaceOrderSubmitEvent>(_onPosPlaceOrderSubmitEvent);
  }

  FutureOr<void> _onPosPlaceOrderInitialEvent(PosPlaceOrderInitialEvent event, Emitter<PosPlaceOrderState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "place_pos_order"}, 'place_pos_order_screen', 'place_pos_order_screen');
      emit(state.copyWith(status: PosPlaceOrderStatus.loading));
      DioApiResponse response = await _posRepository.posOrderSetting();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PosOrderSettingModel posOrderSettingResponse = PosOrderSettingModel.fromJson(myMap);
        emit(state.copyWith(model: posOrderSettingResponse));

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
        const name = PosOrderCustomerFormNameField.dirty('none');
        const number = PosOrderCustomerFormNumberField.dirty('none');
        final countryCode = PosOrderCustomerFormCountryCodeField.dirty(defaultCountryCode);
        emit(
          state.copyWith(
            customerName: name.isValid ? name : const PosOrderCustomerFormNameField.pure(''),
            customerCountryCode: countryCode.isValid ? countryCode : const PosOrderCustomerFormCountryCodeField.pure(),
            flag: flag,
            customerContact: number.isValid ? number : const PosOrderCustomerFormNumberField.pure(''),
            status: PosPlaceOrderStatus.initial,
            isValid: Formz.validate([name, number, countryCode]),
          ),
        );
        await _posRepository.getByRestaurant().then((value) {
          double itemTotal = 0;
          double realPrice = 0;
          double itemDiscount = 0;
          for (var element in value) {
            String countTotal = (double.parse(itemTotal.toString()) + double.parse(element.totalPrice.toString())).toStringAsFixed(2);
            itemTotal = double.parse(countTotal);
            String realCountTotal = (double.parse(realPrice.toString()) + double.parse(element.realPrice.toString())).toStringAsFixed(2);
            realPrice = double.parse(realCountTotal);
            String itemDisountCountTotal = (double.parse(itemDiscount.toString()) + double.parse(element.itemDiscount.toString())).toStringAsFixed(2);
            itemDiscount = double.parse(itemDisountCountTotal);
          }
          emit(state.copyWith(inCart: value, itemTotal: itemTotal, realPrice: realPrice, itemDiscount: itemDiscount));
        });
        List<PosDiscountTypeModel> discountTypeList = <PosDiscountTypeModel>[];
        discountTypeList.clear();
        PosDiscountTypeModel percent = PosDiscountTypeModel(label: 'dd_percent_price', value: 'per');
        PosDiscountTypeModel amount = PosDiscountTypeModel(label: 'dd_amount_price', value: 'amount');
        discountTypeList.add(percent);
        discountTypeList.add(amount);

        List<PosCustomerTypeModel> customerTypeList = <PosCustomerTypeModel>[];
        customerTypeList.clear();
        PosCustomerTypeModel guestCustomer = PosCustomerTypeModel(label: 'dd_guest_customer', value: 'guest');
        PosCustomerTypeModel regularCustomer = PosCustomerTypeModel(label: 'dd_regular_customer', value: 'regular');
        customerTypeList.add(guestCustomer);
        customerTypeList.add(regularCustomer);
        emit(
          state.copyWith(
            grandTotal: calculateGrandTotal(),
            foodServiceCharge: calculateFoodTax(),
            foodServiceChargeName: posOrderSettingResponse.business!.foodTaxName!,
            serviceCharge: calculateServiceCharges(),
            serviceChargeName: posOrderSettingResponse.business!.additionalServiceName!,
            packagingCharges: calculatePackagingCharges(),
            packagingChargesTax: calculatePackageTaxCharges(),
            discountTypeList: discountTypeList,
            discountType: 'per',
            customerTypeList: customerTypeList,
            customerType: 'guest',
          ),
        );
        emit(state.copyWith(status: PosPlaceOrderStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PosPlaceOrderStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PosPlaceOrderStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
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

  FutureOr<void> _onPosPlaceOrderQuantityEvent(PosPlaceOrderQuantityEvent event, Emitter<PosPlaceOrderState> emit) async {
    int index = state.inCart.indexWhere((element) => element.id == event.id && element.uuid == event.uuid);
    if (event.action == 'decrease') {
      if (index != -1) {
        if (state.inCart[index].quantity! == 1) {
          await _posRepository.removeFromCartWithUuidLocal(state.inCart[index].uuid!, state.inCart[index].id!);
        } else {
          state.inCart[index].quantity = state.inCart[index].quantity! - 1;
          await _posRepository.updateProductVariationInCartLocal(state.inCart[index].uuid!, state.inCart[index].id!, state.inCart[index].quantity!);
        }
        emit(state.copyWith(status: PosPlaceOrderStatus.cartUpdate));
        double itemTotal = 0;
        double realPrice = 0;
        double itemDiscount = 0;
        await _posRepository.getByRestaurant().then((value) {
          for (var element in value) {
            String countTotal = (double.parse(itemTotal.toString()) + double.parse(element.totalPrice.toString())).toStringAsFixed(2);
            itemTotal = double.parse(countTotal);
            String realCountTotal = (double.parse(realPrice.toString()) + double.parse(element.realPrice.toString())).toStringAsFixed(2);
            realPrice = double.parse(realCountTotal);
            String itemDisountCountTotal = (double.parse(itemDiscount.toString()) + double.parse(element.itemDiscount.toString())).toStringAsFixed(2);
            itemDiscount = double.parse(itemDisountCountTotal);
          }
          emit(state.copyWith(inCart: value, itemTotal: itemTotal, realPrice: realPrice, itemDiscount: itemDiscount, status: value.isEmpty ? PosPlaceOrderStatus.empty : PosPlaceOrderStatus.success));
        });
      }
    } else if (event.action == 'increase') {
      if (index != -1) {
        if (state.inCart[index].quantity! < state.inCart[index].purchaseLimit!) {
          bool checkAddonHaveStock = true;
          bool checkVariationHaveStock = true;
          int addonOutOfStockLimitNumber = 0;
          int variationOutOfStockLimitNumber = 0;
          for (var addon in state.inCart[index].addons!) {
            if (state.inCart[index].quantity! >= addon.stockNumber!) {
              checkAddonHaveStock = false;
              if (addonOutOfStockLimitNumber == 0) {
                addonOutOfStockLimitNumber = addon.stockNumber!;
              }
            }
          }
          for (var variation in state.inCart[index].variations!) {
            for (var options in variation.options!) {
              if (state.inCart[index].quantity! >= options.stock!) {
                checkVariationHaveStock = false;
                if (variationOutOfStockLimitNumber == 0) {
                  variationOutOfStockLimitNumber = options.stock!;
                }
              }
            }
          }

          if (state.inCart[index].stockType == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
            state.inCart[index].quantity = state.inCart[index].quantity! + 1;
            await _posRepository.updateProductVariationInCartLocal(state.inCart[index].uuid!, state.inCart[index].id!, state.inCart[index].quantity!);
          } else if (state.inCart[index].quantity! < state.inCart[index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
            state.inCart[index].quantity = state.inCart[index].quantity! + 1;
            await _posRepository.updateProductVariationInCartLocal(state.inCart[index].uuid!, state.inCart[index].id!, state.inCart[index].quantity!);
          } else {
            if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
              emit(
                state.copyWith(
                  status: PosPlaceOrderStatus.cartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                  extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                ),
              );
            } else {
              emit(state.copyWith(status: PosPlaceOrderStatus.cartError, statusCode: 0, alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.', extraMessage: '${state.inCart[index].stockNumber!}'));
            }
          }
        } else {
          emit(state.copyWith(status: PosPlaceOrderStatus.cartError, statusCode: 0, alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food', extraMessage: '${state.inCart[index].purchaseLimit}'));
        }
        emit(state.copyWith(status: PosPlaceOrderStatus.cartUpdate));
        double itemTotal = 0;
        double realPrice = 0;
        double itemDiscount = 0;
        await _posRepository.getByRestaurant().then((value) {
          for (var element in value) {
            String countTotal = (double.parse(itemTotal.toString()) + double.parse(element.totalPrice.toString())).toStringAsFixed(2);
            itemTotal = double.parse(countTotal);
            String realCountTotal = (double.parse(realPrice.toString()) + double.parse(element.realPrice.toString())).toStringAsFixed(2);
            realPrice = double.parse(realCountTotal);
            String itemDisountCountTotal = (double.parse(itemDiscount.toString()) + double.parse(element.itemDiscount.toString())).toStringAsFixed(2);
            itemDiscount = double.parse(itemDisountCountTotal);
          }
          emit(state.copyWith(inCart: value, itemTotal: itemTotal, realPrice: realPrice, itemDiscount: itemDiscount, status: value.isEmpty ? PosPlaceOrderStatus.empty : PosPlaceOrderStatus.success));
        });
      }
    }
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
    emit(state.copyWith(status: PosPlaceOrderStatus.success, grandTotal: calculateGrandTotal(), foodServiceCharge: calculateFoodTax(), serviceCharge: calculateServiceCharges()));
  }

  FutureOr<void> _onPosPlaceOrderRemovePriceEvent(PosPlaceOrderRemovePriceEvent event, Emitter<PosPlaceOrderState> emit) async {
    if (event.priceName == 'foodServiceCharge') {
      state.model.business!.foodTaxAmount = 0;
    } else if (event.priceName == 'serviceCharge') {
      state.model.business!.additionalServiceAmount = 0;
    } else if (event.priceName == 'packageCharge') {
      state.model.packaging!.packagingCharges = 0;
    } else if (event.priceName == 'packageChargeTax') {
      state.model.packaging!.packagingChargesTax = 0;
    } else if (event.priceName == 'discount') {
      emit(state.copyWith(discountAmount: 0, status: PosPlaceOrderStatus.removeDiscount));
    }
    emit(state.copyWith(model: state.model));
    emit(
      state.copyWith(
        status: PosPlaceOrderStatus.success,
        grandTotal: calculateGrandTotal(),
        foodServiceCharge: calculateFoodTax(),
        serviceCharge: calculateServiceCharges(),
        packagingCharges: calculatePackagingCharges(),
        packagingChargesTax: calculatePackageTaxCharges(),
      ),
    );
  }

  FutureOr<void> _onPosPlaceOrderDiscountTypeChangedEvent(PosPlaceOrderDiscountTypeChangedEvent event, Emitter<PosPlaceOrderState> emit) async {
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
    emit(state.copyWith(grandTotal: calculateGrandTotal(), foodServiceCharge: calculateFoodTax(), serviceCharge: calculateServiceCharges(), status: PosPlaceOrderStatus.success));
  }

  FutureOr<void> _onPosPlaceOrderDiscountChangedEvent(PosPlaceOrderDiscountChangedEvent event, Emitter<PosPlaceOrderState> emit) async {
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
      emit(state.copyWith(grandTotal: calculateGrandTotal(), foodServiceCharge: calculateFoodTax(), serviceCharge: calculateServiceCharges(), status: PosPlaceOrderStatus.success));
    } else {
      emit(state.copyWith(discountAmount: 0, usedDiscountPrice: 0));
      emit(state.copyWith(grandTotal: calculateGrandTotal(), foodServiceCharge: calculateFoodTax(), serviceCharge: calculateServiceCharges(), status: PosPlaceOrderStatus.success));
    }
  }

  FutureOr<void> _onPosPlaceOrderCustomerTypeChangeEvent(PosPlaceOrderCustomerTypeChangeEvent event, Emitter<PosPlaceOrderState> emit) async {
    if (event.value == 'regular') {
      const customerName = PosOrderCustomerFormNameField.dirty('');
      const customerMobileNumber = PosOrderCustomerFormNumberField.dirty('');
      final customerCountryCode = PosOrderCustomerFormCountryCodeField.dirty(state.customerCountryCode.value);
      emit(
        state.copyWith(
          customerName: customerName.isValid ? customerName : const PosOrderCustomerFormNameField.pure(''),
          customerCountryCode: customerCountryCode.isValid ? customerCountryCode : const PosOrderCustomerFormCountryCodeField.pure(''),
          customerContact: customerMobileNumber.isValid ? customerMobileNumber : const PosOrderCustomerFormNumberField.pure(''),
          status: PosPlaceOrderStatus.initial,
          isValid: Formz.validate([customerName, customerMobileNumber, customerCountryCode]),
        ),
      );
    } else if (event.value == 'guest') {
      const customerName = PosOrderCustomerFormNameField.dirty('none');
      const customerMobileNumber = PosOrderCustomerFormNumberField.dirty('none');
      final customerCountryCode = PosOrderCustomerFormCountryCodeField.dirty(state.customerCountryCode.value);
      emit(
        state.copyWith(
          customerName: customerName.isValid ? customerName : const PosOrderCustomerFormNameField.pure(''),
          customerCountryCode: customerCountryCode.isValid ? customerCountryCode : const PosOrderCustomerFormCountryCodeField.pure(''),
          customerContact: customerMobileNumber.isValid ? customerMobileNumber : const PosOrderCustomerFormNumberField.pure(''),
          status: PosPlaceOrderStatus.initial,
          isValid: Formz.validate([customerName, customerMobileNumber, customerCountryCode]),
        ),
      );
    }
    emit(state.copyWith(customerType: event.value, status: PosPlaceOrderStatus.success));
  }

  FutureOr<void> _onPosPlaceOrderPaymentModelChangeEvent(PosPlaceOrderPaymentModelChangeEvent event, Emitter<PosPlaceOrderState> emit) async {
    emit(state.copyWith(paymentMode: event.payment, status: PosPlaceOrderStatus.success));
  }

  FutureOr<void> _onPosPlaceOrderCustomerNameUnfocusedEvent(PosPlaceOrderCustomerNameUnfocusedEvent event, Emitter<PosPlaceOrderState> emit) async {
    final name = PosOrderCustomerFormNameField.dirty(state.customerName.value);
    emit(state.copyWith(customerName: name, status: PosPlaceOrderStatus.initial, isValid: Formz.validate([name, state.customerContact, state.customerCountryCode])));
  }

  FutureOr<void> _onPosPlaceOrderCustomerNumberUnfocusedEvent(PosPlaceOrderCustomerNumberUnfocusedEvent event, Emitter<PosPlaceOrderState> emit) async {
    final number = PosOrderCustomerFormNumberField.dirty(state.customerContact.value);
    emit(state.copyWith(customerContact: number, status: PosPlaceOrderStatus.initial, isValid: Formz.validate([number, state.customerName, state.customerCountryCode])));
  }

  FutureOr<void> _onPosPlaceOrderCustomerNameChangedEvent(PosPlaceOrderCustomerNameChangedEvent event, Emitter<PosPlaceOrderState> emit) async {
    final name = PosOrderCustomerFormNameField.dirty(event.name);
    emit(state.copyWith(customerName: name.isValid ? name : PosOrderCustomerFormNameField.pure(event.name), status: PosPlaceOrderStatus.initial, isValid: Formz.validate([name, state.customerContact, state.customerCountryCode])));
  }

  FutureOr<void> _onPosPlaceOrderCustomerCountryCodeChangedEvent(PosPlaceOrderCustomerCountryCodeChangedEvent event, Emitter<PosPlaceOrderState> emit) async {
    final countryCode = PosOrderCustomerFormCountryCodeField.dirty(event.countryCode);
    emit(state.copyWith(customerCountryCode: countryCode, flag: event.flag, status: PosPlaceOrderStatus.initial, isValid: Formz.validate([countryCode, state.customerName, state.customerContact])));
  }

  FutureOr<void> _onPosPlaceOrderCustomerNumberChangedEvent(PosPlaceOrderCustomerNumberChangedEvent event, Emitter<PosPlaceOrderState> emit) async {
    final number = PosOrderCustomerFormNumberField.dirty(event.number);
    emit(
      state.copyWith(
        customerContact: number.isValid ? number : PosOrderCustomerFormNumberField.pure(event.number),
        status: PosPlaceOrderStatus.initial,
        isValid: Formz.validate([number, state.customerName, state.customerCountryCode]),
      ),
    );
  }

  FutureOr<void> _onPosPlaceOrderSubmitEvent(PosPlaceOrderSubmitEvent event, Emitter<PosPlaceOrderState> emit) async {
    try {
      final customerName = PosOrderCustomerFormNameField.dirty(state.customerName.value);
      final customerNumber = PosOrderCustomerFormNumberField.dirty(state.customerContact.value);
      final customerCountryCode = PosOrderCustomerFormCountryCodeField.dirty(state.customerCountryCode.value);
      emit(
        state.copyWith(
          customerName: customerName,
          customerContact: customerNumber,
          customerCountryCode: customerCountryCode,
          status: PosPlaceOrderStatus.initial,
          isValid: Formz.validate([customerName, customerNumber, customerCountryCode]),
        ),
      );
      if (state.isValid && state.customerName.value.isNotEmpty && state.customerContact.value.isNotEmpty && state.customerCountryCode.value.isNotEmpty) {
        emit(state.copyWith(status: PosPlaceOrderStatus.placingOrder));
        List<CartItemRequestModel> cartItemRaw = <CartItemRequestModel>[];
        cartItemRaw.clear();
        for (var inCartItem in state.inCart) {
          List<String> newAddonIds = <String>[];
          newAddonIds.clear();
          for (var element in inCartItem.addons!) {
            newAddonIds.add(element.id!);
          }
          List<ServerSavedVariationOptionModel> serverVariations = <ServerSavedVariationOptionModel>[];
          serverVariations.clear();
          for (var variation in inCartItem.variations!) {
            List<String> selectedOptions = <String>[];
            for (var options in variation.options!) {
              selectedOptions.add(options.name!);
            }
            ServerSavedVariationOptionModel saveIt = ServerSavedVariationOptionModel(variation: variation.title!, selected: selectedOptions);
            serverVariations.add(saveIt);
          }
          CartItemRequestModel itemInCart = CartItemRequestModel(
            uuid: inCartItem.uuid!,
            addons: newAddonIds.join(','),
            food: inCartItem.id!,
            quantity: inCartItem.quantity!,
            variations: serverVariations,
            instruction: inCartItem.instruction!,
          );
          cartItemRaw.add(itemInCart);
        }
        PosPlaceOrderRequestModel param = PosPlaceOrderRequestModel(
          restaurant: await _posRepository.getVendorId(),
          paymentMode: state.paymentMode,
          customerType: state.customerType,
          customerName: state.customerName.value.toString(),
          customerCountryCode: state.customerCountryCode.value.toString(),
          customerMobileNumber: state.customerContact.value.toString(),
          cartItemRaw: jsonEncode(cartItemRaw),
          discountType: state.discountType,
          discountAmount: state.usedDiscountPrice,
          foodServiceCharge: state.foodServiceCharge,
          serviceCharge: state.serviceCharge,
          packageCharge: state.packagingCharges,
          packageChargeTax: state.packagingChargesTax,
          extraCharge: 0,
        );
        DioApiResponse response = await _posRepository.posPlaceOrder(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          PosOrderResponseModel orderResponse = PosOrderResponseModel.fromJson(myMap);
          await _posRepository.removeFromCartWithRestaurant();
          emit(state.copyWith(status: PosPlaceOrderStatus.orderPlaced, orderInfo: orderResponse));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: PosPlaceOrderStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PosPlaceOrderStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}

class CartItemRequestModel {
  String? uuid;
  String? addons;
  String? food;
  int? quantity;
  String? instruction;
  List<ServerSavedVariationOptionModel>? variations;

  CartItemRequestModel({this.uuid, this.addons, this.food, this.quantity, this.instruction, this.variations});

  CartItemRequestModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    addons = json['addons'];
    food = json['food'];
    quantity = json['quantity'];
    if (json['variations'] != null) {
      variations = <ServerSavedVariationOptionModel>[];
      json['variations'].forEach((v) {
        variations!.add(ServerSavedVariationOptionModel.fromJson(v));
      });
    } else {
      variations = [];
    }
    if (json['instruction'] != null && json['instruction'] != '') {
      instruction = json['instruction'];
    } else {
      instruction = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['addons'] = addons;
    data['food'] = food;
    data['quantity'] = quantity;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['instruction'] = instruction;
    return data;
  }
}

class ServerSavedVariationOptionModel {
  String? variation;
  List<String>? selected;

  ServerSavedVariationOptionModel({this.variation, this.selected});

  ServerSavedVariationOptionModel.fromJson(Map<String, dynamic> json) {
    variation = json['variation'];
    selected = json['selected'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation'] = variation;
    data['selected'] = selected;
    return data;
  }
}
