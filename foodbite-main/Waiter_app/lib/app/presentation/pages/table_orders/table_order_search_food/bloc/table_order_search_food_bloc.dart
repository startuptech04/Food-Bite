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
import 'package:waiter/app/core/models/pos_food_info_modal_response_model.dart';
import 'package:waiter/app/core/models/pos_food_search_initial_response_model.dart';
import 'package:waiter/app/core/models/pos_food_search_result_response_model.dart';
import 'package:waiter/app/core/models/pos_food_variations_response_data_modal_model.dart';
import 'package:waiter/app/core/models/pos_repeat_quantity_modal_response_model.dart';
import 'package:waiter/app/core/models/pos_food_in_cart_model.dart';
import 'package:waiter/app/core/models/pos_food_in_cart_model.dart' as pos_food_in_cart_model;
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/core/repositories/pos_repository.dart';
import 'package:waiter/app/services/uuid_generator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_order_search_food_event.dart';
part 'table_order_search_food_state.dart';

class TableOrderSearchFoodBloc extends Bloc<TableOrderSearchFoodEvent, TableOrderSearchFoodState> {
  final PosRepository _posRepository = PosRepository();
  final AuthRepository _authRepository = AuthRepository();
  Timer? _debounce;

  TableOrderSearchFoodBloc()
    : super(
        TableOrderSearchFoodState(
          initialData: PosFoodSearchInitialResponseModel(foods: [], success: false, locale: ''),
          response: PosFoodSearchResultResponseModel(foods: [], success: false, locale: ''),
        ),
      ) {
    on<TableOrderSearchFoodInitialEvent>(_onTableOrderSearchFoodInitialEvent);
    on<TableOrderSearchFoodFindResultEvent>(_onTableOrderSearchFoodFindResultEvent);
    on<TableOrderSearchModalResponseEvent>(_onTableOrderSearchModalResponseEvent);
    on<TableOrderSearchVariationModalResponseEvent>(_onTableOrderSearchVariationModalResponseEvent);
    on<TableOrderSearchAddCartEvent>(_onTableOrderSearchAddCartEvent);
    on<TableOrderSearchRepeatFoodOrderResponseEvent>(_onTableOrderSearchRepeatFoodOrderResponseEvent);
    on<TableOrderSearchFoodQuantityDecreaseEvent>(_onTableOrderSearchFoodQuantityDecreaseEvent);
    on<TableOrderSearchFoodVariationModalRepeatResponseEvent>(_onTableOrderSearchFoodVariationModalRepeatResponseEvent);
    on<TableOrderSearchFoodQuantityIncreaseEvent>(_onTableOrderSearchFoodQuantityIncreaseEvent);
    on<TableOrderSearchFoodExecuteQueryEvent>(_onTableOrderSearchFoodExecuteQueryEvent);
  }

