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

class TiffinSubscriptionOffdaysModalScreen extends StatelessWidget {
  final List<String> offDays;
  const TiffinSubscriptionOffdaysModalScreen({super.key, required this.offDays});

  @override
  Widget build(BuildContext context) {
    return TiffinSubscriptionOffdaysModalView(offDays: offDays);
  }
}

class TiffinSubscriptionOffdaysModalView extends StatefulWidget {
  final List<String> offDays;
  const TiffinSubscriptionOffdaysModalView({super.key, required this.offDays});

  @override
  State<TiffinSubscriptionOffdaysModalView> createState() => _TiffinSubscriptionOffdaysModalViewState();
}

class _TiffinSubscriptionOffdaysModalViewState extends State<TiffinSubscriptionOffdaysModalView> {
  List<WeekListModel> weekList = <WeekListModel>[];
  WeekListModel sunday = WeekListModel(name: "sunday", key: 'sunday', index: 0);
  WeekListModel monday = WeekListModel(name: "monday", key: 'monday', index: 1);
  WeekListModel tuesday = WeekListModel(name: "tuesday", key: 'tuesday', index: 2);
  WeekListModel wednesday = WeekListModel(name: "wednesday", key: 'wednesday', index: 3);
  WeekListModel thursday = WeekListModel(name: "thursday", key: 'thursday', index: 4);
  WeekListModel friday = WeekListModel(name: "friday", key: 'friday', index: 5);
  WeekListModel saturday = WeekListModel(name: "saturday", key: 'saturday', index: 6);

  List<String> offDays = <String>[];

  void updateOffDays(String day) {
    setState(() {
      if (offDays.contains(day)) {
        offDays.removeWhere((element) => element == day);
      } else {
        offDays.add(day);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      weekList.clear();
      weekList.add(sunday);
      weekList.add(monday);
      weekList.add(tuesday);
      weekList.add(wednesday);
      weekList.add(thursday);
      weekList.add(friday);
      weekList.add(saturday);
      weekList.sort((a, b) => b.index!.compareTo(a.index!));
      for (var day in widget.offDays) {
        offDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Text(translate.add_update_off_days_tiffin_packages),
        actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            weekList.length,
            (index) => GestureDetector(
              onTap: () => updateOffDays(weekList[index].key!),
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(kAppWeekName(context, weekList[index].name!), style: kAppLblTinyFontBold(context)),
                    Icon(
                      offDays.contains(weekList[index].key!) ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
                      color: offDays.contains(weekList[index].key!) ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: double.infinity,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [Text(translate.cancel_lbl, style: kAppLblSmallFontBold(context, color: 'canvas'))],
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox(width: double.infinity)),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop({'action': true, "days": offDays}),
                    style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                    child: Text(translate.save_lbl),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeekListModel {
  String? name;
  String? key;
  int? index;

  WeekListModel({this.name, this.key, this.index});

  WeekListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['key'] = key;
    data['index'] = index;
    return data;
  }
}
