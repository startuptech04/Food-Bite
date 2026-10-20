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
import 'package:waiter/app/core/models/server_error_model.dart';
import 'package:waiter/app/core/models/table_ongoing_cart_item_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/core/repositories/pos_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_ongoing_item_event.dart';
part 'table_ongoing_item_state.dart';

class TableOngoingItemBloc extends Bloc<TableOngoingItemEvent, TableOngoingItemState> {
  final PosRepository _posRepository = PosRepository();
  final AuthRepository _authRepository = AuthRepository();
  TableOngoingItemBloc()
    : super(
        TableOngoingItemState(
          model: TableOngoingCartItemModel(items: [], success: false, locale: ''),
        ),
      ) {
    on<TableOngoingItemInitialEvent>(_onTableOngoingItemInitialEvent);
  }

  FutureOr<void> _onTableOngoingItemInitialEvent(TableOngoingItemInitialEvent event, Emitter<TableOngoingItemState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "ongoing_table_order"}, 'ongoing_table_order_screen', 'ongoing_table_order_screen');
      emit(state.copyWith(status: TableOngoingItemStatus.loading, tableId: event.tableId, tableNumber: event.tableNumber));
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

        emit(state.copyWith(model: data, status: data.items!.isEmpty ? TableOngoingItemStatus.empty : TableOngoingItemStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOngoingItemStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOngoingItemStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
