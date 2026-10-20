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
import 'package:vendor/app/core/models/dining_coupon_list_response_model.dart';
import 'package:vendor/app/presentation/pages/account/coupons/dining_coupon/@core/bloc/dining_coupon_list_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DiningCouponListScreen extends StatelessWidget {
  const DiningCouponListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DiningCouponListBloc()..add(DiningCouponListInitialEvent()), child: const DiningCouponListView());
  }
}

class DiningCouponListView extends StatefulWidget {
  const DiningCouponListView({super.key});

  @override
  State<DiningCouponListView> createState() => _DiningCouponListViewState();
}

class _DiningCouponListViewState extends State<DiningCouponListView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<DiningCouponListBloc>().add(DiningCouponListLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });
    return BlocConsumer<DiningCouponListBloc, DiningCouponListState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isLoadingHideStart) {
          LoaderService.showLoader(context, msg: translate.please_waiter);
        } else if (state.status.isLoadingHideFailed) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode).then((value) {});
        } else if (state.status.isLoadingHideSuccess) {
          LoaderService.hideLoder(context);
        } else if (state.status.isLoadingDeleteStart) {
          LoaderService.showLoader(context, msg: translate.please_waiter);
        } else if (state.status.isLoadingDeleteFailed) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode).then((value) {});
        } else if (state.status.isLoadingDeleteSuccess) {
          LoaderService.hideLoder(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: SizedBox(
            height: 30,
            child: FloatingActionButton.extended(
              heroTag: 'addDiningCouponFab',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(
                      AppRouter.manageDiningCouponRoute,
                      arguments: [
                        true,
                        DiningCouponInfoConfigModel(locale: state.appLocale),
                      ],
                    )
                    .then((value) {
                      if (!context.mounted) return;
                      if (value != null && value.toString().isNotEmpty) {
                        context.read<DiningCouponListBloc>().add(DiningCouponListInitialEvent());
                      }
                    });
              },
              label: Text(translate.add_coupon),
              icon: const Icon(Icons.add),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const DiningCouponListLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const DiningCouponListErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const DiningCouponListEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.coupons!.length,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(state.model.coupons![index].code!, style: kAppLblMediumFontBold(context, color: 'regular')),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(state.model.coupons![index].start!, style: kAppLblTinyFontBold(context)),
                                    Text(" - ", style: kAppLblTinyFontBold(context)),
                                    Text(state.model.coupons![index].expires!, style: kAppLblTinyFontBold(context)),
                                  ],
                                ),
                              ],
                            ),
                            kAppSpacerVertical(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                state.model.coupons![index].name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kAppLblMediumFontRegular(context, color: 'regular'),
                              ),
                            ),
                            kAppSpacerVertical(height: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${translate.availability} : ${state.model.coupons![index].availability!.toUpperCase()}", style: kAppLblTinyFontRegular(context)),
                                kAppSpacerHorizontal(width: 10),
                                state.model.coupons![index].preBookingChargeAmount! > 0
                                    ? Text("${translate.pre_booking_charge} : ${kAppPriceFormat(state.model.coupons![index].preBookingChargeAmount!)}", style: kAppLblTinyFontRegular(context))
                                    : const SizedBox(),
                              ],
                            ),
                            kAppSpacerVertical(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                state.model.coupons![index].status! == 'requested'
                                    ? Text(translate.coupon_requested, style: kAppLblTinyFontRegular(context))
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(translate.hide_lbl, style: kAppLblTinyFontRegular(context)),
                                          Transform.scale(
                                            scale: 0.5,
                                            child: Switch(
                                              value: state.model.coupons![index].status! == 'live' ? true : false,
                                              thumbIcon: thumbIcon,
                                              activeThumbColor: Theme.of(context).primaryColor,
                                              onChanged: (bool value) {
                                                if (state.model.coupons![index].status! == 'live') {
                                                  showConfirmDialog(
                                                    context,
                                                    translate.alert_confirm_title,
                                                    "${translate.hide_confirm_title} ${state.model.coupons![index].name!}",
                                                    translate.cancel_lbl,
                                                    translate.yes_hide_btn,
                                                  ).then((value) {
                                                    if (!context.mounted) return;
                                                    if (value) {
                                                      context.read<DiningCouponListBloc>().add(DiningCouponListChangeStatusEvent(index: index));
                                                    }
                                                  });
                                                } else {
                                                  context.read<DiningCouponListBloc>().add(DiningCouponListChangeStatusEvent(index: index));
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(AppRouter.manageDiningCouponRoute, arguments: [false, state.model.coupons![index]]).then((value) {
                                      if (!context.mounted) return;
                                      if (value != null && value.toString().isNotEmpty) {
                                        context.read<DiningCouponListBloc>().add(DiningCouponListInitialEvent());
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
                                    showConfirmDialog(context, translate.alert_confirm_title, "${translate.confirm_delete_alert} ${state.model.coupons![index].name!}", translate.cancel_lbl, translate.yes_hide_btn).then((value) {
                                      if (value) {
                                        if (!context.mounted) return;
                                        context.read<DiningCouponListBloc>().add(DiningCouponListDeleteEvent(index: index));
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
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DiningCouponListLoadingView extends StatelessWidget {
  const DiningCouponListLoadingView({super.key});

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

class DiningCouponListErrorView extends StatelessWidget {
  const DiningCouponListErrorView({super.key});

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

class DiningCouponListEmptyView extends StatelessWidget {
  const DiningCouponListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_coupon_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_coupon_found_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //