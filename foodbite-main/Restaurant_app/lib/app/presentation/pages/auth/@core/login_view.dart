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
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/modals/language_translation_modal/language_translation_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_localization/app_localization_bloc.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';
import 'package:vendor/app/presentation/pages/auth/@core/bloc/login_bloc.dart';
import 'package:vendor/app/presentation/pages/auth/login_options/email_otp/email_otp_login.dart';
import 'package:vendor/app/presentation/pages/auth/login_options/email_password/email_password_login.dart';
import 'package:vendor/app/presentation/pages/auth/login_options/phone_otp/phone_otp_login.dart';
import 'package:vendor/app/presentation/pages/auth/login_options/phone_password/phone_password_login.dart';
import 'package:vendor/app/presentation/styles/theme_bloc/theme_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => LoginBloc()..add(LoginInitialEvent()), child: const LoginView());
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.read<ThemeBloc>().add(ChangeThemeEvent()),
              icon: Icon(Icons.light_mode, color: Theme.of(context).iconTheme.color),
            ),
            automaticallyImplyLeading: false,
            title: Text(translate.signin),
            scrolledUnderElevation: 0,
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
                              context.read<LoginBloc>().add(LoginLanguageChangeEvent(locale: value));
                            }
                          }
                        });
                      },
                      icon: FaIcon(FontAwesomeIcons.language, size: Theme.of(context).textTheme.titleSmall?.fontSize, color: Theme.of(context).iconTheme.color),
                    )
                  : const SizedBox(),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.restaurantLoginWith == 'email_password') ...[
                  LoginWithEmailPasswordScreen(),
                ] else if (state.restaurantLoginWith == 'phone_password') ...[
                  LoginWithPhonePasswordScreen(),
                ] else if (state.restaurantLoginWith == 'phone_otp') ...[
                  LoginWithPhoneOtpScreen(),
                ] else if (state.restaurantLoginWith == 'email_otp') ...[
                  LoginWithEmailOtpScreen(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
// DONE //