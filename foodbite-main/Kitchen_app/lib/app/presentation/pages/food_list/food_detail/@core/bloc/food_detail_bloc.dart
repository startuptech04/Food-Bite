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
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/models/food_detail_response_model.dart';
import 'package:kitchen/app/core/models/food_variation_model.dart';
import 'package:kitchen/app/core/models/request/food_request_model.dart';
import 'package:kitchen/app/core/models/server_error_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/core/repositories/menu_repository.dart';
import 'package:kitchen/app/core/validations/food_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'food_detail_event.dart';
part 'food_detail_state.dart';

class FoodDetailBloc extends Bloc<FoodDetailEvent, FoodDetailState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AuthRepository _authRepository = AuthRepository();
  FoodDetailBloc() : super(FoodDetailState(model: FoodDetailResponseModel(success: false, locale: ''))) {
    on<FoodDetailInitialEvent>(_onFoodDetailInitialEvent);
    on<FoodDetailAddonsModalResponseEvent>(_onFoodDetailAddonsModalResponseEvent);
    on<FoodDetailStockChangeEvent>(_onFoodDetailStockChangeEvent);
    on<FoodDetailStockNumberChangedEvent>(_onFoodDetailStockNumberChangedEvent);
    on<FoodDetailVariationChangedEvent>(_onFoodDetailVariationChangedEvent);
    on<FoodDetailVariationDeleteEvent>(_onFoodDetailVariationDeleteEvent);
    on<FoodDetailUpdateFormEvent>(_onFoodDetailUpdateFormEvent);
  }

  FutureOr<void> _onFoodDetailInitialEvent(FoodDetailInitialEvent event, Emitter<FoodDetailState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "food_detail"}, 'food_detail_screen', 'food_detail_screen');
      emit(state.copyWith(status: FoodDetailStatus.loading));
      DioApiResponse response = await _menuRepository.getFoodInfo(event.id);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        FoodDetailResponseModel data = FoodDetailResponseModel.fromJson(myMap, locale.toString());
        final name = FoodNameField.dirty(data.detail!.name!);
        final description = FoodShortDescriptionField.dirty(data.detail!.shortDescription!);
        final image = FoodImageField.dirty(data.detail!.image!);
        final stockNumber = FoodStockField.dirty('${data.detail!.stockNumber!}');
        final List<String> addonsName = <String>[];
        final List<String> addonsIds = <String>[];
        addonsName.clear();
        addonsIds.clear();
        for (var element in data.detail!.addons!) {
          addonsName.add(element.name!);
          addonsIds.add(element.id!);
        }
        emit(
          state.copyWith(
            model: data,
            name: name,
            shortDescription: description,
            image: image,
            stockType: data.detail!.stockType,
            stockNumber: stockNumber,
            addons: addonsIds.join(','),
            addonsName: addonsName.join(','),
            variations: data.detail!.variations!,
            status: FoodDetailStatus.loaded,
          ),
        );
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodDetailAddonsModalResponseEvent(FoodDetailAddonsModalResponseEvent event, Emitter<FoodDetailState> emit) async {
    emit(state.copyWith(addons: event.ids, addonsName: event.names, status: FoodDetailStatus.initial));
  }

  FutureOr<void> _onFoodDetailStockChangeEvent(FoodDetailStockChangeEvent event, Emitter<FoodDetailState> emit) async {
    emit(state.copyWith(stockType: event.type, status: FoodDetailStatus.initial));
    if (event.type == 'unlimited') {
      const stockNumber = FoodStockField.dirty('-1');
      emit(state.copyWith(stockNumber: stockNumber, status: FoodDetailStatus.initial, isValid: Formz.validate([stockNumber, state.image, state.name, state.shortDescription])));
    } else {
      const stockNumber = FoodStockField.dirty('');
      emit(state.copyWith(stockNumber: stockNumber, status: FoodDetailStatus.initial, isValid: Formz.validate([stockNumber, state.image, state.name, state.shortDescription])));
    }
  }

  FutureOr<void> _onFoodDetailStockNumberChangedEvent(FoodDetailStockNumberChangedEvent event, Emitter<FoodDetailState> emit) async {
    final stockNumber = FoodStockField.dirty(event.value);
    emit(
      state.copyWith(stockNumber: stockNumber.isValid ? stockNumber : FoodStockField.pure(event.value), status: FoodDetailStatus.initial, isValid: Formz.validate([stockNumber, state.shortDescription, state.name, state.image])),
    );
  }

  FutureOr<void> _onFoodDetailVariationChangedEvent(FoodDetailVariationChangedEvent event, Emitter<FoodDetailState> emit) async {
    if (state.variations.isEmpty) {
      List<FoodVariationModel> newVariationList = <FoodVariationModel>[];
      emit(state.copyWith(variations: [...newVariationList], status: FoodDetailStatus.initial));
    }
    if (event.isNew) {
      FoodVariationModel variation = FoodVariationModel(isRequired: event.model.isRequired, title: event.model.title, type: event.model.type, min: event.model.min, max: event.model.max, options: event.model.options);
      state.variations.add(variation);
      emit(state.copyWith(variations: [...state.variations], status: FoodDetailStatus.initial));
    } else {
      state.variations[event.index].isRequired = event.model.isRequired;
      state.variations[event.index].title = event.model.title;
      state.variations[event.index].type = event.model.type;
      state.variations[event.index].min = event.model.min;
      state.variations[event.index].max = event.model.max;
      state.variations[event.index].options = event.model.options;
      emit(state.copyWith(variations: [...state.variations], status: FoodDetailStatus.initial));
    }
  }

  FutureOr<void> _onFoodDetailVariationDeleteEvent(FoodDetailVariationDeleteEvent event, Emitter<FoodDetailState> emit) async {
    state.variations.removeAt(event.index);
    emit(state.copyWith(variations: [...state.variations], status: FoodDetailStatus.initial));
  }

  FutureOr<void> _onFoodDetailUpdateFormEvent(FoodDetailUpdateFormEvent event, Emitter<FoodDetailState> emit) async {
    final name = FoodNameField.dirty(state.name.value);
    final description = FoodShortDescriptionField.dirty(state.shortDescription.value);
    final stockNumber = FoodStockField.dirty(state.stockNumber.value);
    final image = FoodImageField.dirty(state.image.value);
    emit(state.copyWith(name: name, shortDescription: description, image: image, stockNumber: stockNumber, status: FoodDetailStatus.initial, isValid: Formz.validate([name, description, image, stockNumber])));
    if (state.isValid && state.name.value.isNotEmpty && state.shortDescription.value.isNotEmpty && state.image.value.isNotEmpty && state.stockNumber.value.isNotEmpty) {
      try {
        FoodRequestModel param = FoodRequestModel(addons: state.addons, variations: state.variations, stockType: state.stockType, stockNumber: stockNumber.value.isNotEmpty ? int.parse(state.stockNumber.value.toString()) : -1);
        emit(state.copyWith(status: FoodDetailStatus.inProgress));
        DioApiResponse response = await _menuRepository.updateFood(state.model.detail!.id!, param);
        if (response.errorType == NetErrorType.none) {
          emit(state.copyWith(status: FoodDetailStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: FoodDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: FoodDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
