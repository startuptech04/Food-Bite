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
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/router/app_route_config.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(translate.app_settings), scrolledUnderElevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRouter.accountSettingChangeEmailRoute),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.change_email, style: kAppLblMediumFontBold(context)),
                    Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRouter.accountSettingChangeMobileRoute),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.change_mobile, style: kAppLblMediumFontBold(context)),
                    Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRouter.accountSettingUpdatePasswordRoute),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.change_password, style: kAppLblMediumFontBold(context)),
                    Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRouter.accountSettingDeleteAccountRoute),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(translate.delete_account, style: kAppLblMediumFontBold(context)),
                    Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// DONE //