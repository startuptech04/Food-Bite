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
import 'package:flutter/material.dart';
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/models/pos_food_info_modal_response_model.dart';
import 'package:waiter/app/core/models/pos_food_variations_response_data_modal_model.dart';
import 'package:waiter/app/core/models/pos_order_model.dart';
import 'package:waiter/app/core/models/pos_restaurant_modal_category_model.dart';
import 'package:waiter/app/core/models/pos_repeat_quantity_modal_response_model.dart';
import 'package:waiter/app/core/models/pos_food_in_cart_model.dart';
import 'package:waiter/app/core/models/pos_food_in_cart_model.dart' as pos_food_in_cart_model;
import 'package:waiter/app/core/models/server_error_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/core/repositories/pos_repository.dart';
import 'package:waiter/app/services/uuid_generator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_order_dashboard_event.dart';
part 'table_order_dashboard_state.dart';

class TableOrderDashboardBloc extends Bloc<TableOrderDashboardEvent, TableOrderDashboardState> {
  final PosRepository _posRepository = PosRepository();
  final AuthRepository _authRepository = AuthRepository();
  TableOrderDashboardBloc()
    : super(
        TableOrderDashboardState(
          model: PosOrderModel(main: [], custom: [], success: false, locale: ''),
        ),
      ) {
    on<TableOrderDashboardInitialEvent>(_onTableOrderDashboardInitialEvent);
    on<TableOrderDashboardScrollToCategoryEvent>(_onTableOrderDashboardScrollToCategoryEvent);
    on<TableOrderDashboardToggleCustomCategoryViewEvent>(_onTableOrderDashboardToggleCustomCategoryViewEvent);
    on<TableOrderDashboardToggleMainCategoryViewEvent>(_onTableOrderDashboardToggleMainCategoryViewEvent);
    on<TableOrderDashboardFoodModalResponseEvent>(_onTableOrderDashboardFoodModalResponseEvent);
    on<TableOrderDashboardVariationModalResponseEvent>(_onTableOrderDashboardVariationModalResponseEvent);
    on<TableOrderDashboardAddCartEvent>(_onTableOrderDashboardAddCartEvent);
    on<TableOrderDashboardRefreshCartDataEvent>(_onTableOrderDashboardRefreshCartDataEvent);
    on<TableOrderDashboardFoodQuantityDecreaseEvent>(_onTableOrderDashboardFoodQuantityDecreaseEvent);
    on<TableOrderDashboardFoodQuantityIncreaseEvent>(_onTableOrderDashboardFoodQuantityIncreaseEvent);
    on<TableOrderDashboardRepeatFoodOrderResponseEvent>(_onTableOrderDashboardRepeatFoodOrderResponseEvent);
    on<TableOrderDashboardFoodVariationModalRepeatResponseEvent>(_onTableOrderDashboardFoodVariationModalRepeatResponseEvent);
  }

