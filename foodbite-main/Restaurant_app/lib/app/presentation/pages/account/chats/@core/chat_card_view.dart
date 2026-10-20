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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/app/presentation/pages/account/chats/@core/bloc/chat_card_bloc.dart';
import 'package:vendor/app/presentation/pages/account/chats/chat_list/chat_list_view.dart';
import 'package:vendor/app/presentation/pages/account/chats/support_chat_list/support_chat_list_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class ChatCardScreen extends StatelessWidget {
  const ChatCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ChatCardBloc()..add(ChatCardInitialEvent()), child: const ChatCardView());
  }
}

class ChatCardView extends StatefulWidget {
  const ChatCardView({super.key});

  @override
  State<ChatCardView> createState() => _ChatCardViewState();
}

class _ChatCardViewState extends State<ChatCardView> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(translate.chats),
        bottom: TabBar(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).hintColor,
          indicatorColor: Theme.of(context).primaryColor,
          labelStyle: kAppStyleTabTitleStyle(context),
          unselectedLabelStyle: kAppStyleTabTitleStyle(context),
          labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          tabs: [Text(translate.direct_chat), Text(translate.support_chat)],
        ),
      ),
      body: TabBarView(controller: tabController, physics: const NeverScrollableScrollPhysics(), children: const [ChatListScreen(), SupportChatListScreen()]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// DONE //