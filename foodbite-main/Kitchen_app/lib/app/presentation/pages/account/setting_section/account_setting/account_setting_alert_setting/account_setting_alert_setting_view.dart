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
import 'package:kitchen/app/core/config/assets_url.dart';
import 'package:kitchen/app/presentation/pages/account/setting_section/account_setting/account_setting_alert_setting/bloc/account_setting_notification_alert_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/error_dialog.dart';
import 'package:kitchen/app/presentation/styles/success_dialog.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

class AccountSettingAlertSettingScreen extends StatelessWidget {
  const AccountSettingAlertSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AccountSettingNotificationAlertBloc()..add(AccountSettingNotificationAlertInitialEvent()), child: const AccountSettingAlertSettingView());
  }
}

class AccountSettingAlertSettingView extends StatelessWidget {
  const AccountSettingAlertSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<AccountSettingNotificationAlertBloc, AccountSettingNotificationAlertState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isUpdateFailed) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isUpdated) {
          showSuccessDialog(context, translate.pref_updated);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isUpdate ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.alert_pref), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const AccountSettingAlertSettingLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const AccountSettingAlertSettingErrorView(),
                  ] else ...[
                    Text(translate.newsletters, style: kAppLblMediumFontBold(context)),
                    Text(translate.newsletters_sub_title, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: Icon(Icons.mail_outline, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.form_email, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'newsletters')),
                            child: Icon(state.newsletters ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.newsletters ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.promo_offer, style: kAppLblMediumFontBold(context)),
                    Text(translate.promo_offer_sub_title, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: Icon(Icons.mail_outline, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.form_email, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'promoEmail')),
                            child: Icon(state.promoEmail ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.promoEmail ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: Icon(Icons.notifications_active_outlined, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.push, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'promoNotification')),
                            child: Icon(state.promoNotification ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.promoNotification ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: FaIcon(FontAwesomeIcons.whatsapp, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.whatsapp, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'promoWhatsApp')),
                            child: Icon(state.promoWhatsApp ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.promoWhatsApp ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.social_alerts, style: kAppLblMediumFontBold(context)),
                    Text(translate.social_alerts_sub_title, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: Icon(Icons.mail_outline, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.form_email, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'socialEmail')),
                            child: Icon(state.socialEmail ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.socialEmail ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: Icon(Icons.notifications_active_outlined, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.push, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'socialNotification')),
                            child: Icon(state.socialNotification ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.socialNotification ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.order_purchases, style: kAppLblMediumFontBold(context)),
                    Text(translate.order_purchases_sub_title, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: Icon(Icons.mail_outline, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.form_email, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'orderEmail')),
                            child: Icon(state.orderEmail ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.orderEmail ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: Icon(Icons.notifications_active_outlined, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.push, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'orderNotification')),
                            child: Icon(state.orderNotification ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.orderNotification ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: FaIcon(FontAwesomeIcons.whatsapp, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.whatsapp, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'orderWhatsApp')),
                            child: Icon(state.orderWhatsApp ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.orderWhatsApp ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.account_updates, style: kAppLblMediumFontBold(context)),
                    Text(translate.account_updates_sub_title, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                                child: Center(child: Icon(Icons.mail_outline, size: 13, color: Theme.of(context).canvasColor)),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Text(translate.form_email, style: kAppLblMediumFontRegular(context)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertChangeEvent(name: 'importantUpdate')),
                            child: Icon(state.importantUpdate ? Icons.toggle_on_outlined : Icons.toggle_off_outlined, size: 25, color: state.importantUpdate ? Theme.of(context).primaryColor : Theme.of(context).canvasColor),
                          ),
                        ],
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
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: ThemeProvider.scaffoldPadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.read<AccountSettingNotificationAlertBloc>().add(AccountSettingNotificationAlertUpdateEvent()),
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isUpdate ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.update_pref),
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

class AccountSettingAlertSettingLoadingView extends StatelessWidget {
  const AccountSettingAlertSettingLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.3, borderRadius: BorderRadius.circular(8)),
              ),
              SkeletonLine(style: SkeletonLineStyle(height: 10, width: 20, borderRadius: BorderRadius.circular(8))),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountSettingAlertSettingErrorView extends StatelessWidget {
  const AccountSettingAlertSettingErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.server_bug_error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //