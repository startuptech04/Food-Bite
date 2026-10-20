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
import 'package:vendor/app/core/models/dining_schedule_time_slot_modal_response_model.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/dining_schedules/@core/bloc/dining_schedule_bloc.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/dining_schedules/dialog_dining_schedule/dialog_dining_schedule_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DiningSchedulesScreen extends StatelessWidget {
  const DiningSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DiningScheduleBloc()..add(DiningScheduleInitialEvent()), child: const DiningSchedulesView());
  }
}

class DiningSchedulesView extends StatelessWidget {
  const DiningSchedulesView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<DiningScheduleBloc, DiningScheduleState>(
      listener: (context, state) {
        if (state.status.isUpdateSuccess) {
          showSuccessDialog(context, translate.slot_updated);
        } else if (state.status.isFailure || state.status.isUpdateFailed || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isUpdateStart ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.dining_booking_schedule), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const DiningScheduleLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const DiningScheduleErrorView(),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.list.slots!.length,
                        (index) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DiningScheduleSlotTitleWidget(dayIndex: state.list.slots![index].day!, dayName: kAppWeekName(context, state.daysName[state.list.slots![index].day!])),
                            state.list.slots![index].times!.isEmpty ? Text(translate.offday, style: kAppLblSmallFontRegular(context)) : const SizedBox(),
                            state.list.slots![index].times!.isNotEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// BreakFast //
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                                        ),
                                        child: Text(translate.breakfast, style: kAppLblTinyFontBold(context)),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                          state.list.slots![index].times!.length,
                                          (mealIndex) => state.list.slots![index].times![mealIndex].type! == 'breakfast'
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(5),
                                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                                      child: Text(state.list.slots![index].times![mealIndex].time!, style: kAppLblSmallFontRegular(context)),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              builder: (context) {
                                                                var height = MediaQuery.of(context).size.height;
                                                                var width = MediaQuery.of(context).size.width;
                                                                return AlertDialog(
                                                                  insetPadding: EdgeInsets.zero,
                                                                  contentPadding: EdgeInsets.zero,
                                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                  content: SizedBox(
                                                                    height: height - 400,
                                                                    width: width - 30,
                                                                    child: DialogDiningScheduleModalScreen(
                                                                      isNew: false,
                                                                      dayName: kAppWeekName(context, state.daysName[state.list.slots![index].day!]),
                                                                      type: state.list.slots![index].times![mealIndex].type!,
                                                                      time: state.list.slots![index].times![mealIndex].time!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) {
                                                              if (!context.mounted) return;
                                                              DiningScheduleTimeSlotModalResponseModel newData = DiningScheduleTimeSlotModalResponseModel.fromJson(value);
                                                              if (newData.action!) {
                                                                context.read<DiningScheduleBloc>().add(DiningScheduleEditTimeSlotEvent(slotIndex: index, mealIndex: mealIndex, time: newData.time!, type: newData.type!));
                                                              }
                                                            });
                                                          },
                                                          icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            showConfirmDialog(context, translate.alert_confirm_title, translate.alert_slot_removed, translate.cancel_lbl, translate.yes_delete_btn).then((value) {
                                                              if (!context.mounted) return;
                                                              if (value) {
                                                                context.read<DiningScheduleBloc>().add(DiningScheduleDeleteTimeSlotEvent(slotIndex: index, mealIndex: mealIndex));
                                                              }
                                                            });
                                                          },
                                                          icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),

                                      /// BreakFast //

