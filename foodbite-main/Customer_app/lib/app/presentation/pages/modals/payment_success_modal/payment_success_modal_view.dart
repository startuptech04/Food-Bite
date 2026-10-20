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
import 'package:user/app/core/config/assets_url.dart';
import 'package:user/app/presentation/styles/app_style.dart';
import 'package:user/app/presentation/styles/theme.dart';
import 'package:user/gen/l10n/app_localizations.dart';

class PaymentSuccessModalScreen extends StatelessWidget {
  final String from;
  const PaymentSuccessModalScreen({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, automaticallyImplyLeading: false),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AssetsUrl.imageURL.successPaymentIcon, height: 100, width: 100),
              kAppSpacerVertical(height: 20),
              if (from == 'order') ...[
                Text(
                  translate.order_success_dialog_title,
                  textAlign: TextAlign.center,
                  style: kAppLblSmallFontBold(context, color: 'primary'),
                ),
                kAppSpacerVertical(height: 10),
                Text(translate.order_sucess_dialog_content, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
              ] else if (from == 'wallet') ...[
                Text(
                  translate.wallet_success_dialog_title,
                  textAlign: TextAlign.center,
                  style: kAppLblSmallFontBold(context, color: 'primary'),
                ),
                kAppSpacerVertical(height: 10),
                Text(translate.wallet_success_dialog_content, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
              ] else if (from == 'dining') ...[
                Text(
                  translate.dining_success_dialog_title,
                  textAlign: TextAlign.center,
                  style: kAppLblSmallFontBold(context, color: 'primary'),
                ),
                kAppSpacerVertical(height: 10),
                Text(translate.dining_success_dialog_content, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
              ] else if (from == 'tiffin') ...[
                Text(
                  translate.tiffin_success_dialog_title,
                  textAlign: TextAlign.center,
                  style: kAppLblSmallFontBold(context, color: 'primary'),
                ),
                kAppSpacerVertical(height: 10),
                Text(translate.tiffin_success_dialog_content, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
              ],
              kAppSpacerVertical(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: kAppTextButtonColoredStyle(context, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor),
                      child: Text(translate.thank_you_btn),
                    ),
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
