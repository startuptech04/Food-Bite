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

part of 'chat_messages_bloc.dart';

sealed class ChatMessagesEvent {}

final class ChatMessagesInitialEvent extends ChatMessagesEvent {
  final String receiverId;
  final String name;
  ChatMessagesInitialEvent({required this.name, required this.receiverId});
}

final class ChatMessagesSendNewMessageEvent extends ChatMessagesEvent {
  String msg;
  ChatMessagesSendNewMessageEvent({required this.msg});
}

final class ChatMessagesReceiveNewMessageEvent extends ChatMessagesEvent {
  final ChatSocketIncomingMessageModel msg;
  ChatMessagesReceiveNewMessageEvent({required this.msg});
}

final class ChatMessagesReceiveLoadMoreEvent extends ChatMessagesEvent {}
