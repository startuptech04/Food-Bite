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
import 'package:vendor/app/presentation/pages/account/schedules/action/bloc/schedular_time_picker_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class ScheduleTimePickerModalScreen extends StatelessWidget {
  final bool isNew;
  final String dayName;
  final String startTime;
  final String endTime;
  const ScheduleTimePickerModalScreen({super.key, required this.isNew, required this.dayName, required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SchedularTimePickerModalBloc()..add(SchedularTimePickerInitialEvent(isNew: isNew, startTime: startTime, endTime: endTime)),
      child: ScheduleTimePickerModalView(isNew: isNew, dayName: dayName, startTime: startTime, endTime: endTime),
    );
  }
}

class ScheduleTimePickerModalView extends StatefulWidget {
  final bool isNew;
  final String dayName;
  final String startTime;
  final String endTime;
  const ScheduleTimePickerModalView({super.key, required this.isNew, required this.dayName, required this.startTime, required this.endTime});

  @override
  State<ScheduleTimePickerModalView> createState() => _ScheduleTimePickerModalViewState();
}

class _ScheduleTimePickerModalViewState extends State<ScheduleTimePickerModalView> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  TimePickerEntryMode entryMode = TimePickerEntryMode.inputOnly;

  TimeOfDay? startTimePicker;
  TimeOfDay? endTimePicker;

  final _startTimeFocusNode = FocusNode();
  final _endTimeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startTimeFocusNode.addListener(() {
      if (!_startTimeFocusNode.hasFocus) {
        context.read<SchedularTimePickerModalBloc>().add(StartTimePickerUnfocused());
      }
    });

    _endTimeFocusNode.addListener(() {
      if (!_endTimeFocusNode.hasFocus) {
        context.read<SchedularTimePickerModalBloc>().add(EndTimePickerUnfocused());
      }
    });
    if (!widget.isNew) {
      _startTimeController.text = widget.startTime;
      _endTimeController.text = widget.endTime;
      int startHour = int.parse(widget.startTime.split(":").first);
      int startMinute = int.parse(widget.startTime.split(":").last.split(" ").first);
      String startMeridium = widget.startTime.split(":").last.split(" ").last.toLowerCase();
      if (startMeridium == "PM" || startMeridium == "pm") {
        if (startHour != 12) {
          startHour = startHour + 12;
        }
      }
      startTimePicker = TimeOfDay(hour: startHour, minute: startMinute);

      int endHour = int.parse(widget.endTime.split(":").first);
      int endMinute = int.parse(widget.endTime.split(":").last.split(" ").first);
      String endMeridium = widget.endTime.split(":").last.split(" ").last.toLowerCase();
      if (endMeridium == "PM" || endMeridium == "pm") {
        if (endHour != 12) {
          endHour = endHour + 12;
        }
      }
      endTimePicker = TimeOfDay(hour: endHour, minute: endMinute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((SchedularTimePickerModalBloc bloc) => bloc.state.isValid);
    return BlocConsumer<SchedularTimePickerModalBloc, SchedularTimePickerModalState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop({'action': true, 'startTime': state.startTime.value, 'endTime': state.endTime.value});
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(widget.isNew ? '${translate.add_slot_to} ${widget.dayName}' : '${translate.update_slot_to} ${widget.dayName}'),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop({'action': false, 'startTime': '', 'endTime': ''}),
                icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                kAppSpacerVertical(height: 10),
                TextFormField(
                  controller: _startTimeController,
                  focusNode: _startTimeFocusNode,
                  decoration: kAppInputDecoration(context, lblText: translate.form_start_time, errText: state.startTime.displayError != null ? translate.form_required : null),
                  style: kAppLblLargeFontMedium(context),
                  readOnly: false,
                  keyboardType: TextInputType.number,
                  onTap: () async {
                    await showTimePicker(
                      context: context,
                      initialEntryMode: entryMode,
                      initialTime: startTimePicker ?? TimeOfDay.now(),
                      cancelText: translate.cancel_lbl,
                      confirmText: translate.ok_lbl,
                      hourLabelText: translate.hour_lbl,
                      minuteLabelText: translate.minute_lbl,
                      helpText: translate.select_start_time_lbl,
                    ).then((value) {
                      if (!context.mounted) return;
                      if (value != null) {
                        String hour = value.hourOfPeriod <= 9 ? '0${value.hourOfPeriod}' : '${value.hourOfPeriod}';
                        String minute = value.minute <= 9 ? '0${value.minute}' : '${value.minute}';
                        _startTimeController.text = '$hour:$minute ${value.period.name.toUpperCase()}';
                        context.read<SchedularTimePickerModalBloc>().add(StartTimePickerChanged(time: '$hour:$minute ${value.period.name.toUpperCase()}'));
                        setState(() {
                          startTimePicker = value;
                        });
                      }
                    });
                  },
                  textInputAction: TextInputAction.next,
                ),
                kAppSpacerVertical(height: 10),
                TextFormField(
                  controller: _endTimeController,
                  focusNode: _endTimeFocusNode,
                  decoration: kAppInputDecoration(context, lblText: translate.form_end_time, errText: state.endTime.displayError != null ? translate.form_required : null),
                  style: kAppLblLargeFontMedium(context),
                  readOnly: false,
                  keyboardType: TextInputType.number,
                  onTap: () async {
                    await showTimePicker(
                      context: context,
                      initialEntryMode: entryMode,
                      initialTime: endTimePicker ?? TimeOfDay.now(),
                      cancelText: translate.cancel_lbl,
                      confirmText: translate.ok_lbl,
                      hourLabelText: translate.hour_lbl,
                      minuteLabelText: translate.minute_lbl,
                      helpText: translate.select_end_time_lbl,
                    ).then((value) {
                      if (!context.mounted) return;
                      if (value != null) {
                        String hour = value.hourOfPeriod <= 9 ? '0${value.hourOfPeriod}' : '${value.hourOfPeriod}';
                        String minute = value.minute <= 9 ? '0${value.minute}' : '${value.minute}';
                        _endTimeController.text = '$hour:$minute ${value.period.name.toUpperCase()}';
                        context.read<SchedularTimePickerModalBloc>().add(EndTimePickerChanged(time: '$hour:$minute ${value.period.name.toUpperCase()}'));
                        setState(() {
                          endTimePicker = value;
                        });
                      }
                    });
                  },
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
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
                          onPressed: isValid ? () => context.read<SchedularTimePickerModalBloc>().add(ScheduleFormSubmitted()) : null,
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                          child: Text(translate.save_lbl),
                        ),
                      ),
                    ),
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
// DONE //