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

part of 'messages_bloc.dart';

sealed class MessagesEvent {}

final class MessagesInitialEvent extends MessagesEvent {
  final String receiverId;
  final String name;
  MessagesInitialEvent({required this.receiverId, required this.name});
}

final class MessagesSendNewMessageEvent extends MessagesEvent {
  String msg;
  MessagesSendNewMessageEvent({required this.msg});
}

final class MessageReceiveNewMessageEvent extends MessagesEvent {
  final ChatSocketIncomingMessageModel msg;
  MessageReceiveNewMessageEvent({required this.msg});
}

final class MessageReceiveLoadMoreEvent extends MessagesEvent {}
