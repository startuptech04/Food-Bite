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

import 'package:bloc/bloc.dart';
import 'package:user/app/core/repositories/auth_repository.dart';

part 'restaurants_by_category_event.dart';
part 'restaurants_by_category_state.dart';

class RestaurantsByCategoryBloc extends Bloc<RestaurantsByCategoryEvent, RestaurantsByCategoryState> {
  final AuthRepository _authRepository = AuthRepository();
  RestaurantsByCategoryBloc() : super(RestaurantsByCategoryInitial()) {
    on<RestaurantsByCategoryInitialEvent>(_onRestaurantsByCategoryInitialEvent);
  }

  FutureOr<void> _onRestaurantsByCategoryInitialEvent(RestaurantsByCategoryInitialEvent event, Emitter<RestaurantsByCategoryState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "restaurant_categories"}, 'restaurant_categories_screen', 'restaurant_categories_screen');
  }
}