  FutureOr<void> _onTableOrderDashboardInitialEvent(TableOrderDashboardInitialEvent event, Emitter<TableOrderDashboardState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "table_order_list"}, 'table_order_list_screen', 'table_order_list_screen');
      emit(state.copyWith(status: TableOrderDashboardStatus.loading, tableNumber: event.tableNumber, tableId: event.tableId));
      DioApiResponse response = await _posRepository.getFoodListForOrder();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PosOrderModel data = PosOrderModel.fromJson(myMap, locale.toString());
        List<PosRestaurantModalCategoryModel> categoryList = <PosRestaurantModalCategoryModel>[];
        final Map<String, GlobalKey> tempGlobalMainCategoriesKey = {};
        tempGlobalMainCategoriesKey['main_recommended'] = GlobalKey();
        for (var element in data.custom!) {
          PosRestaurantModalCategoryModel custom = PosRestaurantModalCategoryModel(id: element.categoryId, name: element.categoryName, count: element.foods!.length);
          categoryList.add(custom);
          tempGlobalMainCategoriesKey['main_${element.categoryId}'] = GlobalKey();
        }
        for (var element in data.main!) {
          PosRestaurantModalCategoryModel main = PosRestaurantModalCategoryModel(id: element.categoryId, name: element.categoryName, count: element.foods!.length);
          categoryList.add(main);
          tempGlobalMainCategoriesKey['main_${element.categoryId}'] = GlobalKey();
        }

        for (var main in data.custom!) {
          for (var element in main.foods!) {
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
        }

        for (var main in data.main!) {
          for (var element in main.foods!) {
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
        }

        emit(
          state.copyWith(
            model: data,
            appLocale: locale.toString(),
            category: categoryList,
            globalMainCategoriesKey: tempGlobalMainCategoriesKey,
            categoryInView: categoryList.isNotEmpty ? categoryList.first.id : '',
            status: TableOrderDashboardStatus.success,
          ),
        );
        add(TableOrderDashboardRefreshCartDataEvent());
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrderDashboardStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDashboardStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderDashboardScrollToCategoryEvent(TableOrderDashboardScrollToCategoryEvent event, Emitter<TableOrderDashboardState> emit) async {
    emit(state.copyWith(categoryInView: event.categoryId, status: TableOrderDashboardStatus.success));
  }

  FutureOr<void> _onTableOrderDashboardToggleCustomCategoryViewEvent(TableOrderDashboardToggleCustomCategoryViewEvent event, Emitter<TableOrderDashboardState> emit) async {
    state.model.custom![event.categoryIndex].isOpen = !state.model.custom![event.categoryIndex].isOpen;
    emit(state.copyWith(model: state.model, status: TableOrderDashboardStatus.success));
  }

  FutureOr<void> _onTableOrderDashboardToggleMainCategoryViewEvent(TableOrderDashboardToggleMainCategoryViewEvent event, Emitter<TableOrderDashboardState> emit) async {
    state.model.main![event.categoryIndex].isOpen = !state.model.main![event.categoryIndex].isOpen;
    emit(state.copyWith(model: state.model, status: TableOrderDashboardStatus.success));
  }

  FutureOr<void> _onTableOrderDashboardFoodModalResponseEvent(TableOrderDashboardFoodModalResponseEvent event, Emitter<TableOrderDashboardState> emit) async {
    try {
      if (event.from == 'custom') {
        int index = state.model.custom![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
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
            int quantity = (int.parse(state.model.custom![event.categoryIndex].foods![index].quantity.toString()) + int.parse(event.response.cartItem!.quantity.toString()));
            if (quantity < state.model.custom![event.categoryIndex].foods![index].purchaseLimit!) {
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
              if (state.model.custom![event.categoryIndex].foods![index].stockType! == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
                state.model.custom![event.categoryIndex].foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
                add(TableOrderDashboardRefreshCartDataEvent());
              } else if (quantity < state.model.custom![event.categoryIndex].foods![index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
                state.model.custom![event.categoryIndex].foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
                add(TableOrderDashboardRefreshCartDataEvent());
              } else {
                if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
                  emit(
                    state.copyWith(
                      model: state.model,
                      status: TableOrderDashboardStatus.cartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                      extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                    ),
                  );
                } else {
                  state.model.custom![event.categoryIndex].foods![index].quantity = state.model.custom![event.categoryIndex].foods![index].stockNumber!;
                  await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.model.custom![event.categoryIndex].foods![index].stockNumber!, state.tableId);
                  final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                  state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                  emit(
                    state.copyWith(
                      model: state.model,
                      status: TableOrderDashboardStatus.cartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                      extraMessage: '${state.model.custom![event.categoryIndex].foods![index].stockNumber!}',
                    ),
                  );
                  add(TableOrderDashboardRefreshCartDataEvent());
                }
              }
            } else {
              state.model.custom![event.categoryIndex].foods![index].quantity = state.model.custom![event.categoryIndex].foods![index].purchaseLimit!;
              await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.model.custom![event.categoryIndex].foods![index].purchaseLimit!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
              emit(
                state.copyWith(
                  model: state.model,
                  status: TableOrderDashboardStatus.cartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                  extraMessage: '${state.model.custom![event.categoryIndex].foods![index].purchaseLimit!}',
                ),
              );
              add(TableOrderDashboardRefreshCartDataEvent());
            }
          } else {
            int quantity = (int.parse(state.model.custom![event.categoryIndex].foods![index].quantity.toString()) + int.parse(event.response.cartItem!.quantity.toString()));
            List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
            savedFoodTranslation.clear();
            for (var element in state.model.custom![event.categoryIndex].foods![index].translations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
              savedFoodTranslation.add(savedData);
            }
            final String locale = await _authRepository.getLocale();
            List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
            foodTaxation.clear();
            for (var element in state.model.custom![event.categoryIndex].foods![index].foodtaxations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
              foodTaxation.add(savedData);
            }

            PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
              uuid: Uuid().generateV4(),
              name: state.model.custom![event.categoryIndex].foods![index].name,
              shortDescription: state.model.custom![event.categoryIndex].foods![index].shortDescription,
              image: state.model.custom![event.categoryIndex].foods![index].image,
              foodType: state.model.custom![event.categoryIndex].foods![index].foodType,
              price: state.model.custom![event.categoryIndex].foods![index].price,
              discountType: state.model.custom![event.categoryIndex].foods![index].discountType,
              discount: state.model.custom![event.categoryIndex].foods![index].discount,
              offerPrice: state.model.custom![event.categoryIndex].foods![index].offerPrice,
              purchaseLimit: state.model.custom![event.categoryIndex].foods![index].purchaseLimit,
              stockNumber: state.model.custom![event.categoryIndex].foods![index].stockNumber,
              stockType: state.model.custom![event.categoryIndex].foods![index].stockType,
              quantity: event.response.cartItem!.quantity,
              id: event.id,
              addons: savedAddon,
              variations: savedVariations,
              translations: savedFoodTranslation,
              status: state.model.custom![event.categoryIndex].foods![index].status,
              inStock: state.model.custom![event.categoryIndex].foods![index].inStock,
              startTime: state.model.custom![event.categoryIndex].foods![index].startTime,
              endTime: state.model.custom![event.categoryIndex].foods![index].endTime,
              taxationEnable: state.model.custom![event.categoryIndex].foods![index].taxationEnable!,
              foodtaxations: foodTaxation,
              instruction: event.response.instruction!,
              tableId: state.tableId,
              locale: locale.toString(),
            );
            state.model.custom![event.categoryIndex].foods![index].quantity = quantity;
            await _posRepository.addToCartLocal(foodInCartInfo);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
            add(TableOrderDashboardRefreshCartDataEvent());
          }
        }
      } else if (event.from == 'main') {
        int index = state.model.main![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
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
            int quantity = (int.parse(state.model.main![event.categoryIndex].foods![index].quantity.toString()) + int.parse(event.response.cartItem!.quantity.toString()));
            if (quantity < state.model.main![event.categoryIndex].foods![index].purchaseLimit!) {
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
              if (state.model.main![event.categoryIndex].foods![index].stockType! == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
                state.model.main![event.categoryIndex].foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
                add(TableOrderDashboardRefreshCartDataEvent());
              } else if (quantity < state.model.main![event.categoryIndex].foods![index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
                state.model.main![event.categoryIndex].foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
                add(TableOrderDashboardRefreshCartDataEvent());
              } else {
                if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
                  emit(
                    state.copyWith(
                      model: state.model,
                      status: TableOrderDashboardStatus.cartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                      extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                    ),
                  );
                } else {
                  state.model.main![event.categoryIndex].foods![index].quantity = state.model.main![event.categoryIndex].foods![index].stockNumber!;
                  await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.model.main![event.categoryIndex].foods![index].stockNumber!, state.tableId);
                  final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                  state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                  emit(
                    state.copyWith(
                      model: state.model,
                      status: TableOrderDashboardStatus.cartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                      extraMessage: '${state.model.main![event.categoryIndex].foods![index].stockNumber!}',
                    ),
                  );
                  add(TableOrderDashboardRefreshCartDataEvent());
                }
              }
            } else {
              state.model.main![event.categoryIndex].foods![index].quantity = state.model.main![event.categoryIndex].foods![index].purchaseLimit!;
              await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.model.main![event.categoryIndex].foods![index].purchaseLimit!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
              emit(
                state.copyWith(
                  model: state.model,
                  status: TableOrderDashboardStatus.cartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                  extraMessage: '${state.model.main![event.categoryIndex].foods![index].purchaseLimit!}',
                ),
              );
              add(TableOrderDashboardRefreshCartDataEvent());
            }
          } else {
            int quantity = (int.parse(state.model.main![event.categoryIndex].foods![index].quantity.toString()) + int.parse(event.response.cartItem!.quantity.toString()));
            List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
            savedFoodTranslation.clear();
            for (var element in state.model.main![event.categoryIndex].foods![index].translations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
              savedFoodTranslation.add(savedData);
            }

            List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
            foodTaxation.clear();
            final String locale = await _authRepository.getLocale();
            for (var element in state.model.main![event.categoryIndex].foods![index].foodtaxations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
              foodTaxation.add(savedData);
            }

            PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
              uuid: Uuid().generateV4(),
              name: state.model.main![event.categoryIndex].foods![index].name,
              shortDescription: state.model.main![event.categoryIndex].foods![index].shortDescription,
              image: state.model.main![event.categoryIndex].foods![index].image,
              foodType: state.model.main![event.categoryIndex].foods![index].foodType,
              price: state.model.main![event.categoryIndex].foods![index].price,
              discountType: state.model.main![event.categoryIndex].foods![index].discountType,
              discount: state.model.main![event.categoryIndex].foods![index].discount,
              offerPrice: state.model.main![event.categoryIndex].foods![index].offerPrice,
              purchaseLimit: state.model.main![event.categoryIndex].foods![index].purchaseLimit,
              stockNumber: state.model.main![event.categoryIndex].foods![index].stockNumber,
              stockType: state.model.main![event.categoryIndex].foods![index].stockType,
              quantity: event.response.cartItem!.quantity,
              id: event.id,
              addons: savedAddon,
              variations: savedVariations,
              translations: savedFoodTranslation,
              status: state.model.main![event.categoryIndex].foods![index].status,
              inStock: state.model.main![event.categoryIndex].foods![index].inStock,
              startTime: state.model.main![event.categoryIndex].foods![index].startTime,
              endTime: state.model.main![event.categoryIndex].foods![index].endTime,
              taxationEnable: state.model.main![event.categoryIndex].foods![index].taxationEnable!,
              foodtaxations: foodTaxation,
              instruction: event.response.instruction!,
              tableId: state.tableId,
              locale: locale.toString(),
            );
            state.model.main![event.categoryIndex].foods![index].quantity = quantity;
            await _posRepository.addToCartLocal(foodInCartInfo);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
            add(TableOrderDashboardRefreshCartDataEvent());
          }
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDashboardStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderDashboardVariationModalResponseEvent(TableOrderDashboardVariationModalResponseEvent event, Emitter<TableOrderDashboardState> emit) async {
    try {
      if (event.from == 'custom') {
        int index = state.model.custom![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          state.model.custom![event.categoryIndex].foods![index].quantity = event.data.cartItem!.quantity;

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
          for (var element in state.model.custom![event.categoryIndex].foods![index].translations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
            savedFoodTranslation.add(savedData);
          }

          List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
          foodTaxation.clear();

          for (var element in state.model.custom![event.categoryIndex].foods![index].foodtaxations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
            foodTaxation.add(savedData);
          }

          PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
            uuid: Uuid().generateV4(),
            name: state.model.custom![event.categoryIndex].foods![index].name,
            shortDescription: state.model.custom![event.categoryIndex].foods![index].shortDescription,
            image: state.model.custom![event.categoryIndex].foods![index].image,
            foodType: state.model.custom![event.categoryIndex].foods![index].foodType,
            price: state.model.custom![event.categoryIndex].foods![index].price,
            discountType: state.model.custom![event.categoryIndex].foods![index].discountType,
            discount: state.model.custom![event.categoryIndex].foods![index].discount,
            offerPrice: state.model.custom![event.categoryIndex].foods![index].offerPrice,
            purchaseLimit: state.model.custom![event.categoryIndex].foods![index].purchaseLimit,
            stockNumber: state.model.custom![event.categoryIndex].foods![index].stockNumber,
            stockType: state.model.custom![event.categoryIndex].foods![index].stockType,
            quantity: event.data.cartItem!.quantity,
            id: event.id,
            addons: savedAddon,
            variations: savedVariations,
            translations: savedFoodTranslation,
            status: state.model.custom![event.categoryIndex].foods![index].status,
            inStock: state.model.custom![event.categoryIndex].foods![index].inStock,
            startTime: state.model.custom![event.categoryIndex].foods![index].startTime,
            endTime: state.model.custom![event.categoryIndex].foods![index].endTime,
            taxationEnable: state.model.custom![event.categoryIndex].foods![index].taxationEnable!,
            foodtaxations: foodTaxation,
            instruction: event.data.instruction!,
            tableId: state.tableId,
            locale: locale.toString(),
          );

          await _posRepository.addToCartLocal(foodInCartInfo);
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
          state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
          emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
          add(TableOrderDashboardRefreshCartDataEvent());
        }
      } else if (event.from == 'main') {
        int index = state.model.main![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          state.model.main![event.categoryIndex].foods![index].quantity = event.data.cartItem!.quantity;

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

          newAddonIds.sort((a, b) => a.toLowerCase().toString().compareTo(b.toLowerCase().toString()));

          List<pos_food_in_cart_model.VariationConfigModel> savedVariations = <pos_food_in_cart_model.VariationConfigModel>[];
          savedVariations.clear();
          for (var element in event.data.cartItem!.variations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.VariationConfigModel savedData = pos_food_in_cart_model.VariationConfigModel.fromJson(myMap);
            savedVariations.add(savedData);
          }

          List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
          savedFoodTranslation.clear();
          for (var element in state.model.main![event.categoryIndex].foods![index].translations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
            savedFoodTranslation.add(savedData);
          }

          List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
          foodTaxation.clear();
          for (var element in state.model.main![event.categoryIndex].foods![index].foodtaxations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
            foodTaxation.add(savedData);
          }

          PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
            uuid: Uuid().generateV4(),
            name: state.model.main![event.categoryIndex].foods![index].name,
            shortDescription: state.model.main![event.categoryIndex].foods![index].shortDescription,
            image: state.model.main![event.categoryIndex].foods![index].image,
            foodType: state.model.main![event.categoryIndex].foods![index].foodType,
            price: state.model.main![event.categoryIndex].foods![index].price,
            discountType: state.model.main![event.categoryIndex].foods![index].discountType,
            discount: state.model.main![event.categoryIndex].foods![index].discount,
            offerPrice: state.model.main![event.categoryIndex].foods![index].offerPrice,
            purchaseLimit: state.model.main![event.categoryIndex].foods![index].purchaseLimit,
            stockNumber: state.model.main![event.categoryIndex].foods![index].stockNumber,
            stockType: state.model.main![event.categoryIndex].foods![index].stockType,
            quantity: event.data.cartItem!.quantity,
            id: event.id,
            addons: savedAddon,
            variations: savedVariations,
            translations: savedFoodTranslation,
            status: state.model.main![event.categoryIndex].foods![index].status,
            inStock: state.model.main![event.categoryIndex].foods![index].inStock,
            startTime: state.model.main![event.categoryIndex].foods![index].startTime,
            endTime: state.model.main![event.categoryIndex].foods![index].endTime,
            taxationEnable: state.model.main![event.categoryIndex].foods![index].taxationEnable!,
            foodtaxations: foodTaxation,
            instruction: event.data.instruction!,
            tableId: state.tableId,
            locale: locale.toString(),
          );

          await _posRepository.addToCartLocal(foodInCartInfo);
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
          state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
          emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
          add(TableOrderDashboardRefreshCartDataEvent());
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDashboardStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderDashboardAddCartEvent(TableOrderDashboardAddCartEvent event, Emitter<TableOrderDashboardState> emit) async {
    try {
      if (event.from == 'custom') {
        int index = state.model.custom![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          state.model.custom![event.categoryIndex].foods![index].quantity = 1;
          List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
          savedFoodTranslation.clear();
          for (var element in state.model.custom![event.categoryIndex].foods![index].translations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
            savedFoodTranslation.add(savedData);
          }

          List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
          foodTaxation.clear();
          final String locale = await _authRepository.getLocale();
          for (var element in state.model.custom![event.categoryIndex].foods![index].foodtaxations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
            foodTaxation.add(savedData);
          }

          PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
            uuid: Uuid().generateV4(),
            name: state.model.custom![event.categoryIndex].foods![index].name,
            shortDescription: state.model.custom![event.categoryIndex].foods![index].shortDescription,
            image: state.model.custom![event.categoryIndex].foods![index].image,
            foodType: state.model.custom![event.categoryIndex].foods![index].foodType,
            price: state.model.custom![event.categoryIndex].foods![index].price,
            discountType: state.model.custom![event.categoryIndex].foods![index].discountType,
            discount: state.model.custom![event.categoryIndex].foods![index].discount,
            offerPrice: state.model.custom![event.categoryIndex].foods![index].offerPrice,
            purchaseLimit: state.model.custom![event.categoryIndex].foods![index].purchaseLimit,
            stockNumber: state.model.custom![event.categoryIndex].foods![index].stockNumber,
            stockType: state.model.custom![event.categoryIndex].foods![index].stockType,
            quantity: 1,
            id: event.id,
            addons: [],
            variations: [],
            translations: savedFoodTranslation,
            status: state.model.custom![event.categoryIndex].foods![index].status,
            inStock: state.model.custom![event.categoryIndex].foods![index].inStock,
            startTime: state.model.custom![event.categoryIndex].foods![index].startTime,
            endTime: state.model.custom![event.categoryIndex].foods![index].endTime,
            taxationEnable: state.model.custom![event.categoryIndex].foods![index].taxationEnable!,
            foodtaxations: foodTaxation,
            instruction: '',
            tableId: state.tableId,
            locale: locale.toString(),
          );
          await _posRepository.addToCartLocal(foodInCartInfo);
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
          state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
          emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
          add(TableOrderDashboardRefreshCartDataEvent());
        }
      } else if (event.from == 'main') {
        int index = state.model.main![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          state.model.main![event.categoryIndex].foods![index].quantity = 1;

          List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
          savedFoodTranslation.clear();
          for (var element in state.model.main![event.categoryIndex].foods![index].translations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
            savedFoodTranslation.add(savedData);
          }

          List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
          foodTaxation.clear();
          final String locale = await _authRepository.getLocale();
          for (var element in state.model.main![event.categoryIndex].foods![index].foodtaxations!) {
            var convertedItem = jsonEncode(element).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
            foodTaxation.add(savedData);
          }

          PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
            uuid: Uuid().generateV4(),
            name: state.model.main![event.categoryIndex].foods![index].name,
            shortDescription: state.model.main![event.categoryIndex].foods![index].shortDescription,
            image: state.model.main![event.categoryIndex].foods![index].image,
            foodType: state.model.main![event.categoryIndex].foods![index].foodType,
            price: state.model.main![event.categoryIndex].foods![index].price,
            discountType: state.model.main![event.categoryIndex].foods![index].discountType,
            discount: state.model.main![event.categoryIndex].foods![index].discount,
            offerPrice: state.model.main![event.categoryIndex].foods![index].offerPrice,
            purchaseLimit: state.model.main![event.categoryIndex].foods![index].purchaseLimit,
            stockNumber: state.model.main![event.categoryIndex].foods![index].stockNumber,
            stockType: state.model.main![event.categoryIndex].foods![index].stockType,
            quantity: 1,
            id: event.id,
            addons: [],
            variations: [],
            translations: savedFoodTranslation,
            status: state.model.main![event.categoryIndex].foods![index].status,
            inStock: state.model.main![event.categoryIndex].foods![index].inStock,
            startTime: state.model.main![event.categoryIndex].foods![index].startTime,
            endTime: state.model.main![event.categoryIndex].foods![index].endTime,
            taxationEnable: state.model.main![event.categoryIndex].foods![index].taxationEnable!,
            foodtaxations: foodTaxation,
            instruction: '',
            tableId: state.tableId,
            locale: locale.toString(),
          );
          await _posRepository.addToCartLocal(foodInCartInfo);
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
          state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
          emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
          add(TableOrderDashboardRefreshCartDataEvent());
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDashboardStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderDashboardRefreshCartDataEvent(TableOrderDashboardRefreshCartDataEvent event, Emitter<TableOrderDashboardState> emit) async {
    for (var main in state.model.custom!) {
      // ignore: avoid_function_literals_in_foreach_calls
      main.foods!.forEach((element) async {
        if (await _posRepository.checkProductInCart(element.id!, state.tableId)) {
          final int? quantityPromise = await _posRepository.getQuantity(element.id!, state.tableId);
          element.quantity = quantityPromise;
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(element.id!, state.tableId);
          element.cartEntity = cartEntityPromise;
        } else {
          element.quantity = 0;
          element.cartEntity = 'single';
        }
      });
    }

    for (var main in state.model.main!) {
      // ignore: avoid_function_literals_in_foreach_calls
      main.foods!.forEach((element) async {
        if (await _posRepository.checkProductInCart(element.id!, state.tableId)) {
          final int? quantityPromise = await _posRepository.getQuantity(element.id!, state.tableId);
          element.quantity = quantityPromise;
          final String? cartEntityPromise = await _posRepository.getProductCartEntity(element.id!, state.tableId);
          element.cartEntity = cartEntityPromise;
        } else {
          element.quantity = 0;
          element.cartEntity = 'single';
        }
      });
    }

    int cartTotalItem = 0;
    await _posRepository.getByTableId(state.tableId).then((value) {
      for (var element in value) {
        cartTotalItem = cartTotalItem + element.quantity!;
      }
    });
    emit(state.copyWith(cartTotalItem: cartTotalItem));
  }

  FutureOr<void> _onTableOrderDashboardFoodQuantityDecreaseEvent(TableOrderDashboardFoodQuantityDecreaseEvent event, Emitter<TableOrderDashboardState> emit) async {
    try {
      if (event.from == 'custom') {
        int index = state.model.custom![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          if (state.model.custom![event.categoryIndex].foods![index].quantity! > 1) {
            state.model.custom![event.categoryIndex].foods![index].quantity = state.model.custom![event.categoryIndex].foods![index].quantity! - 1;
            await _posRepository.updateProductQuantityInCartLocal(event.id, state.model.custom![event.categoryIndex].foods![index].quantity!, state.tableId);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
            add(TableOrderDashboardRefreshCartDataEvent());
          } else {
            state.model.custom![event.categoryIndex].foods![index].quantity = 0;
            await _posRepository.removeFromCartLocal(event.id, state.tableId);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
            add(TableOrderDashboardRefreshCartDataEvent());
          }
        }
      } else if (event.from == 'main') {
        int index = state.model.main![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          if (state.model.main![event.categoryIndex].foods![index].quantity! > 1) {
            state.model.main![event.categoryIndex].foods![index].quantity = state.model.main![event.categoryIndex].foods![index].quantity! - 1;
            await _posRepository.updateProductQuantityInCartLocal(event.id, state.model.main![event.categoryIndex].foods![index].quantity!, state.tableId);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
            add(TableOrderDashboardRefreshCartDataEvent());
          } else {
            state.model.main![event.categoryIndex].foods![index].quantity = 0;
            await _posRepository.removeFromCartLocal(event.id, state.tableId);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
            add(TableOrderDashboardRefreshCartDataEvent());
          }
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDashboardStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderDashboardFoodQuantityIncreaseEvent(TableOrderDashboardFoodQuantityIncreaseEvent event, Emitter<TableOrderDashboardState> emit) async {
    try {
      if (event.from == 'custom') {
        int index = state.model.custom![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          if (state.model.custom![event.categoryIndex].foods![index].quantity! < state.model.custom![event.categoryIndex].foods![index].purchaseLimit!) {
            if (state.model.custom![event.categoryIndex].foods![index].stockType! == 'unlimited') {
              state.model.custom![event.categoryIndex].foods![index].quantity = state.model.custom![event.categoryIndex].foods![index].quantity! + 1;
              await _posRepository.updateProductQuantityInCartLocal(event.id, state.model.custom![event.categoryIndex].foods![index].quantity!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
              emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
              add(TableOrderDashboardRefreshCartDataEvent());
            } else if (state.model.custom![event.categoryIndex].foods![index].quantity! < state.model.custom![event.categoryIndex].foods![index].stockNumber!) {
              state.model.custom![event.categoryIndex].foods![index].quantity = state.model.custom![event.categoryIndex].foods![index].quantity! + 1;
              await _posRepository.updateProductQuantityInCartLocal(event.id, state.model.custom![event.categoryIndex].foods![index].quantity!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
              emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
              add(TableOrderDashboardRefreshCartDataEvent());
            } else {
              emit(
                state.copyWith(
                  status: TableOrderDashboardStatus.cartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                  extraMessage: '${state.model.custom![event.categoryIndex].foods![index].stockNumber!}',
                ),
              );
            }
          } else {
            emit(
              state.copyWith(
                status: TableOrderDashboardStatus.cartError,
                statusCode: 0,
                alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                extraMessage: '${state.model.custom![event.categoryIndex].foods![index].purchaseLimit}',
              ),
            );
          }
        }
      } else if (event.from == 'main') {
        int index = state.model.main![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          if (state.model.main![event.categoryIndex].foods![index].quantity! < state.model.main![event.categoryIndex].foods![index].purchaseLimit!) {
            if (state.model.main![event.categoryIndex].foods![index].stockType! == 'unlimited') {
              state.model.main![event.categoryIndex].foods![index].quantity = state.model.main![event.categoryIndex].foods![index].quantity! + 1;
              await _posRepository.updateProductQuantityInCartLocal(event.id, state.model.main![event.categoryIndex].foods![index].quantity!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
              emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
              add(TableOrderDashboardRefreshCartDataEvent());
            } else if (state.model.main![event.categoryIndex].foods![index].quantity! < state.model.main![event.categoryIndex].foods![index].stockNumber!) {
              state.model.main![event.categoryIndex].foods![index].quantity = state.model.main![event.categoryIndex].foods![index].quantity! + 1;
              await _posRepository.updateProductQuantityInCartLocal(event.id, state.model.main![event.categoryIndex].foods![index].quantity!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
              emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
              add(TableOrderDashboardRefreshCartDataEvent());
            } else {
              emit(
                state.copyWith(
                  status: TableOrderDashboardStatus.cartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                  extraMessage: '${state.model.main![event.categoryIndex].foods![index].stockNumber!}',
                ),
              );
            }
          } else {
            emit(
              state.copyWith(
                status: TableOrderDashboardStatus.cartError,
                statusCode: 0,
                alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                extraMessage: '${state.model.main![event.categoryIndex].foods![index].purchaseLimit}',
              ),
            );
          }
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDashboardStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderDashboardRepeatFoodOrderResponseEvent(TableOrderDashboardRepeatFoodOrderResponseEvent event, Emitter<TableOrderDashboardState> emit) async {
    try {
      if (event.from == 'custom') {
        for (var element in event.data.data!.list!) {
          if (element.quantity == 0) {
            await _posRepository.removeFromCartWithUuidLocal(element.uuid!, event.id, state.tableId);
          } else {
            await _posRepository.updateProductVariationInCartLocal(element.uuid!, event.id, element.quantity!, state.tableId);
          }
        }
        for (var element in state.model.custom![event.categoryIndex].foods!) {
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
        emit(state.copyWith(model: state.model, status: TableOrderDashboardStatus.cartUpdate));
        add(TableOrderDashboardRefreshCartDataEvent());
      } else if (event.from == 'main') {
        for (var element in event.data.data!.list!) {
          if (element.quantity == 0) {
            await _posRepository.removeFromCartWithUuidLocal(element.uuid!, event.id, state.tableId);
          } else {
            await _posRepository.updateProductVariationInCartLocal(element.uuid!, event.id, element.quantity!, state.tableId);
          }
        }
        for (var element in state.model.main![event.categoryIndex].foods!) {
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
        emit(state.copyWith(model: state.model, status: TableOrderDashboardStatus.cartUpdate));
        add(TableOrderDashboardRefreshCartDataEvent());
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDashboardStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderDashboardFoodVariationModalRepeatResponseEvent(TableOrderDashboardFoodVariationModalRepeatResponseEvent event, Emitter<TableOrderDashboardState> emit) async {
    try {
      if (event.from == 'custom') {
        int index = state.model.custom![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
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
            int quantity = (int.parse(state.model.custom![event.categoryIndex].foods![index].quantity.toString()) + int.parse(event.data.cartItem!.quantity.toString()));
            if (quantity < state.model.custom![event.categoryIndex].foods![index].purchaseLimit!) {
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
              if (state.model.custom![event.categoryIndex].foods![index].stockType! == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
                state.model.custom![event.categoryIndex].foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
                add(TableOrderDashboardRefreshCartDataEvent());
              } else if (quantity < state.model.custom![event.categoryIndex].foods![index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
                state.model.custom![event.categoryIndex].foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
                add(TableOrderDashboardRefreshCartDataEvent());
              } else {
                if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
                  emit(
                    state.copyWith(
                      model: state.model,
                      status: TableOrderDashboardStatus.cartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                      extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                    ),
                  );
                } else {
                  state.model.custom![event.categoryIndex].foods![index].quantity = state.model.custom![event.categoryIndex].foods![index].stockNumber!;
                  await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.model.custom![event.categoryIndex].foods![index].stockNumber!, state.tableId);
                  final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                  state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                  emit(
                    state.copyWith(
                      model: state.model,
                      status: TableOrderDashboardStatus.cartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                      extraMessage: '${state.model.custom![event.categoryIndex].foods![index].stockNumber!}',
                    ),
                  );
                  add(TableOrderDashboardRefreshCartDataEvent());
                }
              }
            } else {
              state.model.custom![event.categoryIndex].foods![index].quantity = state.model.custom![event.categoryIndex].foods![index].purchaseLimit!;
              await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.model.custom![event.categoryIndex].foods![index].purchaseLimit!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
              emit(
                state.copyWith(
                  model: state.model,
                  status: TableOrderDashboardStatus.cartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                  extraMessage: '${state.model.custom![event.categoryIndex].foods![index].purchaseLimit!}',
                ),
              );
              add(TableOrderDashboardRefreshCartDataEvent());
            }
          } else {
            int quantity = (int.parse(state.model.custom![event.categoryIndex].foods![index].quantity.toString()) + int.parse(event.data.cartItem!.quantity.toString()));
            List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
            savedFoodTranslation.clear();
            for (var element in state.model.custom![event.categoryIndex].foods![index].translations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
              savedFoodTranslation.add(savedData);
            }

            List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
            foodTaxation.clear();
            final String locale = await _authRepository.getLocale();
            for (var element in state.model.custom![event.categoryIndex].foods![index].foodtaxations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
              foodTaxation.add(savedData);
            }

            PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
              uuid: Uuid().generateV4(),
              name: state.model.custom![event.categoryIndex].foods![index].name,
              shortDescription: state.model.custom![event.categoryIndex].foods![index].shortDescription,
              image: state.model.custom![event.categoryIndex].foods![index].image,
              foodType: state.model.custom![event.categoryIndex].foods![index].foodType,
              price: state.model.custom![event.categoryIndex].foods![index].price,
              discountType: state.model.custom![event.categoryIndex].foods![index].discountType,
              discount: state.model.custom![event.categoryIndex].foods![index].discount,
              offerPrice: state.model.custom![event.categoryIndex].foods![index].offerPrice,
              purchaseLimit: state.model.custom![event.categoryIndex].foods![index].purchaseLimit,
              stockNumber: state.model.custom![event.categoryIndex].foods![index].stockNumber,
              stockType: state.model.custom![event.categoryIndex].foods![index].stockType,
              quantity: event.data.cartItem!.quantity,
              id: event.id,
              addons: savedAddon,
              variations: savedVariations,
              translations: savedFoodTranslation,
              status: state.model.custom![event.categoryIndex].foods![index].status,
              inStock: state.model.custom![event.categoryIndex].foods![index].inStock,
              startTime: state.model.custom![event.categoryIndex].foods![index].startTime,
              endTime: state.model.custom![event.categoryIndex].foods![index].endTime,
              taxationEnable: state.model.custom![event.categoryIndex].foods![index].taxationEnable!,
              foodtaxations: foodTaxation,
              instruction: event.data.instruction!,
              tableId: state.tableId,
              locale: locale.toString(),
            );
            state.model.custom![event.categoryIndex].foods![index].quantity = quantity;
            await _posRepository.addToCartLocal(foodInCartInfo);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.model.custom![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
            add(TableOrderDashboardRefreshCartDataEvent());
          }
        }
      } else if (event.from == 'main') {
        int index = state.model.main![event.categoryIndex].foods!.indexWhere((element) => element.id == event.id);
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
            int quantity = (int.parse(state.model.main![event.categoryIndex].foods![index].quantity.toString()) + int.parse(event.data.cartItem!.quantity.toString()));
            if (quantity < state.model.main![event.categoryIndex].foods![index].purchaseLimit!) {
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
              if (state.model.main![event.categoryIndex].foods![index].stockType! == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
                state.model.main![event.categoryIndex].foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
                add(TableOrderDashboardRefreshCartDataEvent());
              } else if (quantity < state.model.main![event.categoryIndex].foods![index].stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
                state.model.main![event.categoryIndex].foods![index].quantity = quantity;
                await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, quantity, state.tableId);
                final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
                add(TableOrderDashboardRefreshCartDataEvent());
              } else {
                if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
                  emit(
                    state.copyWith(
                      model: state.model,
                      status: TableOrderDashboardStatus.cartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.',
                      extraMessage: '${!checkAddonHaveStock ? addonOutOfStockLimitNumber : variationOutOfStockLimitNumber}',
                    ),
                  );
                } else {
                  state.model.main![event.categoryIndex].foods![index].quantity = state.model.main![event.categoryIndex].foods![index].stockNumber!;
                  await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.model.main![event.categoryIndex].foods![index].stockNumber!, state.tableId);
                  final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
                  state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
                  emit(
                    state.copyWith(
                      model: state.model,
                      status: TableOrderDashboardStatus.cartError,
                      statusCode: 0,
                      alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.',
                      extraMessage: '${state.model.main![event.categoryIndex].foods![index].stockNumber!}',
                    ),
                  );
                  add(TableOrderDashboardRefreshCartDataEvent());
                }
              }
            } else {
              state.model.main![event.categoryIndex].foods![index].quantity = state.model.main![event.categoryIndex].foods![index].purchaseLimit!;
              await _posRepository.updateProductVariationInCartLocal(sameUuid, event.id, state.model.main![event.categoryIndex].foods![index].purchaseLimit!, state.tableId);
              final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
              state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
              emit(
                state.copyWith(
                  model: state.model,
                  status: TableOrderDashboardStatus.cartError,
                  statusCode: 0,
                  alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food',
                  extraMessage: '${state.model.main![event.categoryIndex].foods![index].purchaseLimit!}',
                ),
              );
              add(TableOrderDashboardRefreshCartDataEvent());
            }
          } else {
            int quantity = (int.parse(state.model.main![event.categoryIndex].foods![index].quantity.toString()) + int.parse(event.data.cartItem!.quantity.toString()));
            List<pos_food_in_cart_model.FoodTranslations> savedFoodTranslation = <pos_food_in_cart_model.FoodTranslations>[];
            savedFoodTranslation.clear();
            for (var element in state.model.main![event.categoryIndex].foods![index].translations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.FoodTranslations savedData = pos_food_in_cart_model.FoodTranslations.fromJson(myMap);
              savedFoodTranslation.add(savedData);
            }

            List<pos_food_in_cart_model.TaxationConfigModel> foodTaxation = <pos_food_in_cart_model.TaxationConfigModel>[];
            foodTaxation.clear();
            final String locale = await _authRepository.getLocale();
            for (var element in state.model.main![event.categoryIndex].foods![index].foodtaxations!) {
              var convertedItem = jsonEncode(element).toString();
              Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
              pos_food_in_cart_model.TaxationConfigModel savedData = pos_food_in_cart_model.TaxationConfigModel.fromJson(myMap, locale.toString());
              foodTaxation.add(savedData);
            }

            PosFoodInCartModel foodInCartInfo = PosFoodInCartModel(
              uuid: Uuid().generateV4(),
              name: state.model.main![event.categoryIndex].foods![index].name,
              shortDescription: state.model.main![event.categoryIndex].foods![index].shortDescription,
              image: state.model.main![event.categoryIndex].foods![index].image,
              foodType: state.model.main![event.categoryIndex].foods![index].foodType,
              price: state.model.main![event.categoryIndex].foods![index].price,
              discountType: state.model.main![event.categoryIndex].foods![index].discountType,
              discount: state.model.main![event.categoryIndex].foods![index].discount,
              offerPrice: state.model.main![event.categoryIndex].foods![index].offerPrice,
              purchaseLimit: state.model.main![event.categoryIndex].foods![index].purchaseLimit,
              stockNumber: state.model.main![event.categoryIndex].foods![index].stockNumber,
              stockType: state.model.main![event.categoryIndex].foods![index].stockType,
              quantity: event.data.cartItem!.quantity,
              id: event.id,
              addons: savedAddon,
              variations: savedVariations,
              translations: savedFoodTranslation,
              status: state.model.main![event.categoryIndex].foods![index].status,
              inStock: state.model.main![event.categoryIndex].foods![index].inStock,
              startTime: state.model.main![event.categoryIndex].foods![index].startTime,
              endTime: state.model.main![event.categoryIndex].foods![index].endTime,
              taxationEnable: state.model.main![event.categoryIndex].foods![index].taxationEnable!,
              foodtaxations: foodTaxation,
              instruction: event.data.instruction!,
              tableId: state.tableId,
              locale: locale.toString(),
            );
            state.model.main![event.categoryIndex].foods![index].quantity = quantity;
            await _posRepository.addToCartLocal(foodInCartInfo);
            final String? cartEntityPromise = await _posRepository.getProductCartEntity(event.id, state.tableId);
            state.model.main![event.categoryIndex].foods![index].cartEntity = cartEntityPromise;
            emit(state.copyWith(status: TableOrderDashboardStatus.cartUpdate, model: state.model));
            add(TableOrderDashboardRefreshCartDataEvent());
          }
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDashboardStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
