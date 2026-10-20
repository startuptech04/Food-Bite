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

part of 'support_chat_bloc.dart';

sealed class SupportChatEvent {}

final class SupportChatInitialEvent extends SupportChatEvent {
  final String type;
  final String typeId;
  SupportChatInitialEvent({required this.type, required this.typeId});
}

final class SupportChatSendNewMessageEvent extends SupportChatEvent {
  String msg;
  SupportChatSendNewMessageEvent({required this.msg});
}

final class SupportChatReceiveNewMessageEvent extends SupportChatEvent {
  final ChatSocketIncomingMessageModel msg;
  SupportChatReceiveNewMessageEvent({required this.msg});
}

final class SupportChatReceiveLoadMoreEvent extends SupportChatEvent {}
