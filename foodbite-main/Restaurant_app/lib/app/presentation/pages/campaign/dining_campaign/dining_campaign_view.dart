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
import 'package:vendor/app/core/models/dining_campaign_list_model.dart';
import 'package:vendor/app/presentation/pages/campaign/dining_campaign/bloc/dining_campaign_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DiningCampaignScreen extends StatelessWidget {
  const DiningCampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DiningCampaignBloc()..add(DiningCampaignInitialEvent()), child: const DiningCampaignView());
  }
}

class DiningCampaignView extends StatefulWidget {
  const DiningCampaignView({super.key});

  @override
  State<DiningCampaignView> createState() => _DiningCampaignViewState();
}

class _DiningCampaignViewState extends State<DiningCampaignView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollControlleDiningCampaign = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControlleDiningCampaign.addListener(() {
      if (_scrollControlleDiningCampaign.position.pixels == _scrollControlleDiningCampaign.position.maxScrollExtent) {
        context.read<DiningCampaignBloc>().add(DiningCampaignLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<DiningCampaignBloc, DiningCampaignState>(
      listener: (context, state) {
        if (state.status.isLoaderStarted) {
          LoaderService.showLoader(context);
        } else if (state.status.isLoaderEnded) {
          LoaderService.hideLoder(context);
          showSuccessDialog(context, state.action == 'join' ? translate.request_sent : translate.removed_from_campaign);
        } else if (state.status.isLoaderEndedWithError) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state.status.isLoading
              ? const DiningCampaignLoadingView()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollControlleDiningCampaign,
                  child: Padding(
                    padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(state.campaigns.results!.length, (index) => DiningCampaignInfoTileView(results: state.campaigns.results![index], vendorId: state.vendorId)),
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

class DiningCampaignInfoTileView extends StatelessWidget {
  final DiningCampaignConfigModel results;
  final String vendorId;
  const DiningCampaignInfoTileView({super.key, required this.results, required this.vendorId});

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
                if (results.restaurant!.contains(vendorId)) {
                  showConfirmDialog(context, translate.alert_confirm_title, translate.alert_confirm_leave_campaign, translate.cancel_lbl, translate.alert_yes_leave_campaign).then((value) {
                    if (!context.mounted) return;
                    if (value) {
                      context.read<DiningCampaignBloc>().add(DiningCampaignLeaveEvent(campaignId: results.id!));
                    }
                  });
                } else {
                  context.read<DiningCampaignBloc>().add(DiningCampaignJoinEvent(campaignId: results.id!));
                }
              },
              style: kAppElevatedButtonStyle(
                context,
                disabledColor: Theme.of(context).disabledColor,
                bgColor: results.restaurant!.contains(vendorId) ? ThemeProvider.errorColor : Theme.of(context).primaryColor,
                foreColor: Theme.of(context).scaffoldBackgroundColor,
                height: 40.0,
              ),
              child: Text(results.restaurant!.contains(vendorId) ? translate.leave_campaign : translate.join_campaign),
            ),
          ),
        ],
      ),
    );
  }
}

class DiningCampaignLoadingView extends StatelessWidget {
  const DiningCampaignLoadingView({super.key});

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
                    const Row(
                      children: [
                        SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
                        SizedBox(width: 8),
                        SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
                        SizedBox(width: 8),
                        SkeletonAvatar(style: SkeletonAvatarStyle(width: 20, height: 20)),
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