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
import 'package:vendor/app/core/repositories/account_repository.dart';

part 'chat_card_event.dart';
part 'chat_card_state.dart';

class ChatCardBloc extends Bloc<ChatCardEvent, ChatCardState> {
  final AccountRepository _accountRepository = AccountRepository();
  ChatCardBloc() : super(ChatCardInitial()) {
    on<ChatCardInitialEvent>(_onChatCardInitialEvent);
  }

  FutureOr<void> _onChatCardInitialEvent(ChatCardInitialEvent event, Emitter<ChatCardState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "chat_list"}, 'chat_list_screen', 'chat_list_screen');
  }
}
