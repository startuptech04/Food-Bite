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
import 'package:vendor/app/core/models/food_info_model.dart';
import 'package:vendor/app/core/models/food_variation_model.dart';
import 'package:vendor/app/core/models/request/food_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/food_form_translation.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:vendor/app/core/validations/food_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'manage_food_action_event.dart';
part 'manage_food_action_state.dart';

class ManageFoodActionBloc extends Bloc<ManageFoodActionEvent, ManageFoodActionState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ManageFoodActionBloc() : super(ManageFoodActionState(foodInfo: FoodInfoModel(locale: ''))) {
    on<ManageFoodActionInitialEvent>(_onManageFoodActionInitialEvent);
    on<ManageFoodActionFoodNameChangedEvent>(_onManageFoodActionFoodNameChangedEvent);
    on<ManageFoodActionFoodNameUnfocusedEvent>(_onManageFoodActionFoodNameUnfocusedEvent);
    on<ManageFoodActionFoodShortDescriptionChangedEvent>(_onManageFoodActionFoodShortDescriptionChangedEvent);
    on<ManageFoodActionFoodShortDescriptionUnfocusedEvent>(_onManageFoodActionFoodShortDescriptionUnfocusedEvent);
    on<ManageFoodActionFoodImageChangedEvent>(_onManageFoodActionFoodImageChangedEvent);
    on<ManageFoodActionFoodPriceChangedEvent>(_onManageFoodActionFoodPriceChangedEvent);
    on<ManageFoodActionFoodPriceUnfocusedEvent>(_onManageFoodActionFoodPriceUnfocusedEvent);
    on<ManageFoodActionFoodOwnCategoryChangedEvent>(_onManageFoodActionFoodOwnCategoryChangedEvent);
    on<ManageFoodActionFoodCategoryUnfocusedEvent>(_onManageFoodActionFoodCategoryUnfocusedEvent);
    on<ManageFoodActionFoodSubCategoryUnfocusedEvent>(_onManageFoodActionFoodSubCategoryUnfocusedEvent);
    on<ManageFoodActionFoodCreateFormEvent>(_onManageFoodActionFoodCreateFormEvent);
    on<ManageFoodActionFoodUpdateFormEvent>(_onManageFoodActionFoodUpdateFormEvent);
    on<ManageFoodActionFoodDiscountChangedEvent>(_onManageFoodActionFoodDiscountChangedEvent);
    on<ManageFoodActionFoodDiscountTypeChangedEvent>(_onManageFoodActionFoodDiscountTypeChangedEvent);
    on<ManageFoodActionFoodTaxationToggleEvent>(_onManageFoodActionFoodTaxationToggleEvent);
    on<ManageFoodActionFoodCategoryModalResponseEvent>(_onManageFoodActionFoodCategoryModalResponseEvent);
    on<ManageFoodActionFoodSubCategoryModalResponseEvent>(_onManageFoodActionFoodSubCategoryModalResponseEvent);
    on<ManageFoodActionFoodPreferencesChangeEvent>(_onManageFoodActionFoodPreferencesChangeEvent);
    on<ManageFoodActionFoodPurchaseLimitChangedEvent>(_onManageFoodActionFoodPurchaseLimitChangedEvent);
    on<ManageFoodActionFoodAddonsModalResponseEvent>(_onManageFoodActionFoodAddonsModalResponseEvent);
    on<ManageFoodActionFoodAvailabilityStartTimeChangedEvent>(_onManageFoodActionFoodAvailabilityStartTimeChangedEvent);
    on<ManageFoodActionFoodAvailabilityEndTimeChangedEvent>(_onManageFoodActionFoodAvailabilityEndTimeChangedEvent);
    on<ManageFoodActionFoodStockChangeEvent>(_onManageFoodActionFoodStockChangeEvent);
    on<ManageFoodActionFoodVariationChangedEvent>(_onManageFoodActionFoodVariationChangedEvent);
    on<ManageFoodActionFoodVariationDeleteEvent>(_onManageFoodActionFoodVariationDeleteEvent);
    on<ManageFoodActionFoodStockNumberChangedEvent>(_onManageFoodActionFoodStockNumberChangedEvent);
    on<ManageFoodActionFoodStockNumberUnfocusedEvent>(_onManageFoodActionFoodStockNumberUnfocusedEvent);
    on<ManageFoodActionFoodTaxationUnfocusedEvent>(_onManageFoodActionFoodTaxationUnfocusedEvent);
    on<ManageFoodActionFoodTaxationModalResponseEvent>(_onManageFoodActionFoodTaxationModalResponseEvent);
  }

  FutureOr<void> _onManageFoodActionInitialEvent(ManageFoodActionInitialEvent event, Emitter<ManageFoodActionState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_food_item"}, 'add_update_food_item_screen', 'add_update_food_item_screen');
    final String vendorId = await _menuRepository.getVendorId();
    final String locale = await _accountRepository.getLocale();
    emit(state.copyWith(restaurant: vendorId, locale: locale));
    if (!event.isNew) {
      try {
        emit(state.copyWith(status: ManageFoodActionStatus.loading));
        DioApiResponse response = await _menuRepository.getFoodInfo(event.id, vendorId);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          FoodInfoModel data = FoodInfoModel.fromJson(myMap, locale.toString());
          final name = FoodNameField.dirty(data.foodInfo!.name!);
          final description = FoodShortDescriptionField.dirty(data.foodInfo!.shortDescription!);
          final image = FoodImageField.dirty(data.foodInfo!.image!);
          final price = FoodPriceField.dirty('${data.foodInfo!.price!}');
          final category = FoodCategoryField.dirty(
            data.foodInfo!.ownCategory!
                ? data.foodInfo!.customCategory != null && data.foodInfo!.customCategory!.id!.isNotEmpty
                      ? data.foodInfo!.customCategory!.id!
                      : ''
                : data.foodInfo!.category != null && data.foodInfo!.category!.id!.isNotEmpty
                ? data.foodInfo!.category!.id!
                : '',
          );
          final stockNumber = FoodStockField.dirty('${data.foodInfo!.stockNumber!}');
          final List<String> addonsName = <String>[];
          final List<String> addonsIds = <String>[];
          addonsName.clear();
          addonsIds.clear();
          for (var element in data.foodInfo!.addons!) {
            addonsName.add(element.name!);
            addonsIds.add(element.id!);
          }

          final List<String> taxationName = <String>[];
          final List<String> taxationIds = <String>[];
          taxationName.clear();
          taxationIds.clear();
          for (var element in data.foodInfo!.foodtaxations!) {
            taxationName.add(element.taxName!);
            taxationIds.add(element.id!);
          }

          final foodTaxation = FoodTaxationField.dirty(taxationIds.isEmpty ? '' : taxationIds.join(','));

          emit(
            state.copyWith(
              name: name,
              shortDescription: description,
              image: image,
              price: price,
              category: category,
              stockNumber: stockNumber,
              addons: addonsIds.join(','),
              addonsName: addonsName.join(','),
              ownCategory: data.foodInfo!.ownCategory!,
              subCategory: data.foodInfo!.ownCategory!
                  ? data.foodInfo!.customSubCategory != null && data.foodInfo!.customSubCategory!.id!.isNotEmpty
                        ? data.foodInfo!.customSubCategory!.id!
                        : ''
                  : data.foodInfo!.subCategory != null && data.foodInfo!.subCategory!.id!.isNotEmpty
                  ? data.foodInfo!.subCategory!.id!
                  : '',
              foodType: data.foodInfo!.foodType!,
              startTime: data.foodInfo!.startTime!,
              endTime: data.foodInfo!.endTime!,
              discount: !data.foodInfo!.discount!.isNaN ? '${data.foodInfo!.discount!}' : '',
              discountType: data.foodInfo!.discountType!,
              purchaseLimit: '${data.foodInfo!.purchaseLimit!}',
              status: ManageFoodActionStatus.loaded,
              foodInfo: data,
              variations: data.foodInfo!.variations!,
              taxationEnable: data.foodInfo!.taxationEnable!,
              stockType: data.foodInfo!.stockType,
              foodTaxIds: foodTaxation,
              foodTaxNameList: taxationName.join(','),
              isValid: Formz.validate([name, description, image, price, category, stockNumber, foodTaxation]),
            ),
          );
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageFoodActionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageFoodActionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      try {
        const stockNumber = FoodStockField.dirty('-1');
        const foodTax = FoodTaxationField.dirty('none');
        emit(state.copyWith(stockType: 'unlimited', stockNumber: stockNumber, foodTaxIds: foodTax, status: ManageFoodActionStatus.initialLoaded));
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageFoodActionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onManageFoodActionFoodNameChangedEvent(ManageFoodActionFoodNameChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    final name = FoodNameField.dirty(event.name);
    emit(
      state.copyWith(
        name: name.isValid ? name : FoodNameField.pure(event.name),
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([name, state.image, state.shortDescription, state.category, state.price, state.stockNumber, state.foodTaxIds]),
      ),
    );
  }

  FutureOr<void> _onManageFoodActionFoodNameUnfocusedEvent(ManageFoodActionFoodNameUnfocusedEvent event, Emitter<ManageFoodActionState> emit) async {
    final name = FoodNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, status: ManageFoodActionStatus.initial, isValid: Formz.validate([name, state.image, state.shortDescription, state.category, state.price, state.stockNumber, state.foodTaxIds])));
  }

  FutureOr<void> _onManageFoodActionFoodShortDescriptionChangedEvent(ManageFoodActionFoodShortDescriptionChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    final description = FoodShortDescriptionField.dirty(event.description);
    emit(
      state.copyWith(
        shortDescription: description.isValid ? description : FoodShortDescriptionField.pure(event.description),
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([description, state.image, state.name, state.category, state.price, state.stockNumber, state.foodTaxIds]),
      ),
    );
  }

  FutureOr<void> _onManageFoodActionFoodShortDescriptionUnfocusedEvent(ManageFoodActionFoodShortDescriptionUnfocusedEvent event, Emitter<ManageFoodActionState> emit) async {
    final description = FoodShortDescriptionField.dirty(state.shortDescription.value);
    emit(state.copyWith(shortDescription: description, status: ManageFoodActionStatus.initial, isValid: Formz.validate([description, state.image, state.name, state.category, state.price, state.stockNumber, state.foodTaxIds])));
  }

  FutureOr<void> _onManageFoodActionFoodImageChangedEvent(ManageFoodActionFoodImageChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    final image = FoodImageField.dirty(event.image);
    emit(
      state.copyWith(
        image: image.isValid ? image : FoodImageField.pure(event.image),
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([image, state.shortDescription, state.name, state.category, state.price, state.stockNumber, state.foodTaxIds]),
      ),
    );
  }

  FutureOr<void> _onManageFoodActionFoodPriceChangedEvent(ManageFoodActionFoodPriceChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    final price = FoodPriceField.dirty(event.price);
    emit(
      state.copyWith(
        price: price.isValid ? price : FoodPriceField.pure(event.price),
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([price, state.shortDescription, state.name, state.category, state.image, state.stockNumber, state.foodTaxIds]),
      ),
    );
  }

  FutureOr<void> _onManageFoodActionFoodPriceUnfocusedEvent(ManageFoodActionFoodPriceUnfocusedEvent event, Emitter<ManageFoodActionState> emit) async {
    final price = FoodPriceField.dirty(state.price.value);
    emit(state.copyWith(price: price, status: ManageFoodActionStatus.initial, isValid: Formz.validate([price, state.image, state.name, state.category, state.shortDescription, state.stockNumber, state.foodTaxIds])));
  }

  FutureOr<void> _onManageFoodActionFoodOwnCategoryChangedEvent(ManageFoodActionFoodOwnCategoryChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    const category = FoodCategoryField.dirty('');
    emit(
      state.copyWith(
        ownCategory: event.value,
        category: category.isValid ? category : const FoodCategoryField.pure(''),
        categoryName: '',
        subCategory: '',
        subCategoryName: '',
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([category, state.price, state.name, state.shortDescription, state.stockNumber, state.foodTaxIds]),
      ),
    );
  }

  FutureOr<void> _onManageFoodActionFoodCategoryUnfocusedEvent(ManageFoodActionFoodCategoryUnfocusedEvent event, Emitter<ManageFoodActionState> emit) async {
    final category = FoodCategoryField.dirty(state.category.value);
    emit(state.copyWith(category: category, status: ManageFoodActionStatus.initial, isValid: Formz.validate([category, state.image, state.name, state.price, state.shortDescription, state.stockNumber, state.foodTaxIds])));
  }

  FutureOr<void> _onManageFoodActionFoodSubCategoryUnfocusedEvent(ManageFoodActionFoodSubCategoryUnfocusedEvent event, Emitter<ManageFoodActionState> emit) async {}

  FutureOr<void> _onManageFoodActionFoodCreateFormEvent(ManageFoodActionFoodCreateFormEvent event, Emitter<ManageFoodActionState> emit) async {
    final name = FoodNameField.dirty(state.name.value);
    final description = FoodShortDescriptionField.dirty(state.shortDescription.value);
    final image = FoodImageField.dirty(state.image.value);
    final price = FoodPriceField.dirty(state.price.value);
    final category = FoodCategoryField.dirty(state.category.value);
    final stockNumber = FoodStockField.dirty(state.stockNumber.value);
    final foodTax = FoodTaxationField.dirty(state.foodTaxIds.value);
    emit(
      state.copyWith(
        name: name,
        shortDescription: description,
        image: image,
        price: price,
        category: category,
        stockNumber: stockNumber,
        foodTaxIds: foodTax,
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([name, description, image, price, category, stockNumber]),
      ),
    );
    if (state.isValid &&
        state.name.value.isNotEmpty &&
        state.shortDescription.value.isNotEmpty &&
        state.image.value.isNotEmpty &&
        state.price.value.isNotEmpty &&
        state.category.value.isNotEmpty &&
        state.stockNumber.value.isNotEmpty &&
        state.foodTaxIds.value.isNotEmpty) {
      try {
        FoodRequestModel foodBody = FoodRequestModel(
          name: state.name.value,
          shortDescription: state.shortDescription.value,
          image: state.image.value,
          restaurant: state.restaurant,
          ownCategory: state.ownCategory,
          category: !state.ownCategory ? state.category.value : '',
          subCategory: !state.ownCategory ? state.subCategory : '',
          customCategory: state.ownCategory ? state.category.value : '',
          customSubCategory: state.ownCategory ? state.subCategory : '',
          foodType: state.foodType,
          addons: state.addons,
          startTime: state.startTime,
          endTime: state.endTime,
          price: state.price.value.isNotEmpty ? double.parse(state.price.value) : 0,
          discountType: state.discountType,
          discount: state.discount.isNotEmpty ? double.parse(state.discount) : 0,
          tags: event.tags,
          translations: event.translations,
          purchaseLimit: state.purchaseLimit.isNotEmpty ? int.parse(state.purchaseLimit) : -1,
          variations: state.variations,
          taxationEnable: state.taxationEnable,
          foodTax: foodTax.value.toString() != 'none' ? foodTax.value : '',
          stockType: state.stockType,
          stockNumber: stockNumber.value.isNotEmpty ? int.parse(state.stockNumber.value.toString()) : -1,
        );
        emit(state.copyWith(status: ManageFoodActionStatus.inProgress));
        DioApiResponse response = await _menuRepository.createFood(foodBody);
        if (response.errorType == NetErrorType.none) {
          emit(state.copyWith(status: ManageFoodActionStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageFoodActionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageFoodActionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onManageFoodActionFoodUpdateFormEvent(ManageFoodActionFoodUpdateFormEvent event, Emitter<ManageFoodActionState> emit) async {
    final name = FoodNameField.dirty(state.name.value);
    final description = FoodShortDescriptionField.dirty(state.shortDescription.value);
    final image = FoodImageField.dirty(state.image.value);
    final price = FoodPriceField.dirty(state.price.value);
    final category = FoodCategoryField.dirty(state.category.value);
    final stockNumber = FoodStockField.dirty(state.stockNumber.value);
    final foodTax = FoodTaxationField.dirty(state.foodTaxIds.value);
    emit(
      state.copyWith(
        name: name,
        shortDescription: description,
        image: image,
        price: price,
        category: category,
        stockNumber: stockNumber,
        foodTaxIds: foodTax,
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([name, description, image, price, category, stockNumber]),
      ),
    );
    if (state.isValid &&
        state.name.value.isNotEmpty &&
        state.shortDescription.value.isNotEmpty &&
        state.image.value.isNotEmpty &&
        state.price.value.isNotEmpty &&
        state.category.value.isNotEmpty &&
        state.stockNumber.value.isNotEmpty &&
        state.foodTaxIds.value.isNotEmpty) {
      try {
        FoodRequestModel foodBody = FoodRequestModel(
          name: state.name.value,
          shortDescription: state.shortDescription.value,
          image: state.image.value,
          restaurant: state.restaurant,
          ownCategory: state.ownCategory,
          category: !state.ownCategory ? state.category.value : '',
          subCategory: !state.ownCategory ? state.subCategory : '',
          customCategory: state.ownCategory ? state.category.value : '',
          customSubCategory: state.ownCategory ? state.subCategory : '',
          foodType: state.foodType,
          addons: state.addons,
          startTime: state.startTime,
          endTime: state.endTime,
          price: state.price.value.isNotEmpty ? double.parse(state.price.value) : 0,
          discountType: state.discountType,
          discount: state.discount.isNotEmpty ? double.parse(state.discount) : 0,
          tags: event.tags,
          translations: event.translations,
          purchaseLimit: state.purchaseLimit.isNotEmpty ? int.parse(state.purchaseLimit) : -1,
          variations: state.variations,
          taxationEnable: state.taxationEnable,
          foodTax: foodTax.value.toString() != 'none' ? foodTax.value : '',
          stockType: state.stockType,
          stockNumber: stockNumber.value.isNotEmpty ? int.parse(state.stockNumber.value.toString()) : -1,
        );
        emit(state.copyWith(status: ManageFoodActionStatus.inProgress));
        DioApiResponse response = await _menuRepository.updateFood(state.foodInfo.foodInfo!.id!, foodBody);
        if (response.errorType == NetErrorType.none) {
          emit(state.copyWith(status: ManageFoodActionStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ManageFoodActionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ManageFoodActionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onManageFoodActionFoodDiscountChangedEvent(ManageFoodActionFoodDiscountChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(discount: event.discount, status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodDiscountTypeChangedEvent(ManageFoodActionFoodDiscountTypeChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(discountType: event.value, status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodTaxationToggleEvent(ManageFoodActionFoodTaxationToggleEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(taxationEnable: !state.taxationEnable, status: ManageFoodActionStatus.initial));
    if (state.taxationEnable) {
      const foodTax = FoodTaxationField.dirty('');
      emit(state.copyWith(foodTaxIds: foodTax, status: ManageFoodActionStatus.initial, isValid: Formz.validate([foodTax, state.image, state.name, state.price, state.shortDescription, state.category, state.stockNumber])));
    } else {
      const foodTax = FoodTaxationField.dirty('none');
      emit(state.copyWith(foodTaxIds: foodTax, status: ManageFoodActionStatus.initial, isValid: Formz.validate([foodTax, state.image, state.name, state.price, state.shortDescription, state.category, state.stockNumber])));
    }
  }

  FutureOr<void> _onManageFoodActionFoodCategoryModalResponseEvent(ManageFoodActionFoodCategoryModalResponseEvent event, Emitter<ManageFoodActionState> emit) async {
    final category = FoodCategoryField.dirty(event.id);
    emit(
      state.copyWith(
        category: category.isValid ? category : FoodCategoryField.pure(event.id),
        categoryName: event.name,
        subCategory: '',
        subCategoryName: '',
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([category, state.shortDescription, state.name, state.price, state.image, state.stockNumber, state.foodTaxIds]),
      ),
    );
  }

  FutureOr<void> _onManageFoodActionFoodSubCategoryModalResponseEvent(ManageFoodActionFoodSubCategoryModalResponseEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(subCategory: event.id, subCategoryName: event.name, status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodPreferencesChangeEvent(ManageFoodActionFoodPreferencesChangeEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(foodType: event.value, status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodPurchaseLimitChangedEvent(ManageFoodActionFoodPurchaseLimitChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(purchaseLimit: event.limit, status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodAddonsModalResponseEvent(ManageFoodActionFoodAddonsModalResponseEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(addons: event.ids, addonsName: event.names, status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodAvailabilityStartTimeChangedEvent(ManageFoodActionFoodAvailabilityStartTimeChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(startTime: event.value, status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodAvailabilityEndTimeChangedEvent(ManageFoodActionFoodAvailabilityEndTimeChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(endTime: event.value, status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodStockChangeEvent(ManageFoodActionFoodStockChangeEvent event, Emitter<ManageFoodActionState> emit) async {
    emit(state.copyWith(stockType: event.type, status: ManageFoodActionStatus.initial));
    if (event.type == 'unlimited') {
      const stockNumber = FoodStockField.dirty('-1');
      emit(state.copyWith(stockNumber: stockNumber, status: ManageFoodActionStatus.initial, isValid: Formz.validate([stockNumber, state.image, state.name, state.price, state.shortDescription, state.category, state.foodTaxIds])));
    } else {
      const stockNumber = FoodStockField.dirty('');
      emit(state.copyWith(stockNumber: stockNumber, status: ManageFoodActionStatus.initial, isValid: Formz.validate([stockNumber, state.image, state.name, state.price, state.shortDescription, state.category, state.foodTaxIds])));
    }
  }

  FutureOr<void> _onManageFoodActionFoodVariationChangedEvent(ManageFoodActionFoodVariationChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    if (state.variations.isEmpty) {
      List<FoodVariationModel> newVariationList = <FoodVariationModel>[];
      emit(state.copyWith(variations: [...newVariationList], status: ManageFoodActionStatus.initial));
    }
    if (event.isNew) {
      FoodVariationModel variation = FoodVariationModel(isRequired: event.model.isRequired, title: event.model.title, type: event.model.type, min: event.model.min, max: event.model.max, options: event.model.options);
      state.variations.add(variation);
      emit(state.copyWith(variations: [...state.variations], status: ManageFoodActionStatus.initial));
    } else {
      state.variations[event.index].isRequired = event.model.isRequired;
      state.variations[event.index].title = event.model.title;
      state.variations[event.index].type = event.model.type;
      state.variations[event.index].min = event.model.min;
      state.variations[event.index].max = event.model.max;
      state.variations[event.index].options = event.model.options;
      emit(state.copyWith(variations: [...state.variations], status: ManageFoodActionStatus.initial));
    }
  }

  FutureOr<void> _onManageFoodActionFoodVariationDeleteEvent(ManageFoodActionFoodVariationDeleteEvent event, Emitter<ManageFoodActionState> emit) {
    state.variations.removeAt(event.index);
    emit(state.copyWith(variations: [...state.variations], status: ManageFoodActionStatus.initial));
  }

  FutureOr<void> _onManageFoodActionFoodStockNumberChangedEvent(ManageFoodActionFoodStockNumberChangedEvent event, Emitter<ManageFoodActionState> emit) async {
    final stockNumber = FoodStockField.dirty(event.value);
    emit(
      state.copyWith(
        stockNumber: stockNumber.isValid ? stockNumber : FoodStockField.pure(event.value),
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([stockNumber, state.shortDescription, state.name, state.category, state.image, state.price, state.foodTaxIds]),
      ),
    );
  }

  FutureOr<void> _onManageFoodActionFoodStockNumberUnfocusedEvent(ManageFoodActionFoodStockNumberUnfocusedEvent event, Emitter<ManageFoodActionState> emit) async {
    final stockNumber = FoodStockField.dirty(state.stockNumber.value);
    emit(state.copyWith(stockNumber: stockNumber, status: ManageFoodActionStatus.initial, isValid: Formz.validate([stockNumber, state.image, state.name, state.price, state.shortDescription, state.category, state.foodTaxIds])));
  }

  FutureOr<void> _onManageFoodActionFoodTaxationUnfocusedEvent(ManageFoodActionFoodTaxationUnfocusedEvent event, Emitter<ManageFoodActionState> emit) async {
    final foodTax = FoodTaxationField.dirty(state.foodTaxIds.value);
    emit(state.copyWith(foodTaxIds: foodTax, status: ManageFoodActionStatus.initial, isValid: Formz.validate([foodTax, state.image, state.name, state.price, state.shortDescription, state.category, state.stockNumber])));
  }

  FutureOr<void> _onManageFoodActionFoodTaxationModalResponseEvent(ManageFoodActionFoodTaxationModalResponseEvent event, Emitter<ManageFoodActionState> emit) async {
    final taxation = FoodTaxationField.dirty(event.ids);
    emit(
      state.copyWith(
        foodTaxIds: taxation.isValid ? taxation : FoodTaxationField.pure(event.ids),
        foodTaxNameList: event.names,
        status: ManageFoodActionStatus.initial,
        isValid: Formz.validate([taxation, state.shortDescription, state.name, state.category, state.image, state.price, state.stockNumber]),
      ),
    );
  }
}
