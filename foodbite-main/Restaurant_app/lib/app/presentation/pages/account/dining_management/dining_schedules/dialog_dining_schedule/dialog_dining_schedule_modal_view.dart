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
import 'package:vendor/app/core/models/dining_schedule_meal_type_model.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/dining_schedules/dialog_dining_schedule/bloc/dialog_dining_schedule_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DialogDiningScheduleModalScreen extends StatelessWidget {
  final bool isNew;
  final String dayName;
  final String type;
  final String time;
  const DialogDiningScheduleModalScreen({super.key, required this.isNew, required this.dayName, required this.type, required this.time});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DialogDiningScheduleModalBloc()..add(DialogDiningScheduleModalInitialEvent(isNew, dayName, type, time)),
      child: DialogDiningScheduleModalView(isNew: isNew, dayName: dayName, type: type, time: time),
    );
  }
}

class DialogDiningScheduleModalView extends StatefulWidget {
  final bool isNew;
  final String dayName;
  final String type;
  final String time;
  const DialogDiningScheduleModalView({super.key, required this.isNew, required this.dayName, required this.type, required this.time});

  @override
  State<DialogDiningScheduleModalView> createState() => _DialogDiningScheduleModalViewState();
}

class _DialogDiningScheduleModalViewState extends State<DialogDiningScheduleModalView> {
  final TextEditingController _timeController = TextEditingController();
  TimePickerEntryMode entryMode = TimePickerEntryMode.inputOnly;
  TimeOfDay? timePicker;
  final _timeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _timeFocusNode.addListener(() {
      if (!_timeFocusNode.hasFocus) {
        context.read<DialogDiningScheduleModalBloc>().add(DialogDiningScheduleTimePickerUnfocused());
      }
    });

    if (!widget.isNew) {
      _timeController.text = widget.time;
      int hour = int.parse(widget.time.split(":").first);
      int minute = int.parse(widget.time.split(":").last.split(" ").first);
      String meridium = widget.time.split(":").last.split(" ").last.toLowerCase();
      if (meridium == "PM" || meridium == "pm") {
        if (hour != 12) {
          hour = hour + 12;
        }
      }
      timePicker = TimeOfDay(hour: hour, minute: minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((DialogDiningScheduleModalBloc bloc) => bloc.state.isValid);
    return BlocConsumer<DialogDiningScheduleModalBloc, DialogDiningScheduleModalState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop({'action': true, 'type': state.type.value.toString(), 'time': state.time.value});
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
                onPressed: () => Navigator.of(context).pop({'action': false, 'type': '', 'time': ''}),
                icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate.select_meal, style: kAppLblTinyFontRegular(context)),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                  ),
                  child: DropdownButton<DiningScheduleMealTypeModel>(
                    underline: const SizedBox(),
                    isExpanded: true,
                    value: state.type,
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    style: kAppLblMediumFontRegular(context),
                    items: state.typeList.map((DiningScheduleMealTypeModel item) {
                      return DropdownMenuItem<DiningScheduleMealTypeModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                    }).toList(),
                    onChanged: (newValue) {
                      context.read<DialogDiningScheduleModalBloc>().add(DialogDiningScheduleTypeChangeEvent(type: newValue!));
                    },
                  ),
                ),
                kAppSpacerVertical(height: 10),
                TextFormField(
                  controller: _timeController,
                  focusNode: _timeFocusNode,
                  decoration: kAppInputDecoration(context, lblText: translate.form_time, errText: state.time.displayError != null ? translate.form_required : null),
                  style: kAppLblLargeFontMedium(context),
                  readOnly: false,
                  keyboardType: TextInputType.number,
                  onTap: () async {
                    await showTimePicker(
                      context: context,
                      initialEntryMode: entryMode,
                      initialTime: timePicker ?? TimeOfDay.now(),
                      cancelText: translate.cancel_lbl,
                      confirmText: translate.ok_lbl,
                      hourLabelText: translate.hour_lbl,
                      minuteLabelText: translate.minute_lbl,
                      helpText: translate.select_time_lbl,
                    ).then((value) {
                      if (!context.mounted) return;
                      if (value != null) {
                        String hour = value.hourOfPeriod <= 9 ? '0${value.hourOfPeriod}' : '${value.hourOfPeriod}';
                        String minute = value.minute <= 9 ? '0${value.minute}' : '${value.minute}';
                        _timeController.text = '$hour:$minute ${value.period.name.toUpperCase()}';
                        context.read<DialogDiningScheduleModalBloc>().add(DialogDiningScheduleTimePickerChanged(time: '$hour:$minute ${value.period.name.toUpperCase()}'));
                        setState(() {
                          timePicker = value;
                        });
                      }
                    });
                  },
                  textInputAction: TextInputAction.next,
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
                          onPressed: isValid ? () => context.read<DialogDiningScheduleModalBloc>().add(DialogDiningScheduleModalSubmitEvent()) : null,
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