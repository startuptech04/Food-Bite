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
import 'package:vendor/app/core/config/global_settings.dart';
import 'package:vendor/app/core/models/food_list_model.dart';
import 'package:vendor/app/presentation/pages/menu/foods/@core/bloc/foods_bloc.dart';
import 'package:vendor/app/presentation/pages/menu/foods/action/@food_action_dialog/manage_food_action_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class FoodListScreen extends StatelessWidget {
  final bool customCategory;
  const FoodListScreen({super.key, required this.customCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodsBloc(),
      child: FoodListView(customCategory: customCategory),
    );
  }
}

class FoodListView extends StatefulWidget {
  final bool customCategory;
  const FoodListView({super.key, required this.customCategory});

  @override
  State<FoodListView> createState() => _FoodListViewState();
}

class _FoodListViewState extends State<FoodListView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<FoodsBloc>().add(FoodsInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<FoodsBloc, FoodsState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: state.status.isLoading
              ? null
              : AppBar(
                  titleSpacing: 0,
                  automaticallyImplyLeading: false,
                  scrolledUnderElevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          state.tabList!.length,
                          (index) => InkWell(
                            onTap: () => context.read<FoodsBloc>().add(FoodsTabChangeEvent(key: state.tabList![index].key!)),
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Chip(
                                key: ObjectKey(index),
                                label: Text(kAppTabTranslate(context, state.tabList![index].label!, state.tabList![index].countNumber!)),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.all(2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: state.activeTab == state.tabList![index].key ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1),
                                ),
                                labelStyle: kAppLblSmallFontMedium(context, color: state.activeTab == state.tabList![index].key ? 'primary' : 'regular'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          floatingActionButton: SizedBox(
            height: 30,
            child: FloatingActionButton.extended(
              heroTag: 'addNewFood',
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ManageFoodActionScreen(id: '', isNew: true, customCategory: widget.customCategory);
                        },
                        fullscreenDialog: true,
                      ),
                    )
                    .then((value) {
                      if (!context.mounted) return;
                      if (value) {
                        context.read<FoodsBloc>().add(FoodsInitialEvent());
                      }
                    });
              },
              label: Text(translate.add),
              icon: const Icon(Icons.add),
            ),
          ),
          body: state.status.isLoading
              ? SkeletonListView(itemCount: 10)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                  child: state.activeTab == 'all'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                        onTap: () => context.read<FoodsBloc>().add(FoodsToggleCustomCategoryViewEvent(categoryIndex: categoryIndex)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text('${state.list.custom![categoryIndex].categoryName!} (${state.list.custom![categoryIndex].foods!.length})', style: kAppLblSemiBoldFontLarge(context)),
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
                                                (foodIndex) => FoodInfoTile(results: state.list.custom![categoryIndex].foods![foodIndex], customCategory: widget.customCategory, listFrom: 'custom', categoryIndex: categoryIndex),
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
                                        onTap: () => context.read<FoodsBloc>().add(FoodsToggleMainCategoryViewEvent(categoryIndex: categoryIndex)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text('${state.list.main![categoryIndex].categoryName!} (${state.list.main![categoryIndex].foods!.length})', style: kAppLblSemiBoldFontLarge(context)),
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
                                                (foodIndex) => FoodInfoTile(results: state.list.main![categoryIndex].foods![foodIndex], customCategory: widget.customCategory, listFrom: 'main', categoryIndex: categoryIndex),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(state.foodList.length, (foodIndex) => FoodInfoTile(results: state.foodList[foodIndex], customCategory: widget.customCategory, listFrom: 'otherTabs', categoryIndex: 0)),
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
  final FoodModel results;
  final bool customCategory;
  final String listFrom;
  final int categoryIndex;
  const FoodInfoTile({super.key, required this.results, required this.customCategory, required this.listFrom, required this.categoryIndex});

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
                TextButton.icon(
                  onPressed: () => context.read<FoodsBloc>().add(FoodsUpdateRecommendEvent(id: results.id!, status: !results.recommended!, listFrom: listFrom, categoryIndex: categoryIndex)),
                  icon: Icon(
                    results.recommended! ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    size: Theme.of(context).textTheme.labelSmall?.fontSize,
                    color: results.recommended! ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                  ),
                  label: Text(translate.recommend, style: kAppLblSmallFontSemiBold(context)),
                ),
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.5,
                      child: Switch(
                        value: results.inStock!,
                        thumbIcon: thumbIcon,
                        activeThumbColor: Theme.of(context).primaryColor,
                        onChanged: (bool value) => context.read<FoodsBloc>().add(FoodsUpdateStockEvent(id: results.id!, status: !results.inStock!, listFrom: listFrom, categoryIndex: categoryIndex)),
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
                              return ManageFoodActionScreen(id: results.id!, isNew: false, customCategory: customCategory);
                            },
                            fullscreenDialog: true,
                          ),
                        )
                        .then((value) {
                          if (!context.mounted) return;
                          if (value != null) {
                            context.read<FoodsBloc>().add(FoodsInitialEvent());
                          }
                        });
                  },
                  icon: Icon(Icons.edit_outlined, size: Theme.of(context).textTheme.labelSmall?.fontSize, color: Theme.of(context).canvasColor),
                  label: Text(translate.edit_lbl, style: kAppLblSmallFontSemiBold(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// DONE //