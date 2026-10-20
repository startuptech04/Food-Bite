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
import 'package:waiter/app/core/models/pos_food_info_variation_modal_response_model.dart';
import 'package:waiter/app/core/models/pos_food_info_variation_modal_response_model.dart' as option_data;
import 'package:waiter/app/core/models/pos_single_food_info_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:waiter/app/core/repositories/auth_repository.dart';

part 'food_info_modal_event.dart';
part 'food_info_modal_state.dart';

class FoodInfoModalBloc extends Bloc<FoodInfoModalEvent, FoodInfoModalState> {
  final AuthRepository _authRepository = AuthRepository();
  FoodInfoModalBloc()
    : super(
        FoodInfoModalState(
          info: PosSingleFoodInfoModel(locale: ''),
          cartItem: PosFoodInfoVariationModalResponseModel(locale: ''),
        ),
      ) {
    on<FoodInfoModalInitialEvent>(_onFoodInfoModalInitialEvent);
    on<FoodInfoModalQuantityEvent>(_onFoodInfoModalQuantityEvent);
    on<FoodInfoModalSaveEvent>(_onFoodInfoModalSaveEvent);
    on<FoodInfoModalAddonsEvent>(_onFoodInfoModalAddonsEvent);
    on<FoodInfoModalVariationOptionEvent>(_onFoodInfoModalVariationOptionEvent);
    on<FoodInfoModalCookingInstructionChangeEvent>(_onFoodInfoModalCookingInstructionChangeEvent);
  }

  FutureOr<void> _onFoodInfoModalInitialEvent(FoodInfoModalInitialEvent event, Emitter<FoodInfoModalState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "food_info"}, 'food_info_screen', 'food_info_screen');
      emit(state.copyWith(status: FoodInfoModalStatus.loading, id: event.id));
      if (event.id.isNotEmpty && event.data.isNotEmpty) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(event.data) as Map<String, dynamic>;
        PosSingleFoodInfoModel data = PosSingleFoodInfoModel.fromJson(myMap, locale.toString());
        data.quantity = 1;
        for (var element in data.addons!) {
          if (element.stockNumber == 0) {
            element.inStock = false;
          }
          if (data.discount! > 0 && data.discountType! == '%') {
            element.haveDiscount = true;
            final double discount = double.parse(data.discount!.toString());
            String discountValue = (double.parse(element.price.toString()) - (double.parse(element.price.toString()) * double.parse(discount.toString()) / 100)).toStringAsFixed(2);
            element.discountPrice = double.parse(discountValue);
          } else {
            element.haveDiscount = false;
            element.discountPrice = 0.0;
          }
        }

        for (var variationElement in data.variations!) {
          for (var optionElement in variationElement.options!) {
            if (optionElement.stock == 0) {
              optionElement.inStock = false;
            }
            if (data.discount! > 0 && data.discountType! == '%') {
              optionElement.haveDiscount = true;
              final double discount = double.parse(data.discount!.toString());
              String discountValue = (double.parse(optionElement.price.toString()) - (double.parse(optionElement.price.toString()) * double.parse(discount.toString()) / 100)).toStringAsFixed(2);
              optionElement.discountPrice = double.parse(discountValue);
            } else {
              optionElement.haveDiscount = false;
              optionElement.discountPrice = 0.0;
            }
          }
        }
        data.variations!.sort((a, b) => b.isRequired! ? 1 : -1);
        state.cartItem.addons = [];
        state.cartItem.quantity = data.quantity;
        state.cartItem.variations = [];
        emit(state.copyWith(status: FoodInfoModalStatus.success, info: data, cartItem: state.cartItem, originalPrice: data.price!, discountPrice: data.offerPrice!));
      } else {
        emit(state.copyWith(status: FoodInfoModalStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodInfoModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodInfoModalQuantityEvent(FoodInfoModalQuantityEvent event, Emitter<FoodInfoModalState> emit) async {
    if (state.info.quantity == 1 && event.action == 'decrease') {
      emit(state.copyWith(status: FoodInfoModalStatus.success, cartItem: state.cartItem));
    } else if (event.action == 'decrease') {
      state.info.quantity = state.info.quantity! - 1;
      emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.success));
    } else if (event.action == 'increase') {
      if (state.info.quantity! < state.info.purchaseLimit!) {
        bool checkAddonHaveStock = true;
        bool checkVariationHaveStock = true;
        int outOfStockLimitNumber = 0;
        for (var addon in state.info.addons!) {
          if (addon.checked! && state.info.quantity! >= addon.stockNumber!) {
            addon.limitCrossed = true;
            checkAddonHaveStock = false;
            outOfStockLimitNumber = addon.stockNumber!;
          }
        }
        for (var variation in state.info.variations!) {
          for (var options in variation.options!) {
            if (options.checked! && state.info.quantity! >= options.stock!) {
              options.limitCrossed = true;
              checkVariationHaveStock = false;
              outOfStockLimitNumber = options.stock!;
            }
          }
        }
        if (state.info.stockType == 'unlimited' && checkAddonHaveStock && checkVariationHaveStock) {
          state.info.quantity = state.info.quantity! + 1;
          emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.success));
        } else if (state.info.quantity! < state.info.stockNumber! && checkAddonHaveStock && checkVariationHaveStock) {
          state.info.quantity = state.info.quantity! + 1;
          emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.success));
        } else {
          if (checkAddonHaveStock == false || checkVariationHaveStock == false) {
            emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.customError, statusCode: 0, alertMessage: 'Sorry, our variation limited to ##dynamic## items right now.', extraMessage: '$outOfStockLimitNumber'));
          } else {
            emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.customError, statusCode: 0, alertMessage: 'Sorry, our stock is limited to ##dynamic## items right now.', extraMessage: '${state.info.stockNumber}'));
          }
        }
      } else {
        emit(state.copyWith(status: FoodInfoModalStatus.customError, statusCode: 0, alertMessage: 'Sorry, You can purchase upto ##dynamic## items on this food', extraMessage: '${state.info.purchaseLimit}'));
      }
    }
    double realPrice = state.info.price!;
    String extraPriceString = (double.parse(calculateAddons().toString()) + (double.parse(calculateVariations().toString()))).toStringAsFixed(2);
    String originalPriceString = (double.parse(realPrice.toString()) + double.parse(extraPriceString)).toStringAsFixed(2);
    double originalPrice = double.parse(originalPriceString);
    double discountPrice = state.info.offerPrice!;
    if (state.info.discountType! == '%') {
      String discountAmountString = ((double.parse(originalPrice.toString()) * double.parse(state.info.discount!.toString())) / 100).toStringAsFixed(2);
      String discountedPriceString = (double.parse(originalPrice.toString()) - double.parse(discountAmountString)).toStringAsFixed(2);
      discountPrice = double.parse(discountedPriceString);
    } else {
      String discountPriceString = (double.parse(originalPrice.toString()) - double.parse(state.info.discount!.toString())).toStringAsFixed(2);
      discountPrice = double.parse(discountPriceString);
    }
    String originalPriceStringFinal = (double.parse(originalPrice.toString()) * state.info.quantity!).toStringAsFixed(2);
    originalPrice = double.parse(originalPriceStringFinal);
    String discountPriceStringFinal = (double.parse(discountPrice.toString()) * state.info.quantity!).toStringAsFixed(2);
    discountPrice = double.parse(discountPriceStringFinal);
    emit(state.copyWith(originalPrice: originalPrice, discountPrice: discountPrice, status: FoodInfoModalStatus.success));
  }

  FutureOr<void> _onFoodInfoModalSaveEvent(FoodInfoModalSaveEvent event, Emitter<FoodInfoModalState> emit) async {
    var items = state.info.variations!.where((element) => element.isRequired == true);
    bool requiredValidation = false;
    bool minMaxValidation = false;
    for (var variation in items) {
      int checkIndex = variation.options!.indexWhere((element) => element.checked == true);
      if (checkIndex == -1) {
        requiredValidation = true;
      }
    }
    for (var variation in state.info.variations!) {
      int minOption = variation.min!;
      final selectedOptions = variation.options!.where((vOption) => vOption.checked == true);
      if (selectedOptions.isEmpty && variation.isRequired! == false) {
        minMaxValidation = false;
      } else if (selectedOptions.length < minOption) {
        minMaxValidation = true;
      }
    }
    if (requiredValidation == false && minMaxValidation == false) {
      final String locale = await _authRepository.getLocale();
      List<option_data.AddonModelConfigModel> savedAddon = <option_data.AddonModelConfigModel>[];
      savedAddon.clear();
      for (var element in state.info.addons!) {
        if (element.checked == true) {
          var convertedItem = jsonEncode(element).toString();
          Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
          option_data.AddonModelConfigModel savedData = option_data.AddonModelConfigModel.fromJson(myMap, locale.toString());
          savedAddon.add(savedData);
        }
      }
      List<option_data.VariationOptionConfigModel> savedOptions = <option_data.VariationOptionConfigModel>[];
      List<option_data.VariationConfigModel> savedVariations = <option_data.VariationConfigModel>[];
      savedVariations.clear();
      for (var variation in state.info.variations!) {
        savedOptions.clear();
        for (var option in variation.options!) {
          if (option.checked == true) {
            var convertedItem = jsonEncode(option).toString();
            Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
            option_data.VariationOptionConfigModel savedData = option_data.VariationOptionConfigModel.fromJson(myMap);
            savedOptions.add(savedData);
          }
        }
        if (savedOptions.isNotEmpty) {
          option_data.VariationConfigModel variationsData = option_data.VariationConfigModel(
            isRequired: variation.isRequired,
            title: variation.title,
            type: variation.type,
            min: variation.min,
            max: variation.max,
            options: [...savedOptions],
          );
          savedVariations.add(variationsData);
        }
      }
      state.cartItem.addons = savedAddon;
      state.cartItem.quantity = state.info.quantity;
      state.cartItem.variations = savedVariations;
      emit(state.copyWith(status: FoodInfoModalStatus.saveClose, cartItem: state.cartItem));
    } else {
      emit(state.copyWith(status: FoodInfoModalStatus.customError, statusCode: 0, alertMessage: 'Validation Failed, Please select required items', extraMessage: ''));
    }
  }

  FutureOr<void> _onFoodInfoModalAddonsEvent(FoodInfoModalAddonsEvent event, Emitter<FoodInfoModalState> emit) async {
    if (state.info.addons![event.index].inStock!) {
      state.info.addons![event.index].checked = !state.info.addons![event.index].checked!;
      for (var addon in state.info.addons!) {
        addon.limitCrossed = false;
      }
      for (var variation in state.info.variations!) {
        for (var options in variation.options!) {
          options.limitCrossed = false;
        }
      }
      state.info.quantity = 1;
      emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.success));
      double realPrice = state.info.price!;
      String extraPriceString = (double.parse(calculateAddons().toString()) + (double.parse(calculateVariations().toString()))).toStringAsFixed(2);
      String originalPriceString = (double.parse(realPrice.toString()) + double.parse(extraPriceString)).toStringAsFixed(2);
      double originalPrice = double.parse(originalPriceString);
      double discountPrice = state.info.offerPrice!;
      if (state.info.discountType! == '%') {
        String discountAmountString = ((double.parse(originalPrice.toString()) * double.parse(state.info.discount!.toString())) / 100).toStringAsFixed(2);
        String discountedPriceString = (double.parse(originalPrice.toString()) - double.parse(discountAmountString)).toStringAsFixed(2);
        discountPrice = double.parse(discountedPriceString);
      } else {
        String discountPriceString = (double.parse(originalPrice.toString()) - double.parse(state.info.discount!.toString())).toStringAsFixed(2);
        discountPrice = double.parse(discountPriceString);
      }
      String originalPriceStringFinal = (double.parse(originalPrice.toString()) * state.info.quantity!).toStringAsFixed(2);
      originalPrice = double.parse(originalPriceStringFinal);
      String discountPriceStringFinal = (double.parse(discountPrice.toString()) * state.info.quantity!).toStringAsFixed(2);
      discountPrice = double.parse(discountPriceStringFinal);
      emit(state.copyWith(originalPrice: originalPrice, discountPrice: discountPrice, status: FoodInfoModalStatus.success));
    }
  }

  FutureOr<void> _onFoodInfoModalVariationOptionEvent(FoodInfoModalVariationOptionEvent event, Emitter<FoodInfoModalState> emit) async {
    if (state.info.variations![event.vIndex].options![event.oIndex].inStock!) {
      for (var addon in state.info.addons!) {
        addon.limitCrossed = false;
      }
      if (event.type == 'single') {
        int radioIndex = state.info.variations![event.vIndex].options!.indexWhere((element) => element.checked == true);
        if (radioIndex != -1) {
          state.info.variations![event.vIndex].options![radioIndex].checked = false;
          for (var variation in state.info.variations!) {
            for (var options in variation.options!) {
              options.limitCrossed = false;
            }
          }
          state.info.quantity = 1;
          emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.success));
        }

        state.info.variations![event.vIndex].options![event.oIndex].checked = true;
        for (var variation in state.info.variations!) {
          for (var options in variation.options!) {
            options.limitCrossed = false;
          }
        }
        state.info.quantity = 1;
        emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.success));
      } else {
        if (state.info.variations![event.vIndex].options![event.oIndex].checked! || state.info.variations![event.vIndex].options![event.oIndex].enable!) {
          state.info.variations![event.vIndex].options![event.oIndex].checked = !state.info.variations![event.vIndex].options![event.oIndex].checked!;
          for (var variation in state.info.variations!) {
            for (var options in variation.options!) {
              options.limitCrossed = false;
            }
          }
          state.info.quantity = 1;
          emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.success));
        }

        final totalChecked = state.info.variations![event.vIndex].options!.where((vOptions) => vOptions.checked == true);
        for (var vOptoins in state.info.variations![event.vIndex].options!) {
          if (!vOptoins.checked! && totalChecked.length >= state.info.variations![event.vIndex].max!) {
            vOptoins.enable = false;
          } else {
            vOptoins.enable = true;
          }
        }
        for (var variation in state.info.variations!) {
          for (var options in variation.options!) {
            options.limitCrossed = false;
          }
        }
        state.info.quantity = 1;
        emit(state.copyWith(info: state.info, status: FoodInfoModalStatus.success));
      }
      double realPrice = state.info.price!;
      String extraPriceString = (double.parse(calculateAddons().toString()) + (double.parse(calculateVariations().toString()))).toStringAsFixed(2);
      String originalPriceString = (double.parse(realPrice.toString()) + double.parse(extraPriceString)).toStringAsFixed(2);
      double originalPrice = double.parse(originalPriceString);
      double discountPrice = state.info.offerPrice!;
      if (state.info.discountType! == '%') {
        String discountAmountString = ((double.parse(originalPrice.toString()) * double.parse(state.info.discount!.toString())) / 100).toStringAsFixed(2);
        String discountedPriceString = (double.parse(originalPrice.toString()) - double.parse(discountAmountString)).toStringAsFixed(2);
        discountPrice = double.parse(discountedPriceString);
      } else {
        String discountPriceString = (double.parse(originalPrice.toString()) - double.parse(state.info.discount!.toString())).toStringAsFixed(2);
        discountPrice = double.parse(discountPriceString);
      }
      String originalPriceStringFinal = (double.parse(originalPrice.toString()) * state.info.quantity!).toStringAsFixed(2);
      originalPrice = double.parse(originalPriceStringFinal);
      String discountPriceStringFinal = (double.parse(discountPrice.toString()) * state.info.quantity!).toStringAsFixed(2);
      discountPrice = double.parse(discountPriceStringFinal);
      emit(state.copyWith(originalPrice: originalPrice, discountPrice: discountPrice, status: FoodInfoModalStatus.success));
    }
  }

  double calculateAddons() {
    double addonPrice = 0.0;
    for (var element in state.info.addons!) {
      if (element.checked == true) {
        String price = (double.parse(addonPrice.toString()) + (double.parse(element.price.toString()))).toStringAsFixed(2);
        addonPrice = double.parse(price);
      }
    }
    return addonPrice;
  }

  double calculateVariations() {
    double variationPrice = 0.0;
    for (var variation in state.info.variations!) {
      for (var options in variation.options!) {
        if (options.checked == true) {
          String price = (double.parse(variationPrice.toString()) + (double.parse(options.price.toString()))).toStringAsFixed(2);
          variationPrice = double.parse(price);
        }
      }
    }
    return variationPrice;
  }

  FutureOr<void> _onFoodInfoModalCookingInstructionChangeEvent(FoodInfoModalCookingInstructionChangeEvent event, Emitter<FoodInfoModalState> emit) async {
    emit(state.copyWith(cookingInstruction: event.instruction));
  }
}