                                      /// Lunch //
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                                        ),
                                        child: Text(translate.lunch, style: kAppLblTinyFontBold(context)),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                          state.list.slots![index].times!.length,
                                          (mealIndex) => state.list.slots![index].times![mealIndex].type! == 'lunch'
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(5),
                                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                                      child: Text(state.list.slots![index].times![mealIndex].time!, style: kAppLblSmallFontRegular(context)),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              builder: (context) {
                                                                var height = MediaQuery.of(context).size.height;
                                                                var width = MediaQuery.of(context).size.width;
                                                                return AlertDialog(
                                                                  insetPadding: EdgeInsets.zero,
                                                                  contentPadding: EdgeInsets.zero,
                                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                  content: SizedBox(
                                                                    height: height - 400,
                                                                    width: width - 30,
                                                                    child: DialogDiningScheduleModalScreen(
                                                                      isNew: false,
                                                                      dayName: kAppWeekName(context, state.daysName[state.list.slots![index].day!]),
                                                                      type: state.list.slots![index].times![mealIndex].type!,
                                                                      time: state.list.slots![index].times![mealIndex].time!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) {
                                                              if (!context.mounted) return;
                                                              DiningScheduleTimeSlotModalResponseModel newData = DiningScheduleTimeSlotModalResponseModel.fromJson(value);
                                                              if (newData.action!) {
                                                                context.read<DiningScheduleBloc>().add(DiningScheduleEditTimeSlotEvent(slotIndex: index, mealIndex: mealIndex, time: newData.time!, type: newData.type!));
                                                              }
                                                            });
                                                          },
                                                          icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            showConfirmDialog(context, translate.alert_confirm_title, translate.alert_slot_removed, translate.cancel_lbl, translate.yes_delete_btn).then((value) {
                                                              if (!context.mounted) return;
                                                              if (value) {
                                                                context.read<DiningScheduleBloc>().add(DiningScheduleDeleteTimeSlotEvent(slotIndex: index, mealIndex: mealIndex));
                                                              }
                                                            });
                                                          },
                                                          icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),

                                      /// Lunch //

                                      /// Dinner //
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
                                        ),
                                        child: Text(translate.dinner, style: kAppLblTinyFontBold(context)),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                          state.list.slots![index].times!.length,
                                          (mealIndex) => state.list.slots![index].times![mealIndex].type! == 'dinner'
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(5),
                                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                                      child: Text(state.list.slots![index].times![mealIndex].time!, style: kAppLblSmallFontRegular(context)),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              builder: (context) {
                                                                var height = MediaQuery.of(context).size.height;
                                                                var width = MediaQuery.of(context).size.width;
                                                                return AlertDialog(
                                                                  insetPadding: EdgeInsets.zero,
                                                                  contentPadding: EdgeInsets.zero,
                                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                  content: SizedBox(
                                                                    height: height - 400,
                                                                    width: width - 30,
                                                                    child: DialogDiningScheduleModalScreen(
                                                                      isNew: false,
                                                                      dayName: kAppWeekName(context, state.daysName[state.list.slots![index].day!]),
                                                                      type: state.list.slots![index].times![mealIndex].type!,
                                                                      time: state.list.slots![index].times![mealIndex].time!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) {
                                                              if (!context.mounted) return;
                                                              DiningScheduleTimeSlotModalResponseModel newData = DiningScheduleTimeSlotModalResponseModel.fromJson(value);
                                                              if (newData.action!) {
                                                                context.read<DiningScheduleBloc>().add(DiningScheduleEditTimeSlotEvent(slotIndex: index, mealIndex: mealIndex, time: newData.time!, type: newData.type!));
                                                              }
                                                            });
                                                          },
                                                          icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            showConfirmDialog(context, translate.alert_confirm_title, translate.alert_slot_removed, translate.cancel_lbl, translate.yes_delete_btn).then((value) {
                                                              if (!context.mounted) return;
                                                              if (value) {
                                                                context.read<DiningScheduleBloc>().add(DiningScheduleDeleteTimeSlotEvent(slotIndex: index, mealIndex: mealIndex));
                                                              }
                                                            });
                                                          },
                                                          icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),

                                      /// Dinner //
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
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
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.read<DiningScheduleBloc>().add(DiningScheduleSaveEvent()),
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isUpdateStart ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.save_lbl),
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

class DiningScheduleSlotTitleWidget extends StatelessWidget {
  final int dayIndex;
  final String dayName;
  const DiningScheduleSlotTitleWidget({super.key, required this.dayIndex, required this.dayName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5, color: ThemeProvider.lightDisabledColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(dayName, style: kAppLblMediumFontBold(context)),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  return AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    content: SizedBox(
                      height: height - 400,
                      width: width - 30,
                      child: DialogDiningScheduleModalScreen(isNew: true, dayName: dayName, type: '', time: ''),
                    ),
                  );
                },
              ).then((value) {
                if (!context.mounted) return;
                DiningScheduleTimeSlotModalResponseModel newData = DiningScheduleTimeSlotModalResponseModel.fromJson(value);
                if (newData.action!) {
                  context.read<DiningScheduleBloc>().add(DiningScheduleAddTimeSlotEvent(dayIndex: dayIndex, time: newData.time!, type: newData.type!));
                }
              });
            },
            icon: FaIcon(FontAwesomeIcons.squarePlus, size: Theme.of(context).textTheme.labelLarge?.fontSize),
          ),
        ],
      ),
    );
  }
}

class DiningScheduleLoadingView extends StatelessWidget {
  const DiningScheduleLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonAvatar(style: SkeletonAvatarStyle(width: MediaQuery.of(context).size.width, height: 10)),
            kAppSpacerVertical(height: 10),
            SkeletonAvatar(style: SkeletonAvatarStyle(width: MediaQuery.of(context).size.width / 1.2, height: 10)),
            kAppSpacerVertical(height: 10),
          ],
        ),
      ),
    );
  }
}

class DiningScheduleErrorView extends StatelessWidget {
  const DiningScheduleErrorView({super.key});

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