  FutureOr<void> _onTableOrderSearchFoodInitialEvent(TableOrderSearchFoodInitialEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "table_order_search_food"}, 'table_order_search_food_screen', 'table_order_search_food_screen');
      emit(state.copyWith(tableNumber: event.tableNumber, tableId: event.tableId));
      DioApiResponse response = await _posRepository.waiterInitialFoodSearch();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PosFoodSearchInitialResponseModel initialResponse = PosFoodSearchInitialResponseModel.fromJson(myMap, locale.toString());
        for (var element in initialResponse.foods!) {
          if (await _posRepository.checkProductInCart(element.id!, event.tableId)) {
            final int? quantityPromise = await _posRepository.getQuantity(element.id!, event.tableId);
            element.quantity = quantityPromise;
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(element.id!, event.tableId);
            element.cartEntity = cartEntityPromise;
          } else {
            element.quantity = 0;
            element.cartEntity = 'single';
          }
        }
        emit(state.copyWith(status: TableOrderSearchFoodStatus.initial, appLocale: locale.toString(), initialData: initialResponse));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderSearchFoodFindResultEvent(TableOrderSearchFoodFindResultEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      add(TableOrderSearchFoodExecuteQueryEvent(query: event.searchQuery));
    });
  }

  FutureOr<void> _onTableOrderSearchModalResponseEvent(TableOrderSearchModalResponseEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    try {
      if (event.collection == 'initial') {
        int index = state.initialData.foods!.indexWhere((element) => element.id == event.id);
        if (index != -1 && event.response.action! == true) {
          List<pos_food_in_cart_model.AddonConfigModel> savedAddon = <pos_food_in_cart_model.AddonConfigModel>[];
          savedAddon.clear();
          List<String> newAddonIds = <String>[];
          newAddonIds.clear();
          final String locale = await _authRepository.getLocale();
          for (var element in event.response.cartItem!.addons!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.AddonConfigModel savedData = pos_food_in_cart_model.AddonConfigModel.fromJson(myMap, locale.toString());
            newAddonIds.add(savedData.id!);
            savedAddon.add(savedData);
          }

          List<pos_food_in_cart_model.VariationConfigModel> savedVariations = <pos_food_in_cart_model.VariationConfigModel>[];
          savedVariations.clear();
          List<String> newVariationIds = <String>[];
          for (var element in event.response.cartItem!.variations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.VariationConfigModel savedData = pos_food_in_cart_model.VariationConfigModel.fromJson(myMap);
            for (var op in savedData.options!) {
              newVariationIds.add('${savedData.title}-${op.name}');
            }
            savedVariations.add(savedData);
          }
          newAddonIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
          newVariationIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));

          bool isSameProduct = false;
          String sameUuid = '';
          await _posRepository.getRepeatList(event.id, state.tableId).then((value) {
            List<String> existingAddonIds = <String>[];
            existingAddonIds.clear();
            List<String> existingVariationIds = <String>[];
            existingVariationIds.clear();
            for (var element in value) {
              for (var addn in element.addons!) {
                existingAddonIds.add(addn.id!);
              }
              for (var variant in element.variations!) {
                for (var ops in variant.options!) {
                  existingVariationIds.add('${variant.title}-${ops.name}');
                }
              }
              existingAddonIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
              existingVariationIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
              if (newAddonIds.join('') == existingAddonIds.join('') && newVariationIds.join('') == existingVariationIds.join('')) {
                sameUuid = element.uuid!;
                isSameProduct = true;
              }
            }
          });
          if (isSameProduct && sameUuid.isNotEmpty && sameUuid != '') {
            int quantity = (int.parse(state.initialData.foods![index].quantity.toString()) + int.parse(event.response.cartItem!.quantity.toString()));
            if (quantity < state.initialData.foods![index].purchaseLimit!) {
              bool checkAddonHaveStock = true;
              bool checkVariationHaveStock = true;
              int addonOutOfStockLimitNumber = 0;
              int variationOutOfStockLimitNumber = 0;
              for (var addon in savedAddon) {
                if (quantity >= addon.stockNumber!) {
                  checkAddonHaveStock = false;
                  if (addonOutOfStockLimitNumber == 0) {
                    addonOutOfStockLimitNumber = addon.stockNumber!;
                  }
                }
              }
              for (var variation in savedVariations) {
                for (var options in variation.options!) {
                  if (quantity >= options.stock!) {
                    checkVariationHaveStock = false;
                    if (variationOutOfStockLimitNumber == 0) {
                      variationOutOfStockLimitNumber = options.stock!;
                    }
                  }
                }
              }
              if (state.initialData.foods![index].stockType! == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
                state.initialData.foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.initialData.foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderSearchFoodStatus.initialCartUpdate, initialData: state.initialData));
              } else if (quantity < state.initialData.foods![index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
                state.initialData.foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.initialData.foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderSearchFoodStatus.initialCartUpdate, initialData: state.initialData));
              } else {
                if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
                  emit(
                    state.copyWith(
                      initialData: state.initialData,
                      status: TableOrderSearchFoodStatus.initialCartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                      extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                    ),
                  );
                } else {
                  state.initialData.foods![index].quantity = state.initialData.foods![index].stockNumber!;
                  await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.initialData.foods![index].stockNumber!, state.tableId);
                  final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                  state.initialData.foods![index].cartEntity = cartEntityPromise;
                  emit(
                    state.copyWith(
                      initialData: state.initialData,
                      status: TableOrderSearchFoodStatus.initialCartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                      extraMessage: '${state.initialData.foods![index].stockNumber!}',
                    ),
                  );
                }
              }
            } else {
              state.initialData.foods![index].quantity = state.initialData.foods![index].purchaseLimit!;
              await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.initialData.foods![index].purchaseLimit!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.initialData.foods![index].cartEntity = cartEntityPromise;
              emit(
                state.copyWith(
                  initialData: state.initialData,
                  status: TableOrderSearchFoodStatus.initialCartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                  extraMessage: '${state.initialData.foods![index].purchaseLimit!}',
                ),
              );
            }
          } else {
            int quantity = (int.parse(state.initialData.foods![index].quantity.toString()) + int.parse(event.response.cartItem!.quantity.toString()));
            List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
            savedFoodTranslation.clear();
            for (var element in state.initialData.foods![index].translations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
              savedFoodTranslation.add(savedData);
            }

            List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
            foodTaxation.clear();
            final String locale = await _authRepository.getLocale();
            for (var element in state.initialData.foods![index].foodtaxations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
              foodTaxation.add(savedData);
            }

            PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
              uuid: Uuid().generateV4(),
              name: state.initialData.foods![index].name,
              shortDescription: state.initialData.foods![index].shortDescription,
              image: state.initialData.foods![index].image,
              foodType: state.initialData.foods![index].foodType,
              price: state.initialData.foods![index].price,
              discountType: state.initialData.foods![index].discountType,
              discount: state.initialData.foods![index].discount,
              offerPrice: state.initialData.foods![index].offerPrice,
              purchaseLimit: state.initialData.foods![index].purchaseLimit,
              stockNumber: state.initialData.foods![index].stockNumber,
              stockType: state.initialData.foods![index].stockType,
              quantity: event.response.cartItem!.quantity,
              id: event.id,
              addons: savedAddon,
              variations: savedVariations,
              translations: savedFoodTranslation,
              status: state.initialData.foods![index].status,
              inStock: state.initialData.foods![index].inStock,
              startTime: state.initialData.foods![index].startTime,
              endTime: state.initialData.foods![index].endTime,
              taxationEnable: state.initialData.foods![index].taxationEnable!,
              foodtaxations: foodTaxation,
              instruction: event.response.instruction!,
              tableId: state.tableId,
              locale: locale.toString(),
            );
            state.initialData.foods![index].quantity = quantity;
            await _posRepository.addToCartLocal(foodInCartInfo);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.initialData.foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderSearchFoodStatus.initialCartUpdate, initialData: state.initialData));
          }
        }
      } else if (event.collection == 'result') {
        int index = state.response.foods!.indexWhere((element) => element.id == event.id);
        if (index != -1 && event.response.action! == true) {
          List<pos_food_in_cart_model.AddonConfigModel> savedAddon = <pos_food_in_cart_model.AddonConfigModel>[];
          savedAddon.clear();
          List<String> newAddonIds = <String>[];
          newAddonIds.clear();
          final String locale = await _authRepository.getLocale();
          for (var element in event.response.cartItem!.addons!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.AddonConfigModel savedData = pos_food_in_cart_model.AddonConfigModel.fromJson(myMap, locale.toString());
            newAddonIds.add(savedData.id!);
            savedAddon.add(savedData);
          }

          List<pos_food_in_cart_model.VariationConfigModel> savedVariations = <pos_food_in_cart_model.VariationConfigModel>[];
          savedVariations.clear();
          List<String> newVariationIds = <String>[];
          for (var element in event.response.cartItem!.variations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.VariationConfigModel savedData = pos_food_in_cart_model.VariationConfigModel.fromJson(myMap);
            for (var op in savedData.options!) {
              newVariationIds.add('${savedData.title}-${op.name}');
            }
            savedVariations.add(savedData);
          }
          newAddonIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
          newVariationIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));

          bool isSameProduct = false;
          String sameUuid = '';
          await _posRepository.getRepeatList(event.id, state.tableId).then((value) {
            List<String> existingAddonIds = <String>[];
            existingAddonIds.clear();
            List<String> existingVariationIds = <String>[];
            existingVariationIds.clear();
            for (var element in value) {
              for (var addn in element.addons!) {
                existingAddonIds.add(addn.id!);
              }
              for (var variant in element.variations!) {
                for (var ops in variant.options!) {
                  existingVariationIds.add('${variant.title}-${ops.name}');
                }
              }
              existingAddonIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
              existingVariationIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
              if (newAddonIds.join('') == existingAddonIds.join('') && newVariationIds.join('') == existingVariationIds.join('')) {
                sameUuid = element.uuid!;
                isSameProduct = true;
              }
            }
          });
          if (isSameProduct && sameUuid.isNotEmpty && sameUuid != '') {
            int quantity = (int.parse(state.response.foods![index].quantity.toString()) + int.parse(event.response.cartItem!.quantity.toString()));
            if (quantity < state.response.foods![index].purchaseLimit!) {
              bool checkAddonHaveStock = true;
              bool checkVariationHaveStock = true;
              int addonOutOfStockLimitNumber = 0;
              int variationOutOfStockLimitNumber = 0;
              for (var addon in savedAddon) {
                if (quantity >= addon.stockNumber!) {
                  checkAddonHaveStock = false;
                  if (addonOutOfStockLimitNumber == 0) {
                    addonOutOfStockLimitNumber = addon.stockNumber!;
                  }
                }
              }
              for (var variation in savedVariations) {
                for (var options in variation.options!) {
                  if (quantity >= options.stock!) {
                    checkVariationHaveStock = false;
                    if (variationOutOfStockLimitNumber == 0) {
                      variationOutOfStockLimitNumber = options.stock!;
                    }
                  }
                }
              }
              if (state.response.foods![index].stockType! == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
                state.response.foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.response.foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
              } else if (quantity < state.response.foods![index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
                state.response.foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.response.foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
              } else {
                if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
                  emit(
                    state.copyWith(
                      response: state.response,
                      status: TableOrderSearchFoodStatus.searchCartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                      extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                    ),
                  );
                } else {
                  state.response.foods![index].quantity = state.response.foods![index].stockNumber!;
                  await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.response.foods![index].stockNumber!, state.tableId);
                  final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                  state.response.foods![index].cartEntity = cartEntityPromise;
                  emit(
                    state.copyWith(
                      response: state.response,
                      status: TableOrderSearchFoodStatus.searchCartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                      extraMessage: '${state.response.foods![index].stockNumber!}',
                    ),
                  );
                }
              }
            } else {
              state.response.foods![index].quantity = state.response.foods![index].purchaseLimit!;
              await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.response.foods![index].purchaseLimit!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.response.foods![index].cartEntity = cartEntityPromise;
              emit(
                state.copyWith(
                  response: state.response,
                  status: TableOrderSearchFoodStatus.searchCartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                  extraMessage: '${state.response.foods![index].purchaseLimit!}',
                ),
              );
            }
          } else {
            int quantity = (int.parse(state.response.foods![index].quantity.toString()) + int.parse(event.response.cartItem!.quantity.toString()));
            List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
            savedFoodTranslation.clear();
            for (var element in state.response.foods![index].translations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
              savedFoodTranslation.add(savedData);
            }

            List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
            foodTaxation.clear();
            final String locale = await _authRepository.getLocale();
            for (var element in state.response.foods![index].foodtaxations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
              foodTaxation.add(savedData);
            }

            PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
              uuid: Uuid().generateV4(),
              name: state.response.foods![index].name,
              shortDescription: state.response.foods![index].shortDescription,
              image: state.response.foods![index].image,
              foodType: state.response.foods![index].foodType,
              price: state.response.foods![index].price,
              discountType: state.response.foods![index].discountType,
              discount: state.response.foods![index].discount,
              offerPrice: state.response.foods![index].offerPrice,
              purchaseLimit: state.response.foods![index].purchaseLimit,
              stockNumber: state.response.foods![index].stockNumber,
              stockType: state.response.foods![index].stockType,
              quantity: event.response.cartItem!.quantity,
              id: event.id,
              addons: savedAddon,
              variations: savedVariations,
              translations: savedFoodTranslation,
              status: state.response.foods![index].status,
              inStock: state.response.foods![index].inStock,
              startTime: state.response.foods![index].startTime,
              endTime: state.response.foods![index].endTime,
              taxationEnable: state.response.foods![index].taxationEnable!,
              foodtaxations: foodTaxation,
              instruction: event.response.instruction!,
              tableId: state.tableId,
              locale: locale.toString(),
            );
            state.response.foods![index].quantity = quantity;
            await _posRepository.addToCartLocal(foodInCartInfo);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.response.foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
          }
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderSearchVariationModalResponseEvent(TableOrderSearchVariationModalResponseEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    try {
      int index = state.response.foods!.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        state.response.foods![index].quantity = event.data.cartItem!.quantity;

        List<pos_food_in_cart_model.AddonConfigModel> savedAddon = <pos_food_in_cart_model.AddonConfigModel>[];
        savedAddon.clear();
        List<String> newAddonIds = <String>[];
        newAddonIds.clear();
        final String locale = await _authRepository.getLocale();
        for (var element in event.data.cartItem!.addons!) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          pos_food_in_cart_model.AddonConfigModel savedData = pos_food_in_cart_model.AddonConfigModel.fromJson(myMap, locale.toString());
          newAddonIds.add(savedData.id!);
          savedAddon.add(savedData);
        }

        List<pos_food_in_cart_model.VariationConfigModel> savedVariations = <pos_food_in_cart_model.VariationConfigModel>[];
        savedVariations.clear();
        for (var element in event.data.cartItem!.variations!) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          pos_food_in_cart_model.VariationConfigModel savedData = pos_food_in_cart_model.VariationConfigModel.fromJson(myMap);
          savedVariations.add(savedData);
        }

        newAddonIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));

        List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
        savedFoodTranslation.clear();
        for (var element in state.response.foods![index].translations!) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
          savedFoodTranslation.add(savedData);
        }

        List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
        foodTaxation.clear();

        for (var element in state.response.foods![index].foodtaxations!) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
          foodTaxation.add(savedData);
        }

        PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
          uuid: Uuid().generateV4(),
          name: state.response.foods![index].name,
          shortDescription: state.response.foods![index].shortDescription,
          image: state.response.foods![index].image,
          foodType: state.response.foods![index].foodType,
          price: state.response.foods![index].price,
          discountType: state.response.foods![index].discountType,
          discount: state.response.foods![index].discount,
          offerPrice: state.response.foods![index].offerPrice,
          purchaseLimit: state.response.foods![index].purchaseLimit,
          stockNumber: state.response.foods![index].stockNumber,
          stockType: state.response.foods![index].stockType,
          quantity: event.data.cartItem!.quantity,
          id: event.id,
          addons: savedAddon,
          variations: savedVariations,
          translations: savedFoodTranslation,
          status: state.response.foods![index].status,
          inStock: state.response.foods![index].inStock,
          startTime: state.response.foods![index].startTime,
          endTime: state.response.foods![index].endTime,
          taxationEnable: state.response.foods![index].taxationEnable!,
          foodtaxations: foodTaxation,
          instruction: event.data.instruction!,
          tableId: state.tableId,
          locale: locale.toString(),
        );

        await _posRepository.addToCartLocal(foodInCartInfo);
        final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
        state.response.foods![index].cartEntity = cartEntityPromise;
        emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderSearchAddCartEvent(TableOrderSearchAddCartEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    try {
      int index = state.response.foods!.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        state.response.foods![index].quantity = 1;

        List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
        savedFoodTranslation.clear();

        for (var element in state.response.foods![index].translations!) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
          savedFoodTranslation.add(savedData);
        }

        List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
        foodTaxation.clear();
        final String locale = await _authRepository.getLocale();
        for (var element in state.response.foods![index].foodtaxations!) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
          foodTaxation.add(savedData);
        }

        PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
          uuid: Uuid().generateV4(),
          name: state.response.foods![index].name,
          shortDescription: state.response.foods![index].shortDescription,
          image: state.response.foods![index].image,
          foodType: state.response.foods![index].foodType,
          price: state.response.foods![index].price,
          discountType: state.response.foods![index].discountType,
          discount: state.response.foods![index].discount,
          offerPrice: state.response.foods![index].offerPrice,
          purchaseLimit: state.response.foods![index].purchaseLimit,
          stockNumber: state.response.foods![index].stockNumber,
          stockType: state.response.foods![index].stockType,
          quantity: 1,
          id: event.id,
          addons: [],
          variations: [],
          translations: savedFoodTranslation,
          status: state.response.foods![index].status,
          inStock: state.response.foods![index].inStock,
          startTime: state.response.foods![index].startTime,
          endTime: state.response.foods![index].endTime,
          taxationEnable: state.response.foods![index].taxationEnable!,
          foodtaxations: foodTaxation,
          instruction: '',
          tableId: state.tableId,
          locale: locale.toString(),
        );
        await _posRepository.addToCartLocal(foodInCartInfo);
        final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
        state.response.foods![index].cartEntity = cartEntityPromise;
        emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderSearchRepeatFoodOrderResponseEvent(TableOrderSearchRepeatFoodOrderResponseEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    try {
      for (var element in event.data.data!.list!) {
        if (element.quantity == 0) {
          await _posRepository.removeFromCartWithUuidLocal(element.uuid!, event.id, state.tableId);
        } else {
          await _posRepository.updateProductVariationInCartLocal(element.uuid!, event.id, element.quantity!, state.tableId);
        }
      }
      for (var element in state.response.foods!) {
        if (await _posRepository.checkProductInCart(element.id!, state.tableId)) {
          final int? quantityPromise = await _posRepository.getQuantity(element.id!, state.tableId);
          element.quantity = quantityPromise;
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(element.id!, state.tableId);
          element.cartEntity = cartEntityPromise;
        } else {
          element.quantity = 0;
          element.cartEntity = 'single';
        }
      }
      emit(state.copyWith(response: state.response, status: TableOrderSearchFoodStatus.searchCartUpdate));
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderSearchFoodQuantityDecreaseEvent(TableOrderSearchFoodQuantityDecreaseEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    try {
      int index = state.response.foods!.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        if (state.response.foods![index].quantity! > 1) {
          state.response.foods![index].quantity = state.response.foods![index].quantity! - 1;
          await _posRepository.updateProductQuantityInCartLocal(event.id, state.response.foods![index].quantity!, state.tableId);
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
          state.response.foods![index].cartEntity = cartEntityPromise;
          emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
        } else {
          state.response.foods![index].quantity = 0;
          await _posRepository.removeFromCartLocal(event.id, state.tableId);
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
          state.response.foods![index].cartEntity = cartEntityPromise;
          emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderSearchFoodVariationModalRepeatResponseEvent(TableOrderSearchFoodVariationModalRepeatResponseEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    try {
      int index = state.response.foods!.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        List<pos_food_in_cart_model.AddonConfigModel> savedAddon = <pos_food_in_cart_model.AddonConfigModel>[];
        savedAddon.clear();
        List<String> newAddonIds = <String>[];
        newAddonIds.clear();
        final String locale = await _authRepository.getLocale();
        for (var element in event.data.cartItem!.addons!) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          pos_food_in_cart_model.AddonConfigModel savedData = pos_food_in_cart_model.AddonConfigModel.fromJson(myMap, locale.toString());
          newAddonIds.add(savedData.id!);
          savedAddon.add(savedData);
        }

        List<pos_food_in_cart_model.VariationConfigModel> savedVariations = <pos_food_in_cart_model.VariationConfigModel>[];
        savedVariations.clear();
        List<String> newVariationIds = <String>[];
        for (var element in event.data.cartItem!.variations!) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          pos_food_in_cart_model.VariationConfigModel savedData = pos_food_in_cart_model.VariationConfigModel.fromJson(myMap);
          for (var op in savedData.options!) {
            newVariationIds.add('${savedData.title}-${op.name}');
          }
          savedVariations.add(savedData);
        }
        newAddonIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
        newVariationIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));

        bool isSameProduct = false;
        String sameUuid = '';
        await _posRepository.getRepeatList(event.id, state.tableId).then((value) {
          List<String> existingAddonIds = <String>[];
          existingAddonIds.clear();
          List<String> existingVariationIds = <String>[];
          existingVariationIds.clear();
          for (var element in value) {
            for (var addn in element.addons!) {
              existingAddonIds.add(addn.id!);
            }
            for (var variant in element.variations!) {
              for (var ops in variant.options!) {
                existingVariationIds.add('${variant.title}-${ops.name}');
              }
            }
            existingAddonIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
            existingVariationIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));
            if (newAddonIds.join('') == existingAddonIds.join('') && newVariationIds.join('') == existingVariationIds.join('')) {
              sameUuid = element.uuid!;
              isSameProduct = true;
            }
          }
        });
        if (isSameProduct && sameUuid.isNotEmpty && sameUuid != '') {
          int quantity = (int.parse(state.response.foods![index].quantity.toString()) + int.parse(event.data.cartItem!.quantity.toString()));
          if (quantity < state.response.foods![index].purchaseLimit!) {
            bool checkAddonHaveStock = true;
            bool checkVariationHaveStock = true;
            int addonOutOfStockLimitNumber = 0;
            int variationOutOfStockLimitNumber = 0;
            for (var addon in savedAddon) {
              if (quantity >= addon.stockNumber!) {
                checkAddonHaveStock = false;
                if (addonOutOfStockLimitNumber == 0) {
                  addonOutOfStockLimitNumber = addon.stockNumber!;
                }
              }
            }
            for (var variation in savedVariations) {
              for (var options in variation.options!) {
                if (quantity >= options.stock!) {
                  checkVariationHaveStock = false;
                  if (variationOutOfStockLimitNumber == 0) {
                    variationOutOfStockLimitNumber = options.stock!;
                  }
                }
              }
            }
            if (state.response.foods![index].stockType! == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
              state.response.foods![index].quantity = quantity;
              await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.response.foods![index].cartEntity = cartEntityPromise;
              emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
            } else if (quantity < state.response.foods![index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
              state.response.foods![index].quantity = quantity;
              await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.response.foods![index].cartEntity = cartEntityPromise;
              emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
            } else {
              if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
                emit(
                  state.copyWith(
                    response: state.response,
                    status: TableOrderSearchFoodStatus.searchCartError,
                    statusCode: 0,
                    alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                    extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                  ),
                );
              } else {
                state.response.foods![index].quantity = state.response.foods![index].stockNumber!;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.response.foods![index].stockNumber!, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.response.foods![index].cartEntity = cartEntityPromise;
                emit(
                  state.copyWith(
                    response: state.response,
                    status: TableOrderSearchFoodStatus.searchCartError,
                    statusCode: 0,
                    alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                    extraMessage: '${state.response.foods![index].stockNumber!}',
                  ),
                );
              }
            }
          } else {
            state.response.foods![index].quantity = state.response.foods![index].purchaseLimit!;
            await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.response.foods![index].purchaseLimit!, state.tableId);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.response.foods![index].cartEntity = cartEntityPromise;
            emit(
              state.copyWith(
                response: state.response,
                status: TableOrderSearchFoodStatus.searchCartError,
                statusCode: 0,
                alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                extraMessage: '${state.response.foods![index].purchaseLimit!}',
              ),
            );
          }
        } else {
          int quantity = (int.parse(state.response.foods![index].quantity.toString()) + int.parse(event.data.cartItem!.quantity.toString()));
          List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
          savedFoodTranslation.clear();
          for (var element in state.response.foods![index].translations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
            savedFoodTranslation.add(savedData);
          }

          List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
          foodTaxation.clear();
          final String locale = await _authRepository.getLocale();
          for (var element in state.response.foods![index].foodtaxations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
            foodTaxation.add(savedData);
          }

          PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
            uuid: Uuid().generateV4(),
            name: state.response.foods![index].name,
            shortDescription: state.response.foods![index].shortDescription,
            image: state.response.foods![index].image,
            foodType: state.response.foods![index].foodType,
            price: state.response.foods![index].price,
            discountType: state.response.foods![index].discountType,
            discount: state.response.foods![index].discount,
            offerPrice: state.response.foods![index].offerPrice,
            purchaseLimit: state.response.foods![index].purchaseLimit,
            stockNumber: state.response.foods![index].stockNumber,
            stockType: state.response.foods![index].stockType,
            quantity: event.data.cartItem!.quantity,
            id: event.id,
            addons: savedAddon,
            variations: savedVariations,
            translations: savedFoodTranslation,
            status: state.response.foods![index].status,
            inStock: state.response.foods![index].inStock,
            startTime: state.response.foods![index].startTime,
            endTime: state.response.foods![index].endTime,
            taxationEnable: state.response.foods![index].taxationEnable!,
            foodtaxations: foodTaxation,
            instruction: event.data.instruction!,
            tableId: state.tableId,
            locale: locale.toString(),
          );
          state.response.foods![index].quantity = quantity;
          await _posRepository.addToCartLocal(foodInCartInfo);
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
          state.response.foods![index].cartEntity = cartEntityPromise;
          emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderSearchFoodQuantityIncreaseEvent(TableOrderSearchFoodQuantityIncreaseEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    try {
      int index = state.response.foods!.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        if (state.response.foods![index].quantity! < state.response.foods![index].purchaseLimit!) {
          if (state.response.foods![index].stockType! == 'unlimited') {
            state.response.foods![index].quantity = state.response.foods![index].quantity! + 1;
            await _posRepository.updateProductQuantityInCartLocal(event.id, state.response.foods![index].quantity!, state.tableId);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.response.foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
          } else if (state.response.foods![index].quantity! < state.response.foods![index].stockNumber!) {
            state.response.foods![index].quantity = state.response.foods![index].quantity! + 1;
            await _posRepository.updateProductQuantityInCartLocal(event.id, state.response.foods![index].quantity!, state.tableId);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.response.foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderSearchFoodStatus.searchCartUpdate, response: state.response));
          } else {
            emit(
              state.copyWith(
                status: TableOrderSearchFoodStatus.searchCartError,
                statusCode: 0,
                alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                extraMessage: '${state.response.foods![index].stockNumber!}',
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              status: TableOrderSearchFoodStatus.searchCartError,
              statusCode: 0,
              alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
              extraMessage: '${state.response.foods![index].purchaseLimit}',
            ),
          );
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderSearchFoodExecuteQueryEvent(TableOrderSearchFoodExecuteQueryEvent event, Emitter<TableOrderSearchFoodState> emit) async {
    if (event.query.length >= 3) {
      try {
        DioApiResponse response = await _posRepository.waiterFoodSearch(event.query);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _authRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          PosFoodSearchResultResponseModel searchResult = PosFoodSearchResultResponseModel.fromJson(myMap, locale.toString());
          for (var element in searchResult.foods!) {
            if (await _posRepository.checkProductInCart(element.id!, state.tableId)) {
              final int? quantityPromise = await _posRepository.getQuantity(element.id!, state.tableId);
              element.quantity = quantityPromise;
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(element.id!, state.tableId);
              element.cartEntity = cartEntityPromise;
            } else {
              element.quantity = 0;
              element.cartEntity = 'single';
            }
          }
          emit(state.copyWith(status: searchResult.foods!.isEmpty ? TableOrderSearchFoodStatus.empty : TableOrderSearchFoodStatus.success, response: searchResult));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: TableOrderSearchFoodStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      emit(state.copyWith(status: TableOrderSearchFoodStatus.initial));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
