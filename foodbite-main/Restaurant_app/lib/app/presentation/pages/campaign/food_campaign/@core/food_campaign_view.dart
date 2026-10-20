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
import 'package:vendor/app/core/models/food_campaign_list_model.dart';
import 'package:vendor/app/presentation/pages/campaign/food_campaign/@core/bloc/food_campaign_bloc.dart';
import 'package:vendor/app/presentation/pages/campaign/food_campaign/action/food_campaign_modal.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class FoodCampaignListScreen extends StatelessWidget {
  const FoodCampaignListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => FoodCampaignBloc()..add(FoodCampaignInitialEvent()), child: const FoodCampaignListView());
  }
}

class FoodCampaignListView extends StatefulWidget {
  const FoodCampaignListView({super.key});

  @override
  State<FoodCampaignListView> createState() => _FoodCampaignListViewState();
}

class _FoodCampaignListViewState extends State<FoodCampaignListView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollControlleFoodCampaign = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControlleFoodCampaign.addListener(() {
      if (_scrollControlleFoodCampaign.position.pixels == _scrollControlleFoodCampaign.position.maxScrollExtent) {
        context.read<FoodCampaignBloc>().add(FoodCampaignLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<FoodCampaignBloc, FoodCampaignState>(
      listener: (context, state) {
        if (state.status.isLoaderStarted) {
          LoaderService.showLoader(context);
        } else if (state.status.isLoaderEnded) {
          LoaderService.hideLoder(context);
        } else if (state.status.isLoaderEndedWithError) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state.status.isLoading
              ? const FoodCampaignSkeleton()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollControlleFoodCampaign,
                  child: Padding(
                    padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(state.campaigns.results!.length, (index) => FoodCampaignListTile(results: state.campaigns.results![index], vendorId: state.vendorId)),
                        ),
                        state.status.isLoadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FoodCampaignListTile extends StatelessWidget {
  final FoodCampaignResultModel results;
  final String vendorId;
  const FoodCampaignListTile({super.key, required this.results, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
            child: CacheNetworkImageWidget(height: 120, width: MediaQuery.of(context).size.width, imageUrl: results.image!, fit: BoxFit.cover),
          ),
          kAppSpacerVertical(height: 10),
          Text(results.title!, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 10),
          Text('${translate.duration} : ${results.startDate!} - ${results.endDate!}', style: kAppLblSmallFontMedium(context)),
          kAppSpacerVertical(height: 5),
          Text('${translate.form_time} : ${results.startTime!} - ${results.endTime!}', style: kAppLblSmallFontMedium(context)),
          kAppSpacerVertical(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) {
                      return FoodCampaignActionScreen(id: results.id!, title: results.title!, savedFoods: results.foods!);
                    },
                  ),
                );
              },
              style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
              child: Text(translate.join_campaign),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodCampaignSkeleton extends StatelessWidget {
  const FoodCampaignSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: SkeletonItem(
            child: Column(
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(width: double.infinity, minHeight: MediaQuery.of(context).size.height / 8, maxHeight: MediaQuery.of(context).size.height / 5),
                ),
                kAppSpacerVertical(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
                        kAppSpacerHorizontal(width: 8),
                        const SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
                        kAppSpacerHorizontal(width: 8),
                        const SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
                      ],
                    ),
                    SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// DONE //