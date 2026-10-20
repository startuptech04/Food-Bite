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

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final AuthRepository _authRepository = AuthRepository();
  FavouriteBloc() : super(FavouriteInitial()) {
    on<FavouriteInitialEvent>(_onFavouriteInitialEvent);
  }

  FutureOr<void> _onFavouriteInitialEvent(FavouriteInitialEvent event, Emitter<FavouriteState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "favourite"}, 'favourite_screen', 'favourite_screen');
  }
}
