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
import 'package:vendor/app/core/models/dining_booking_list_response_model.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/@core/bloc/dining_pre_booking_bloc.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/dining_booking_details/dining_booking_detail_view.dart';
import 'package:vendor/app/presentation/pages/modals/complete_dining_booking_modal/complete_dining_booking_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/dining_cancellation_reason_modal/dining_cancellation_reason_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/dining_help_modal/dining_help_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/router/app_route_config.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DiningPreBookingsScreen extends StatelessWidget {
  const DiningPreBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DiningPreBookingBloc()..add(DiningPreBookingInitialEvent()), child: const DiningPreBookingsView());
  }
}

class DiningPreBookingsView extends StatefulWidget {
  const DiningPreBookingsView({super.key});

  @override
  State<DiningPreBookingsView> createState() => _DiningPreBookingsViewState();
}

class _DiningPreBookingsViewState extends State<DiningPreBookingsView> {
  final GlobalKey<RefreshIndicatorState> _refreshBookingIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollMoreBookings = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollMoreBookings.addListener(() {
      if (_scrollMoreBookings.position.pixels == _scrollMoreBookings.position.maxScrollExtent) {
        context.read<DiningPreBookingBloc>().add(DiningPreBookingLoadMoreBookingEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<DiningPreBookingBloc, DiningPreBookingState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isOrderChange ? true : false,
          child: Scaffold(
            appBar: AppBar(
              title: Text(translate.dining_bookings),
              scrolledUnderElevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      builder: (BuildContext context) {
                        return const FractionallySizedBox(heightFactor: 0.65, child: DiningHelpModalScreen());
                      },
                    ).then((value) {
                      if (!context.mounted) return;
                      if (value != null && value.toString().isNotEmpty) {
                        if (value == 'schedule') {
                          Navigator.of(context).pushNamed(AppRouter.diningScheduleRoute);
                        } else if (value == 'guest') {
                          Navigator.of(context).pushNamed(AppRouter.diningGuestCountRoute);
                        } else if (value == 'menu') {
                          Navigator.of(context).pushNamed(AppRouter.diningSettingRoute);
                        }
                      }
                    });
                  },
                  icon: FaIcon(FontAwesomeIcons.ellipsisVertical, size: Theme.of(context).textTheme.titleSmall?.fontSize, color: Theme.of(context).canvasColor),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: state.status.isLoading
                    ? Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            10,
                            (index) => Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: const SkeletonAvatar(style: SkeletonAvatarStyle(width: 60, height: 5)),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            state.tabList!.length,
                            (index) => GestureDetector(
                              onTap: () => context.read<DiningPreBookingBloc>().add(DiningPreBookingTabChangeEvent(key: state.tabList![index].key!)),
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
            body: RefreshIndicator(
              key: _refreshBookingIndicatorKey,
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onRefresh: () async {
                context.read<DiningPreBookingBloc>().add(DiningPreBookingPullRefreshEvent());
              },
              child: SingleChildScrollView(
                controller: _scrollMoreBookings,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.status.isLoading || state.status.isChangeTabs) ...[
                      const DiningPreBookingsLoadingView(),
                    ] else if (state.status.isEmpty) ...[
                      DiningPreBookingsEmptyView(orderTitle: state.activeTab),
                    ] else if (state.status.isFailure) ...[
                      const DiningPreBookingsErrorView(),
                    ] else ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          state.model.bookings!.length,
                          (bookingIndex) => DiningPreBookingsInfoTileView(
                            bookingIndex: bookingIndex,
                            model: state.model.bookings![bookingIndex],
                            restaurantCanCancelRequest: state.model.diningSettings!.restaurantCanCancelRequest!,
                            status: state.status,
                            orderChangeId: state.orderChangeId,
                            newOrderStatus: state.newOrderStatus,
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
            ),
          ),
        );
      },
    );
  }
}

class DiningPreBookingsInfoTileView extends StatelessWidget {
  final int bookingIndex;
  final DiningBookingConfigModel model;
  final bool restaurantCanCancelRequest;
  final DiningPreBookingStatus status;
  final String orderChangeId;
  final String newOrderStatus;
  const DiningPreBookingsInfoTileView({super.key, required this.bookingIndex, required this.model, required this.status, required this.orderChangeId, required this.newOrderStatus, required this.restaurantCanCancelRequest});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5),
          bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${translate.id} : ${model.id!.toUpperCase()}", style: kAppLblTinyFontRegular(context)),
                    Text(model.bookingDate!.toUpperCase(), style: kAppLblTinyFontRegular(context)),
                  ],
                ),
                kAppSpacerVertical(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${model.userInfo!.firstName} ${model.userInfo!.lastName}", style: kAppLblTinyFontRegular(context)),
                    Text("+${model.userInfo!.countryCode!} ${model.userInfo!.contactNumber!}", style: kAppLblTinyFontRegular(context)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return DiningBookingDetailScreen(bookingId: model.id!);
                      },
                    ),
                  )
                  .then((value) {
                    if (!context.mounted) return;
                    if (value != null && value != '' && value.toString().isNotEmpty) {
                      context.read<DiningPreBookingBloc>().add(DiningPreBookingPullRefreshEvent());
                    }
                  });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.only(bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${translate.form_name}:", style: kAppLblTinyFontBold(context)),
                      kAppSpacerHorizontal(width: 10),
                      Text(model.userName!, style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.email_lbl, style: kAppLblTinyFontBold(context)),
                      kAppSpacerHorizontal(width: 10),
                      Text(model.userEmail!, style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${translate.phone} :", style: kAppLblTinyFontBold(context)),
                      kAppSpacerHorizontal(width: 10),
                      Text("+${model.userCountryCode} ${model.userContact}", style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return DiningBookingDetailScreen(bookingId: model.id!);
                      },
                    ),
                  )
                  .then((value) {
                    if (!context.mounted) return;
                    if (value != null && value != '' && value.toString().isNotEmpty) {
                      context.read<DiningPreBookingBloc>().add(DiningPreBookingPullRefreshEvent());
                    }
                  });
            },
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.pre_booking_charge, style: kAppLblTinyFontRegular(context)),
                      Text(kAppPriceFormat(model.preBookingCharge!), style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.coupon_cover_charge, style: kAppLblTinyFontRegular(context)),
                      Text("'${kAppPriceFormat(model.couponCoverCharge!)}", style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                  kAppSpacerVertical(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translate.grand_total, style: kAppLblTinyFontBold(context)),
                      Text(kAppPriceFormat(model.grandTotal!), style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return DiningBookingDetailScreen(bookingId: model.id!);
                      },
                    ),
                  )
                  .then((value) {
                    if (!context.mounted) return;
                    if (value != null && value != '' && value.toString().isNotEmpty) {
                      context.read<DiningPreBookingBloc>().add(DiningPreBookingPullRefreshEvent());
                    }
                  });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: Text("${model.bookingDate} ${translate.at} ${model.bookingSlot}", style: kAppLblTinyFontBold(context)),
            ),
          ),
          model.specialRequest!.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) {
                              return DiningBookingDetailScreen(bookingId: model.id!);
                            },
                          ),
                        )
                        .then((value) {
                          if (!context.mounted) return;
                          if (value != null && value != '' && value.toString().isNotEmpty) {
                            context.read<DiningPreBookingBloc>().add(DiningPreBookingPullRefreshEvent());
                          }
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(AssetsUrl.imageURL.foodInstruction, height: 12, width: 12, color: Theme.of(context).primaryColor),
                        kAppSpacerHorizontal(width: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Text(
                            model.specialRequest!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kAppLblTinyFontRegularChip(context, color: 'primary'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (model.status! == 'created') ...[
                restaurantCanCancelRequest == true
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
                                    context.read<DiningPreBookingBloc>().add(DiningPreBookingRejectNewBookingEvent(bookingIndex: bookingIndex, reasonId: value.toString()));
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
                              child: status.isOrderChange && orderChangeId == model.id && newOrderStatus == 'reject'
                                  ? kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                  : Text(translate.reject_booking, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: ElevatedButton(
                              onPressed: () => context.read<DiningPreBookingBloc>().add(DiningPreBookingAcceptNewBookingEvent(bookingIndex: bookingIndex)),
                              style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                              child: status.isOrderChange && orderChangeId == model.id && newOrderStatus == 'accept'
                                  ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                                  : Text(translate.accept_booking, style: kAppLblTinyFontRegularLight(context)),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.read<DiningPreBookingBloc>().add(DiningPreBookingAcceptNewBookingEvent(bookingIndex: bookingIndex)),
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                          child: status.isOrderChange && orderChangeId == model.id && newOrderStatus == 'accept'
                              ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                              : Text(translate.accept_booking, style: kAppLblTinyFontRegularLight(context)),
                        ),
                      ),
              ] else if (model.status! == 'accepted') ...[
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
                              bookingId: model.id!,
                              userName: "${model.userInfo!.firstName} ${model.userInfo!.lastName}",
                              bookingDate: model.bookingDate!.toUpperCase(),
                              contactNumber: '+${model.userInfo!.countryCode!} ${model.userInfo!.contactNumber!}',
                              couponCoverCharge: model.couponCoverCharge!,
                              grandTotal: model.grandTotal!,
                              couponId: model.coupon!.id!,
                              couponCode: model.coupon!.code!,
                              couponDiscountType: model.coupon!.discountType!,
                              couponMinDiscount: model.coupon!.minDiscount!,
                              couponMaxDiscount: model.coupon!.maxDiscount!,
                            ),
                          );
                        },
                      ).then((value) {
                        if (!context.mounted) return;
                        if (value != null && value.toString().isNotEmpty) {
                          if (value.toString() == 'true') {
                            context.read<DiningPreBookingBloc>().add(DiningPreBookingCompleteBookingEvent(bookingIndex: bookingIndex));
                          }
                        }
                      });
                    },
                    style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 40.0),
                    child: status.isOrderChange && orderChangeId == model.id && newOrderStatus == 'complete'
                        ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0)
                        : Text(translate.mark_as_complete, style: kAppLblTinyFontRegularLight(context)),
                  ),
                ),
              ] else if (model.status! != 'created' && model.status! != 'accepted') ...[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) {
                              return DiningBookingDetailScreen(bookingId: model.id!);
                            },
                          ),
                        )
                        .then((value) {
                          if (!context.mounted) return;
                          if (value != null && value != '' && value.toString().isNotEmpty) {
                            context.read<DiningPreBookingBloc>().add(DiningPreBookingPullRefreshEvent());
                          }
                        });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (model.status! == 'created') ...[
                        Text(translate.booking_status_created, style: kAppLblSmallFontBold(context, color: 'primary')),
                      ] else if (model.status! == 'accepted') ...[
                        Text(translate.booking_status_accepted, style: kAppLblSmallFontBold(context, color: 'primary')),
                      ] else if (model.status! == 'completed') ...[
                        Text(translate.booking_status_completed, style: kAppLblSmallFontBold(context, color: 'primary')),
                      ] else if (model.status! == 'cancelled') ...[
                        Text(translate.booking_status_cancelled, style: kAppLblSmallFontBold(context, color: 'primary')),
                      ] else if (model.status! == 'rejected') ...[
                        Text(translate.booking_status_rejected, style: kAppLblSmallFontBold(context, color: 'primary')),
                      ] else if (model.status! == 'refunded') ...[
                        Text(translate.booking_status_refunded, style: kAppLblSmallFontBold(context, color: 'primary')),
                      ] else if (model.status! == 'partially_refunded') ...[
                        Text(translate.booking_status_refunded, style: kAppLblSmallFontBold(context, color: 'primary')),
                      ] else if (model.status! == 'pending_payments') ...[
                        Text(translate.booking_status_payment_pending, style: kAppLblSmallFontBold(context, color: 'primary')),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class DiningPreBookingsLoadingView extends StatelessWidget {
  const DiningPreBookingsLoadingView({super.key});

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

class DiningPreBookingsEmptyView extends StatelessWidget {
  final String orderTitle;
  const DiningPreBookingsEmptyView({super.key, required this.orderTitle});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
      child: Center(
        child: Column(
          children: [
            kAppSpacerVertical(height: 20),
            Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
            kAppSpacerVertical(height: 20),
            Text(translate.no_booking_found, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
            kAppSpacerVertical(height: 5),
            Text("${translate.no_title} $orderTitle ${translate.no_booking_sub_title}", textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}

class DiningPreBookingsErrorView extends StatelessWidget {
  const DiningPreBookingsErrorView({super.key});

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
            Text(translate.error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
          ],
        ),
      ),
    );
  }
}
// DONE //