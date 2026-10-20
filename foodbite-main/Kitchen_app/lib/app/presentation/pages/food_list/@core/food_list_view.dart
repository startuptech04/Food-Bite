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
import 'package:kitchen/app/core/config/assets_url.dart';
import 'package:kitchen/app/core/config/global_settings.dart';
import 'package:kitchen/app/core/models/food_list_model.dart';
import 'package:kitchen/app/presentation/pages/food_list/@core/bloc/food_list_bloc.dart';
import 'package:kitchen/app/presentation/pages/food_list/food_detail/@core/food_detail_view.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/error_dialog.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FoodListView();
  }
}

class FoodListView extends StatefulWidget {
  const FoodListView({super.key});

  @override
  State<FoodListView> createState() => _FoodListViewState();
}

class _FoodListViewState extends State<FoodListView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<FoodListBloc>().add(FoodListInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<FoodListBloc, FoodListState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false, title: Text(translate.food_list), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const FoodListLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const FoodListErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const FoodListEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.list.custom!.length,
                      (categoryIndex) => Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => context.read<FoodListBloc>().add(FoodListToggleCustomCategoryViewEvent(categoryIndex: categoryIndex)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${state.list.custom![categoryIndex].categoryName!} (${state.list.custom![categoryIndex].foods!.length})", style: kAppLblSemiBoldFontLarge(context)),
                                    Icon(state.list.custom![categoryIndex].isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 18, color: Theme.of(context).canvasColor),
                                  ],
                                ),
                              ),
                            ),
                            state.list.custom![categoryIndex].isOpen
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                      state.list.custom![categoryIndex].foods!.length,
                                      (foodIndex) => FoodInfoTile(results: state.list.custom![categoryIndex].foods![foodIndex], listFrom: 'custom', categoryIndex: categoryIndex),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.list.main!.length,
                      (categoryIndex) => Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => context.read<FoodListBloc>().add(FoodListToggleMainCategoryViewEvent(categoryIndex: categoryIndex)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${state.list.main![categoryIndex].categoryName!} (${state.list.main![categoryIndex].foods!.length})", style: kAppLblSemiBoldFontLarge(context)),
                                    Icon(state.list.main![categoryIndex].isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 18, color: Theme.of(context).canvasColor),
                                  ],
                                ),
                              ),
                            ),
                            state.list.main![categoryIndex].isOpen
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                      state.list.main![categoryIndex].foods!.length,
                                      (foodIndex) => FoodInfoTile(results: state.list.main![categoryIndex].foods![foodIndex], listFrom: 'main', categoryIndex: categoryIndex),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
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

class FoodInfoTile extends StatelessWidget {
  final FoodDetailConfigModel results;
  final String listFrom;
  final int categoryIndex;
  const FoodInfoTile({super.key, required this.results, required this.listFrom, required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(results.name!, style: kAppLblMediumFontBold(context)),
                    kAppSpacerVertical(height: 5),
                    Text(results.shortDescription!, style: kAppLblSmallFontRegular(context)),
                    kAppSpacerVertical(height: 5),
                    Text(
                      GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}${results.price!}' : '${results.price!}${GlobalSettings.globalCurrencySymbol}',
                      style: kAppLblSmallFontRegular(context),
                    ),
                  ],
                ),
              ),
              kAppSpacerHorizontal(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(40),
                  child: CacheNetworkImageWidget(width: 40.0, height: 40.0, imageUrl: results.image!),
                ),
              ),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).disabledColor, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.5,
                      child: Switch(
                        value: results.inStock!,
                        thumbIcon: thumbIcon,
                        activeThumbColor: Theme.of(context).primaryColor,
                        onChanged: (bool value) => context.read<FoodListBloc>().add(FoodListUpdateStockEvent(id: results.id!, status: !results.inStock!, listFrom: listFrom, categoryIndex: categoryIndex)),
                      ),
                    ),
                    Text(translate.in_stock, style: kAppLblSmallFontSemiBold(context)),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return FoodDetailScreen(id: results.id!);
                            },
                            fullscreenDialog: true,
                          ),
                        )
                        .then((value) {
                          if (!context.mounted) return;
                          if (value != null) {
                            context.read<FoodListBloc>().add(FoodListInitialEvent());
                          }
                        });
                  },
                  icon: Icon(Icons.edit_outlined, size: Theme.of(context).textTheme.labelSmall?.fontSize, color: Theme.of(context).canvasColor),
                  label: Text(translate.update_stock_detail, style: kAppLblSmallFontSemiBold(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodListLoadingView extends StatelessWidget {
  const FoodListLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
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
                ],
              ),
              SkeletonLine(style: SkeletonLineStyle(height: 10, width: 20, borderRadius: BorderRadius.circular(8))),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodListEmptyView extends StatelessWidget {
  const FoodListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_matching_record_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_matching_record_found_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class FoodListErrorView extends StatelessWidget {
  const FoodListErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.server_bug_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //