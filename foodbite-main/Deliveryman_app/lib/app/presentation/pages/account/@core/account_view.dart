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

import 'package:driver/app/presentation/pages/account/@core/bloc/account_bloc.dart';
import 'package:driver/app/presentation/pages/account/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:driver/app/presentation/pages/modals/language_translation_modal/language_translation_modal_view.dart';
import 'package:driver/app/presentation/styles/app_localization/app_localization_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/loader_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/presentation/styles/theme_bloc/theme_bloc.dart';
import 'package:driver/app/router/app_route_config.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state.status.isSubmitSuccess) {
              context.read<AccountBloc>().add(AccountInitialEvent());
            }
          },
        ),
      ],
      child: const AccountView(),
    );
  }
}

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(AccountInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    super.build(context);
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status.isLogoutStart) {
          LoaderService.showLoader(context, msg: translate.loader_please_wait);
        } else if (state.status.isLogoutSuccess) {
          LoaderService.hideLoder(context);
          context.read<AccountBloc>().add(AccountInitialEvent());
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.loginRoute, (Route<dynamic> route) => false);
        } else if (state.status.isLogoutFailed) {
          LoaderService.hideLoder(context);
          context.read<AccountBloc>().add(AccountInitialEvent());
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: ThemeProvider.scaffoldPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Theme.of(context).disabledColor, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                      child: CacheNetworkImageWidget(width: 50.0, height: 50.0, imageUrl: state.driverCover),
                    ),
                    kAppSpacerHorizontal(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.driverName, style: kAppLblMediumFontBold(context)),
                        kAppSpacerVertical(height: 2),
                        Text(state.driverEmail, style: kAppLblTinyFontRegular(context)),
                        kAppSpacerVertical(height: 2),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(AppRouter.editProfileRoute),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate.your_profile, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                              kAppSpacerHorizontal(width: 5),
                              Icon(Icons.chevron_right_outlined, size: 12, color: Theme.of(context).primaryColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SettingsSection(
                  title: translate.profile,
                  children: [
                    SettingsItem(icon: Icons.star, label: translate.your_reviews, onTap: () => Navigator.of(context).pushNamed(AppRouter.reviewListRoute)),
                    SettingsItem(icon: Icons.chat_outlined, label: translate.chat_messages, onTap: () => Navigator.of(context).pushNamed(AppRouter.chatCardRoute)),
                    SettingsItem(
                      icon: Icons.brightness_4,
                      label: translate.light_mode,
                      showChevron: false,
                      trailing: GestureDetector(
                        onTap: () {
                          context.read<AccountBloc>().add(AccountChangeThemeEvent());
                          context.read<ThemeBloc>().add(ChangeThemeEvent());
                        },
                        child: Icon(state.lightMode ? Icons.toggle_off_outlined : Icons.toggle_on_outlined, size: 25, color: Theme.of(context).canvasColor),
                      ),
                    ),
                    SettingsItem(icon: Icons.campaign, label: translate.notification_sound, onTap: () => Navigator.of(context).pushNamed(AppRouter.notificationSoundRoute)),
                  ],
                ),
                SettingsSection(
                  title: translate.more,
                  children: [
                    SettingsItem(
                      icon: Icons.translate_outlined,
                      label: translate.choose_language,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: false,
                          enableDrag: false,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(heightFactor: 0.7, child: LanguageTranslationModalScreen(selected: state.locale));
                          },
                        ).then((value) {
                          if (!context.mounted) return;
                          if (value != null) {
                            if (value.toString() != state.locale) {
                              context.read<AppLocalizationBloc>().add(ChangeAppLocalizationEvent(defaultLanguage: value));
                              Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.bottomTabRoute, (Route<dynamic> route) => false, arguments: [4]);
                            }
                          }
                        });
                      },
                    ),
                    SettingsItem(
                      icon: Icons.info_outline,
                      label: translate.about,
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.appPageRoute, arguments: ['about-us']),
                    ),
                    SettingsItem(
                      icon: Icons.privacy_tip_outlined,
                      label: translate.privacy_policy,
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.appPageRoute, arguments: ['privacy-policy']),
                    ),
                    SettingsItem(
                      icon: Icons.text_format_sharp,
                      label: translate.terms_and_condition,
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.appPageRoute, arguments: ['terms-and-conditions']),
                    ),
                    SettingsItem(
                      icon: Icons.replay_circle_filled_rounded,
                      label: translate.refund_policy,
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.appPageRoute, arguments: ['refund-policy']),
                    ),
                    SettingsItem(
                      icon: Icons.local_shipping_outlined,
                      label: translate.shipping_policy,
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.appPageRoute, arguments: ['shipping-policy']),
                    ),
                    SettingsItem(
                      icon: Icons.cancel_outlined,
                      label: translate.cancellation_policy,
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.appPageRoute, arguments: ['cancellation-policy']),
                    ),
                    SettingsItem(
                      icon: Icons.help_outline,
                      label: translate.help,
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.appPageRoute, arguments: ['help']),
                    ),
                    SettingsItem(
                      icon: Icons.format_quote_rounded,
                      label: translate.faqs,
                      onTap: () => Navigator.of(context).pushNamed(AppRouter.appPageRoute, arguments: ['frequently-asked-questions']),
                    ),
                    SettingsItem(icon: Icons.feedback_outlined, label: translate.send_feedback, onTap: () => Navigator.of(context).pushNamed(AppRouter.feedbackRoute)),
                    SettingsItem(icon: Icons.report_gmailerrorred, label: translate.report_emergency, onTap: () => Navigator.of(context).pushNamed(AppRouter.reportEmergencyRoute)),
                    SettingsItem(icon: Icons.settings_outlined, label: translate.settings, onTap: () => Navigator.of(context).pushNamed(AppRouter.settingSectionRoute)),
                    SettingsItem(icon: Icons.power_settings_new_outlined, label: translate.logout, onTap: () => context.read<AccountBloc>().add(AccountLogoutEvent())),
                  ],
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CacheNetworkImageWidget(width: 106.0, height: 34.0, imageUrl: state.appLogo),
                      Text("v${state.currentVersion}", style: kAppLblTinyFontRegular(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SettingsSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Theme.of(context).disabledColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 40.0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(title, style: kAppLblMediumFontSemiBoldWhite(context))],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool showChevron;
  final Widget? trailing;

  const SettingsItem({super.key, required this.icon, required this.label, this.onTap, this.showChevron = true, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).disabledColor, width: 1.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(50.0)),
                  child: Center(child: Icon(icon, size: 13, color: Theme.of(context).canvasColor)),
                ),
                kAppSpacerHorizontal(width: 10),
                Text(label, style: kAppLblMediumFontRegular(context)),
              ],
            ),
            trailing ?? (showChevron ? Icon(Icons.chevron_right, size: 13, color: Theme.of(context).canvasColor) : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
// DONE //