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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';
import 'package:vendor/app/presentation/pages/intro/bloc/intro_bloc.dart';
import 'package:vendor/app/presentation/pages/modals/language_translation_modal/language_translation_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_localization/app_localization_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/theme_bloc/theme_bloc.dart';
import 'package:vendor/app/router/app_route_config.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => IntroBloc()..add(IntroInitialEvent()), child: const IntroView());
  }
}

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  PageController pageController = PageController(initialPage: 0, viewportFraction: 1);
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<IntroBloc, IntroState>(
      listener: (context, state) {
        if (state.status.isNotificationGranted) {
          showSuccessDialog(context, translate.notification_permission_granted);
          pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        } else if (state.status.isNotificationDicline) {
          showErrorDialog(context, translate.notificaiton_permission_declined, state.extraMessage.toString(), state.statusCode);
          pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        } else if (state.status.isBluetoothGranted) {
          showSuccessDialog(context, translate.bluetooth_permission_granted);
          pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        } else if (state.status.isBluetoothDicline) {
          showErrorDialog(context, translate.bluetooth_permission_declined, state.extraMessage.toString(), state.statusCode);
          pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        } else if (state.status.isCameraGranted) {
          showSuccessDialog(context, translate.camera_permission_granted);
          pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        } else if (state.status.isCameraDicline) {
          showErrorDialog(context, translate.camera_permission_declined, state.extraMessage.toString(), state.statusCode);
          pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
        } else if (state.status.isLocationGranted) {
          showSuccessDialog(context, translate.location_permission_granted);
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.loginRoute, (Route<dynamic> route) => false);
        } else if (state.status.isLocatoinDicline) {
          showErrorDialog(context, translate.location_permission_declined, state.extraMessage.toString(), state.statusCode);
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.loginRoute, (Route<dynamic> route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.read<ThemeBloc>().add(ChangeThemeEvent()),
              icon: Icon(Icons.light_mode, color: Theme.of(context).iconTheme.color),
            ),
            scrolledUnderElevation: 0,
            title: Text(translate.permission_title),
            actions: <Widget>[
              AppSupportedLanguagesModel.languages.isNotEmpty && AppSupportedLanguagesModel.languages.length > 1
                  ? IconButton(
                      onPressed: () {
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
                              context.read<IntroBloc>().add(IntroLanguageChangeEvent(locale: value));
                            }
                          }
                        });
                      },
                      icon: FaIcon(FontAwesomeIcons.language, size: Theme.of(context).textTheme.titleSmall?.fontSize, color: Theme.of(context).iconTheme.color),
                    )
                  : const SizedBox(),
            ],
          ),
          body: PageView.builder(
            itemCount: 4,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (index == 0) ...[
                      NotificationPermissionWidget(currentPageIndex: currentPageIndex, status: state.status),
                    ] else if (index == 1) ...[
                      BluetoothPermissionWidget(currentPageIndex: currentPageIndex, status: state.status),
                    ] else if (index == 2) ...[
                      CameraPermissionWidget(currentPageIndex: currentPageIndex, status: state.status),
                    ] else if (index == 3) ...[
                      LocationPermissionWidget(currentPageIndex: currentPageIndex, status: state.status),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class NotificationPermissionWidget extends StatelessWidget {
  final int currentPageIndex;
  final IntroStatus status;
  const NotificationPermissionWidget({super.key, required this.currentPageIndex, required this.status});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AssetsUrl.imageURL.notificationPermission, height: 80, width: 80),
        kAppSpacerVertical(height: 20),
        Text(translate.notification_permission_title, textAlign: TextAlign.center, style: kAppLblLargeFontBold(context)),
        kAppSpacerVertical(height: 5),
        Text("${Environments.appName} ${translate.notification_permission_sub_title}", textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        kAppSpacerVertical(height: 40),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => context.read<IntroBloc>().add(IntroNotificationPermissionEvent()),
                style: kAppTextButtonColoredStyle(context, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor),
                child: status.isLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0) : Text(translate.permission_allow_text),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BluetoothPermissionWidget extends StatelessWidget {
  final int currentPageIndex;
  final IntroStatus status;
  const BluetoothPermissionWidget({super.key, required this.currentPageIndex, required this.status});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AssetsUrl.imageURL.bluetoothPermission, height: 80, width: 80),
        kAppSpacerVertical(height: 20),
        Text(translate.bluetooth_permission_title, textAlign: TextAlign.center, style: kAppLblLargeFontBold(context)),
        kAppSpacerVertical(height: 5),
        Text("${Environments.appName} ${translate.bluetooth_permission_sub_title}", textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        kAppSpacerVertical(height: 40),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => context.read<IntroBloc>().add(IntroBluetoothPermissionEvent()),
                style: kAppTextButtonColoredStyle(context, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor),
                child: status.isLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0) : Text(translate.permission_allow_text),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CameraPermissionWidget extends StatelessWidget {
  final int currentPageIndex;
  final IntroStatus status;
  const CameraPermissionWidget({super.key, required this.currentPageIndex, required this.status});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AssetsUrl.imageURL.cameraPermission, height: 80, width: 80),
        kAppSpacerVertical(height: 20),
        Text(translate.camera_permission_title, textAlign: TextAlign.center, style: kAppLblLargeFontBold(context)),
        kAppSpacerVertical(height: 5),
        Text("${Environments.appName} ${translate.camera_permission_sub_title}", textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        kAppSpacerVertical(height: 40),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => context.read<IntroBloc>().add(IntroCameraPermissionEvent()),
                style: kAppTextButtonColoredStyle(context, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor),
                child: status.isLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0) : Text(translate.permission_allow_text),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LocationPermissionWidget extends StatelessWidget {
  final int currentPageIndex;
  final IntroStatus status;
  const LocationPermissionWidget({super.key, required this.currentPageIndex, required this.status});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AssetsUrl.imageURL.locationPermission, height: 80, width: 80),
        kAppSpacerVertical(height: 20),
        Text(translate.location_permission_title, textAlign: TextAlign.center, style: kAppLblLargeFontBold(context)),
        kAppSpacerVertical(height: 5),
        Text("${Environments.appName} ${translate.location_permission_sub_title}", textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        kAppSpacerVertical(height: 40),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  context.read<IntroBloc>().add(IntroLocationPermisionEvent());
                },
                style: kAppTextButtonColoredStyle(context, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor),
                child: status.isLoading ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 2.0) : Text(translate.permission_allow_text),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// DONE //