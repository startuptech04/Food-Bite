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
import 'package:vendor/app/presentation/pages/auth/reset_password/@core/bloc/reset_password_bloc.dart';
import 'package:vendor/app/presentation/pages/auth/reset_password/reset_password_option/reset_with_email_otp/reset_with_email_otp_view.dart';
import 'package:vendor/app/presentation/pages/auth/reset_password/reset_password_option/reset_with_phone_otp/reset_with_phone_otp_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ResetPasswordBloc()..add(ResetPasswordInitialEvent()), child: const ResetPasswordView());
  }
}

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.forgot_password_lbl), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.userResetPasswordWith == 'email_otp') ...[const ResetWithEmailOtpScreen()] else if (state.userResetPasswordWith == 'phone_otp') ...[const ResetWithPhoneOtpScreen()],
              ],
            ),
          ),
        );
      },
    );
  }
}
// DONE //