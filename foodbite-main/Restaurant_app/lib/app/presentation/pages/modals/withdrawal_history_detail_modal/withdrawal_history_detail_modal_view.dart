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
import 'package:vendor/app/core/models/withdrawal_history_model.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class WithdrawalHistoryDetailModalView extends StatelessWidget {
  final WithdrawalHistoryConfigModel model;
  const WithdrawalHistoryDetailModalView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Text(translate.withdrawal_history_detail),
        actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: ThemeProvider.scaffoldPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate.id.toUpperCase(), style: kAppLblBoldFont(context)),
                Text(model.id!, style: kAppLblBoldFont(context)),
              ],
            ),
            kAppSpacerVertical(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate.status.toUpperCase(), style: kAppLblBoldFont(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (model.status! == 'created') ...[
                      Text(translate.pending, style: kAppLblBoldFont(context)),
                    ] else if (model.status! == 'accepted') ...[
                      Text(translate.accepted, style: kAppLblBoldFont(context)),
                    ] else ...[
                      Text(translate.rejected, style: kAppLblBoldFont(context)),
                    ],
                  ],
                ),
              ],
            ),
            kAppSpacerVertical(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate.amount.toUpperCase(), style: kAppLblBoldFont(context)),
                Text(kAppPriceFormat(model.amount!), style: kAppLblBoldFont(context)),
              ],
            ),
            kAppSpacerVertical(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate.payout_method.toUpperCase(), style: kAppLblBoldFont(context)),
                Text(model.withdrawalMethodDetail!.name!, style: kAppLblBoldFont(context)),
              ],
            ),
            kAppSpacerVertical(height: 10),
            Text(translate.payout_creds.toUpperCase(), style: kAppLblBoldFont(context)),
            kAppSpacerVertical(height: 5),
            model.status! == 'created'
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: ThemeProvider.scaffoldPadding),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ThemeProvider.greyColorBorder, width: 1),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        model.restaurantPayoutMethodDetail!.credential!.length,
                        (formIndex) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${model.restaurantPayoutMethodDetail!.credential![formIndex].fieldName!}:', style: kAppLblSmallFontMedium(context)),
                              Text(model.restaurantPayoutMethodDetail!.credential![formIndex].fieldValue!, style: kAppLblSmallFontMedium(context)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: ThemeProvider.scaffoldPadding),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ThemeProvider.greyColorBorder, width: 1),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        model.formElement!.length,
                        (formIndex) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${model.formElement![formIndex].fieldName!}:', style: kAppLblSmallFontMedium(context)),
                              Text(model.formElement![formIndex].fieldValue!, style: kAppLblSmallFontMedium(context)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            model.status! == 'accepted'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.approval_notes.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text(model.approvedNotes!, style: kAppLblBoldFont(context)),
                      kAppSpacerVertical(height: 10),
                      model.proof!.isNotEmpty ? CacheNetworkImageWidget(width: (MediaQuery.of(context).size.width - 20), height: 500, imageUrl: model.proof!, fit: BoxFit.contain) : const SizedBox(),
                      kAppSpacerVertical(height: 10),
                    ],
                  )
                : const SizedBox(),
            model.status! == 'rejected'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate.rejection_notes.toUpperCase(), style: kAppLblBoldFont(context)),
                      Text(model.rejectedReason!, style: kAppLblBoldFont(context)),
                      kAppSpacerVertical(height: 10),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
// DONE //