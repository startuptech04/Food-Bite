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
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/presentation/pages/menu/media_file_list/bloc/media_file_list_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class MediaFileListScreen extends StatelessWidget {
  const MediaFileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => MediaFileListBloc()..add(MediaFileListInitialEvent()), child: const MediaFileListView());
  }
}

class MediaFileListView extends StatefulWidget {
  const MediaFileListView({super.key});

  @override
  State<MediaFileListView> createState() => _MediaFileListViewState();
}

class _MediaFileListViewState extends State<MediaFileListView> {
  final ScrollController _scrollMoreMedia = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollMoreMedia.addListener(() {
      if (_scrollMoreMedia.position.pixels == _scrollMoreMedia.position.maxScrollExtent) {
        context.read<MediaFileListBloc>().add(MediaFileListLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<MediaFileListBloc, MediaFileListState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.media_files), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            controller: _scrollMoreMedia,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const MediaFileListLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const MediaFileListErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const MediaFileListEmptyView(),
                ] else ...[
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(state.medias.results!.length, (index) {
                      return Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(8), // Border width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: ThemeProvider.transparentColor, width: 2),
                          shape: BoxShape.rectangle,
                        ),
                        child: CacheNetworkImageWidget(width: 40, height: 40, imageUrl: state.medias.results![index].path!),
                      );
                    }),
                  ),
                  kAppSpacerVertical(height: 20),
                  state.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  kAppSpacerVertical(height: 20),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class MediaFileListLoadingView extends StatelessWidget {
  const MediaFileListLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 150),
          scrollDirection: Axis.vertical,
          key: UniqueKey(),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 150.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
              ),
              child: SkeletonAvatar(style: SkeletonAvatarStyle(width: MediaQuery.of(context).size.width / 3, height: 150.0)),
            );
          },
          itemCount: 40,
        ),
      ],
    );
  }
}

class MediaFileListErrorView extends StatelessWidget {
  const MediaFileListErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class MediaFileListEmptyView extends StatelessWidget {
  const MediaFileListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_media_file_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_media_file_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //