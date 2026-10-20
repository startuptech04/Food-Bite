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
import 'package:kitchen/app/core/config/assets_url.dart';
import 'package:kitchen/app/env.dart';
import 'package:kitchen/app/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_localization/app_localization_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/error_dialog.dart';
import 'package:kitchen/app/presentation/styles/force_update_dialog.dart';
import 'package:kitchen/app/router/app_route_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(SplashInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.status.isAppLocale) {
          context.read<AppLocalizationBloc>().add(ChangeAppLocalizationEvent(defaultLanguage: state.appLocale));
        } else if (state.status.isUnAuthorized) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.loginRoute, (Route<dynamic> route) => false);
        } else if (state.status.isForceUpdate) {
          ForceUpdateDialogService.showUpdateDialog(context, state.newUpdateVersion, state.versionUpdateUrl);
        } else if (state.status.isAuthorized) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.bottomTabRoute, (Route<dynamic> route) => false, arguments: [1]);
        } else if (state.status.isFailure) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.serverErrorRoute, (Route<dynamic> route) => false);
        } else if (state.status.isMaintenance) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.maintenanceRoute, (Route<dynamic> route) => false, arguments: [state.businessEmail, state.businessMobile]);
        } else if (state.status.isConnectionError) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.internetConnectionRoute, (Route<dynamic> route) => false);
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AssetsUrl.imageURL.splashIcon, height: 70, width: 70, fit: BoxFit.cover),
                      kAppSpacerVertical(height: 10),
                      Text(Environments.appName, style: kAppLblMediumFontBold(context, color: 'primary')),
                    ],
                  ),
                ),
              ),
              Positioned(bottom: 50, child: kAppCenterCircularProgress(context)),
            ],
          ),
        );
      },
    );
  }
}
// DONE //