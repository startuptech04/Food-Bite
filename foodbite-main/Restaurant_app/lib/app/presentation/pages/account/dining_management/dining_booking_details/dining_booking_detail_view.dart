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
import 'package:vendor/app/presentation/pages/account/dining_management/dining_booking_details/bloc/dining_booking_detail_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/complete_dining_booking_modal/complete_dining_booking_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/dining_cancellation_reason_modal/dining_cancellation_reason_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DiningBookingDetailScreen extends StatelessWidget {
  final String bookingId;
  const DiningBookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiningBookingDetailBloc()..add(DiningBookingDetailInitialEvent(bookingId: bookingId)),
      child: const DiningBookingDetailView(),
    );
  }
}

class DiningBookingDetailView extends StatelessWidget {
  const DiningBookingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<DiningBookingDetailBloc, DiningBookingDetailState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isAcceptSuccess) {
          showSuccessDialog(context, translate.booking_accepted).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isRejectSuccess) {
          showSuccessDialog(context, translate.booking_rejected).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isAccept || state.status.isReject || state.status.isCallCustomer ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(translate.booking_detail),
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed(AppRouter.supportChatRoute, arguments: ['dining', state.bookingId]),
                  label: Text(
                    translate.support,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'semibold'),
                  ),
                  icon: Icon(Icons.chat_outlined, color: Theme.of(context).primaryColor, size: 12),
                  iconAlignment: IconAlignment.start,
                ),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const DiningBookingDetailLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const DiningBookingDetailErrorView(),
                  ] else ...[
                    kAppSpacerVertical(height: 10),
                    kAppTitleDivider(context, translate.reservation_detail, 0),
                    kAppSpacerVertical(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.tag, color: Theme.of(context).canvasColor, size: 14),
                                kAppSpacerHorizontal(width: 10),
                                Text("${translate.id} : ${state.model.details!.id!}".toUpperCase(), style: kAppLblMediumFontSemiBold(context, color: 'regular')),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month_outlined, color: Theme.of(context).canvasColor, size: 14),
                                kAppSpacerHorizontal(width: 10),
                                Text("${translate.scheduled} : ${state.model.details!.bookingDate!} ${translate.at} ${state.model.details!.bookingSlot!}", style: kAppLblMediumFontSemiBold(context, color: 'regular')),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.supervised_user_circle_outlined, color: Theme.of(context).canvasColor, size: 14),
                                kAppSpacerHorizontal(width: 10),
                                Text("${translate.number_of_guests} : ${state.model.details!.guest!}", style: kAppLblMediumFontSemiBold(context, color: 'regular')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    kAppTitleDivider(context, translate.customer_details, 0),
                    kAppSpacerVertical(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.account_circle_outlined, color: Theme.of(context).canvasColor, size: 14),
                                kAppSpacerHorizontal(width: 10),
                                Text("${translate.form_name} : ${state.model.details!.userName}", style: kAppLblMediumFontSemiBold(context, color: 'regular')),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.email_outlined, color: Theme.of(context).canvasColor, size: 14),
                                kAppSpacerHorizontal(width: 10),
                                Text("${translate.email_lbl} : ${state.model.details!.userEmail}", style: kAppLblMediumFontSemiBold(context, color: 'regular')),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.call_outlined, color: Theme.of(context).canvasColor, size: 14),
                                kAppSpacerHorizontal(width: 10),
                                Text("${translate.phone} : +${state.model.details!.userCountryCode} ${state.model.details!.userContact!}", style: kAppLblMediumFontSemiBold(context, color: 'regular')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: CircleAvatar(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CacheNetworkImageWidget(width: 50.0, height: 50.0, imageUrl: state.model.details!.userInfo!.image!),
                                    ),
                                  ),
                                ),
                                kAppSpacerHorizontal(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${state.model.details!.userInfo!.firstName!} ${state.model.details!.userInfo!.lastName!} ${state.model.details!.userInfo!.role! == 'guest' ? '(${translate.guest})' : ''}',
                                      style: kAppLblMediumFontBold(context),
                                    ),
                                    Text(state.model.details!.userInfo!.contactEmail!, maxLines: 1, overflow: TextOverflow.ellipsis, style: kAppLblTinyFontRegular(context)),
                                    Text("+${state.model.details!.userInfo!.countryCode!} ${state.model.details!.userInfo!.contactNumber!}", maxLines: 1, overflow: TextOverflow.ellipsis, style: kAppLblTinyFontRegular(context)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      final String id = state.model.details!.userInfo!.id!;
                                      final String name = '${state.model.details!.userInfo!.firstName!} ${state.model.details!.userInfo!.lastName!}';
                                      Navigator.of(context).pushNamed(AppRouter.chatMessageRoute, arguments: [name, id]);
                                    },
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.chat_outlined, size: 10, color: Theme.of(context).canvasColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.chat, style: kAppLblTinyFontRegular(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () => context.read<DiningBookingDetailBloc>().add(DiningBookingDetailCallCustomerEvent()),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          state.status.isCallCustomer
                                              ? kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                              : Icon(Icons.call, size: 10, color: Theme.of(context).canvasColor),
                                          kAppSpacerHorizontal(width: 5),
                                          Text(translate.call, style: kAppLblTinyFontRegular(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    state.model.details!.coupon!.id!.isNotEmpty || state.model.details!.specialRequest!.isNotEmpty
                        ? Column(
                            children: [
                              kAppSpacerVertical(height: 20),
                              kAppTitleDivider(context, translate.more_details, 0),
                              kAppSpacerVertical(height: 20),
                              state.model.details!.coupon!.id!.isNotEmpty
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(Icons.card_giftcard_outlined, size: Theme.of(context).textTheme.titleSmall?.fontSize, color: Theme.of(context).canvasColor),
                                              kAppSpacerHorizontal(width: 10),
                                              Text(translate.coupon, style: kAppLblMediumFontMedium(context)),
                                            ],
                                          ),
                                          kAppSpacerVertical(height: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width / 1.2,
                                            child: Text(state.model.details!.coupon!.name!, maxLines: 2, overflow: TextOverflow.ellipsis, style: kAppLblTinyFontRegular(context)),
                                          ),
                                          kAppSpacerVertical(height: 5),
                                          Text(
                                            "${translate.minimum} ${state.model.details!.coupon!.discountType! == 'amount' ? kAppPriceFormat(state.model.details!.coupon!.minDiscount!) : '${state.model.details!.coupon!.minDiscount!}%'} ${translate.discount}",
                                            style: kAppLblTinyFontRegular(context),
                                          ),
                                          kAppSpacerVertical(height: 5),
                                          state.model.details!.coupon!.maxDiscount! > 0
                                              ? Text(
                                                  "${translate.maximum} ${state.model.details!.coupon!.discountType! == 'amount' ? kAppPriceFormat(state.model.details!.coupon!.maxDiscount!) : '${state.model.details!.coupon!.maxDiscount!}%'} ${translate.discount}",
                                                  style: kAppLblTinyFontRegular(context),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              state.model.details!.specialRequest!.isNotEmpty
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(Icons.history_edu_outlined, size: Theme.of(context).textTheme.titleSmall?.fontSize, color: Theme.of(context).canvasColor),
                                              kAppSpacerHorizontal(width: 10),
                                              Text(translate.your_special_request, style: kAppLblMediumFontMedium(context)),
                                            ],
                                          ),
                                          kAppSpacerVertical(height: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width / 1.2,
                                            child: Text(state.model.details!.specialRequest!, maxLines: 2, overflow: TextOverflow.ellipsis, style: kAppLblTinyFontRegular(context)),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          )
                        : const SizedBox(),
                    state.model.details!.grandTotal! > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kAppSpacerVertical(height: 20),
                              kAppTitleDivider(context, translate.billing_summary, 0),
                              kAppSpacerVertical(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    state.model.details!.preBookingCharge! > 0
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(vertical: 2),
                                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(translate.pre_booking_charge, style: kAppLblTinyFontRegular(context)),
                                                Text(kAppPriceFormat(state.model.details!.preBookingCharge!), style: kAppLblTinyFontRegular(context)),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    state.model.details!.couponCoverCharge! > 0
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(vertical: 2),
                                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(translate.coupon_cover_charge, style: kAppLblTinyFontRegular(context)),
                                                Text(kAppPriceFormat(state.model.details!.couponCoverCharge!), style: kAppLblTinyFontRegular(context)),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                                      ),
                                      child: Text(translate.amount_will_adjusted_in_finla_bill, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5, bottom: 10),
                                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("${translate.paid} (${state.model.details!.paymentInfo!.name!})", style: kAppLblTinyFontBold(context)),
                                          Text(kAppPriceFormat(state.model.details!.grandTotal!), style: kAppLblTinyFontBold(context)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state.model.details!.status! == 'created') ...[
                              state.model.diningSettings!.restaurantCanCancelRequest! == true
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width / 3.5,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                enableDrag: false,
                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                builder: (BuildContext context) {
                                                  return const FractionallySizedBox(heightFactor: 0.7, child: DiningCancellationReasonModalScreen());
                                                },
                                              ).then((value) {
                                                if (!context.mounted) return;
                                                if (value != null && value.toString().isNotEmpty) {
                                                  context.read<DiningBookingDetailBloc>().add(DiningBookingDetailRejectEvent(reasonId: value.toString()));
                                                }
                                              });
                                            },
                                            style: kAppElevatedButtonOutlineStyle(
                                              context,
                                              disabledColor: Theme.of(context).disabledColor,
                                              bgColor: ThemeProvider.transparentColor,
                                              foreColor: Theme.of(context).canvasColor,
                                              borderColor: Theme.of(context).primaryColor,
                                              height: 40.0,
                                            ),
                                            child: state.status.isReject
                                                ? kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                                : Text(translate.reject_booking, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width / 1.8,
                                          child: ElevatedButton(
                                            onPressed: () => context.read<DiningBookingDetailBloc>().add(DiningBookingDetailAcceptEvent()),
                                            style: kAppElevatedButtonStyle(
                                              context,
                                              disabledColor: Theme.of(context).disabledColor,
                                              bgColor: Theme.of(context).primaryColor,
                                              foreColor: Theme.of(context).scaffoldBackgroundColor,
                                              height: 40.0,
                                            ),
                                            child: state.status.isAccept
                                                ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                                : Text(translate.accept_booking, style: kAppLblTinyFontRegularLight(context)),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => context.read<DiningBookingDetailBloc>().add(DiningBookingDetailAcceptEvent()),
                                        style: kAppElevatedButtonStyle(
                                          context,
                                          disabledColor: Theme.of(context).disabledColor,
                                          bgColor: Theme.of(context).primaryColor,
                                          foreColor: Theme.of(context).scaffoldBackgroundColor,
                                          height: 40.0,
                                        ),
                                        child: state.status.isAccept
                                            ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                            : Text(translate.accept_booking, style: kAppLblTinyFontRegularLight(context)),
                                      ),
                                    ),
                            ] else if (state.model.details!.status! == 'accepted') ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      enableDrag: false,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      builder: (BuildContext context) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.9,
                                          child: CompleteDiningBookingModalScreen(
                                            bookingId: state.model.details!.id!,
                                            userName: "${state.model.details!.userInfo!.firstName} ${state.model.details!.userInfo!.lastName}",
                                            bookingDate: state.model.details!.bookingDate!.toUpperCase(),
                                            contactNumber: '+${state.model.details!.userInfo!.countryCode!} ${state.model.details!.userInfo!.contactNumber!}',
                                            couponCoverCharge: state.model.details!.couponCoverCharge!,
                                            grandTotal: state.model.details!.grandTotal!,
                                            couponId: state.model.details!.coupon!.id!,
                                            couponCode: state.model.details!.coupon!.code!,
                                            couponDiscountType: state.model.details!.coupon!.discountType!,
                                            couponMinDiscount: state.model.details!.coupon!.minDiscount!,
                                            couponMaxDiscount: state.model.details!.coupon!.maxDiscount!,
                                          ),
                                        );
                                      },
                                    ).then((value) {
                                      if (!context.mounted) return;
                                      if (value != null && value.toString().isNotEmpty) {
                                        if (value.toString() == 'true') {
                                          showSuccessDialog(context, translate.booking_completed).then((value) {
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop(true);
                                          });
                                        }
                                      }
                                    });
                                  },
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 40.0,
                                  ),
                                  child: Text(translate.mark_as_complete, style: kAppLblTinyFontRegularLight(context)),
                                ),
                              ),
                            ] else if (state.model.details!.status! != 'created' && state.model.details!.status! != 'accepted') ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (state.model.details!.status! == 'created') ...[
                                    Text(translate.booking_status_created, style: kAppLblSmallFontBold(context, color: 'primary')),
                                  ] else if (state.model.details!.status! == 'accepted') ...[
                                    Text(translate.booking_status_accepted, style: kAppLblSmallFontBold(context, color: 'primary')),
                                  ] else if (state.model.details!.status! == 'completed') ...[
                                    Text(translate.booking_status_completed, style: kAppLblSmallFontBold(context, color: 'primary')),
                                  ] else if (state.model.details!.status! == 'cancelled') ...[
                                    Text(translate.booking_status_cancelled, style: kAppLblSmallFontBold(context, color: 'primary')),
                                  ] else if (state.model.details!.status! == 'rejected') ...[
                                    Text(translate.booking_status_rejected, style: kAppLblSmallFontBold(context, color: 'primary')),
                                  ] else if (state.model.details!.status! == 'refunded') ...[
                                    Text(translate.booking_status_refunded, style: kAppLblSmallFontBold(context, color: 'primary')),
                                  ] else if (state.model.details!.status! == 'partially_refunded') ...[
                                    Text(translate.booking_status_refunded, style: kAppLblSmallFontBold(context, color: 'primary')),
                                  ] else if (state.model.details!.status! == 'pending_payments') ...[
                                    Text(translate.booking_status_payment_pending, style: kAppLblSmallFontBold(context, color: 'primary')),
                                  ],
                                ],
                              ),
                            ],
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

class DiningBookingDetailLoadingView extends StatelessWidget {
  const DiningBookingDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 5),
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 50, width: double.infinity, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(width: 80, height: 30, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
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
    );
  }
}

class DiningBookingDetailErrorView extends StatelessWidget {
  const DiningBookingDetailErrorView({super.key});

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