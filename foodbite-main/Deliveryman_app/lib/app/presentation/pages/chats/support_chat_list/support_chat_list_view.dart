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
import 'package:driver/app/core/models/my_support_chat_list_model.dart';
import 'package:driver/app/presentation/pages/chats/support_chat_list/bloc/support_chat_list_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:driver/app/router/app_route_config.dart';

class SupportChatListScreen extends StatelessWidget {
  const SupportChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SupportChatListBloc()..add(SupportChatListInitialEvent()), child: const SupportChatListView());
  }
}

class SupportChatListView extends StatefulWidget {
  const SupportChatListView({super.key});

  @override
  State<SupportChatListView> createState() => _SupportChatListViewState();
}

class _SupportChatListViewState extends State<SupportChatListView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<SupportChatListBloc, SupportChatListState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const SupportChatListLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const SupportChatListErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const SupportChatListEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(state.model.chats!.length, (chatIndex) => SupportChatInfoTileWidget(model: state.model.chats![chatIndex])),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SupportChatInfoTileWidget extends StatelessWidget {
  final SupportChatListModel model;
  const SupportChatInfoTileWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        String type = model.supportType!;
        String typeId = '';
        if (model.supportType! == 'orders') {
          typeId = model.orders!;
        } else if (model.supportType! == 'dining') {
          typeId = model.booking!;
        } else if (model.supportType! == 'tiffin_subscription') {
          typeId = model.purchaseSubscription!;
        } else if (model.supportType! == 'complaints') {
          typeId = model.complaints!;
        } else if (model.supportType! == 'reports') {
          typeId = model.reportIssue!;
        }
        Navigator.of(context).pushNamed(AppRouter.supportChatRoute, arguments: [type, typeId]);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(kAppSupportChatType(context, model.supportType!), style: kAppLblMediumFontBold(context)),
                    kAppSpacerHorizontal(width: 10),
                    if (model.supportType == 'orders') ...[
                      Text("#${model.orders!.toUpperCase()}", style: kAppLblTinyFontRegular(context)),
                    ] else if (model.supportType! == 'dining') ...[
                      Text("#${model.booking!.toUpperCase()}", style: kAppLblTinyFontRegular(context)),
                    ] else if (model.supportType! == 'tiffin_subscription') ...[
                      Text("#${model.purchaseSubscription!.toUpperCase()}", style: kAppLblTinyFontRegular(context)),
                    ] else if (model.supportType! == 'complaints') ...[
                      Text("#${model.complaints!.toUpperCase()}", style: kAppLblTinyFontRegular(context)),
                    ] else if (model.supportType! == 'reports') ...[
                      Text("#${model.reportIssue!.toUpperCase()}", style: kAppLblTinyFontRegular(context)),
                    ],
                  ],
                ),
                kAppSpacerVertical(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (model.status! == 'open') ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: ThemeProvider.primaryColor, borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          translate.open,
                          style: TextStyle(color: ThemeProvider.ratingTextColorLight, fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
                        ),
                      ),
                    ] else if (model.status! == 'in_progress') ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: ThemeProvider.blueColor, borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          translate.in_progress,
                          style: TextStyle(color: ThemeProvider.ratingTextColorLight, fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
                        ),
                      ),
                    ] else if (model.status! == 'resolved') ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: ThemeProvider.ratingBgColorLight, borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          translate.resolved,
                          style: TextStyle(color: ThemeProvider.ratingTextColorLight, fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
                        ),
                      ),
                    ],
                    kAppSpacerHorizontal(width: 10),
                    Text(model.updatedAt!, style: kAppLblTinyFontRegular(context)),
                  ],
                ),
                kAppSpacerVertical(height: 2),
                Text(kAppTrimWord(model.lastMessage!, 40), style: kAppLblTinyFontRegular(context)),
              ],
            ),
            OverlappingAvatars(imageUrls: model.team!),
          ],
        ),
      ),
    );
  }
}

class SupportChatListLoadingView extends StatelessWidget {
  const SupportChatListLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        20,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SkeletonLine(style: SkeletonLineStyle(height: 50, width: 50, borderRadius: BorderRadius.circular(8))),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.3, borderRadius: BorderRadius.circular(8)),
                    ),
                    kAppSpacerVertical(height: 10),
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                    ),
                    kAppSpacerVertical(height: 10),
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2.3, borderRadius: BorderRadius.circular(8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupportChatListErrorView extends StatelessWidget {
  const SupportChatListErrorView({super.key});

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

class SupportChatListEmptyView extends StatelessWidget {
  const SupportChatListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_matching_record_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_reason_found_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class OverlappingAvatars extends StatelessWidget {
  final List<SupportTeamConfigModel> imageUrls;

  const OverlappingAvatars({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: Stack(
        alignment: Alignment.centerRight,
        children: imageUrls.asMap().entries.map((entry) {
          int index = entry.key;
          SupportTeamConfigModel team = entry.value;
          return Positioned(
            left: index * 25,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: CacheNetworkImageWidget(width: 25.0, height: 25.0, imageUrl: team.image!),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
// DONE //