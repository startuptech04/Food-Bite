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
import 'package:kitchen/app/core/models/otp_modal_response_model.dart';
import 'package:kitchen/app/presentation/pages/account/setting_section/account_setting/account_setting_change_email/bloc/account_setting_change_email_bloc.dart';
import 'package:kitchen/app/presentation/pages/modals/otp_modal/otp_modal_view.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/error_dialog.dart';
import 'package:kitchen/app/presentation/styles/success_dialog.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/app/router/app_route_config.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

class AccountSettingChangeEmailScreen extends StatelessWidget {
  const AccountSettingChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AccountSettingChangeEmailBloc()..add(AccountSettingChangeEmailInitialEvent()), child: const AccountSettingChangeEmailView());
  }
}

class AccountSettingChangeEmailView extends StatefulWidget {
  const AccountSettingChangeEmailView({super.key});

  @override
  State<AccountSettingChangeEmailView> createState() => _AccountSettingChangeEmailViewState();
}

class _AccountSettingChangeEmailViewState extends State<AccountSettingChangeEmailView> {
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<AccountSettingChangeEmailBloc>().add(AccountSettingChangeEmailUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((AccountSettingChangeEmailBloc bloc) => bloc.state.isValid);
    return BlocConsumer<AccountSettingChangeEmailBloc, AccountSettingChangeEmailState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode, fromAuth: false);
        } else if (state.status.isVerify) {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return OtpModalScreen(
                      providerName: state.verification.provider!,
                      sentTo: state.email.value.toString(),
                      providerId: state.verification.id!,
                      otpLength: state.verification.otpLength!,
                      canResendOTP: state.verification.canResendOtp!,
                      mode: 'email_otp',
                    );
                  },
                  fullscreenDialog: true,
                ),
              )
              .then((value) {
                if (!context.mounted) return;
                OTPModalResponse otpModalResponse = OTPModalResponse.fromJson(value);
                if (otpModalResponse.action! && otpModalResponse.status!) {
                  context.read<AccountSettingChangeEmailBloc>().add(AccountSettingChangeEmailVerificationSuccessEvent());
                }
              });
        } else if (state.status.isSuccess) {
          showSuccessDialog(context, translate.email_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.loginRoute, (Route<dynamic> route) => false);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isInProgress ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.change_email), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(translate.re_auth_required, style: kAppLblMediumFontBold(context)),
                  kAppSpacerVertical(height: 10),
                  Text(translate.security_logout_email_phone_change, style: kAppLblTinyFontRegular(context)),
                  kAppSpacerVertical(height: 10),
                  Text("${translate.auth_mode_using} ${state.userEmail}. ${translate.auth_mode_email_verification}", style: kAppLblTinyFontRegular(context)),
                  kAppSpacerVertical(height: 40),
                  TextFormField(
                    initialValue: state.email.value,
                    focusNode: _emailFocusNode,
                    decoration: kAppInputDecoration(context, prefixIcon: const Icon(Icons.email_outlined), lblText: translate.form_email, errText: state.email.displayError != null ? translate.form_required : null),
                    style: kAppLblSmallFontMedium(context),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context.read<AccountSettingChangeEmailBloc>().add(AccountSettingChangeEmailChangedEvent(email: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isValid ? () => context.read<AccountSettingChangeEmailBloc>().add(AccountSettingChangeEmailSubmitEvent()) : null,
                      style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                      child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.verify),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// DONE //