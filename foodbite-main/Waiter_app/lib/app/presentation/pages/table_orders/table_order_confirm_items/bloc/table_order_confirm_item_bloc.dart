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
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/models/pos_food_in_cart_model.dart';
import 'package:waiter/app/core/models/request/cart_item_request_model.dart';
import 'package:waiter/app/core/models/server_error_model.dart';
import 'package:waiter/app/core/models/table_ongoing_cart_item_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/core/repositories/pos_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_order_confirm_item_event.dart';
part 'table_order_confirm_item_state.dart';

class TableOrderConfirmItemBloc extends Bloc<TableOrderConfirmItemEvent, TableOrderConfirmItemState> {
  final PosRepository _posRepository = PosRepository();
  final AuthRepository _authRepository = AuthRepository();
  TableOrderConfirmItemBloc()
    : super(
        TableOrderConfirmItemState(
          model: TableOngoingCartItemModel(items: [], success: false, locale: ''),
        ),
      ) {
    on<TableOrderConfirmItemInitialEvent>(_onTableOrderConfirmItemInitialEvent);
    on<TableOrderConfirmItemQuantityEvent>(_onTableOrderConfirmItemQuantityEvent);
    on<TableOrderConfirmItemSubmitEvent>(_onTableOrderConfirmItemSubmitEvent);
  }

  FutureOr<void> _onTableOrderConfirmItemInitialEvent(TableOrderConfirmItemInitialEvent event, Emitter<TableOrderConfirmItemState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "confirm_table_order_item"}, 'confirm_table_order_item_screen', 'confirm_table_order_item_screen');
      emit(state.copyWith(status: TableOrderConfirmItemStatus.loading));
      DioApiResponse response = await _posRepository.ongoingTableOrder(event.tableId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        TableOngoingCartItemModel data = TableOngoingCartItemModel.fromJson(myMap, locale.toString());
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
          if (discount > 0) {
            if (element.foodInfo!.discountType! == '%') {
              String discountValue = (double.parse(price.toString()) - (double.parse(price.toString()) * double.parse(discount.toString()) / 100)).toStringAsFixed(2);
              offerPrice = double.parse(discountValue);
            } else {
              String discountValue = (double.parse(price.toString()) - double.parse(discount.toString())).toStringAsFixed(2);
              offerPrice = double.parse(discountValue);
            }
          }

          String finalOfferPrice = (offerPrice * element.quantity!).toStringAsFixed(2);
          element.itemPrice = double.parse(finalOfferPrice);

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
        await _posRepository.getByTableId(event.tableId).then((value) {
          emit(state.copyWith(model: data, inCart: value, tableId: event.tableId, tableNumber: event.tableNumber, status: TableOrderConfirmItemStatus.success));
        });
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrderConfirmItemStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderConfirmItemStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderConfirmItemQuantityEvent(TableOrderConfirmItemQuantityEvent event, Emitter<TableOrderConfirmItemState> emit) async {
    int index = state.inCart.indexWhere((element) => element.id == event.id && element.uuid == event.uuid);
    if (event.action == 'decrease') {
      if (index != -1) {
        if (state.inCart[index].quantity! == 1) {
          await _posRepository.removeFromCartWithUuidLocal(state.inCart[index].uuid!, state.inCart[index].id!, state.tableId);
        } else {
          state.inCart[index].quantity = state.inCart[index].quantity! - 1;
          await _posRepository.updateProductVariationInCartLocal(state.inCart[index].uuid!, state.inCart[index].id!, state.inCart[index].quantity!, state.tableId);
        }
        emit(state.copyWith(status: TableOrderConfirmItemStatus.cartUpdate));
        await _posRepository.getByTableId(state.tableId).then((value) {
          emit(state.copyWith(inCart: value, status: value.isEmpty ? TableOrderConfirmItemStatus.empty : TableOrderConfirmItemStatus.success));
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
            await _posRepository.updateProductVariationInCartLocal(state.inCart[index].uuid!, state.inCart[index].id!, state.inCart[index].quantity!, state.tableId);
          } else if (state.inCart[index].quantity! < state.inCart[index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
            state.inCart[index].quantity = state.inCart[index].quantity! + 1;
            await _posRepository.updateProductVariationInCartLocal(state.inCart[index].uuid!, state.inCart[index].id!, state.inCart[index].quantity!, state.tableId);
          } else {
            if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
              emit(
                state.copyWith(
                  status: TableOrderConfirmItemStatus.cartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                  extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                ),
              );
            } else {
              emit(state.copyWith(status: TableOrderConfirmItemStatus.cartError, statusCode: 0, alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.', extraMessage: '${state.inCart[index].stockNumber!}'));
            }
          }
        } else {
          emit(state.copyWith(status: TableOrderConfirmItemStatus.cartError, statusCode: 0, alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food', extraMessage: '${state.inCart[index].purchaseLimit}'));
        }
        emit(state.copyWith(status: TableOrderConfirmItemStatus.cartUpdate));
        await _posRepository.getByTableId(state.tableId).then((value) {
          emit(state.copyWith(inCart: value, status: value.isEmpty ? TableOrderConfirmItemStatus.empty : TableOrderConfirmItemStatus.success));
        });
      }
    }
    emit(state.copyWith(status: TableOrderConfirmItemStatus.success));
  }

  FutureOr<void> _onTableOrderConfirmItemSubmitEvent(TableOrderConfirmItemSubmitEvent event, Emitter<TableOrderConfirmItemState> emit) async {
    try {
      List<CartItemServerObjectModel> cartObject = <CartItemServerObjectModel>[];
      cartObject.clear();
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
        CartItemServerObjectModel itemObject = CartItemServerObjectModel(
          uuid: inCartItem.uuid!,
          addons: newAddonIds.join(','),
          food: inCartItem.id!,
          quantity: inCartItem.quantity!,
          variations: serverVariations,
          instruction: inCartItem.instruction,
        );
        cartObject.add(itemObject);
      }
      CartItemRequestModel param = CartItemRequestModel(tableId: state.tableId, tableNumber: state.tableNumber, restaurant: await _posRepository.getVendorId(), cartItem: cartObject, waiter: await _posRepository.waiterId());
      DioApiResponse response = await _posRepository.addItemToCartServer(param);
      if (response.errorType == NetErrorType.none) {
        await _posRepository.removeFromCartWithTable(state.tableId);
        emit(state.copyWith(status: TableOrderConfirmItemStatus.orderPlaced));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrderConfirmItemStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderConfirmItemStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
