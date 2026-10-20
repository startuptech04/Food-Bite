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
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TiffinSubscriptionTimeslotModalScreen extends StatelessWidget {
  final bool isNew;
  final String startTime;
  final String endTime;
  const TiffinSubscriptionTimeslotModalScreen({super.key, required this.isNew, required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    return TiffinSubscriptionTimeslotModalView(isNew: isNew, startTime: startTime, endTime: endTime);
  }
}

class TiffinSubscriptionTimeslotModalView extends StatefulWidget {
  final bool isNew;
  final String startTime;
  final String endTime;
  const TiffinSubscriptionTimeslotModalView({super.key, required this.isNew, required this.startTime, required this.endTime});

  @override
  State<TiffinSubscriptionTimeslotModalView> createState() => _TiffinSubscriptionTimeslotModalViewState();
}

class _TiffinSubscriptionTimeslotModalViewState extends State<TiffinSubscriptionTimeslotModalView> {
  final TextEditingController _slotStartTimeController = TextEditingController();
  final TextEditingController _slotEndTimeController = TextEditingController();

  TimePickerEntryMode entryMode = TimePickerEntryMode.inputOnly;
  TimeOfDay? startTimePicker;
  TimeOfDay? endTimePicker;

  @override
  void initState() {
    super.initState();
    TimeOfDay stringToTimeOfDay(String time) {
      final parts = time.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      return TimeOfDay(hour: hour, minute: minute);
    }

    if (!widget.isNew) {
      _slotStartTimeController.text = widget.startTime;
      _slotEndTimeController.text = widget.endTime;
      startTimePicker = stringToTimeOfDay(widget.startTime);
      endTimePicker = stringToTimeOfDay(widget.endTime);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _slotStartTimeController.dispose();
    _slotEndTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Text(widget.isNew ? translate.add_slot : translate.update_slot),
        actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _slotStartTimeController,
              decoration: kAppInputDecoration(context, lblText: translate.form_start_time),
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
                  helpText: translate.form_start_time,
                ).then((value) {
                  if (value != null) {
                    String formatTime(TimeOfDay time) {
                      final String hour = time.hour.toString().padLeft(2, '0');
                      final String minute = time.minute.toString().padLeft(2, '0');
                      return '$hour:$minute';
                    }

                    setState(() {
                      startTimePicker = value;
                      _slotStartTimeController.text = formatTime(value);
                    });
                  }
                });
              },
              textInputAction: TextInputAction.next,
            ),
            kAppSpacerVertical(height: 20),
            TextFormField(
              controller: _slotEndTimeController,
              decoration: kAppInputDecoration(context, lblText: translate.form_end_time),
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
                  helpText: translate.form_end_time,
                ).then((value) {
                  if (value != null) {
                    String formatTime(TimeOfDay time) {
                      final String hour = time.hour.toString().padLeft(2, '0');
                      final String minute = time.minute.toString().padLeft(2, '0');
                      return '$hour:$minute';
                    }

                    setState(() {
                      endTimePicker = value;
                      _slotEndTimeController.text = formatTime(value);
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
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _slotStartTimeController.text.isNotEmpty && _slotEndTimeController.text.isNotEmpty
                ? () {
                    String formatTime(TimeOfDay time) {
                      final String hour = time.hour.toString().padLeft(2, '0');
                      final String minute = time.minute.toString().padLeft(2, '0');
                      return '$hour:$minute';
                    }

                    String startTime = formatTime(startTimePicker!);
                    String endTime = formatTime(endTimePicker!);
                    Navigator.of(context).pop({'action': true, 'start': startTime, 'end': endTime});
                  }
                : null,
            style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
            child: Text(widget.isNew ? translate.save_slot : translate.update_slot),
          ),
        ),
      ),
    );
  }
}
