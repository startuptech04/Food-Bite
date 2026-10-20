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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/core/config/global_settings.dart';
import 'package:vendor/app/core/models/food_campaign_details_food_list_model.dart';
import 'package:vendor/app/presentation/pages/campaign/food_campaign/action/bloc/food_campaign_action_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class FoodCampaignActionScreen extends StatelessWidget {
  final String id;
  final String title;
  final List<String> savedFoods;
  const FoodCampaignActionScreen({super.key, required this.id, required this.title, required this.savedFoods});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodCampaignActionBloc()..add(FoodCampaignActionInitialEvent(id: id, title: title, savedFoods: savedFoods)),
      child: const FoodCampaignActionView(),
    );
  }
}

class FoodCampaignActionView extends StatefulWidget {
  const FoodCampaignActionView({super.key});

  @override
  State<FoodCampaignActionView> createState() => _FoodCampaignActionViewState();
}

class _FoodCampaignActionViewState extends State<FoodCampaignActionView> {
  final ScrollController _newScrollControlle = ScrollController();
  final ScrollController _inListScrollControlle = ScrollController();
  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<FoodCampaignActionBloc, FoodCampaignActionState>(
      listener: (context, state) {
        if (state.status.isLoaderStarted) {
          LoaderService.showLoader(context);
        } else if (state.status.isLoaderEnded) {
          LoaderService.hideLoder(context);
          showSuccessDialog(context, state.action == 'join' ? translate.request_sent : translate.removed_from_campaign);
        } else if (state.status.isLoaderEndedWithError) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(state.title),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(false),
                icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
              ),
            ],
          ),
          bottomNavigationBar: state.status.isLoading
              ? SafeArea(child: const SizedBox())
              : SafeArea(
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => {Navigator.of(context).pop(false)},
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).scaffoldBackgroundColor, foreColor: Theme.of(context).canvasColor, height: 50.0),
                                child: Text(translate.cancel_lbl),
                              ),
                            ),
                          ),
                          kAppSpacerHorizontal(width: 10),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => {Navigator.of(context).pop(true)},
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                                child: Text(translate.save_lbl),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          body: state.status.isLoading
              ? kAppCenterCircularProgress(context)
              : Padding(
                  padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FoodInfoTitle(title: translate.add_food_in_campaign),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _newScrollControlle,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(state.campaigns.foods!.length, (index) => NewFoodListTile(results: state.campaigns.foods![index], savedFoods: state.savedFoods)),
                          ),
                        ),
                      ),
                      kAppSpacerVertical(height: 30),
                      FoodInfoTitle(title: translate.food_in_campaign),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _inListScrollControlle,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(state.campaigns.info!.foods!.length, (index) => InCampaignListTile(index: index, results: state.campaigns.foods![index])),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class FoodInfoTitle extends StatelessWidget {
  final String title;
  const FoodInfoTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).colorScheme.secondary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelMedium?.fontSize),
          kAppSpacerHorizontal(width: 10),
          Text(title, style: kAppLblMediumFontBold(context, color: 'primary')),
        ],
      ),
    );
  }
}

class NewFoodListTile extends StatelessWidget {
  final FoodsInfoInCampaignModel results;
  final List<String> savedFoods;
  const NewFoodListTile({super.key, required this.results, required this.savedFoods});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(35),
                  child: CacheNetworkImageWidget(width: 40.0, height: 40.0, imageUrl: results.image!),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(results.name!, style: kAppLblMediumFontSemiBold(context)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobalSettings.globalCurrencySide == 'left'
                              ? '${translate.form_price} : ${GlobalSettings.globalCurrencySymbol}${results.price!}'
                              : '${translate.form_price} : ${results.price!}${GlobalSettings.globalCurrencySymbol}',
                          style: kAppLblSmallFontRegular(context),
                        ),
                        Text('${translate.total_addon} : ${results.addons!.length}', style: kAppLblSmallFontRegular(context)),
                        Text('${translate.total_variation} : ${results.variations!.length}', style: kAppLblSmallFontRegular(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: !savedFoods.contains(results.id!) ? () => context.read<FoodCampaignActionBloc>().add(FoodCampaignActionJoinEvent(id: results.id!)) : null,
            icon: FaIcon(FontAwesomeIcons.check, size: Theme.of(context).textTheme.labelMedium?.fontSize),
          ),
        ],
      ),
    );
  }
}

class InCampaignListTile extends StatelessWidget {
  final int index;
  final FoodsInfoInCampaignModel results;
  const InCampaignListTile({super.key, required this.results, required this.index});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(10),
                  child: CacheNetworkImageWidget(width: 15.0, height: 15.0, imageUrl: results.image!),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(results.name!, style: kAppLblMediumFontSemiBold(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          GlobalSettings.globalCurrencySide == 'left'
                              ? '${translate.form_price} : ${GlobalSettings.globalCurrencySymbol}${results.price!}'
                              : '${translate.form_price} : ${results.price!}${GlobalSettings.globalCurrencySymbol}',
                          style: kAppLblSmallFontRegular(context),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text('${translate.total_addon} : ${results.addons!.length}', style: kAppLblSmallFontRegular(context)),
                        ),
                        Text('${translate.total_variation} : ${results.variations!.length}', style: kAppLblSmallFontRegular(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              showConfirmDialog(context, translate.alert_confirm_title, translate.alert_confirm_leave_campaign, translate.cancel_lbl, translate.alert_yes_leave_campaign).then((value) {
                if (!context.mounted) return;
                if (value) {
                  context.read<FoodCampaignActionBloc>().add(FoodCampaignActionLeaveEvent(index: index, id: results.id!));
                }
              });
            },
            icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelMedium?.fontSize),
          ),
        ],
      ),
    );
  }
}
// DONE //