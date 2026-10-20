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
import 'package:vendor/app/core/models/pos_food_info_variation_modal_response_model.dart';
import 'package:vendor/app/core/models/pos_single_food_info_model.dart';
import 'package:vendor/app/presentation/pages/modals/food_info_modal/bloc/food_info_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class FoodInfoModalScreen extends StatelessWidget {
  final String id;
  final String data;
  const FoodInfoModalScreen({super.key, required this.id, required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodInfoModalBloc()..add(FoodInfoModalInitialEvent(id: id, data: data)),
      child: const FoodInfoModalView(),
    );
  }
}

class FoodInfoModalView extends StatelessWidget {
  const FoodInfoModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodInfoModalBloc, FoodInfoModalState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSaveClose) {
          Navigator.of(context).pop({"action": true, "isFavourite": state.info.isFavourite, "quantity": state.info.quantity, "cartItem": state.cartItem.toJson(), 'instruction': state.instruction});
        }
      },
      builder: (context, state) {
        return state.status.isLoading
            ? const FoodInfoModalLoadingView()
            : state.status.isFailure
            ? const FoodInfoModalErrorView()
            : FoodInfoModalResponseView(model: state.info, savedInCart: state.cartItem, originalPrice: state.originalPrice, discountPrice: state.discountPrice);
      },
    );
  }
}

