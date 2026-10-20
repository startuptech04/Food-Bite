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
import 'package:vendor/app/core/models/time_slot_modal_response_model.dart';
import 'package:vendor/app/presentation/pages/account/schedules/@core/bloc/schedules_bloc.dart';
import 'package:vendor/app/presentation/pages/account/schedules/action/schedule_time_picker_modal_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SchedulesBloc()..add(SchedulesInitialEvent()), child: const ScheduleView());
  }
}

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<SchedulesBloc, SchedulesState>(
      listener: (context, state) {
        if (state.status.isUpdateSucces) {
          showSuccessDialog(context, translate.slot_updated);
        } else if (state.status.isFailure || state.status.isUpdateFailed || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isUpdateStart ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.restaurant_opening_closing_schedule), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const ScheduleLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const ScheduleErrorView(),
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
                            SlotTitleWidget(dayIndex: state.list.slots![index].day!, dayName: kAppWeekName(context, state.daysName[state.list.slots![index].day!])),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: state.list.slots![index].times!.isEmpty
                                  ? [Text(translate.offday, style: kAppLblSmallFontRegular(context))]
                                  : List.generate(
                                      state.list.slots![index].times!.length,
                                      (slotIndex) => SlotTimeWidget(
                                        dayIndex: index,
                                        dayName: kAppWeekName(context, state.daysName[state.list.slots![index].day!]),
                                        timeIndex: slotIndex,
                                        startTime: state.list.slots![index].times![slotIndex].start!,
                                        endTime: state.list.slots![index].times![slotIndex].end!,
                                      ),
                                    ),
                            ),
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
                                  onPressed: () => context.read<SchedulesBloc>().add(ScheduleSubmitEvent()),
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

class ScheduleLoadingView extends StatelessWidget {
  const ScheduleLoadingView({super.key});

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

class ScheduleErrorView extends StatelessWidget {
  const ScheduleErrorView({super.key});

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

class SlotTitleWidget extends StatelessWidget {
  final int dayIndex;
  final String dayName;
  const SlotTitleWidget({super.key, required this.dayIndex, required this.dayName});

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
                      child: ScheduleTimePickerModalScreen(isNew: true, dayName: dayName, startTime: '', endTime: ''),
                    ),
                  );
                },
              ).then((value) {
                if (!context.mounted) return;
                TimeSlotModalResponseModel timeSlotModalRespons = TimeSlotModalResponseModel.fromJson(value);
                if (timeSlotModalRespons.action!) {
                  context.read<SchedulesBloc>().add(ScheduleAddTimeSlotEvent(dayIndex: dayIndex, startTime: timeSlotModalRespons.startTime!, endTime: timeSlotModalRespons.endTime!));
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

class SlotTimeWidget extends StatelessWidget {
  final int dayIndex;
  final String dayName;
  final int timeIndex;
  final String startTime;
  final String endTime;
  const SlotTimeWidget({super.key, required this.dayIndex, required this.dayName, required this.timeIndex, required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Text(startTime, style: kAppLblSmallFontRegular(context)),
              Text(" "),
              Text(translate.to, style: kAppLblSmallFontRegular(context)),
              Text(" "),
              Text(endTime, style: kAppLblSmallFontRegular(context)),
            ],
          ),
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
                        child: ScheduleTimePickerModalScreen(isNew: false, dayName: dayName, startTime: startTime, endTime: endTime),
                      ),
                    );
                  },
                ).then((value) {
                  if (!context.mounted) return;
                  TimeSlotModalResponseModel timeSlotModalRespons = TimeSlotModalResponseModel.fromJson(value);
                  if (timeSlotModalRespons.action!) {
                    context.read<SchedulesBloc>().add(ScheduleEditTimeSlotEvent(dayIndex: dayIndex, slotIndex: timeIndex, startTime: timeSlotModalRespons.startTime!, endTime: timeSlotModalRespons.endTime!));
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
                    context.read<SchedulesBloc>().add(ScheduleDeleteTimeSlotEvent(dayIndex: dayIndex, slotIndex: timeIndex));
                  }
                });
              },
              icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelLarge?.fontSize),
            ),
          ],
        ),
      ],
    );
  }
}
// DONE //