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

import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/models/chat_socket_incoming_message_model.dart';
import 'package:driver/app/presentation/pages/chats/messages/bloc/messages_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/services/chat_service_socket_io.dart';
import 'package:driver/app/services/uuid_generator.dart';

class MessageScreen extends StatelessWidget {
  final String receiverId;
  final String name;
  const MessageScreen({super.key, required this.receiverId, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesBloc()..add(MessagesInitialEvent(receiverId: receiverId, name: name)),
      child: const MessageView(),
    );
  }
}

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final ChatService chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollMessages = ScrollController();
  bool _socketInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollMessages.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollMessages.position.pixels == _scrollMessages.position.minScrollExtent) {
      context.read<MessagesBloc>().add(MessageReceiveLoadMoreEvent());
    }
  }

  void initSocket(String roomId) {
    if (_socketInitialized) return;
    chatService.connectToServer(roomId, (data) {
      final chatMessage = ChatSocketIncomingMessageModel.fromJson(data);
      context.read<MessagesBloc>().add(MessageReceiveNewMessageEvent(msg: chatMessage));
    });
    _socketInitialized = true;
  }

  void jumpToBottom() {
    _scrollMessages.jumpTo(_scrollMessages.position.maxScrollExtent + 120);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollMessages.dispose();
    chatService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<MessagesBloc, MessagesState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isChatInitialize) {
          initSocket(state.chatRoomId);
          jumpToBottom();
        } else if (state.status.isScrollDown) {
          jumpToBottom();
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: Text(state.name), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            controller: _scrollMessages,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const MessageLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const MessageErrorView(),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.model.chats!.length,
                        (index) => state.model.chats![index].senderId! == state.userId
                            ? MessageLeftSideView(message: state.model.chats![index].message!, messageType: state.model.chats![index].messageType!)
                            : MessageRightSideView(message: state.model.chats![index].message!, messageType: state.model.chats![index].messageType!),
                      ),
                    ),
                    state.loadMore ? Column(children: [kAppSpacerVertical(height: 20), kAppCenterCircularProgress(context), kAppSpacerVertical(height: 20)]) : const SizedBox(),
                  ],
                ],
              ),
            ),
          ),
          bottomNavigationBar: state.status.isLoading
              ? SafeArea(child: const SizedBox())
              : SafeArea(
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TextField(
                                controller: _messageController,
                                minLines: 1,
                                maxLines: 5,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: translate.type_message,
                                  labelStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium', color: Theme.of(context).canvasColor),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).canvasColor),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).canvasColor),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                style: kAppLblSmallFontMedium(context),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            context.read<MessagesBloc>().add(MessagesSendNewMessageEvent(msg: _messageController.text));
                            chatService.sendMessage(
                              chatRoomId: state.chatRoomId,
                              senderId: state.userId,
                              message: _messageController.text,
                              role: state.authRole,
                              randomId: Uuid().generateV4().toString(),
                              firstName: state.senderFirstName,
                              lastName: state.senderLastName,
                              cover: state.senderCover,
                            );
                            _messageController.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class MessageLoadingView extends StatelessWidget {
  const MessageLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(10, (index) {
        bool isLeftBubble = index % 2 == 0;
        return isLeftBubble
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        width: MediaQuery.of(context).size.width - 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    ),
                                    child: SkeletonLine(
                                      style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.4, borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    ),
                                    child: SkeletonLine(
                                      style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.3, borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            child: SkeletonLine(
                              style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.8, borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            child: SkeletonLine(
                              style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.3, borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}

class MessageRightSideView extends StatelessWidget {
  final String message;
  final String messageType;
  const MessageRightSideView({super.key, required this.message, required this.messageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width - 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                  ),
                  child: Text(message, style: kAppLblMediumFontBold(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageLeftSideView extends StatelessWidget {
  final String message;
  final String messageType;
  const MessageLeftSideView({super.key, required this.message, required this.messageType});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: MediaQuery.of(context).size.width - 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          ),
                          child: Text(message, style: kAppLblMediumFontBold(context)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MessageErrorView extends StatelessWidget {
  const MessageErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.something_went_wrong_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
