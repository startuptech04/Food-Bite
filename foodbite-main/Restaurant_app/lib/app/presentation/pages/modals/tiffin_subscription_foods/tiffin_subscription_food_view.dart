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
import 'package:vendor/app/presentation/pages/modals/tiffin_subscription_foods/bloc/tiffin_subscription_food_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TiffinSubscriptionFoodScreen extends StatelessWidget {
  final List<String> foodList;
  const TiffinSubscriptionFoodScreen({super.key, required this.foodList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TiffinSubscriptionFoodBloc()..add(TiffinSubscriptionFoodInitialEvent(foodList: foodList)),
      child: TiffinSubscriptionFoodView(foodList: foodList),
    );
  }
}

class TiffinSubscriptionFoodView extends StatelessWidget {
  final List<String> foodList;
  const TiffinSubscriptionFoodView({super.key, required this.foodList});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<TiffinSubscriptionFoodBloc, TiffinSubscriptionFoodState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSaveItem) {
          List<String> name = <String>[];
          for (var foodItem in state.model.foods!) {
            if (state.foodList.contains(foodItem.id!)) {
              name.add(foodItem.name!);
            }
          }
          Navigator.of(context).pop({'action': true, 'id': state.foodList, 'name': name});
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(translate.select_food_for_tiffin_packages),
            actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const TiffinSubscriptionFoodLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const TiffinSubscriptionFoodErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const TiffinSubscriptionFoodEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.foods!.length,
                      (index) => GestureDetector(
                        onTap: () => context.read<TiffinSubscriptionFoodBloc>().add(TiffinSubscriptionFoodSelectEvent(foodId: state.model.foods![index].id!)),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CacheNetworkImageWidget(width: 50.0, height: 50.0, imageUrl: state.model.foods![index].image!),
                                  ),
                                  kAppSpacerHorizontal(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 1.4,
                                        child: Text(state.model.foods![index].name!, maxLines: 1, overflow: TextOverflow.ellipsis, style: kAppLblSmallFontBold(context)),
                                      ),
                                      Text('${translate.addons} : ${state.model.foods![index].addons!.length} ${translate.variation}: ${state.model.foods![index].variations!.length}', style: kAppLblSmallFontRegular(context)),
                                      Text(
                                        '${translate.form_price}: ${kAppPriceFormat(state.model.foods![index].price!)} ${translate.discount}: (${state.model.foods![index].discount!} ${state.model.foods![index].discountType!})',
                                        style: kAppLblSmallFontRegular(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                state.foodList.contains(state.model.foods![index].id!) ? Icons.check_box : Icons.check_box_outline_blank,
                                size: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          bottomNavigationBar: state.status.isLoading || state.status.isFailure || state.status.isEmpty
              ? SafeArea(child: const SizedBox())
              : SafeArea(
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [Text(translate.cancel_lbl, style: kAppLblSmallFontBold(context, color: 'canvas'))],
                                ),
                              ),
                            ),
                          ),
                          const Expanded(flex: 1, child: SizedBox(width: double.infinity)),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: state.foodList.isNotEmpty ? () => context.read<TiffinSubscriptionFoodBloc>().add(TiffinSubscriptionFoodSaveEvent()) : null,
                              style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                              child: Text(translate.save_lbl),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class TiffinSubscriptionFoodLoadingView extends StatelessWidget {
  const TiffinSubscriptionFoodLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(10, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          ),
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 5),
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 5),
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.2, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 5),
            ],
          ),
        );
      }),
    );
  }
}

class TiffinSubscriptionFoodErrorView extends StatelessWidget {
  const TiffinSubscriptionFoodErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.something_went_wrong_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class TiffinSubscriptionFoodEmptyView extends StatelessWidget {
  const TiffinSubscriptionFoodEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_tiffin_food_found_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //