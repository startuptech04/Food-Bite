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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/tiffin_subscription_package_list_response_model.dart';
import 'package:vendor/app/presentation/pages/account/tiffin_subscription/@core/bloc/tiffin_subscription_list_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TiffinSubscriptionListScreen extends StatelessWidget {
  const TiffinSubscriptionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TiffinSubscriptionListBloc()..add(TiffinSubscriptionListInitialEvent()), child: const TiffinSubscriptionListView());
  }
}

class TiffinSubscriptionListView extends StatefulWidget {
  const TiffinSubscriptionListView({super.key});

  @override
  State<TiffinSubscriptionListView> createState() => _TiffinSubscriptionListViewState();
}

class _TiffinSubscriptionListViewState extends State<TiffinSubscriptionListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<TiffinSubscriptionListBloc>().add(TiffinSubscriptionListLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    return BlocConsumer<TiffinSubscriptionListBloc, TiffinSubscriptionListState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.package_list), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const TiffinSubscriptionListLoadingView(),
                ] else if (state.status.isEmpty) ...[
                  const TiffinSubscriptionListEmptyView(),
                ] else if (state.status.isFailure) ...[
                  const TiffinSubscriptionListErrorView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.results!.length,
                      (index) => Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Theme.of(context).disabledColor, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 200.0, imageUrl: state.model.results![index].image!),
                            ),
                            kAppSpacerVertical(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Text(
                                state.model.results![index].name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kAppLblMediumFontBold(context, color: 'regular'),
                              ),
                            ),
                            kAppSpacerVertical(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.model.results![index].orderTo! == 'homedelivery' ? translate.home_delivery : translate.self_pickup, style: kAppLblTinyFontRegular(context)),
                                    // Text(" | ", style: kAppLblTinyFontRegular(context)),
                                    Text(kAppTiffinKind(context, state.model.results![index].available!), style: kAppLblTinyFontRegular(context)),
                                    // Text(" | ", style: kAppLblTinyFontRegular(context)),
                                    Text("${kAppTiffinSubscriptionTime(state.model.results![index].interval!)} ${translate.days}", style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${translate.form_price} : ${kAppPriceFormat(state.model.results![index].price!)}", style: kAppLblTinyFontRegular(context)),
                                    // Text(" | ", style: kAppLblTinyFontRegular(context)),
                                    Text(
                                      '${translate.discount} : ${state.model.results![index].discountType! == '%' ? '${state.model.results![index].discount}%' : kAppPriceFormat(state.model.results![index].discount!)}',
                                      style: kAppLblTinyFontRegular(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            kAppSpacerVertical(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${translate.total_food} : ${state.model.results![index].foods!.length}", style: kAppLblTinyFontRegular(context)),
                                Text("${translate.total_purchase} : ${state.model.results![index].totalPurchase!}", style: kAppLblTinyFontRegular(context)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                state.model.results![index].status! == 'live' || state.model.results![index].status == 'hide'
                                    ? Row(
                                        children: [
                                          Text(translate.hide_lbl, style: kAppLblTinyFontRegular(context)),
                                          Transform.scale(
                                            scale: 0.5,
                                            child: Switch(
                                              value: state.model.results![index].status! == 'live' ? true : false,
                                              thumbIcon: thumbIcon,
                                              activeThumbColor: Theme.of(context).primaryColor,
                                              onChanged: (bool value) {
                                                if (state.model.results![index].status! == 'live') {
                                                  showConfirmDialog(
                                                    context,
                                                    translate.alert_confirm_title,
                                                    '${translate.hide_confirm_title} ${state.model.results![index].name!}',
                                                    translate.cancel_lbl,
                                                    translate.yes_hide_btn,
                                                  ).then((value) {
                                                    if (!context.mounted) return;
                                                    if (value) {
                                                      context.read<TiffinSubscriptionListBloc>().add(TiffinSubscriptionListUpdateStatusEvent(index: index));
                                                    }
                                                  });
                                                } else {
                                                  context.read<TiffinSubscriptionListBloc>().add(TiffinSubscriptionListUpdateStatusEvent(index: index));
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(translate.on_hold, style: kAppLblTinyFontRegular(context)),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(AppRouter.manageTiffinSubscriptionRoute, arguments: [false, state.model.results![index]]).then((value) {
                                      if (!context.mounted) return;
                                      if (value != null && value.toString().isNotEmpty) {
                                        context.read<TiffinSubscriptionListBloc>().add(TiffinSubscriptionListInitialEvent());
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(translate.edit_lbl, style: kAppLblTinyFontRegular(context)),
                                      kAppSpacerHorizontal(width: 10),
                                      FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showConfirmDialog(context, translate.alert_confirm_title, "${translate.confirm_delete_alert} ${state.model.results![index].name!}", translate.cancel_lbl, translate.yes_hide_btn).then((value) {
                                      if (!context.mounted) return;
                                      if (value) {
                                        context.read<TiffinSubscriptionListBloc>().add(TiffinSubscriptionListDeleteEvent(index: index));
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(translate.delete_lbl, style: kAppLblTinyFontRegular(context)),
                                      kAppSpacerHorizontal(width: 10),
                                      FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed(AppRouter.tiffinSubscriptionPurchaserHistoryRoute, arguments: [state.model.results![index].id!]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(translate.purchaser, style: kAppLblTinyFontRegular(context)),
                                      kAppSpacerHorizontal(width: 10),
                                      FaIcon(FontAwesomeIcons.fileLines, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  kAppSpacerVertical(height: 20),
                  state.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  kAppSpacerVertical(height: 20),
                ],
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            height: 30,
            child: FloatingActionButton.extended(
              heroTag: 'addTiffinSubscriptionPackageFab',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(
                      AppRouter.manageTiffinSubscriptionRoute,
                      arguments: [
                        true,
                        TiffinSubcriptionPackageConfigModel(locale: state.appLocale),
                      ],
                    )
                    .then((value) {
                      if (!context.mounted) return;
                      if (value != null && value.toString().isNotEmpty) {
                        context.read<TiffinSubscriptionListBloc>().add(TiffinSubscriptionListInitialEvent());
                      }
                    });
              },
              label: Text(translate.add_package),
              icon: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}

class TiffinSubscriptionListLoadingView extends StatelessWidget {
  const TiffinSubscriptionListLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonListTile(
                hasSubtitle: true,
                padding: const EdgeInsets.all(0),
                leadingStyle: const SkeletonAvatarStyle(width: 25, height: 25),
                titleStyle: SkeletonLineStyle(height: 10, randomLength: false, borderRadius: BorderRadius.circular(16)),
                subtitleStyle: SkeletonLineStyle(height: 10, randomLength: true, borderRadius: BorderRadius.circular(16)),
              ),
              kAppSpacerVertical(height: 20),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  spacing: 6,
                  padding: const EdgeInsets.all(0),
                  lineStyle: SkeletonLineStyle(height: 10, randomLength: false, borderRadius: BorderRadius.circular(16)),
                ),
              ),
              kAppSpacerVertical(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 3.5, borderRadius: BorderRadius.circular(8)),
                  ),
                  SkeletonLine(
                    style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 3.5, borderRadius: BorderRadius.circular(8)),
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

class TiffinSubscriptionListEmptyView extends StatelessWidget {
  const TiffinSubscriptionListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_tiffin_package_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_tiffin_package_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class TiffinSubscriptionListErrorView extends StatelessWidget {
  const TiffinSubscriptionListErrorView({super.key});

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
// DONE //