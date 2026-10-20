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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/pos_food_info_modal_response_model.dart';
import 'package:vendor/app/core/models/pos_food_model.dart';
import 'package:vendor/app/core/models/pos_food_variations_response_data_modal_model.dart';
import 'package:vendor/app/core/models/pos_repeat_quantity_modal_response_model.dart';
import 'package:vendor/app/presentation/pages/modals/food_info_modal/food_info_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/food_variations_modal/@core/food_variations_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/food_variations_modal/repeat/food_variation_modal_repeat_view.dart';
import 'package:vendor/app/presentation/pages/modals/pos_menu_modal/pos_menu_modal_view.dart';
import 'package:vendor/app/presentation/pages/pos_management/@core/bloc/pos_management_bloc.dart';
import 'package:vendor/app/presentation/pages/pos_management/pos_place_order/bloc/pos_place_order_bloc.dart';
import 'package:vendor/app/presentation/pages/pos_management/pos_search_food/bloc/pos_search_food_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class POSManagementScreen extends StatelessWidget {
  const POSManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PosPlaceOrderBloc, PosPlaceOrderState>(
          listener: (context, state) {
            if (state.status.isCartUpdate || state.status.isCartError || state.status.isOrderPlaced) {
              context.read<PosManagementBloc>().add(PosManagementRefreshCartDataEvent());
            }
          },
        ),
        BlocListener<PosSearchFoodBloc, PosSearchFoodState>(
          listener: (context, state) {
            if (state.status.isInitialCartUpdate || state.status.isInitialCartError || state.status.isSearchCartUpdate || state.status.isSearchCartError || state.status.isCartError) {
              context.read<PosManagementBloc>().add(PosManagementRefreshCartDataEvent());
            }
          },
        ),
      ],
      child: const POSManagementView(),
    );
  }
}

class POSManagementView extends StatefulWidget {
  const POSManagementView({super.key});

  @override
  State<POSManagementView> createState() => _POSManagementViewState();
}

