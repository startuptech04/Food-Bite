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
import 'package:waiter/app/core/repositories/auth_repository.dart';

part 'cache_network_widget_event.dart';
part 'cache_network_widget_state.dart';

class CacheNetworkWidgetBloc extends Bloc<CacheNetworkWidgetEvent, CacheNetworkWidgetState> {
  final AuthRepository _authRepository = AuthRepository();
  CacheNetworkWidgetBloc() : super(const CacheNetworkWidgetState()) {
    on<CachedNetworkImageInitialEvent>(_onCachedNetworkImageInitialEvent);
  }

  FutureOr<void> _onCachedNetworkImageInitialEvent(CachedNetworkImageInitialEvent event, Emitter<CacheNetworkWidgetState> emit) async {
    final String mediaUrl = await _authRepository.getMediaUrl();
    emit(state.copyWith(mediaUrl: mediaUrl));
  }
}