class FoodInfoModalLoadingView extends StatelessWidget {
  const FoodInfoModalLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, scrolledUnderElevation: 0),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 120, width: double.infinity, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 20),
              SkeletonLine(
                style: SkeletonLineStyle(height: 16, width: double.infinity, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8))),
                  SkeletonLine(style: SkeletonLineStyle(height: 16, width: 64, borderRadius: BorderRadius.circular(8))),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: List.generate(
                  10,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: SkeletonLine(
                      style: SkeletonLineStyle(height: 120, width: double.infinity, borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodInfoModalErrorView extends StatelessWidget {
  const FoodInfoModalErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, scrolledUnderElevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
          child: Center(
            child: Column(
              children: [
                kAppSpacerVertical(height: 20),
                Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
                kAppSpacerVertical(height: 20),
                Text(translate.unexpected_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
                kAppSpacerVertical(height: 30),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: kAppTextButtonColoredStyle(context, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor),
                  child: Text(translate.understand_btn_go_back),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoodInfoModalResponseView extends StatelessWidget {
  final PosSingleFoodInfoModel model;
  final PosFoodInfoVariationModalResponseModel savedInCart;
  final double originalPrice;
  final double discountPrice;
  const FoodInfoModalResponseView({super.key, required this.model, required this.savedInCart, required this.originalPrice, required this.discountPrice});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    var top = 0.0;
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            pinned: true,
            snap: false,
            floating: true,
            elevation: 0,
            centerTitle: false,
            expandedHeight: 120.0,
            iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop({"action": false, "isFavourite": model.isFavourite, "quantity": model.quantity, "cartItem": savedInCart.toJson()}),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ThemeProvider.whiteColor),
                child: Icon(Icons.arrow_back, size: Theme.of(context).textTheme.labelLarge?.fontSize, color: ThemeProvider.primaryColor),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (ctx, cons) {
                top = cons.biggest.height;
                return FlexibleSpaceBar(
                  centerTitle: false,
                  title: top <= 56
                      ? AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(microseconds: 200),
                          child: Text(kAppTrimWord(model.name!, 40), style: Theme.of(context).appBarTheme.titleTextStyle),
                        )
                      : const SizedBox.shrink(),
                  background: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 120.0, imageUrl: model.image!),
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          model.foodType! != 'none' ? Row(children: [kAppFoodType(model.foodType!), kAppSpacerHorizontal(width: 5)]) : const SizedBox(),
                        ],
                      ),
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
                      model.discount! > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kAppSpacerVertical(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(color: ThemeProvider.darkBackgroundColor, borderRadius: BorderRadius.circular(10.0)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(AssetsUrl.imageURL.offerTag, height: 10, width: 10),
                                      kAppSpacerHorizontal(width: 5),
                                      Text(
                                        model.discountType == '%' ? '${translate.flat} ${model.discount}% ${translate.off}' : '${translate.flat} ${kAppPriceFormat(model.discount!)} ${translate.off}',
                                        style: kAppLblTinyBoldOffer(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      kAppSpacerVertical(height: 5),
                      Text(model.shortDescription!, style: kAppLblTinyFontRegular(context)),
                      kAppSpacerVertical(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          model.variations!.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                    model.variations!.length,
                                    (vIndex) => Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(kAppTrimWord(model.variations![vIndex].title!, 20), style: kAppLblMediumFontBold(context)),
                                                    kAppSpacerVertical(height: 5),
                                                    model.variations![vIndex].type == 'single'
                                                        ? Text(translate.select_any_one_option, style: kAppLblTinyFontRegular(context))
                                                        : Text('${translate.select_min} ${model.variations![vIndex].min} ${translate.and_upto} ${model.variations![vIndex].max}', style: kAppLblTinyFontRegular(context)),
                                                  ],
                                                ),
                                                model.variations![vIndex].isRequired!
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                        child: Text(translate.form_required, style: kAppLblTinyFontRegular(context)),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                          Divider(thickness: 0.5, color: ThemeProvider.lightDisabledColor, height: 5),
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: List.generate(
                                                model.variations![vIndex].options!.length,
                                                (oIndex) => InkWell(
                                                  onTap: () => context.read<FoodInfoModalBloc>().add(FoodInfoModalVariationOptionEvent(vIndex: vIndex, oIndex: oIndex, type: model.variations![vIndex].type!)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(model.variations![vIndex].options![oIndex].name!, style: kAppLblTinyFontBold(context)),
                                                            model.variations![vIndex].options![oIndex].limitCrossed!
                                                                ? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      kAppSpacerHorizontal(width: 5),
                                                                      Text(
                                                                        '(${translate.only} ${model.variations![vIndex].options![oIndex].stock!} ${translate.item_available})',
                                                                        style: kAppLblTinyFontRegularChip(context, color: 'primary'),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : const SizedBox(),
                                                            !model.variations![vIndex].options![oIndex].inStock!
                                                                ? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      kAppSpacerHorizontal(width: 5),
                                                                      Text('(${translate.out_of_stock})', style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                                                    ],
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            !model.variations![vIndex].options![oIndex].haveDiscount!
                                                                ? Text('+ ${kAppPriceFormat(model.variations![vIndex].options![oIndex].price!)}', style: kAppLblTinyFontBold(context))
                                                                : Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(kAppPriceFormat(model.variations![vIndex].options![oIndex].price!), style: kAppLblTinyStrokeRegular(context)),
                                                                      kAppSpacerHorizontal(width: 5),
                                                                      Text('+ ${kAppPriceFormat(model.variations![vIndex].options![oIndex].discountPrice!)}', style: kAppLblTinyFontBold(context)),
                                                                    ],
                                                                  ),
                                                            kAppSpacerHorizontal(width: 5),
                                                            model.variations![vIndex].type == 'single'
                                                                ? Icon(
                                                                    model.variations![vIndex].options![oIndex].checked! ? Icons.radio_button_checked_rounded : Icons.radio_button_off,
                                                                    size: 16,
                                                                    color: Theme.of(context).primaryColor,
                                                                  )
                                                                : Icon(
                                                                    model.variations![vIndex].options![oIndex].checked!
                                                                        ? Icons.check_box_rounded
                                                                        : model.variations![vIndex].options![oIndex].enable!
                                                                        ? Icons.check_box_outline_blank_rounded
                                                                        : Icons.indeterminate_check_box_outlined,
                                                                    size: 16,
                                                                    color: Theme.of(context).primaryColor,
                                                                  ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          model.addons!.isNotEmpty
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(translate.addon, style: kAppLblMediumFontBold(context)),
                                                kAppSpacerVertical(height: 5),
                                                Text(translate.select_addon, style: kAppLblTinyFontRegular(context)),
                                              ],
                                            ),
                                            const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Divider(thickness: 0.5, color: ThemeProvider.lightDisabledColor, height: 5),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: List.generate(
                                            model.addons!.length,
                                            (aIndex) => InkWell(
                                              onTap: () => context.read<FoodInfoModalBloc>().add(FoodInfoModalAddonsEvent(index: aIndex)),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(model.addons![aIndex].name!, style: kAppLblTinyFontBold(context)),
                                                        model.addons![aIndex].limitCrossed!
                                                            ? Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  kAppSpacerHorizontal(width: 5),
                                                                  Text('(${translate.only} ${model.addons![aIndex].stockNumber!} ${translate.item_available})', style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                                                ],
                                                              )
                                                            : const SizedBox(),
                                                        !model.addons![aIndex].inStock!
                                                            ? Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  kAppSpacerHorizontal(width: 5),
                                                                  Text('(${translate.out_of_stock})', style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                                                ],
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        !model.addons![aIndex].haveDiscount!
                                                            ? Text('+ ${kAppPriceFormat(model.addons![aIndex].price!)}', style: kAppLblTinyFontBold(context))
                                                            : Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Text(kAppPriceFormat(model.addons![aIndex].price!), style: kAppLblTinyStrokeRegular(context)),
                                                                  kAppSpacerHorizontal(width: 5),
                                                                  Text('+ ${kAppPriceFormat(model.addons![aIndex].discountPrice!)}', style: kAppLblTinyFontBold(context)),
                                                                ],
                                                              ),
                                                        kAppSpacerHorizontal(width: 5),
                                                        Icon(model.addons![aIndex].checked! ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, size: 16, color: Theme.of(context).primaryColor),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      kAppSpacerVertical(height: 30),
                      TextField(
                        maxLines: 3,
                        maxLength: 100,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        decoration: kAppInputDecoration(context, lblText: translate.form_cooking_instructions, errText: null),
                        style: kAppLblSmallFontMedium(context),
                        onChanged: (value) => context.read<FoodInfoModalBloc>().add(FoodInfoModalInstructionChangeEvent(instruction: value)),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.total_amount, style: kAppLblMediumFontBold(context)),
                    discountPrice > 0 && model.discount! > 0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(kAppPriceFormat(originalPrice), style: kAppLblTinyStrokeRegular(context)),
                              kAppSpacerHorizontal(width: 5),
                              Text('+ ${kAppPriceFormat(discountPrice)}', style: kAppLblTinyFontBold(context)),
                            ],
                          )
                        : Text('+ ${kAppPriceFormat(originalPrice)}', style: kAppLblTinyFontBold(context)),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            onTap: () => context.read<FoodInfoModalBloc>().add(FoodInfoModalQuantityEvent(action: 'decrease')),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15, left: 5),
                              child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Text('${model.quantity}', style: kAppLblSmallFontBold(context, color: 'primary')),
                          InkWell(
                            onTap: () => context.read<FoodInfoModalBloc>().add(FoodInfoModalQuantityEvent(action: 'increase')),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, right: 5),
                              child: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox(width: double.infinity)),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () => context.read<FoodInfoModalBloc>().add(FoodInfoModalSaveEvent()),
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(translate.add_to_cart, style: kAppLblSmallFontBoldCart(context))],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// DONE //