class _POSManagementViewState extends State<POSManagementView> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollControllerMain = ScrollController();
  final ScrollController _scrollControllerCategories = ScrollController();
  final Map<String, GlobalKey> _globalBottomCategoriesKey = {};

  @override
  void initState() {
    super.initState();
    context.read<PosManagementBloc>().add(PosManagementInitialEvent());
  }

  void scrollBottomCategory(String categoryKey, String realId) {
    final keyContext = _globalBottomCategoriesKey[categoryKey]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(keyContext, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  void onScrollToPosition(String id, String realId) {
    final keyContext = context.read<PosManagementBloc>().state.globalMainCategoriesKey[id]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(keyContext, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<PosManagementBloc, PosManagementState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError || state.status.isCartError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onRefresh: () async {
            context.read<PosManagementBloc>().add(PosManagementInitialEvent());
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(translate.pos_orders),
              actions: !state.status.isUnauthorized
                  ? [
                      IconButton(onPressed: () => context.read<PosManagementBloc>().add(PosManagementInitialEvent()), icon: const Icon(Icons.refresh_outlined, size: 15)),
                      IconButton(onPressed: () => Navigator.of(context).pushNamed(AppRouter.posOrderListRoute), icon: const Icon(Icons.list_alt_outlined)),
                    ]
                  : [],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20.0),
                child: !state.status.isUnauthorized
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(AppRouter.posSearchFoodRoute),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search_outlined, color: Theme.of(context).primaryColor),
                                kAppSpacerHorizontal(width: 5),
                                Text(translate.search_menu, style: kAppLblMediumFontMediumGrey(context)),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            body: SingleChildScrollView(
              controller: _scrollControllerMain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const PosManagementLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const PosManagementErrorView(),
                  ] else if (state.status.isEmpty) ...[
                    const PosManagementEmptyView(),
                  ] else if (state.status.isUnauthorized) ...[
                    const PosManagementUnauthorizedView(),
                  ] else ...[
                    kAppSpacerVertical(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.model.custom!.length,
                        (categoryIndex) => Container(
                          padding: const EdgeInsets.only(left: ThemeProvider.scaffoldPadding, right: ThemeProvider.scaffoldPadding, bottom: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                key: state.globalMainCategoriesKey['main_${state.model.custom![categoryIndex].categoryId!.toString()}'],
                                onTap: () => context.read<PosManagementBloc>().add(PosManagementToggleCustomCategoryViewEvent(categoryIndex: categoryIndex)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('${state.model.custom![categoryIndex].categoryName!} (${state.model.custom![categoryIndex].foods!.length})', style: kAppLblSemiBoldFontLarge(context)),
                                      Icon(state.model.custom![categoryIndex].isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 18, color: Theme.of(context).canvasColor),
                                    ],
                                  ),
                                ),
                              ),
                              state.model.custom![categoryIndex].isOpen
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(
                                        state.model.custom![categoryIndex].foods!.length,
                                        (foodIndex) => FoodBlockView(model: state.model.custom![categoryIndex].foods![foodIndex], from: 'custom', categoryIndex: categoryIndex, appLocale: state.appLocale),
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
                        state.model.main!.length,
                        (categoryIndex) => Container(
                          padding: const EdgeInsets.only(left: ThemeProvider.scaffoldPadding, right: ThemeProvider.scaffoldPadding, bottom: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                key: state.globalMainCategoriesKey['main_${state.model.main![categoryIndex].categoryId!.toString()}'],
                                onTap: () => context.read<PosManagementBloc>().add(PosManagementToggleMainCategoryViewEvent(categoryIndex: categoryIndex)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('${state.model.main![categoryIndex].categoryName!} (${state.model.main![categoryIndex].foods!.length})', style: kAppLblSemiBoldFontLarge(context)),
                                      Icon(state.model.main![categoryIndex].isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 18, color: Theme.of(context).canvasColor),
                                    ],
                                  ),
                                ),
                              ),
                              state.model.main![categoryIndex].isOpen
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(
                                        state.model.main![categoryIndex].foods!.length,
                                        (foodIndex) => FoodBlockView(model: state.model.main![categoryIndex].foods![foodIndex], from: 'main', categoryIndex: categoryIndex, appLocale: state.appLocale),
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
            bottomNavigationBar: state.category.isNotEmpty && !state.status.isUnauthorized
                ? SafeArea(
                    child: SizedBox(
                      height: state.cartTotalItem >= 1 ? 100 : 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: SingleChildScrollView(
                                    controller: _scrollControllerCategories,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: List.generate(state.category.length, (categoryIndex) {
                                        _globalBottomCategoriesKey['bottom_${state.category[categoryIndex].id.toString()}'] = GlobalKey();
                                        return Container(
                                          key: _globalBottomCategoriesKey['bottom_${state.category[categoryIndex].id.toString()}'],
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          margin: const EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                            color: state.categoryInView == state.category[categoryIndex].id ? Theme.of(context).colorScheme.shadow : Theme.of(context).scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              context.read<PosManagementBloc>().add(PosManagementScrollToCategoryEvent(categoryId: state.category[categoryIndex].id!));
                                              scrollBottomCategory('bottom_${state.category[categoryIndex].id.toString()}', state.category[categoryIndex].id!.toString());
                                              onScrollToPosition('main_${state.category[categoryIndex].id.toString()}', state.category[categoryIndex].id.toString());
                                            },
                                            child: Text(state.category[categoryIndex].name!, style: state.categoryInView == state.category[categoryIndex].id ? kAppLblTinyFontBold(context) : kAppLblTinyFontRegular(context)),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Align(
                                            alignment: Alignment.bottomRight,
                                            child: FractionallySizedBox(
                                              heightFactor: state.category.isNotEmpty && state.category.length >= 10 ? 0.5 : 0.4,
                                              widthFactor: 0.7,
                                              child: Dialog(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                child: FractionallySizedBox(
                                                  child: RestaurantMenuModalScreen(currentInView: state.categoryInView, categories: state.category),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) {
                                        if (!context.mounted) return;
                                        if (value != null && value.toString() != 'null') {
                                          context.read<PosManagementBloc>().add(PosManagementScrollToCategoryEvent(categoryId: value.toString()));
                                          scrollBottomCategory('bottom_$value', value.toString());
                                          onScrollToPosition('main_${value.toString()}', value.toString());
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(color: ThemeProvider.darkBackgroundColor, borderRadius: BorderRadius.circular(5)),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.fastfood_outlined, size: 10, color: ThemeProvider.whiteColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.menu_title, style: TextStyle(color: ThemeProvider.whiteColor, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          state.cartTotalItem >= 1
                              ? GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed(AppRouter.posPlaceOrderRoute),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [Text('${state.cartTotalItem} ${state.cartTotalItem == 1 ? translate.item : translate.items} ${translate.added}', style: kAppLblTinyFontBoldCart(context))],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(kAppPriceFormat(state.cartTotalAmount), style: kAppLblTinyFontBoldCart(context)),
                                            Text(translate.place_order, style: kAppLblTinyFontBoldCart(context)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  )
                : SafeArea(child: const SizedBox()),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FoodBlockView extends StatelessWidget {
  final FoodListModel model;
  final String from;
  final int categoryIndex;
  final String appLocale;
  const FoodBlockView({super.key, required this.model, required this.from, required this.categoryIndex, required this.appLocale});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                      heightFactor: 0.7,
                      child: FoodInfoModalScreen(id: model.id!, data: jsonEncode(model)),
                    );
                  },
                ).then((value) {
                  if (!context.mounted) return;
                  if (value != null) {
                    PosFoodInfoModalResponseModel foodInfoModalResponse = PosFoodInfoModalResponseModel.fromJson(value, appLocale);
                    context.read<PosManagementBloc>().add(PosManagementFoodModalResponseEvent(id: model.id!, from: from, categoryIndex: categoryIndex, response: foodInfoModalResponse));
                  }
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kAppFoodType(model.foodType!),
                  kAppSpacerVertical(height: 5),
                  Text(kAppTrimWord(model.name!, 50), style: kAppLblMediumFontBold(context)),
                  kAppSpacerVertical(height: 5),
                  model.discount! <= 0
                      ? Text(kAppPriceFormat(model.price!), style: kAppLblTinyMediumFontSemi(context))
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(kAppPriceFormat(model.price!), style: kAppLblTinyStrokeFontRegular(context)),
                            kAppSpacerHorizontal(width: 5),
                            Text(kAppPriceFormat(model.offerPrice!), style: kAppLblTinyMediumFontSemi(context)),
                          ],
                        ),
                  kAppSpacerVertical(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(kAppTrimWord(model.shortDescription!, 150), style: kAppLblTinyFontRegular(context)),
                  ),
                  kAppSpacerVertical(height: 5),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.7,
                          child: FoodInfoModalScreen(id: model.id!, data: jsonEncode(model)),
                        );
                      },
                    ).then((value) {
                      if (!context.mounted) return;
                      if (value != null) {
                        PosFoodInfoModalResponseModel foodInfoModalResponse = PosFoodInfoModalResponseModel.fromJson(value, appLocale);
                        context.read<PosManagementBloc>().add(PosManagementFoodModalResponseEvent(id: model.id!, from: from, categoryIndex: categoryIndex, response: foodInfoModalResponse));
                      }
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CacheNetworkImageWidget(width: double.infinity, height: 80.0, imageUrl: model.image!),
                  ),
                ),
                Positioned(
                  bottom: -25,
                  child: Column(
                    children: [
                      model.quantity! <= 0
                          ? InkWell(
                              onTap: () {
                                if (model.addons!.isNotEmpty || model.variations!.isNotEmpty) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    enableDrag: false,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.7,
                                        child: FoodVariationsModalScreen(
                                          id: model.id!,
                                          name: model.name!,
                                          image: model.image!,
                                          options: jsonEncode({"addons": model.addons!, "variations": model.variations!}),
                                          price: model.price!,
                                          offerPrice: model.offerPrice!,
                                          discount: model.discount!,
                                          discountType: model.discountType!,
                                          purchaseLimit: int.parse(model.purchaseLimit!.toString()),
                                          stockNumber: int.parse(model.stockNumber!.toString()),
                                          stockType: model.stockType!,
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    if (!context.mounted) return;
                                    if (value != null) {
                                      PosFoodVariationModalResponseDataModel foodVariationModalResponse = PosFoodVariationModalResponseDataModel.fromJson(value, appLocale);
                                      if (foodVariationModalResponse.action!) {
                                        context.read<PosManagementBloc>().add(PosManagementVariationModalResponseEvent(id: model.id!, data: foodVariationModalResponse, from: from, categoryIndex: categoryIndex));
                                      }
                                    }
                                  });
                                } else {
                                  context.read<PosManagementBloc>().add(PosManagementAddCartEvent(id: model.id!, from: from, categoryIndex: categoryIndex));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: Text(translate.add_lbl, style: kAppLblSmallFontBold(context, color: 'primary')),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (model.cartEntity == 'multiple') {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          enableDrag: false,
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(heightFactor: 0.4, child: FoodVariationModalRepeatScreen(id: model.id!, action: false));
                                          },
                                        ).then((value) {
                                          if (!context.mounted) return;
                                          if (value != null) {
                                            PosRepeatQuantityModalResponseModel repeatQuantityModalResponse = PosRepeatQuantityModalResponseModel.fromJson(value);
                                            if (repeatQuantityModalResponse.action == 'update') {
                                              context.read<PosManagementBloc>().add(PosManagementRepeatFoodOrderResponseEvent(id: model.id!, data: repeatQuantityModalResponse, from: from, categoryIndex: categoryIndex));
                                            }
                                          }
                                        });
                                      } else {
                                        context.read<PosManagementBloc>().add(PosManagementFoodQuantityDecreaseEvent(id: model.id!, from: from, categoryIndex: categoryIndex));
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15, left: 5),
                                      child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  Text('${model.quantity!}', style: kAppLblSmallFontBold(context, color: 'primary')),
                                  InkWell(
                                    onTap: () {
                                      if (model.addons!.isNotEmpty || model.variations!.isNotEmpty) {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          enableDrag: false,
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(heightFactor: 0.4, child: FoodVariationModalRepeatScreen(id: model.id!, action: true));
                                          },
                                        ).then((value) {
                                          if (!context.mounted) return;
                                          if (value != null) {
                                            PosRepeatQuantityModalResponseModel repeatQuantityModalResponse = PosRepeatQuantityModalResponseModel.fromJson(value);
                                            if (repeatQuantityModalResponse.action == 'update') {
                                              context.read<PosManagementBloc>().add(PosManagementRepeatFoodOrderResponseEvent(id: model.id!, data: repeatQuantityModalResponse, from: from, categoryIndex: categoryIndex));
                                            } else if (repeatQuantityModalResponse.action == 'new') {
                                              /////////////////////////////////////////
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                enableDrag: false,
                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                builder: (BuildContext context) {
                                                  return FractionallySizedBox(
                                                    heightFactor: 0.7,
                                                    child: FoodVariationsModalScreen(
                                                      id: model.id!,
                                                      name: model.name!,
                                                      image: model.image!,
                                                      options: jsonEncode({"addons": model.addons!, "variations": model.variations!}),
                                                      price: model.price!,
                                                      offerPrice: model.offerPrice!,
                                                      discount: model.discount!,
                                                      discountType: model.discountType!,
                                                      purchaseLimit: int.parse(model.purchaseLimit!.toString()),
                                                      stockNumber: int.parse(model.stockNumber!.toString()),
                                                      stockType: model.stockType!,
                                                    ),
                                                  );
                                                },
                                              ).then((value) {
                                                if (!context.mounted) return;
                                                if (value != null) {
                                                  PosFoodVariationModalResponseDataModel foodVariationModalResponse = PosFoodVariationModalResponseDataModel.fromJson(value, appLocale);
                                                  if (foodVariationModalResponse.action!) {
                                                    context.read<PosManagementBloc>().add(
                                                      PosManagementFoodVariationModalRepeatResponseEvent(id: model.id!, data: foodVariationModalResponse, from: from, categoryIndex: categoryIndex),
                                                    );
                                                  }
                                                }
                                              });
                                              /////////////////////////////////////////
                                            }
                                          }
                                        });
                                      } else {
                                        context.read<PosManagementBloc>().add(PosManagementFoodQuantityIncreaseEvent(id: model.id!, from: from, categoryIndex: categoryIndex));
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15, right: 5),
                                      child: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(height: 5),
                      model.addons!.isNotEmpty || model.variations!.isNotEmpty ? Text(translate.customisable, style: kAppLblTinyFontRegular(context)) : Text('', style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PosManagementLoadingView extends StatelessWidget {
  const PosManagementLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            SkeletonLine(
                              style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                            ),
                            const SizedBox(height: 5),
                            SkeletonLine(
                              style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                            ),
                            const SizedBox(height: 5),
                            SkeletonLine(
                              style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                                const SizedBox(width: 10),
                                SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SkeletonAvatar(style: SkeletonAvatarStyle(width: 80, height: 80, borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class PosManagementEmptyView extends StatelessWidget {
  const PosManagementEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
        child: Column(
          children: [
            kAppSpacerVertical(height: 20),
            Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
            kAppSpacerVertical(height: 20),
            Text(translate.no_food_found_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class PosManagementErrorView extends StatelessWidget {
  const PosManagementErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
      child: Center(
        child: Column(
          children: [
            kAppSpacerVertical(height: 20),
            Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
            kAppSpacerVertical(height: 20),
            Text(translate.no_food_found_error_two, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class PosManagementUnauthorizedView extends StatelessWidget {
  const PosManagementUnauthorizedView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
      child: Center(
        child: Column(
          children: [
            kAppSpacerVertical(height: 20),
            Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
            kAppSpacerVertical(height: 20),
            Text(translate.pos_permission_denied, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}
// DONE //