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

import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:driver/app/presentation/pages/account/setting_section/@core/bloc/setting_section_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/router/app_route_config.dart';

class SettingSectionScreen extends StatelessWidget {
  const SettingSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SettingSectionBloc()..add(SettingSectionInitialEvent()), child: const SettingSectionView());
  }
}

class SettingSectionView extends StatelessWidget {
  const SettingSectionView({super.key});

  void openAppSettingsPage() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<SettingSectionBloc, SettingSectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate.settings, style: kAppLblMediumFontBold(context)),
                Text("v${state.currentVersion}", style: kAppLblTinyFontRegular(context)),
                kAppSpacerVertical(height: 20),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(AppRouter.editProfileRoute),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.profile_info, style: kAppLblMediumFontBold(context)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(translate.update_bio, style: kAppLblTinyFontRegular(context), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(AppRouter.accountSettingAlertSettingRoute),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.alert_pref, style: kAppLblMediumFontBold(context)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(translate.choose_reminders, style: kAppLblTinyFontRegular(context), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(AppRouter.appSettingRoute),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.user_account, style: kAppLblMediumFontBold(context)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(translate.manage_login_creds_to_remove_account, style: kAppLblTinyFontRegular(context), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    openAppSettingsPage();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.device_access, style: kAppLblMediumFontBold(context)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(translate.control_permissions, style: kAppLblTinyFontRegular(context), maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// DONE //