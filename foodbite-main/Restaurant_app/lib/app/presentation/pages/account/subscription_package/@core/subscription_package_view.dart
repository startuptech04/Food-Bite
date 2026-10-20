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
import 'package:vendor/app/core/models/subscription_package_info_model.dart';
import 'package:vendor/app/presentation/pages/account/subscription_package/@core/bloc/subscription_package_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/payment_modal/payment_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class SubscriptionPackageScreen extends StatelessWidget {
  const SubscriptionPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SubscriptionPackageBloc()..add(SubscriptionPackageInitialEvent()), child: const SubscriptionPackageView());
  }
}

class SubscriptionPackageView extends StatelessWidget {
  const SubscriptionPackageView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<SubscriptionPackageBloc, SubscriptionPackageState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isPaymentLinkFetched) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.subscriptionPackagePaymentRoute, (Route<dynamic> route) => false, arguments: [state.paymentLinkId]);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isFetchingPaymentLink ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.your_subscription_package), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const SubscriptionPackageLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const SubscriptionPackageErrorView(),
                  ] else ...[
                    Text(state.model.info!.subscriptionInfo!.name!, style: kAppLblLargeFontBold(context)),
                    kAppSpacerVertical(height: 5),
                    Text(state.model.info!.subscriptionInfo!.shortDescriptions!, style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 5),
                    Text('${translate.current_subscription_will_expire} ${state.model.info!.trialEndDate!.isNotEmpty ? state.model.info!.trialEndDate : state.model.info!.endDate!}', style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 20),
                    SubscriptionDetailWidget(model: state.model.info!.subscriptionInfo!),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure || !state.model.expireSoon!
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: SizedBox(
                      height: 65,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    useSafeArea: true,
                                    enableDrag: false,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return FractionallySizedBox(
                                        child: PaymentModalScreen(
                                          payTotal: state.model.info!.subscriptionInfo!.discount! <= 0 ? state.model.info!.subscriptionInfo!.price! : state.model.info!.subscriptionInfo!.offerPrice!,
                                          paymentList: jsonEncode(state.model.payments!).toString(),
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    if (!context.mounted) return;
                                    if (value != null && value != '') {
                                      context.read<SubscriptionPackageBloc>().add(SubscriptionPackagePaymentChangedEvent(id: value));
                                    }
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: CacheNetworkImageWidget(width: 20, height: 10.0, imageUrl: state.paymentImageURL),
                                        ),
                                        kAppSpacerHorizontal(width: 5),
                                        Text(translate.pay_using, style: kAppLblTinyFontRegular(context)),
                                        kAppSpacerHorizontal(width: 5),
                                        Icon(Icons.arrow_drop_up_outlined, color: Theme.of(context).colorScheme.tertiary, size: 14),
                                      ],
                                    ),
                                    kAppSpacerVertical(height: 5),
                                    Text(state.paymentName, style: kAppLblMediumFontRegular(context)),
                                  ],
                                ),
                              ),
                            ),
                            const Expanded(flex: 1, child: SizedBox(width: double.infinity)),
                            Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () => context.read<SubscriptionPackageBloc>().add(SubscriptionPackageMakePaymentEvent()),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5)),
                                  child: state.status.isFetchingPaymentLink
                                      ? Center(child: kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0))
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.model.info!.subscriptionInfo!.discount! <= 0 ? kAppPriceFormat(state.model.info!.subscriptionInfo!.price!) : kAppPriceFormat(state.model.info!.subscriptionInfo!.offerPrice!),
                                                  style: kAppLblMediumFontSemiBoldWhite(context),
                                                ),
                                                kAppSpacerVertical(height: 3),
                                                Text(translate.total, style: kAppLblTinyFontBoldCart(context)),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(translate.renew_now, style: kAppLblMediumFontSemiBoldWhite(context)),
                                                Icon(Icons.arrow_right, color: Theme.of(context).scaffoldBackgroundColor, size: 14),
                                              ],
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class SubscriptionDetailWidget extends StatelessWidget {
  final SubscriptionPackageDetailConfigModel model;
  const SubscriptionDetailWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Theme.of(context).shadowColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ClipOval(child: CacheNetworkImageWidget(width: 50.0, height: 50.0, imageUrl: model.icon!))],
          ),
          kAppSpacerVertical(height: 20),
          Center(
            child: Text(kAppTrimWord(model.name!, 25), style: kAppLblSmallFontBold(context, color: 'primary')),
          ),
          model.discount! <= 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text(kAppPriceFormat(model.price!), style: kAppLblTinyMediumFontSemi(context))],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(kAppPriceFormat(model.price!), style: kAppLblTinyStrokeFontRegular(context)),
                    kAppSpacerHorizontal(width: 5),
                    Text(kAppPriceFormat(model.offerPrice!), style: kAppLblTinyMediumFontSemi(context)),
                  ],
                ),
          kAppSpacerVertical(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.validity, style: kAppLblSmallFontMedium(context)),
              Text("${model.validity!} ${translate.days}", style: kAppLblSmallFontMedium(context)),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.order_limit, style: kAppLblSmallFontMedium(context)),
              Text(model.orderLimit! != -1 ? '${model.orderLimit!} ${translate.per_month}' : translate.unlimited, style: kAppLblSmallFontMedium(context)),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.product_limit, style: kAppLblSmallFontMedium(context)),
              Text(model.productLimit! != -1 ? '${model.productLimit!}' : translate.unlimited, style: kAppLblSmallFontMedium(context)),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.pos_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.pos! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.own_deliveryman_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.ownDriver! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.promote_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.promote! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.custom_category_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.customCategory! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.outlet_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.multiOutlet! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.table_booking_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.preBooking! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.table_order_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.tableOrder! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.tiffin_subcription_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.tiffinSubscription! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.waiter_service_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.ownWaiter! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translate.own_kitchen_owner_permission, style: kAppLblSmallFontMedium(context)),
              Image.asset(model.ownKitchen! == true ? AssetsUrl.imageURL.subscriptionPermission : AssetsUrl.imageURL.subscriptionNoPermission, height: 15, width: 15),
            ],
          ),
        ],
      ),
    );
  }
}

class SubscriptionPackageLoadingView extends StatelessWidget {
  const SubscriptionPackageLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SkeletonLine(style: SkeletonLineStyle(height: 100.0, width: 100.0, borderRadius: BorderRadius.circular(50.0)))],
        ),
        kAppSpacerVertical(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
      ],
    );
  }
}

class SubscriptionPackageErrorView extends StatelessWidget {
  const SubscriptionPackageErrorView({super.key});

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