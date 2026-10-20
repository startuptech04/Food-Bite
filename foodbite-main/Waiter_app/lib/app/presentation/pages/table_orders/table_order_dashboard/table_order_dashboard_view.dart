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
import 'package:waiter/app/core/config/assets_url.dart';
import 'package:waiter/app/core/models/pos_food_info_modal_response_model.dart';
import 'package:waiter/app/core/models/pos_food_variations_response_data_modal_model.dart';
import 'package:waiter/app/core/models/pos_order_model.dart';
import 'package:waiter/app/core/models/pos_repeat_quantity_modal_response_model.dart';
import 'package:waiter/app/presentation/pages/modals/food_info_modal/food_info_modal_view.dart';
import 'package:waiter/app/presentation/pages/modals/food_variations_modal/@core/food_variations_modal_view.dart';
import 'package:waiter/app/presentation/pages/modals/food_variations_modal/repeat/food_variation_modal_repeat_view.dart';
import 'package:waiter/app/presentation/pages/modals/pos_menu_modal/pos_menu_modal_view.dart';
import 'package:waiter/app/presentation/pages/table_orders/table_order_confirm_items/bloc/table_order_confirm_item_bloc.dart';
import 'package:waiter/app/presentation/pages/table_orders/table_order_dashboard/bloc/table_order_dashboard_bloc.dart';
import 'package:waiter/app/presentation/pages/table_orders/table_order_search_food/bloc/table_order_search_food_bloc.dart';
import 'package:waiter/app/presentation/styles/app_style.dart';
import 'package:waiter/app/presentation/styles/error_dialog.dart';
import 'package:waiter/app/presentation/styles/theme.dart';
import 'package:waiter/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:waiter/app/router/app_route_config.dart';
import 'package:waiter/gen/l10n/app_localizations.dart';

class TableOrderDashboardScreen extends StatelessWidget {
  final int tableNumber;
  final String tableId;
  const TableOrderDashboardScreen({super.key, required this.tableNumber, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TableOrderConfirmItemBloc, TableOrderConfirmItemState>(
          listener: (context, state) {
            if (state.status.isCartUpdate || state.status.isCartError || state.status.isOrderPlaced) {
              context.read<TableOrderDashboardBloc>().add(TableOrderDashboardRefreshCartDataEvent());
            }
          },
        ),
        BlocListener<TableOrderSearchFoodBloc, TableOrderSearchFoodState>(
          listener: (context, state) {
            if (state.status.isInitialCartUpdate || state.status.isInitialCartError || state.status.isSearchCartUpdate || state.status.isSearchCartError || state.status.isCartError) {
              context.read<TableOrderDashboardBloc>().add(TableOrderDashboardRefreshCartDataEvent());
            }
          },
        ),
      ],
      child: TableOrderDashboardView(tableNumber: tableNumber, tableId: tableId),
    );
  }
}

class TableOrderDashboardView extends StatefulWidget {
  final int tableNumber;
  final String tableId;
  const TableOrderDashboardView({super.key, required this.tableNumber, required this.tableId});

  @override
  State<TableOrderDashboardView> createState() => _TableOrderDashboardViewState();
}

class _TableOrderDashboardViewState extends State<TableOrderDashboardView> {
  final ScrollController _scrollControllerMain = ScrollController();
  final ScrollController _scrollControllerCategories = ScrollController();
  final Map<String, GlobalKey> _globalBottomCategoriesKey = {};

  void scrollBottomCategory(String categoryKey, String realId) {
    final keyContext = _globalBottomCategoriesKey[categoryKey]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(keyContext, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  void onScrollToPosition(String id, String realId) {
    final keyContext = context.read<TableOrderDashboardBloc>().state.globalMainCategoriesKey[id]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(keyContext, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<TableOrderDashboardBloc>().add(TableOrderDashboardInitialEvent(tableNumber: widget.tableNumber, tableId: widget.tableId));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<TableOrderDashboardBloc, TableOrderDashboardState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError || state.status.isCartError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text("${translate.dine_in_order} #${widget.tableNumber}"),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.tableOngoingOrderItemRoute, arguments: [state.tableNumber, state.tableId]),
                icon: const Icon(Icons.format_list_numbered_outlined),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(AppRouter.tableOrderSearchFoodRoute, arguments: [state.tableNumber, state.tableId]),
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
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: _scrollControllerMain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const TableOrderDashboardLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const TableOrderDashboardErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const TableOrderDashboardEmptyView(),
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
                              onTap: () => context.read<TableOrderDashboardBloc>().add(TableOrderDashboardToggleCustomCategoryViewEvent(categoryIndex: categoryIndex)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${state.model.custom![categoryIndex].categoryName!} (${state.model.custom![categoryIndex].foods!.length})", style: kAppLblSemiBoldFontLarge(context)),
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
                                      (foodIndex) => FoodBlockView(model: state.model.custom![categoryIndex].foods![foodIndex], from: 'custom', categoryIndex: categoryIndex, tableId: state.tableId, appLocale: state.appLocale),
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
                              onTap: () => context.read<TableOrderDashboardBloc>().add(TableOrderDashboardToggleMainCategoryViewEvent(categoryIndex: categoryIndex)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${state.model.main![categoryIndex].categoryName!} (${state.model.main![categoryIndex].foods!.length})", style: kAppLblSemiBoldFontLarge(context)),
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
                                      (foodIndex) => FoodBlockView(model: state.model.main![categoryIndex].foods![foodIndex], from: 'main', categoryIndex: categoryIndex, tableId: state.tableId, appLocale: state.appLocale),
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
          bottomNavigationBar: state.category.isNotEmpty
              ? SafeArea(
                  child: SizedBox(
                    height: state.cartTotalItem >= 1 ? 100 : 50,
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
                                            context.read<TableOrderDashboardBloc>().add(TableOrderDashboardScrollToCategoryEvent(categoryId: state.category[categoryIndex].id!));
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
                                        context.read<TableOrderDashboardBloc>().add(TableOrderDashboardScrollToCategoryEvent(categoryId: value.toString()));
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
                                        Text(translate.menu, style: TextStyle(color: ThemeProvider.whiteColor, fontSize: 12)),
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
                                onTap: () => Navigator.of(context).pushNamed(AppRouter.tableOrderConfirmItemRoute, arguments: [state.tableNumber, state.tableId]),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("${state.cartTotalItem} ${state.cartTotalItem == 1 ? translate.item : translate.items} ${translate.added}", style: kAppLblTinyFontBoldCart(context)),
                                      Text(translate.place_order, style: kAppLblTinyFontBoldCart(context)),
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
        );
      },
    );
  }
}

class FoodBlockView extends StatelessWidget {
  final FoodListModel model;
  final String from;
  final int categoryIndex;
  final String tableId;
  final String appLocale;
  const FoodBlockView({super.key, required this.model, required this.from, required this.categoryIndex, required this.tableId, required this.appLocale});

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
                    PosFoodInfoModalResponseModel foodInfoModalResponse = PosFoodInfoModalResponseModel.fromJson(value, appLocale.toString());
                    context.read<TableOrderDashboardBloc>().add(TableOrderDashboardFoodModalResponseEvent(id: model.id!, from: from, categoryIndex: categoryIndex, response: foodInfoModalResponse));
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
                        PosFoodInfoModalResponseModel foodInfoModalResponse = PosFoodInfoModalResponseModel.fromJson(value, appLocale.toString());
                        context.read<TableOrderDashboardBloc>().add(TableOrderDashboardFoodModalResponseEvent(id: model.id!, from: from, categoryIndex: categoryIndex, response: foodInfoModalResponse));
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
                                      PosFoodVariationModalResponseDataModel foodVariationModalResponse = PosFoodVariationModalResponseDataModel.fromJson(value, appLocale.toString());
                                      if (foodVariationModalResponse.action!) {
                                        context.read<TableOrderDashboardBloc>().add(TableOrderDashboardVariationModalResponseEvent(id: model.id!, data: foodVariationModalResponse, from: from, categoryIndex: categoryIndex));
                                      }
                                    }
                                  });
                                } else {
                                  context.read<TableOrderDashboardBloc>().add(TableOrderDashboardAddCartEvent(id: model.id!, from: from, categoryIndex: categoryIndex));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: Text(translate.add, style: kAppLblSmallFontBold(context, color: 'primary')),
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
                                            return FractionallySizedBox(
                                              heightFactor: 0.4,
                                              child: FoodVariationModalRepeatScreen(id: model.id!, action: false, tableId: tableId),
                                            );
                                          },
                                        ).then((value) {
                                          if (!context.mounted) return;
                                          if (value != null) {
                                            PosRepeatQuantityModalResponseModel repeatQuantityModalResponse = PosRepeatQuantityModalResponseModel.fromJson(value);
                                            if (repeatQuantityModalResponse.action == 'update') {
                                              context.read<TableOrderDashboardBloc>().add(
                                                TableOrderDashboardRepeatFoodOrderResponseEvent(id: model.id!, data: repeatQuantityModalResponse, from: from, categoryIndex: categoryIndex),
                                              );
                                            }
                                          }
                                        });
                                      } else {
                                        context.read<TableOrderDashboardBloc>().add(TableOrderDashboardFoodQuantityDecreaseEvent(id: model.id!, from: from, categoryIndex: categoryIndex));
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15, left: 5),
                                      child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  Text("${model.quantity!}", style: kAppLblSmallFontBold(context, color: 'primary')),
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
                                            return FractionallySizedBox(
                                              heightFactor: 0.4,
                                              child: FoodVariationModalRepeatScreen(id: model.id!, action: true, tableId: tableId),
                                            );
                                          },
                                        ).then((value) {
                                          if (!context.mounted) return;
                                          if (value != null) {
                                            PosRepeatQuantityModalResponseModel repeatQuantityModalResponse = PosRepeatQuantityModalResponseModel.fromJson(value);
                                            if (repeatQuantityModalResponse.action == 'update') {
                                              context.read<TableOrderDashboardBloc>().add(
                                                TableOrderDashboardRepeatFoodOrderResponseEvent(id: model.id!, data: repeatQuantityModalResponse, from: from, categoryIndex: categoryIndex),
                                              );
                                            } else if (repeatQuantityModalResponse.action == 'new') {
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
                                                  PosFoodVariationModalResponseDataModel foodVariationModalResponse = PosFoodVariationModalResponseDataModel.fromJson(value, appLocale.toString());
                                                  if (foodVariationModalResponse.action!) {
                                                    context.read<TableOrderDashboardBloc>().add(
                                                      TableOrderDashboardFoodVariationModalRepeatResponseEvent(id: model.id!, data: foodVariationModalResponse, from: from, categoryIndex: categoryIndex),
                                                    );
                                                  }
                                                }
                                              });
                                            }
                                          }
                                        });
                                      } else {
                                        context.read<TableOrderDashboardBloc>().add(TableOrderDashboardFoodQuantityIncreaseEvent(id: model.id!, from: from, categoryIndex: categoryIndex));
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
                      model.addons!.isNotEmpty || model.variations!.isNotEmpty ? Text(translate.customisable, style: kAppLblTinyFontRegular(context)) : Text("", style: kAppLblTinyFontRegular(context)),
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

class TableOrderDashboardLoadingView extends StatelessWidget {
  const TableOrderDashboardLoadingView({super.key});

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

class TableOrderDashboardErrorView extends StatelessWidget {
  const TableOrderDashboardErrorView({super.key});

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
            Text(translate.no_food_found_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class TableOrderDashboardEmptyView extends StatelessWidget {
  const TableOrderDashboardEmptyView({super.key});

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
// DONE //